import 'dart:async';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/call_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/agora_call_manager.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart' show ServiceNotEnabledException;
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AstrologerVideoCallController extends GetxController {
  late AstrologerModel astrologer;
  final CallService _callService = CallService();
  final AgoraCallManager _agoraManager = AgoraCallManager();
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();
  
  final RxBool isMuted = false.obs;
  final RxBool isVideoOn = true.obs;
  final RxBool isSpeakerOn = false.obs;
  final RxBool isUserSpeaking = false.obs;
  final RxBool isAstrologerSpeaking = false.obs;
  final RxBool isAstrologerVideoOn = true.obs;
  final RxString callDuration = '00:00'.obs;
  final RxString remainingTime = '00:00'.obs; // Countdown timer
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString callStatus = 'Initializing...'.obs; // Initializing..., Ringing..., Connected, Error
  final RxBool isRinging = false.obs; // True when waiting for astrologer to accept
  final RxBool isCallConnected = false.obs; // True when astrologer has joined

  // Store call data
  String? _callId;
  String? _channelName;
  String? _token;
  String? _appId;
  int? _remoteUid;
  int? _timeoutSeconds;
  int? _availableMinutes; // Max available minutes from wallet (for countdown UX)
  double? _walletBalance; // Current wallet balance (updated via WebSocket)
  double? _pricePerMinute; // Price per minute (updated via WebSocket)
  Timer? _countdownTimer; // Timer for countdown
  Timer? _billingTimer; // Timer for manual billing calculation (fallback)
  Timer? _walletSyncTimer; // Timer for periodic wallet balance sync
  int _remainingSeconds = 0; // Remaining seconds based on availableMinutes
  bool _durationExpiredNotified = false;
  DateTime? _callStartTime; // Track when call actually started (when astrologer joined)

  // WebSocket for billing updates
  io.Socket? _socket;
  static const String callSocketUrl = 'http://3.109.91.254:8009/';
  
  // Reactive variables for billing
  final RxDouble walletBalance = 0.0.obs;
  final RxDouble totalCost = 0.0.obs;
  final RxInt totalMinutesBilled = 0.obs;
  final RxBool showLowBalanceWarning = false.obs;
  final RxBool isSocketConnected = false.obs;
  final RxDouble pricePerMinute = 0.0.obs; // Reactive price per minute

  @override
  void onInit() {
    super.onInit();
    // Get astrologer and callData from arguments
    final args = Get.arguments;
    CallData? callData;
    
    if (args is Map<String, dynamic>) {
      if (args['astrologer'] != null) {
        astrologer = args['astrologer'] as AstrologerModel;
      }
      if (args['callData'] != null) {
        callData = args['callData'] as CallData;
        // Use availableMinutes from API response for countdown (UX only)
        _availableMinutes = callData.availableMinutes ?? callData.durationMinutes;
        _walletBalance = callData.walletBalance;
        _pricePerMinute = callData.pricePerMinute;
      }
    } else if (args is AstrologerModel) {
      astrologer = args;
    } else {
      // Handle error case
      Get.back();
      return;
    }

    // Setup Agora callbacks
    _setupAgoraCallbacks();
    
    // If callData is provided, use it directly; otherwise initialize call
    if (callData != null) {
      _initializeCallWithData(callData);
    } else {
      _initializeCall();
    }
  }

  /// Connect to WebSocket immediately after call initiation (for astrologer notification)
  /// This is a separate connection that doesn't join the call room yet
  Future<void> _connectSocketForNotification() async {
    try {
      if (_callId == null || _callId!.isEmpty) {
        if (kDebugMode) print('Cannot connect socket for notification - callId is empty');
        return;
      }

      final token = UserData().accessToken ?? '';
      if (token.isEmpty) {
        if (kDebugMode) print('Cannot connect socket - no auth token');
        return;
      }

      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📡 Connecting to WebSocket for call notification (Video)...');
        print('📡 Call ID: $_callId');
        print('═══════════════════════════════════════════════════════════');
      }

      _socket = io.io(
        callSocketUrl,
        io.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setAuth({'token': token})
            .disableAutoConnect()
            .enableForceNew()
            .setReconnectionAttempts(3)
            .setTimeout(10000)
            .build(),
      );

      _socket!.connect();

      _socket!.onConnect((_) {
        if (kDebugMode) {
          print('═══════════════════════════════════════════════════════════');
          print('📡 Video Call WebSocket connected');
          print('═══════════════════════════════════════════════════════════');
        }
        isSocketConnected.value = true;
        
        // CRITICAL: Follow exact same pattern as chat
        // Join call room IMMEDIATELY after socket connects (just like chat joins immediately)
        if (_callId != null && _callId!.isNotEmpty) {
          _joinCallRoom();
        } else {
          if (kDebugMode) print('Socket connected but callId is empty, waiting...');
        }
      });

      _socket!.onDisconnect((_) {
        isSocketConnected.value = false;
        if (kDebugMode) print('📡 Video Call WebSocket disconnected');
      });

      _socket!.onError((error) {
        if (kDebugMode) print('📡 Video Call WebSocket error: $error');
      });

      _socket!.onConnectError((error) {
        if (kDebugMode) print('📡 Video Call WebSocket connection error: $error');
        isSocketConnected.value = false;
      });

      // Set up billing event listeners (will be used after call connects)
      _setupBillingEventListeners();
    } catch (e) {
      if (kDebugMode) print('Error connecting video call socket for notification: $e');
    }
  }

  /// Set up billing event listeners on the socket - Follow exact same pattern as chat
  void _setupBillingEventListeners() {
    if (_socket == null) return;

    // --- JOIN CONFIRMATION (like chat's join_success) ---
    _socket!.on('join_success', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('✅ JOINED CALL ROOM SUCCESSFULLY (Video)');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
      
      // Check if session is active - if not, we need to wait for session_started event
      if (data is Map && data['sessionActive'] == true) {
        if (kDebugMode) print('✅ Session is ACTIVE - billing should start now');
      } else {
        if (kDebugMode) print('⚠️ Session not active yet - waiting for session_started event...');
      }
    });
    
    // Also listen for call-specific join confirmations
    _socket!.on('call_joined', (data) {
      if (kDebugMode) {
        print('✅ Call room joined confirmation (Video): $data');
      }
    });
    
    // --- SESSION STARTED EVENT (like chat) - This triggers billing ---
    _socket!.on('session_started', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('🎉 SESSION STARTED EVENT (Video Call) - Billing should start now!');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
    });
    
    // --- SESSION STARTED EVENT (like chat) - RECEIVED FROM BACKEND - This triggers billing ---
    // CRITICAL: Chat listens for this event FROM backend, we should too!
    _socket!.on('session_started', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('🎉 SESSION STARTED EVENT RECEIVED FROM BACKEND (Video Call)');
        print('💰 Billing should start now - Backend will send billing_update events!');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
      // Mark session as active (like chat does)
      // Backend should now start sending billing_update events
    });
    
    // Also listen for call-specific session started events
    _socket!.on('call_started', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('🎉 CALL STARTED EVENT RECEIVED (Video Call) - Billing should start now!');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
    });

    // --- BILLING EVENTS (exact same as chat) ---
    _socket!.on('billing_update', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('💰💰💰 BILLING UPDATE RECEIVED (VIDEO CALL) 💰💰💰');
        print('Raw Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
      _handleBillingUpdate(data);
    });
    
    // Also listen for call-specific billing events (in case backend uses different event names)
    _socket!.on('call_billing_update', (data) {
      if (kDebugMode) print('💰 Call Billing Update (Video Call): $data');
      _handleBillingUpdate(data);
    });
    
    _socket!.on('video_call_billing', (data) {
      if (kDebugMode) print('💰 Video Call Billing (Video Call): $data');
      _handleBillingUpdate(data);
    });

    _socket!.on('low_balance_warning', (data) {
      if (kDebugMode) print('⚠️ Low Balance Warning (Video Call): $data');
      
      if (data['balance'] != null) {
        final balance = (data['balance'] as num).toDouble();
        walletBalance.value = balance;
        _walletBalance = balance;
        _updateGlobalWalletBalance(balance);
      }
      
      showLowBalanceWarning.value = true;
      
      Get.snackbar(
        'Low Balance',
        data['message'] ?? 'Your wallet balance is running low. Please recharge to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    });

    _socket!.on('call_force_ended', (data) async {
      if (kDebugMode) print('🛑 Call Force Ended (Video Call): $data');

      if (data['balance'] != null) {
        final newBalance = (data['balance'] as num).toDouble();
        walletBalance.value = newBalance;
        _walletBalance = newBalance;
        _updateGlobalWalletBalance(newBalance);
      }
      
      _availableMinutes = 0;
      _remainingSeconds = 0;
      _updateRemainingTime();
      _countdownTimer?.cancel();

      // End the call
      await _agoraManager.leaveChannel();
      await _agoraManager.dispose();
      await _disconnectSocket();

      Get.snackbar(
        'Call Ended',
        data['message'] ?? 'Your wallet balance is insufficient to continue the call',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    });
  }


  /// Handle billing update from WebSocket
  void _handleBillingUpdate(dynamic data) {
    // Handle amountDeducted (the amount deducted in this minute)
    if (data['amountDeducted'] != null) {
      final amountDeducted = (data['amountDeducted'] as num).toDouble();
      if (kDebugMode) print('💰 Amount deducted this minute: ₹$amountDeducted');
    }

    if (data['minutesBilled'] != null) {
      totalMinutesBilled.value = (data['minutesBilled'] as num).toInt();
    }
    if (data['totalAmount'] != null) {
      // Use backend's authoritative totalAmount (this is the actual cumulative charges)
      totalCost.value = (data['totalAmount'] as num).toDouble();
      if (kDebugMode) print('💰 Backend Total Cost: ₹${totalCost.value}');
    }
    if (data['remainingBalance'] != null) {
      final newBalance = (data['remainingBalance'] as num).toDouble();
      walletBalance.value = newBalance;
      _walletBalance = newBalance;
      
      // Update global WalletController if registered
      _updateGlobalWalletBalance(newBalance);
      
      // Update available minutes and countdown
      if (pricePerMinute.value > 0) {
        final newAvailableMinutes = (walletBalance.value / pricePerMinute.value).floor();
        _availableMinutes = newAvailableMinutes;
        // Update countdown timer if call is connected
        if (isCallConnected.value && newAvailableMinutes > 0) {
          _remainingSeconds = newAvailableMinutes * 60;
          _updateRemainingTime();
        }
      }
      
      if (kDebugMode) {
        print('💰 Updated wallet balance: ₹${walletBalance.value}');
        print('💰 Total cost so far: ₹${totalCost.value}');
        print('💰 Minutes billed: ${totalMinutesBilled.value}');
      }
    }
  }

  /// Update global WalletController balance if registered
  void _updateGlobalWalletBalance(double newBalance) {
    try {
      if (Get.isRegistered<WalletController>()) {
        final walletController = Get.find<WalletController>();
        walletController.walletBalance.value = newBalance;
        if (kDebugMode) {
          print('💰 Updated global WalletController balance: ₹$newBalance');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Could not update global WalletController: $e');
      }
    }
  }

  /// Join call room for billing updates - Follow exact same pattern as chat
  void _joinCallRoom() {
    if (_socket?.connected == true && _callId != null && _callId!.isNotEmpty) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📡 JOINING CALL ROOM (following chat pattern - Video)');
        print('CallId: $_callId');
        print('Socket connected: ${_socket?.connected}');
        print('Socket ID: ${_socket?.id}');
        print('═══════════════════════════════════════════════════════════');
      }
      
      // Use exact same pattern as chat: emit join_call (like join_chat)
      final joinPayload = {
        'callId': _callId,
        'role': 'user',
        'callType': 'VIDEO', // Add callType to help backend identify call type
      };
      
      if (kDebugMode) {
        print('Join payload: $joinPayload');
      }
      
      _socket!.emit('join_call', joinPayload);
      
      // Also try alternative event names that backend might expect
      _socket!.emit('join_call_room', joinPayload);
      
      if (kDebugMode) {
        print('✅ join_call and join_call_room events emitted');
        print('✅ Waiting for join_success confirmation...');
      }
    } else {
      if (kDebugMode) {
        print('⚠️ Cannot join room - Socket connected: ${_socket?.connected}, CallId: $_callId');
      }
    }
  }

  /// Disconnect WebSocket
  Future<void> _disconnectSocket() async {
    if (_socket != null) {
      try {
        if (_socket!.connected && _callId != null && _callId!.isNotEmpty) {
          _socket!.emit('leave_call', {'callId': _callId});
          await Future.delayed(const Duration(milliseconds: 200));
        }
        _socket!.disconnect();
        _socket!.dispose();
      } catch (e) {
        if (kDebugMode) print('Error disconnecting video call socket: $e');
      }
      _socket = null;
      isSocketConnected.value = false;
    }
  }

  void _setupAgoraCallbacks() {
    _agoraManager.onRemoteVideoMuted = (muted) {
      isAstrologerVideoOn.value = !muted;
    };
    _agoraManager.onCallStateChanged = (state) {
      switch (state) {
        case CallState.initializing:
          break;
        case CallState.joining:
          break;
        case CallState.ringing:
          callStatus.value = 'Ringing...';
          isRinging.value = true;
          isLoading.value = false;
          break;
        case CallState.joined:
          callStatus.value = 'Connected';
          isRinging.value = false;
          isCallConnected.value = true;
          isLoading.value = false;
          break;
        case CallState.leaving:
          break;
        case CallState.idle:
          break;
        case CallState.error:
          isLoading.value = false;
          isRinging.value = false;
          break;
        case CallState.timeout:
          callStatus.value = 'Busy';
          isLoading.value = false;
          isRinging.value = false;
          Future.delayed(const Duration(seconds: 1), () => Get.back());
          break;
        case CallState.notAnswered:
          callStatus.value = 'Busy';
          isLoading.value = false;
          isRinging.value = false;
          Future.delayed(const Duration(seconds: 1), () => Get.back());
          break;
        case CallState.endedByRemote:
          callStatus.value = 'Call Ended';
          isLoading.value = false;
          isRinging.value = false;
          Future.delayed(const Duration(seconds: 1), () {
            endCall(); // Use endCall to show review prompt
          });
          break;
      }
    };

    _agoraManager.onUserJoined = (uid) {
      // Astrologer has joined - call is now connected
      _remoteUid = uid;
      callStatus.value = 'Connected';
      isRinging.value = false;
      isCallConnected.value = true;
      isAstrologerSpeaking.value = true;
      isAstrologerVideoOn.value = true;
      isLoading.value = false;
      
      // Record call start time for billing calculation
      _callStartTime = DateTime.now();
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('✅ ASTROLOGER JOINED - Video Call is now connected!');
        print('📞 Video call started at: $_callStartTime');
        print('═══════════════════════════════════════════════════════════');
      }
      
      // CRITICAL: Emit WebSocket events to signal backend that call is active
      // Backend needs this to start billing (like chat receives session_started from backend)
      // For calls, backend might detect billing start from these events OR from Agora channel join detection
      if (isSocketConnected.value && _callId != null && _callId!.isNotEmpty) {
        if (kDebugMode) {
          print('═══════════════════════════════════════════════════════════');
          print('💰 EMITTING WEB SOCKET EVENTS TO START BILLING (Video)');
          print('💰 Backend should detect both parties joined and start billing');
          print('═══════════════════════════════════════════════════════════');
        }
        
        // Emit events that backend uses to detect call is active and both parties joined
        // Try multiple event names to match what backend expects
        _socket!.emit('call_active', {
          'callId': _callId,
          'callType': 'VIDEO',
          'role': 'user',
          'status': 'ACTIVE',
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        _socket!.emit('call_connected', {
          'callId': _callId,
          'callType': 'VIDEO',
          'role': 'user',
          'status': 'CONNECTED',
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        _socket!.emit('user_joined_call', {
          'callId': _callId,
          'callType': 'VIDEO',
          'role': 'user',
          'channelName': _channelName,
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        // Also emit call_started event (but NOT session_started - backend sends that!)
        // Backend should detect both parties joined and send session_started event
        _socket!.emit('call_started', {
          'callId': _callId,
          'callType': 'VIDEO',
          'role': 'user',
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        // NOTE: We DON'T emit session_started - that's sent BY the backend when it starts billing
        // (Following chat pattern - chat never emits session_started, only receives it)
        
        if (kDebugMode) {
          print('✅ Emitted multiple WebSocket events (Video):');
          print('   - call_active');
          print('   - call_connected');
          print('   - user_joined_call');
          print('   - call_started');
          print('✅ Waiting for backend to send session_started event (like chat)');
          print('✅ Backend should detect call is active, send session_started, then start billing');
        }
      } else {
        if (kDebugMode) print('⚠️ Cannot emit billing events - Socket connected: ${isSocketConnected.value}, CallId: $_callId (Video)');
      }
      
      // Start periodic wallet sync (every 30 seconds) to ensure we have latest balance
      _startWalletSyncTimer();
      
      // Start countdown timer when call is connected
      _startCountdownTimer();
      
      // Start manual billing timer (fallback if WebSocket doesn't work)
      // Wait a moment to ensure pricePerMinute is set
      Future.delayed(const Duration(milliseconds: 500), () {
        _startBillingTimer();
        // Also try again after 2 seconds if it didn't start (check if timer was created)
        Future.delayed(const Duration(seconds: 2), () {
          if (_billingTimer == null && isCallConnected.value && pricePerMinute.value > 0) {
            if (kDebugMode) print('🔄 Retrying to start billing timer (Video)...');
            _startBillingTimer();
          }
        });
      });
    };

    _agoraManager.onUserOffline = (uid) {
      _remoteUid = null;
      isAstrologerSpeaking.value = false;
      isAstrologerVideoOn.value = false;
      // Handled by AgoraCallManager to set specific states (notAnswered, endedByRemote)
    };

    _agoraManager.onCallDurationChanged = (duration) {
      // Only update duration display if call is connected
      // DO NOT calculate billing here - let billing timer handle it to avoid double deduction
      if (isCallConnected.value) {
        // Format as hh:mm:ss
        final hours = (duration ~/ 3600).toString().padLeft(2, '0');
        final minutes = ((duration % 3600) ~/ 60).toString().padLeft(2, '0');
        final seconds = (duration % 60).toString().padLeft(2, '0');
        callDuration.value = '$hours:$minutes:$seconds';
      }
    };

        _agoraManager.onError = (error) {
          errorMessage.value = error;
          isLoading.value = false;
          isRinging.value = false;
          
          // Handle specific error messages
          if (error == 'Busy') {
            callStatus.value = 'Busy';
            Future.delayed(const Duration(seconds: 1), () => Get.back());
          } else if (error == 'Call Ended') {
            callStatus.value = 'Call Ended';
            Future.delayed(const Duration(seconds: 1), () => Get.back());
          } else {
            Get.snackbar(
              'Call Error',
              error,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        };
  }


  Future<void> _initializeCall() async {
    try {
      isLoading.value = true;
      callStatus.value = 'Initiating call...';

      // Call API to initiate call (durationMinutes optional - not used for billing)
      final response = await _callService.initiateCall(
        astrologerId: astrologer.astrologerId,
        callType: 'VIDEO',
        durationMinutes: null, // Optional - backend handles per-minute billing
      );

      if (response == null || !response.success || response.data == null) {
        errorMessage.value = response?.message ?? 'Failed to initiate call';
        isLoading.value = false;
        Get.snackbar(
          'Call Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(seconds: 2), () => Get.back());
        return;
      }

      _initializeCallWithData(response.data!);
    } on ServiceNotEnabledException catch (e) {
      errorMessage.value = e.message;
      isLoading.value = false;
      Get.snackbar(
        'Service Not Available',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      Future.delayed(const Duration(seconds: 2), () => Get.back());
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      isLoading.value = false;
      Get.snackbar(
        'Call Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 2), () => Get.back());
    }
  }

  Future<void> _initializeCallWithData(CallData callData) async {
    try {
      isLoading.value = true;
      callStatus.value = 'Connecting...';

      // Store call data
      _callId = callData.callId;
      _channelName = callData.channelName;
      _token = callData.token;
      _appId = callData.appId;
      _timeoutSeconds = callData.timeoutSeconds;
      // Use availableMinutes for countdown (UX only - backend handles actual billing)
      // availableMinutes is preferred, fallback to durationMinutes if availableMinutes not provided
      _availableMinutes = callData.availableMinutes ?? (callData.durationMinutes > 0 ? callData.durationMinutes : 0);
      _walletBalance = callData.walletBalance ?? 0.0;
      _pricePerMinute = callData.pricePerMinute; // pricePerMinute is non-nullable
      
      // Initialize reactive variables - IMPORTANT: Set these correctly
      final initialWallet = callData.walletBalance ?? 0.0;
      final ratePerMin = callData.pricePerMinute;
      
      // CRITICAL: Ensure we have a valid rate - fallback to astrologer's rate if needed
      final finalRate = ratePerMin > 0 ? ratePerMin : (astrologer.videoPricePerMin ?? 0.0);
      
      // Use wallet balance from CallData immediately (don't block on API call)
      // Fetch actual wallet balance from backend in background for accuracy
      walletBalance.value = initialWallet > 0 ? initialWallet : 0.0;
      pricePerMinute.value = finalRate;
      totalCost.value = 0.0; // Start with 0 - will be calculated as call progresses
      totalMinutesBilled.value = 0;
      
      // Also update private variables
      _pricePerMinute = finalRate;
      _walletBalance = walletBalance.value;
      
      // Fetch actual wallet balance from backend asynchronously (non-blocking)
      // This ensures call setup is not delayed by API calls
      if (initialWallet <= 0) {
        _profileHelper.getWalletBalance().then((balance) {
          if (balance > 0) {
            walletBalance.value = balance;
            _walletBalance = balance;
            if (kDebugMode) print('💰 Updated wallet balance from backend: ₹$balance');
          }
        }).catchError((e) {
          if (kDebugMode) print('⚠️ Error fetching wallet balance (non-blocking): $e');
          // Don't show error to user - use CallData balance as fallback
        });
      }
      
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('💰 INITIALIZED BILLING VALUES (Video Call)');
        print('═══════════════════════════════════════════════════════════');
        print('  Call ID: $_callId');
        print('  Wallet Balance (from CallData): ₹$initialWallet');
        print('  Wallet Balance (actual from backend): ₹${walletBalance.value}');
        print('  Rate/Min: ₹${pricePerMinute.value}');
        print('  Available Minutes: $_availableMinutes');
        print('  Total Cost (initial): ₹${totalCost.value}');
        print('  Price from CallData: ₹${ratePerMin}');
        print('  Price from Astrologer: ₹${astrologer.videoPricePerMin}');
        print('  Final Rate Used: ₹${pricePerMinute.value}');
        print('═══════════════════════════════════════════════════════════');
      }
      
      if (pricePerMinute.value <= 0) {
        if (kDebugMode) print('❌ WARNING: Price per minute is 0 or invalid!');
      }
      
      if (walletBalance.value <= 0) {
        if (kDebugMode) print('❌ WARNING: Wallet balance is 0 or invalid!');
      }
      
      _remainingSeconds = _availableMinutes! * 60; // Initialize remaining seconds from availableMinutes
      _durationExpiredNotified = false;
      _updateRemainingTime(); // Set initial remaining time display

      // IMPORTANT: Connect to WebSocket immediately after call initiation
      // Backend needs the WebSocket connection to notify astrologer about incoming call
      // We'll join the call room later (only for billing) after astrologer joins
      _connectSocketForNotification();

      // Initialize Agora
      final initialized = await _agoraManager.initialize(
        appId: _appId!,
        isVideoCall: true,
        timeoutSeconds: _timeoutSeconds ?? 60,
      );

      if (!initialized) {
        errorMessage.value = 'Failed to initialize call engine';
        isLoading.value = false;
        Get.snackbar(
          'Call Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(seconds: 2), () => Get.back());
        return;
      }

      // IMPORTANT: Give backend time to process call initiation and notify astrologer
      // Backend needs to:
      // 1. Process the call initiation request
      // 2. Set up call state in database
      // 3. Send WebSocket notification to astrologer
      // Joining too quickly can cause race conditions
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('⏳ Waiting 2 seconds before joining Agora channel (Video)...');
        print('⏳ Call ID: $_callId');
        print('⏳ Channel: $_channelName');
        print('⏳ This allows backend time to notify astrologer');
        print('═══════════════════════════════════════════════════════════');
      }
      callStatus.value = 'Preparing call...';
      await Future.delayed(const Duration(seconds: 2)); // 2 second delay for backend processing
      
      // Now join channel - backend should have notified astrologer by now
      callStatus.value = 'Connecting to call...';
      if (kDebugMode) {
        print('📞 Now joining Agora channel (Video)...');
        print('📞 Channel: $_channelName');
        print('📞 Token length: ${_token?.length ?? 0}');
      }

      // Join channel
      final joined = await _agoraManager.joinChannel(
        token: _token!,
        channelName: _channelName!,
      );

      if (!joined) {
        errorMessage.value = 'Failed to join call';
        isLoading.value = false;
        Get.snackbar(
          'Call Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(seconds: 2), () => Get.back());
        return;
      }

      // Sync states
      isMuted.value = _agoraManager.isMuted;
      isVideoOn.value = _agoraManager.isVideoEnabled;
      isSpeakerOn.value = _agoraManager.isSpeakerEnabled;
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      isLoading.value = false;
      Get.snackbar(
        'Call Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 2), () => Get.back());
    }
  }

  void _updateRemainingTime() {
    if (_remainingSeconds <= 0) {
      remainingTime.value = '00:00:00';
      return;
    }
    // Format as hh:mm:ss
    final hours = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    remainingTime.value = '$hours:$minutes:$seconds';
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    if (_availableMinutes == null || _availableMinutes! <= 0) return;
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && isCallConnected.value) {
        _remainingSeconds--;
        _updateRemainingTime();
        
        // Note: Backend handles actual billing per-minute. This countdown is for UX only.
        // Backend will end call if wallet balance insufficient via WebSocket event.
        if (_remainingSeconds <= 0) {
          timer.cancel();
          _notifyDurationExpired();
        }
      }
    });
  }

  void _notifyDurationExpired() {
    if (_durationExpiredNotified) return;
    _durationExpiredNotified = true;
    _countdownTimer?.cancel();
    _remainingSeconds = 0;
    _updateRemainingTime();
    Get.snackbar(
      'Available Minutes Depleted',
      'Based on your wallet balance, you\'ve reached the estimated maximum. The call will continue until you manually end it or your balance is insufficient.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  /// Start manual billing timer - calculates and deducts money every minute as fallback
  void _startBillingTimer() {
    _billingTimer?.cancel();
    
    if (!isCallConnected.value) {
      if (kDebugMode) print('⚠️ Cannot start billing timer - call not connected');
      return;
    }
    
    // Wait a bit for pricePerMinute to be set if it's not ready yet
    if (pricePerMinute.value <= 0) {
      if (kDebugMode) print('⚠️ Price per minute is 0, waiting...');
      // Try again after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (pricePerMinute.value > 0 && isCallConnected.value) {
          _startBillingTimer();
        } else {
          if (kDebugMode) print('❌ Still no price per minute after delay. Price: ${pricePerMinute.value}');
        }
      });
      return;
    }
    
    if (kDebugMode) {
      print('═══════════════════════════════════════════════════════════');
      print('💰 Starting manual billing timer (Video)');
      print('💰 Rate: ₹${pricePerMinute.value}/min');
      print('💰 Initial Wallet Balance: ₹${walletBalance.value}');
      print('💰 Initial Total Cost: ₹${totalCost.value}');
      print('═══════════════════════════════════════════════════════════');
    }
    
    // CRITICAL: Deduct first minute AFTER 60 seconds (1 minute) completes, not immediately
    // This ensures charges are applied only when actual minutes have passed
    _billingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!isCallConnected.value) {
        if (kDebugMode) print('💰 Billing timer stopped - call disconnected');
        timer.cancel();
        return;
      }
      
      if (pricePerMinute.value <= 0) {
        if (kDebugMode) print('⚠️ Billing timer stopped - price per minute is 0');
        timer.cancel();
        return;
      }
      
      // Calculate which minute we're deducting (1st, 2nd, 3rd, etc.)
      final minuteNumber = totalMinutesBilled.value + 1;
      
      // Check if we have enough balance for this minute
      if (walletBalance.value < pricePerMinute.value) {
        if (kDebugMode) print('⚠️ Insufficient balance for minute $minuteNumber. Current: ₹${walletBalance.value}, Needed: ₹${pricePerMinute.value}');
        showLowBalanceWarning.value = true;
        timer.cancel();
        
        // End call if balance insufficient
        Future.delayed(const Duration(seconds: 2), () {
          if (walletBalance.value < pricePerMinute.value && isCallConnected.value) {
            Get.snackbar(
              'Insufficient Balance',
              'Your wallet balance is insufficient to continue the call',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            endCall();
          }
        });
        return;
      }
      
      // Deduct one minute's charge (this fires after each full minute completes)
      final balanceBefore = walletBalance.value;
      walletBalance.value = walletBalance.value - pricePerMinute.value;
      totalCost.value = totalCost.value + pricePerMinute.value;
      totalMinutesBilled.value = minuteNumber;
      _walletBalance = walletBalance.value; // Update private variable
      
      // Update available minutes based on remaining balance
      final newAvailableMinutes = (walletBalance.value / pricePerMinute.value).floor();
      _availableMinutes = newAvailableMinutes;
      if (newAvailableMinutes > 0) {
        _remainingSeconds = newAvailableMinutes * 60;
        _updateRemainingTime();
      } else {
        _remainingSeconds = 0;
        _updateRemainingTime();
      }
      
      // Check for low balance warning (less than 2 minutes remaining)
      if (walletBalance.value < (pricePerMinute.value * 2) && !showLowBalanceWarning.value) {
        showLowBalanceWarning.value = true;
        Get.snackbar(
          'Low Balance',
          'Your wallet balance is running low. Please recharge to continue.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      
      // Try to sync wallet balance with backend periodically (every 2 minutes)
      if (minuteNumber % 2 == 0) {
        _syncWalletBalanceWithBackend();
      }
      
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('💰 ⏰ MINUTE $minuteNumber COMPLETED - Deducting charges (Video)');
        print('💰 Amount deducted: ₹${pricePerMinute.value}');
        print('💰 Balance: ₹$balanceBefore → ₹${walletBalance.value}');
        print('💰 Total Cost (cumulative): ₹${totalCost.value}');
        print('💰 Expected cost for $minuteNumber minutes: ₹${pricePerMinute.value * minuteNumber}');
        print('💰 Total Minutes Billed: ${totalMinutesBilled.value}');
        print('💰 Available Minutes Remaining: $_availableMinutes');
        print('═══════════════════════════════════════════════════════════');
      }
    });
    
    if (kDebugMode) print('✅ Billing timer started - will deduct after each full minute completes (Video)');
  }

  /// Start periodic wallet sync timer
  void _startWalletSyncTimer() {
    _walletSyncTimer?.cancel();
    _walletSyncTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!isCallConnected.value) {
        timer.cancel();
        return;
      }
      _syncWalletBalanceWithBackend();
    });
    if (kDebugMode) print('✅ Wallet sync timer started - will sync every 30 seconds (Video)');
  }

  /// Sync wallet balance with backend
  Future<void> _syncWalletBalanceWithBackend() async {
    try {
      final backendBalance = await _profileHelper.getWalletBalance();
      // Always update with backend value (backend is authoritative)
      if (backendBalance >= 0) {
        if (backendBalance != walletBalance.value) {
          if (kDebugMode) {
            print('💰 Syncing wallet balance (Video): Local ₹${walletBalance.value} → Backend ₹$backendBalance');
          }
        }
        walletBalance.value = backendBalance;
        _walletBalance = backendBalance;
        
        // Recalculate available minutes
        if (pricePerMinute.value > 0) {
          _availableMinutes = (walletBalance.value / pricePerMinute.value).floor();
          if (isCallConnected.value && _availableMinutes! > 0) {
            _remainingSeconds = _availableMinutes! * 60;
            _updateRemainingTime();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Error syncing wallet balance: $e');
    }
  }

  Future<void> toggleMute() async {
    await _agoraManager.toggleMute();
    isMuted.value = _agoraManager.isMuted;
  }

  Future<void> toggleVideo() async {
    await _agoraManager.toggleVideo();
    isVideoOn.value = _agoraManager.isVideoEnabled;
  }

  Future<void> switchCamera() async {
    await _agoraManager.switchCamera();
  }

  Future<void> toggleSpeaker() async {
    await _agoraManager.toggleSpeaker();
    isSpeakerOn.value = _agoraManager.isSpeakerEnabled;
  }

  void toggleSpeakingIndicator() {
    // This is just for UI indication, actual speaking detection would require audio level monitoring
    isUserSpeaking.value = !isUserSpeaking.value;
  }

  void openChat() {
    // TODO: Open chat during video call
    Get.snackbar(
      'Coming Soon',
      'Chat feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> endCall() async {
    // Only show review prompt if call was connected
    final wasConnected = isCallConnected.value;
    
    // Stop all timers
    _billingTimer?.cancel();
    _walletSyncTimer?.cancel();
    
    // Disconnect WebSocket first
    await _disconnectSocket();
    
    // Sync wallet balance one final time before ending
    await _syncWalletBalanceWithBackend();
    
    // Calculate actual call duration and amount for backend billing
    int? actualTotalMinutes;
    double? actualTotalAmount;
    
    if (_callStartTime != null && totalMinutesBilled.value > 0) {
      // Use the actual minutes billed (calculated by our timer)
      actualTotalMinutes = totalMinutesBilled.value;
      actualTotalAmount = totalCost.value;
      
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('💰 CALCULATED BILLING PARAMETERS FOR BACKEND (Video)');
        print('   Total Minutes: $actualTotalMinutes');
        print('   Total Amount: ₹$actualTotalAmount');
        print('   Price Per Minute: ₹${pricePerMinute.value}');
        print('═══════════════════════════════════════════════════════════');
      }
    }
    
    // Call API to end the call with billing parameters (this will deduct money from wallet)
    if (_callId != null) {
      try {
        await _callService.endCall(
          callId: _callId!,
          totalMinutes: actualTotalMinutes,
          totalAmount: actualTotalAmount,
        );
        if (kDebugMode) {
          print('═══════════════════════════════════════════════════════════');
          print('✅ Video call ended via API with billing parameters');
          print('💰 Total Cost sent to backend: ₹${actualTotalAmount ?? 0}');
          print('💰 Minutes sent to backend: ${actualTotalMinutes ?? 0}');
          print('💰 Local Total Cost: ₹${totalCost.value}');
          print('💰 Final Balance (local): ₹${walletBalance.value}');
          print('💰 Minutes Billed: ${totalMinutesBilled.value}');
          print('═══════════════════════════════════════════════════════════');
        }
        
        // Sync wallet balance multiple times after call ends to ensure backend processed the deduction
        Future.delayed(const Duration(seconds: 1), () async {
          await _syncWalletBalanceWithBackend();
        });
        Future.delayed(const Duration(seconds: 3), () async {
          await _syncWalletBalanceWithBackend();
        });
        Future.delayed(const Duration(seconds: 5), () async {
          await _syncWalletBalanceWithBackend();
        });
      } catch (e) {
        debugPrint('Error calling end call API: $e');
        // Continue even if API call fails
      }
    }
    
    await _agoraManager.leaveChannel();
    await _agoraManager.dispose();
    Get.back();
    
    // Show review prompt after closing call screen
    if (wasConnected) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showReviewPrompt();
      });
    }
  }

  void _showReviewPrompt() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.star, color: AppColors.saffron, size: 24.w),
            SizedBox(width: 8.w),
            Expanded(
              child: AutoTranslateText(
                'Rate Your Experience',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                ).merge(AppTypography.h2),
              ),
            ),
          ],
        ),
        content: AutoTranslateText(
          'Would you like to rate your experience with ${astrologer.displayName}?',
          style: MyTextTheme.smallBCN.copyWith(
            color: const Color(0xFF666666),
          ).merge(AppTypography.body1),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText(
              'Maybe Later',
              style: MyTextTheme.smallBCN.copyWith(
                color: const Color(0xFF666666),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close prompt dialog
              Get.back(); // Go back from call screen
              // Navigate to astrologer detail with review prompt
              Future.delayed(const Duration(milliseconds: 300), () {
                Get.toNamed(AppRoutes.astrologerDetail, arguments: {
                  'astrologer': astrologer,
                  'showReviewPrompt': true,
                  'serviceType': 'VIDEO',
                });
              });
            },
            child: AutoTranslateText(
              'Rate Now',
              style: MyTextTheme.smallBCB.copyWith(
                color: AppColors.saffron,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get video views
  Widget? getLocalVideoView() {
    return _agoraManager.getLocalVideoView();
  }

  Widget? getRemoteVideoView() {
    if (_remoteUid == null) return null;
    return _agoraManager.getRemoteVideoView(_remoteUid!);
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _billingTimer?.cancel();
    _walletSyncTimer?.cancel();
    _disconnectSocket();
    _agoraManager.dispose();
    super.onClose();
  }
}
