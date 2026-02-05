import 'dart:async';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/call_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/agora_call_manager.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart'
    show ServiceNotEnabledException;
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

class AstrologerVoiceCallController extends GetxController {
  late AstrologerModel astrologer;
  final CallService _callService = CallService();
  final AgoraCallManager _agoraManager = AgoraCallManager();
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();

  final RxBool isMuted = false.obs;
  final RxBool isSpeakerOn = false.obs;
  final RxString callStatus =
      'Initializing...'.obs; // Initializing..., Ringing..., Connected, Error
  final RxString callDuration = '00:00'.obs;
  final RxString remainingTime = '00:00'.obs; // Countdown timer
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isRinging =
      false.obs; // True when waiting for astrologer to accept
  final RxBool isCallConnected = false.obs; // True when astrologer has joined

  // Store call data
  String? _callId;
  String? _channelName;
  String? _token;
  String? _appId;
  int? _timeoutSeconds;
  int?
  _availableMinutes; // NEW: Max available minutes from wallet (for countdown UX)
  double? _walletBalance; // Current wallet balance (updated via WebSocket)
  double? _pricePerMinute; // Price per minute (updated via WebSocket)
  Timer? _countdownTimer; // Timer for countdown
  Timer? _billingTimer; // Timer for manual billing calculation (fallback)
  Timer? _walletSyncTimer; // Timer for periodic wallet balance sync
  int _remainingSeconds = 0; // Remaining seconds based on availableMinutes
  bool _durationExpiredNotified = false;
  DateTime?
  _callStartTime; // Track when call actually started (when astrologer joined)

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

  // Money Anchor variables for robust visual sync (mirrors chat)
  DateTime? _lastMoneySyncTime;
  int _moneySecondsAtSync = 0;

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
        _availableMinutes =
            callData.availableMinutes ?? callData.durationMinutes;
        _walletBalance = callData.walletBalance ?? 0.0;
        walletBalance.value = _walletBalance!;
        _pricePerMinute = callData.pricePerMinute;
        pricePerMinute.value = _pricePerMinute!;

        // Initialize Money Anchor for robust visual countdown sync
        _syncMoneyAnchor(_walletBalance!, _pricePerMinute!);
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
        if (kDebugMode)
          print('Cannot connect socket for notification - callId is empty');
        return;
      }

      final token = UserData().accessToken ?? '';
      if (token.isEmpty) {
        if (kDebugMode) print('Cannot connect socket - no auth token');
        return;
      }

      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📡 Connecting to WebSocket for call notification...');
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
          print('📡 Call WebSocket connected');
          print('═══════════════════════════════════════════════════════════');
        }
        isSocketConnected.value = true;

        // CRITICAL: Follow exact same pattern as chat
        // Join call room IMMEDIATELY after socket connects (just like chat joins immediately)
        if (_callId != null && _callId!.isNotEmpty) {
          _joinCallRoom();
        } else {
          if (kDebugMode)
            print('Socket connected but callId is empty, waiting...');
        }
      });

      _socket!.onDisconnect((_) {
        isSocketConnected.value = false;
        if (kDebugMode) print('📡 Call WebSocket disconnected');
      });

      _socket!.onError((error) {
        if (kDebugMode) print('📡 Call WebSocket error: $error');
      });

      _socket!.onConnectError((error) {
        if (kDebugMode) print('📡 Call WebSocket connection error: $error');
        isSocketConnected.value = false;
      });

      // Set up billing event listeners (will be used after call connects)
      _setupBillingEventListeners();
    } catch (e) {
      if (kDebugMode)
        print('Error connecting call socket for notification: $e');
    }
  }

  /// Set up billing event listeners on the socket - Follow exact same pattern as chat
  void _setupBillingEventListeners() {
    if (_socket == null) return;

    // --- JOIN CONFIRMATION (like chat's join_success) ---
    _socket!.on('join_success', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('✅ JOINED CALL ROOM SUCCESSFULLY');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }

      // Check if session is active - if not, we need to wait for session_started event
      if (data is Map && data['sessionActive'] == true) {
        if (kDebugMode) print('✅ Session is ACTIVE - billing should start now');
      } else {
        if (kDebugMode)
          print(
            '⚠️ Session not active yet - waiting for session_started event...',
          );
      }
    });

    // Also listen for call-specific join confirmations
    _socket!.on('call_joined', (data) {
      if (kDebugMode) {
        print('✅ Call room joined confirmation: $data');
      }
    });

    // --- SESSION STARTED EVENT (like chat) - RECEIVED FROM BACKEND - This triggers billing ---
    // CRITICAL: Chat listens for this event FROM backend, we should too!
    _socket!.on('session_started', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('🎉 SESSION STARTED EVENT RECEIVED FROM BACKEND (Voice Call)');
        print(
          '💰 Billing should start now - Backend will send billing_update events!',
        );
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
        print('🎉 CALL STARTED EVENT (Voice Call) - Billing should start now!');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
    });

    // --- BILLING EVENTS (exact same as chat) ---
    _socket!.on('billing_update', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('💰💰💰 BILLING UPDATE RECEIVED (VOICE CALL) 💰💰💰');
        print('Raw Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }
      _handleBillingUpdate(data);
    });

    // Also listen for call-specific billing events (in case backend uses different event names)
    _socket!.on('call_billing_update', (data) {
      if (kDebugMode) print('💰 Call Billing Update (Voice Call): $data');
      _handleBillingUpdate(data);
    });

    _socket!.on('voice_call_billing', (data) {
      if (kDebugMode) print('💰 Voice Call Billing (Voice Call): $data');
      _handleBillingUpdate(data);
    });

    _socket!.on('low_balance_warning', (data) {
      if (kDebugMode) print('⚠️ Low Balance Warning (Voice Call): $data');

      if (data['balance'] != null) {
        final balance = (data['balance'] as num).toDouble();
        walletBalance.value = balance;
        _walletBalance = balance;
        _updateGlobalWalletBalance(balance);
      }

      showLowBalanceWarning.value = true;

      Get.snackbar(
        'Low Balance',
        data['message'] ??
            'Your wallet balance is running low. Please recharge to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    });

    _socket!.on('call_force_ended', (data) async {
      if (kDebugMode) print('🛑 Call Force Ended (Voice Call): $data');

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
        data['message'] ??
            'Your wallet balance is insufficient to continue the call',
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

      // Only update if balance significantly changed or first time
      // This prevents visual jitter while maintaining backend authority
      if ((newBalance - walletBalance.value).abs() > 0.1 ||
          walletBalance.value == 0) {
        walletBalance.value = newBalance;
        _walletBalance = newBalance;

        // Sync the Money Anchor - this is the source of truth for visual countdown
        _syncMoneyAnchor(newBalance, pricePerMinute.value);

        // Update global WalletController if registered
        _updateGlobalWalletBalance(newBalance);
      }

      if (kDebugMode) {
        print(
          '💰 Updated wallet balance from backend: ₹${walletBalance.value}',
        );
        print('💰 Total cost so far: ₹${totalCost.value}');
        print('💰 Minutes billed: ${totalMinutesBilled.value}');
      }
    }
  }

  /// Syncs the "Money Anchor" when balance or price changes significantly.
  /// This prevents the visual countdown from jumping and provides a smooth UX.
  void _syncMoneyAnchor(double wallet, double price) {
    if (price <= 0) return;
    int newMoneySeconds = (wallet / price * 60).floor();

    // If money changed significantly OR first time sync
    if (_lastMoneySyncTime == null ||
        (newMoneySeconds - _moneySecondsAtSync).abs() > 2) {
      if (kDebugMode) {
        print(
          '💰 Call Timer Anchor Synced: $newMoneySeconds seconds (Wallet: $wallet)',
        );
      }
      _moneySecondsAtSync = newMoneySeconds;
      _lastMoneySyncTime = DateTime.now();
      _remainingSeconds = _moneySecondsAtSync;
      _updateRemainingTime();
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
        print('📡 JOINING CALL ROOM (following chat pattern)');
        print('CallId: $_callId');
        print('Socket connected: ${_socket?.connected}');
        print('Socket ID: ${_socket?.id}');
        print('═══════════════════════════════════════════════════════════');
      }

      // Use exact same pattern as chat: emit join_call (like join_chat)
      final joinPayload = {'callId': _callId, 'role': 'user'};

      if (kDebugMode) {
        print('Join payload: $joinPayload');
      }

      _socket!.emit('join_call', joinPayload);

      if (kDebugMode) {
        print('✅ join_call event emitted');
        print('✅ Waiting for join_success confirmation...');
      }
    } else {
      if (kDebugMode) {
        print(
          '⚠️ Cannot join room - Socket connected: ${_socket?.connected}, CallId: $_callId',
        );
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
        if (kDebugMode) print('Error disconnecting call socket: $e');
      }
      _socket = null;
      isSocketConnected.value = false;
    }
  }

  void _setupAgoraCallbacks() {
    _agoraManager.onCallStateChanged = (state) {
      switch (state) {
        case CallState.initializing:
          callStatus.value = 'Initializing...';
          break;
        case CallState.joining:
          callStatus.value = 'Connecting...';
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
          callStatus.value = 'Disconnecting...';
          break;
        case CallState.idle:
          break;
        case CallState.error:
          callStatus.value = 'Error';
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
      isRinging.value = false;
      isCallConnected.value = true;
      callStatus.value = 'Connected';
      isLoading.value = false;

      // Record call start time for billing calculation
      _callStartTime = DateTime.now();
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('✅ ASTROLOGER JOINED - Call is now connected!');
        print('📞 Call started at: $_callStartTime');
        print('═══════════════════════════════════════════════════════════');
      }

      // CRITICAL: Emit WebSocket events to signal backend that call is active
      // Backend needs this to start billing (like chat receives session_started from backend)
      // For calls, backend might detect billing start from these events OR from Agora channel join detection
      if (isSocketConnected.value && _callId != null && _callId!.isNotEmpty) {
        if (kDebugMode) {
          print('═══════════════════════════════════════════════════════════');
          print('💰 EMITTING WEB SOCKET EVENTS TO START BILLING');
          print(
            '💰 Backend should detect both parties joined and start billing',
          );
          print('═══════════════════════════════════════════════════════════');
        }

        // Emit events that backend uses to detect call is active and both parties joined
        // Try multiple event names to match what backend expects
        _socket!.emit('call_active', {
          'callId': _callId,
          'callType': 'VOICE',
          'role': 'user',
          'status': 'ACTIVE',
          'timestamp': DateTime.now().toIso8601String(),
        });

        _socket!.emit('call_connected', {
          'callId': _callId,
          'callType': 'VOICE',
          'role': 'user',
          'status': 'CONNECTED',
          'timestamp': DateTime.now().toIso8601String(),
        });

        _socket!.emit('user_joined_call', {
          'callId': _callId,
          'callType': 'VOICE',
          'role': 'user',
          'channelName': _channelName,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Also emit call_started event (but NOT session_started - backend sends that!)
        // Backend should detect both parties joined and send session_started event
        _socket!.emit('call_started', {
          'callId': _callId,
          'callType': 'VOICE',
          'role': 'user',
          'timestamp': DateTime.now().toIso8601String(),
        });

        // NOTE: We DON'T emit session_started - that's sent BY the backend when it starts billing
        // (Following chat pattern - chat never emits session_started, only receives it)

        if (kDebugMode) {
          print('✅ Emitted multiple WebSocket events:');
          print('   - call_active');
          print('   - call_connected');
          print('   - user_joined_call');
          print('   - call_started');
          print(
            '✅ Waiting for backend to send session_started event (like chat)',
          );
          print(
            '✅ Backend should detect call is active, send session_started, then start billing',
          );
        }
      } else {
        if (kDebugMode)
          print(
            '⚠️ Cannot emit billing events - Socket connected: ${isSocketConnected.value}, CallId: $_callId',
          );
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
          if (_billingTimer == null &&
              isCallConnected.value &&
              pricePerMinute.value > 0) {
            if (kDebugMode) print('🔄 Retrying to start billing timer...');
            _startBillingTimer();
          }
        });
      });

      Get.snackbar(
        'Call Connected',
        'Astrologer joined the call',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    };

    _agoraManager.onUserOffline = (uid) {
      // Astrologer left the call
      if (isCallConnected.value) {
        // Call was connected, astrologer ended it
        Get.snackbar(
          'Call Ended',
          'Astrologer ended the call',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        Future.delayed(const Duration(seconds: 1), () {
          endCall(); // Use endCall to show review prompt
        });
      } else {
        // Call was ringing, astrologer rejected or didn't answer
        callStatus.value = 'Call Rejected';
        Get.snackbar(
          'Call Not Answered',
          'Astrologer did not answer the call',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Future.delayed(const Duration(seconds: 2), () {
          endCall(); // Don't show review if call wasn't connected
        });
      }
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
          duration: const Duration(seconds: 5),
        );
        if (_agoraManager.callState != CallState.timeout &&
            _agoraManager.callState != CallState.notAnswered &&
            _agoraManager.callState != CallState.endedByRemote) {
          Future.delayed(const Duration(seconds: 2), () => Get.back());
        }
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
        callType: 'VOICE',
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
      _availableMinutes =
          callData.availableMinutes ??
          (callData.durationMinutes > 0 ? callData.durationMinutes : 0);
      _walletBalance = callData.walletBalance ?? 0.0;
      _pricePerMinute =
          callData.pricePerMinute; // pricePerMinute is non-nullable

      // Initialize reactive variables - IMPORTANT: Set these correctly
      final initialWallet = callData.walletBalance ?? 0.0;
      final ratePerMin = callData.pricePerMinute;

      // CRITICAL: Ensure we have a valid rate - fallback to astrologer's rate if needed
      final finalRate = ratePerMin > 0
          ? ratePerMin
          : (astrologer.voicePricePerMin ?? 0.0);

      // Use wallet balance from CallData immediately (don't block on API call)
      // Fetch actual wallet balance from backend in background for accuracy
      walletBalance.value = initialWallet > 0 ? initialWallet : 0.0;
      pricePerMinute.value = finalRate;
      totalCost.value =
          0.0; // Start with 0 - will be calculated as call progresses
      totalMinutesBilled.value = 0;

      // Also update private variables
      _pricePerMinute = finalRate;
      _walletBalance = walletBalance.value;

      // Sync Money Anchor for robust visual countdown
      _syncMoneyAnchor(_walletBalance!, _pricePerMinute!);

      // Fetch actual wallet balance from backend asynchronously (non-blocking)
      // This ensures call setup is not delayed by API calls
      if (initialWallet <= 0) {
        _profileHelper
            .getWalletBalance()
            .then((balance) {
              if (balance > 0) {
                walletBalance.value = balance;
                _walletBalance = balance;
                if (kDebugMode)
                  print('💰 Updated wallet balance from backend: ₹$balance');
              }
            })
            .catchError((e) {
              if (kDebugMode)
                print('⚠️ Error fetching wallet balance (non-blocking): $e');
              // Don't show error to user - use CallData balance as fallback
            });
      }

      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('💰 INITIALIZED BILLING VALUES (Voice Call)');
        print('═══════════════════════════════════════════════════════════');
        print('  Call ID: $_callId');
        print('  Wallet Balance (from CallData): ₹$initialWallet');
        print(
          '  Wallet Balance (actual from backend): ₹${walletBalance.value}',
        );
        print('  Rate/Min: ₹${pricePerMinute.value}');
        print('  Available Minutes: $_availableMinutes');
        print('  Total Cost (initial): ₹${totalCost.value}');
        print('  Price from CallData: ₹${ratePerMin}');
        print('  Price from Astrologer: ₹${astrologer.voicePricePerMin}');
        print('  Final Rate Used: ₹${pricePerMinute.value}');
        print('═══════════════════════════════════════════════════════════');
      }

      if (pricePerMinute.value <= 0) {
        if (kDebugMode) print('❌ WARNING: Price per minute is 0 or invalid!');
      }

      if (walletBalance.value <= 0) {
        if (kDebugMode) print('❌ WARNING: Wallet balance is 0 or invalid!');
      }

      _remainingSeconds =
          _availableMinutes! *
          60; // Initialize remaining seconds from availableMinutes
      _durationExpiredNotified = false;
      _updateRemainingTime(); // Set initial remaining time display

      // IMPORTANT: Connect to WebSocket immediately after call initiation
      // Backend needs the WebSocket connection to notify astrologer about incoming call
      // We'll join the call room later (only for billing) after astrologer joins
      _connectSocketForNotification();

      // Debug logging
      debugPrint('Call data received:');
      debugPrint('  CallId: $_callId');
      debugPrint('  ChannelName: $_channelName');
      debugPrint('  Token length: ${_token?.length ?? 0}');
      debugPrint('  AppId: $_appId');
      debugPrint('  TimeoutSeconds: $_timeoutSeconds');
      debugPrint('  AvailableMinutes: $_availableMinutes');
      debugPrint('  WalletBalance: $_walletBalance');
      debugPrint('  PricePerMinute: $_pricePerMinute');

      // Initialize Agora
      final initialized = await _agoraManager.initialize(
        appId: _appId!,
        isVideoCall: false,
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
        print('⏳ Waiting 2 seconds before joining Agora channel...');
        print('⏳ Call ID: $_callId');
        print('⏳ Channel: $_channelName');
        print('⏳ This allows backend time to notify astrologer');
        print('═══════════════════════════════════════════════════════════');
      }
      callStatus.value = 'Preparing call...';
      await Future.delayed(
        const Duration(seconds: 2),
      ); // 2 second delay for backend processing

      // Now join channel - backend should have notified astrologer by now
      callStatus.value = 'Connecting to call...';
      if (kDebugMode) {
        print('📞 Now joining Agora channel...');
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

      // Sync mute state
      isMuted.value = _agoraManager.isMuted;
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
    final minutes = ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    remainingTime.value = '$hours:$minutes:$seconds';
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isCallConnected.value) {
        timer.cancel();
        return;
      }

      if (_lastMoneySyncTime != null) {
        final elapsedSinceSync = DateTime.now()
            .difference(_lastMoneySyncTime!)
            .inSeconds;
        final secondsRemaining = _moneySecondsAtSync - elapsedSinceSync;

        if (secondsRemaining <= 0) {
          _remainingSeconds = 0;
          // Don't auto-disconnect here, wait for backend call_force_ended event
          if (!_durationExpiredNotified) {
            _notifyDurationExpired();
          }
        } else {
          _remainingSeconds = secondsRemaining;
        }
        _updateRemainingTime();
      }
    });
  }

  /// Start manual billing timer - calculates and deducts money every minute as fallback
  /// IMPORTANT: First minute is deducted AFTER 1 minute completes, not immediately
  void _startBillingTimer() {
    _billingTimer?.cancel();

    if (!isCallConnected.value) return;

    if (kDebugMode) {
      print('💰 Starting periodic billing sync timer');
    }

    // This timer is now just a fallback for syncing balance from backend
    // Backend is the source of truth for all deductions
    _billingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!isCallConnected.value) {
        timer.cancel();
        return;
      }

      // Periodic backend sync
      _syncWalletBalanceWithBackend();
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

  Future<void> toggleMute() async {
    await _agoraManager.toggleMute();
    isMuted.value = _agoraManager.isMuted;
  }

  Future<void> toggleSpeaker() async {
    await _agoraManager.toggleSpeaker();
    isSpeakerOn.value = _agoraManager.isSpeakerEnabled;
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
    if (kDebugMode)
      print('✅ Wallet sync timer started - will sync every 30 seconds');
  }

  /// Sync wallet balance with backend
  Future<void> _syncWalletBalanceWithBackend() async {
    try {
      final backendBalance = await _profileHelper.getWalletBalance();
      // Always update with backend value (backend is authoritative)
      if (backendBalance >= 0) {
        if (backendBalance != walletBalance.value) {
          if (kDebugMode) {
            print(
              '💰 Syncing wallet balance: Local ₹${walletBalance.value} → Backend ₹$backendBalance',
            );
          }
        }
        walletBalance.value = backendBalance;
        _walletBalance = backendBalance;

        // Sync the Money Anchor for visual smoothness
        _syncMoneyAnchor(backendBalance, pricePerMinute.value);

        // Update global WalletController
        _updateGlobalWalletBalance(backendBalance);
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Error syncing wallet balance: $e');
    }
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
        print('💰 CALCULATED BILLING PARAMETERS FOR BACKEND');
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
          print('✅ Call ended via API with billing parameters');
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
                style: MyTextTheme.mediumBCB
                    .copyWith(color: const Color(0xFF5F2221))
                    .merge(AppTypography.h2),
              ),
            ),
          ],
        ),
        content: AutoTranslateText(
          'Would you like to rate your experience with ${astrologer.displayName}?',
          style: MyTextTheme.smallBCN
              .copyWith(color: const Color(0xFF666666))
              .merge(AppTypography.body1),
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
                Get.toNamed(
                  AppRoutes.astrologerDetail,
                  arguments: {
                    'astrologer': astrologer,
                    'showReviewPrompt': true,
                    'serviceType': 'AUDIO',
                  },
                );
              });
            },
            child: AutoTranslateText(
              'Rate Now',
              style: MyTextTheme.smallBCB.copyWith(color: AppColors.saffron),
            ),
          ),
        ],
      ),
    );
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
