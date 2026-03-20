import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/call_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/agora_call_manager.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart'
    show ServiceNotEnabledException;
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrologer_review_dialog.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_review_controller.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:astrobharataiuser/core/base/base_controller.dart';

class AstrologerVideoCallController extends BaseController {
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
  final RxString callStatus =
      'Initializing...'.obs; // Initializing..., Ringing..., Connected, Error
  final RxBool isRinging =
      false.obs; // True when waiting for astrologer to accept
  final RxBool isCallConnected = false.obs; // True when astrologer has joined

  // Store call data
  String? _callId;
  String? _channelName;
  String? _token;
  String? _appId;
  int? _remoteUid;
  int?
  _availableMinutes; // Max available minutes from wallet (for countdown UX)
  double? _walletBalance; // Current wallet balance (updated via WebSocket)
  double? _pricePerMinute; // Price per minute (updated via WebSocket)
  Timer? _countdownTimer; // Timer for countdown
  Timer? _billingTimer; // Timer for manual billing calculation (fallback)
  Timer? _walletSyncTimer; // Timer for periodic wallet balance sync
  Timer? _ringingCountdownTimer; // 2-min wait for astrologer to accept
  final RxInt ringingSecondsRemaining = 120.obs;
  int _remainingSeconds = 0; // Remaining seconds based on availableMinutes
  bool _durationExpiredNotified = false;
  DateTime?
  _callStartTime; // Track when call actually started (when astrologer joined)

  // WebSocket for billing updates
  io.Socket? _socket;
  // Socket.io URL (gateway, no port/IP-based routing)
  static const String callSocketUrl = 'https://api.astrobharatai.com';

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
      Get.offNamed(AppRoutes.userDashboard);
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
          if (kDebugMode)
            print('Socket connected but callId is empty, waiting...');
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
        if (kDebugMode)
          print('📡 Video Call WebSocket connection error: $error');
        isSocketConnected.value = false;
      });

      // Set up billing event listeners (will be used after call connects)
      _setupBillingEventListeners();
    } catch (e) {
      if (kDebugMode)
        print('Error connecting video call socket for notification: $e');
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
        if (kDebugMode)
          print(
            '⚠️ Session not active yet - waiting for session_started event...',
          );
      }
    });

    // Also listen for call-specific join confirmations
    // --- CALL ACCEPTANCE EVENTS (Strict Billing Trigger) ---
    _socket!.on('call_accepted', (data) async {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('✅ CALL ACCEPTED BY ASTROLOGER (Video Call)');
        print('Data: $data');
        print('═══════════════════════════════════════════════════════════');
      }

      // 1. Call connect API precisely when astrologer accepts to sync billing
      if (_callId != null && _callId!.isNotEmpty) {
        try {
          if (kDebugMode)
            print('📡 Calling connect API (post-accept) for callId: $_callId');
          await _callService.connectCall(_callId!);
          if (kDebugMode)
            print('✅ Connect API (post-accept) called successfully');
        } catch (e) {
          debugPrint('❌ Error calling connect API (post-accept): $e');
        }
      }

      // 2. Update call status to connected
      isRinging.value = false;
      isCallConnected.value = true;
      callStatus.value = 'Connected';
      isLoading.value = false;

      // 3. Show notification
      Get.snackbar(
        'Connected',
        'Astrologer accepted the call!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });

    _socket!.on('call_rejected', (data) {
      if (kDebugMode) print('❌ Call rejected by astrologer: $data');
      callStatus.value = 'Call Rejected';
      isRinging.value = false;
      isLoading.value = false;

      Get.snackbar(
        'Call Rejected',
        data['reason'] ?? 'Astrologer is currently unavailable.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      Future.delayed(const Duration(seconds: 2), () => Get.back());
    });

    // --- SESSION STARTED EVENT (like chat) - This triggers billing ---
    _socket!.on('session_started', (data) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print(
          '🎉 SESSION STARTED EVENT (Video Call) - Billing should start now!',
        );
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
        print(
          '🎉 CALL STARTED EVENT RECEIVED (Video Call) - Billing should start now!',
        );
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
        data['message'] ??
            'Your wallet balance is running low. Please recharge to continue.',
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
          '💰 Video Call Timer Anchor Synced: $newMoneySeconds seconds (Wallet: $wallet)',
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
          callStatus.value = 'Not accepted';
          isLoading.value = false;
          isRinging.value = false;
          _cancelAllTimers();
          Get.snackbar(
            '',
            'Astrologer did not accept the call.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
          break;
        case CallState.notAnswered:
          callStatus.value = 'Not accepted';
          isLoading.value = false;
          isRinging.value = false;
          _cancelAllTimers();
          Get.snackbar(
            '',
            'Astrologer did not accept the call.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
          break;
        case CallState.endedByRemote:
          callStatus.value = 'Call Ended';
          isLoading.value = false;
          isRinging.value = false;
          Future.delayed(const Duration(milliseconds: 400), () {
            endCall();
          });
          break;
      }
    };

    _agoraManager.onUserJoined = (uid) {
      _ringingCountdownTimer?.cancel();
      _ringingCountdownTimer = null;
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
          print(
            '💰 Backend should detect both parties joined and start billing',
          );
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
            '⚠️ Cannot emit billing events - Socket connected: ${isSocketConnected.value}, CallId: $_callId (Video)',
          );
      }

      // DO NOT start wallet sync timer - it resets balance
      // Backend will send billing_update events with the correct balance

      // DO NOT start client-side billing timer
      // Backend will handle billing and send billing_update events every minute
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('✅ Waiting for backend billing_update events (Video)');
        print('✅ Backend will deduct money and send updates every minute');
        print('═══════════════════════════════════════════════════════════');
      }

      // Start countdown timer when call is connected
      _startCountdownTimer();
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
        Future.delayed(const Duration(seconds: 1), () {
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
        });
      } else if (error == 'Call Ended') {
        callStatus.value = 'Call Ended';
        Future.delayed(const Duration(seconds: 1), () {
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
        });
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
        Future.delayed(const Duration(seconds: 2), () {
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
        });
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
      Future.delayed(const Duration(seconds: 2), () {
        try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
      });
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
      Future.delayed(const Duration(seconds: 2), () {
        try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
      });
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
          : (astrologer.videoPricePerMin ?? 0.0);

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
        print('💰 INITIALIZED BILLING VALUES (Video Call)');
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

      _remainingSeconds =
          _availableMinutes! *
          60; // Initialize remaining seconds from availableMinutes
      _durationExpiredNotified = false;
      _updateRemainingTime(); // Set initial remaining time display

      // IMPORTANT: Connect to WebSocket immediately after call initiation
      // Backend needs the WebSocket connection to notify astrologer about incoming call
      // We'll join the call room later (only for billing) after astrologer joins
      _connectSocketForNotification();

      // Initialize Agora (2-minute accept timeout)
      final initialized = await _agoraManager.initialize(
        appId: _appId!,
        isVideoCall: true,
        timeoutSeconds: 120,
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
        Future.delayed(const Duration(seconds: 2), () {
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
        });
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
      await Future.delayed(
        const Duration(seconds: 2),
      ); // 2 second delay for backend processing

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
        Future.delayed(const Duration(seconds: 2), () {
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
        });
        return;
      }

      isRinging.value = true;
      ringingSecondsRemaining.value = 120;
      _ringingCountdownTimer?.cancel();
      _ringingCountdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (ringingSecondsRemaining.value <= 0) {
          _ringingCountdownTimer?.cancel();
          _ringingCountdownTimer = null;
          _cancelAllTimers();
          Get.snackbar(
            '',
            'Astrologer did not accept the call.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
          return;
        }
        ringingSecondsRemaining.value = ringingSecondsRemaining.value - 1;
      });

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
      Future.delayed(const Duration(seconds: 2), () {
        try { Get.offNamed(AppRoutes.userDashboard); } catch (_) {}
      });
    }
  }

  void _cancelAllTimers() {
    _ringingCountdownTimer?.cancel();
    _ringingCountdownTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _billingTimer?.cancel();
    _billingTimer = null;
    _walletSyncTimer?.cancel();
    _walletSyncTimer = null;
  }

  String get formattedRingingCountdown {
    final s = ringingSecondsRemaining.value.clamp(0, 120);
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
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

  /// Sync wallet balance with backend
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

  void _popUntilOffCallScreen() {
    try {
      Get.offNamed(AppRoutes.userDashboard);
    } catch (_) {}
  }

  Future<void> endCall() async {
    final wasConnected = isCallConnected.value;
    final callId = _callId;
    final totalMins = totalMinutesBilled.value;
    final amount = totalCost.value;
    _cancelAllTimers();

    _disconnectSocket();
    if (callId != null) {
      _callService.endCall(
        callId: callId,
        totalMinutes: totalMins > 0 ? totalMins : null,
        totalAmount: amount > 0 ? amount : null,
      ).catchError((e) {
        debugPrint('End call API: $e');
        return false;
      });
    }
    _agoraManager.leaveChannel().then((_) => _agoraManager.dispose()).catchError((e) {
      debugPrint('Leave/dispose: $e');
    });

    try {
      Get.offNamed(AppRoutes.userDashboard);
    } catch (_) {}

    if (wasConnected) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _showReviewPrompt();
      });
    }
  }

  Future<void> _showReviewPrompt() async {
    AstrologerReview? existingReview;
    try {
      final reviewController = Get.put(
        AstrologerReviewController(),
        tag: astrologer.astrologerId,
        permanent: false,
      );
      await reviewController.loadMyReview(astrologer.astrologerId, serviceType: 'VIDEO');
      existingReview = reviewController.myReview.value;
    } catch (e) {
      if (kDebugMode) print('Failed to load existing review: $e');
    }

    AstrologerReviewDialog.showPrompt(
      context: Get.context!,
      astrologer: astrologer,
      serviceType: 'VIDEO',
      existingReview: existingReview,
      onMaybeLater: _popUntilOffCallScreen,
      onCloseAfterReview: _popUntilOffCallScreen,
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
    _cancelAllTimers();
    _disconnectSocket();
    _agoraManager.dispose();
    super.onClose();
  }
}
