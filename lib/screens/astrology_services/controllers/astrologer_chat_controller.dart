import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/controllers/global_chat_controller.dart';
import 'package:astrobharataiuser/core/services/chat_minimize_manager.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_review_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrologer_review_dialog.dart';
import 'package:astrobharataiuser/content_moderation/moderation_helper.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';

class AstrologerChatController extends BaseController
    with WidgetsBindingObserver {
  final AstrologerChatService _chatService = AstrologerChatService();
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();
  final AstrologerService _astrologerService = AstrologerService();

  AstrologerModel? _astrologer;
  final Rx<AstrologerModel?> astrologerRx = Rx<AstrologerModel?>(null);

  AstrologerModel get astrologer => _astrologer ?? astrologerRx.value!;
  String get astrologerName =>
      _astrologer?.displayName ??
      astrologerRx.value?.displayName ??
      'Astrologer';
  String? get astrologerImage =>
      _astrologer?.profilePicture ?? astrologerRx.value?.profilePicture;

  final String? initialChatId;
  final UserProfileModel? chatProfile;

  AstrologerChatController({
    AstrologerModel? astrologer,
    this.initialChatId,
    this.chatProfile,
  }) : _astrologer = astrologer {
    if (astrologer != null) {
      astrologerRx.value = astrologer;
    }
  }

  // Socket.io connection
  io.Socket? _socket;
  // Socket.io URL (gateway, no port/IP-based routing)
  static const String chatSocketUrl = 'https://api.astrobharatai.com';

  // Session
  final Rx<AstrologerChatSession?> currentSession = Rx<AstrologerChatSession?>(
    null,
  );
  final RxString chatId = ''.obs;
  final RxString sessionStatus = 'CREATED'.obs;

  // New Billing Stats
  final RxDouble walletBalance = 0.0.obs;
  final RxDouble pricePerMinute = 0.0.obs;
  final RxDouble totalCost = 0.0.obs;
  final RxInt totalMinutes = 0.obs;

  // Timer (Visual Only) - Robust Money Anchor Method
  Timer? _visualCountdownTimer;
  DateTime? _lastMoneySyncTime;
  int _moneySecondsAtSync = 0;

  final RxInt availableMinutes = 0.obs;
  final RxInt visualSecondsRemaining = 0.obs;
  final RxBool showLowBalanceWarning = false.obs;

  // Status Checking
  Timer? _statusCheckTimer;
  Timer? _activeSessionStatusCheckTimer;

  // 2-minute accept timeout (CREATED session) - running countdown
  Timer? _acceptTimeoutTimer;
  static const int _acceptTimeoutSeconds = 120;
  final RxInt acceptTimeoutSecondsRemaining = 120.obs;

  // Messages
  final RxList<AstrologerChatMessage> messages = <AstrologerChatMessage>[].obs;
  final RxBool isLoadingMessages = false.obs;

  // Message input
  final TextEditingController messageController = TextEditingController();
  final RxString messageText = ''.obs;

  // Typing indicator
  final RxBool isAstrologerTyping = false.obs;
  Timer? _typingTimer;

  // Connection status
  final RxBool isConnected = false.obs;
  final RxBool isOtherPartyOnline = false.obs;
  final RxBool isInChatRoom = false.obs;

  bool get astrologerOnlineStatus => _astrologer?.isOnline ?? false;

  /// Effective online status: when CREATED use astrologer model; when ACTIVE use socket data
  bool get effectiveOnlineStatus {
    if (sessionStatus.value == 'CREATED') {
      return astrologerOnlineStatus;
    }
    return isOtherPartyOnline.value;
  }

  // UI state
  final RxBool isSendingMessage = false.obs;
  final RxBool showRatingDialog = false.obs;
  bool _ratingDialogShown = false;

  // Formatted timer string (mm:ss)
  // Formatted timer string (mm:ss)
  String get formattedTimer {
    int seconds = visualSecondsRemaining.value;
    if (seconds == 0 && availableMinutes.value > 0) {
      seconds = availableMinutes.value * 60;
    }
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// 2-minute accept wait countdown (mm:ss) - decreases until 0 then chat is cancelled
  String get formattedAcceptTimeout {
    final s = acceptTimeoutSecondsRemaining.value.clamp(0, _acceptTimeoutSeconds);
    final m = (s / 60).floor();
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  // Session ending state
  bool _isEndingSession = false;
  Completer<void>? _sessionEndCompleter;

  // Reply feature
  final Rx<AstrologerChatMessage?> replyingToMessage =
      Rx<AstrologerChatMessage?>(null);
  final RxString messageToScrollTo = ''.obs;

  bool _profileMessageSent = false;

  @override
  void onInit() {
    super.onInit();
    Get.find<GlobalChatController>().setChatScreenStatus(true);
    WidgetsBinding.instance.addObserver(this);
    if (_astrologer != null) {
      pricePerMinute.value = _astrologer!.chatPrice ?? 0.0;
    }
    messageController.addListener(() {
      messageText.value = messageController.text;
      _emitTyping();
    });
    _initializeChat();
  }

  @override
  void onClose() {
    Get.find<GlobalChatController>().setChatScreenStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    _visualCountdownTimer?.cancel();
    _statusCheckTimer?.cancel();
    _activeSessionStatusCheckTimer?.cancel();
    _acceptTimeoutTimer?.cancel();
    _typingTimer?.cancel();
    messageController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('App Resumed: Syncing Session...');
      }
      _refreshSessionAndSync();
    }
  }

  /// Initialize chat - start session or join existing
  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;
      CrashlyticsService.trackAction(
        "CHAT",
        "INIT",
        data: "astrologer:${_astrologer?.astrologerId}, chatId:$initialChatId",
      );

      AstrologerChatSession? session;

      if (initialChatId != null && initialChatId!.isNotEmpty) {
        // CASE: Navigating with a specific chatId (e.g. from Dashboard recovery)
        chatId.value = initialChatId!;

        // Load session first to get astrologer ID
        session = await _chatService.getSession(initialChatId!);

        // CRITICAL: Always fetch astrologer when rejoining (even if _astrologer exists)
        // This ensures we have the latest data and the UI updates correctly.
        // When API omits astrologerId (session.astrologerId == 'unknown'), use _astrologer from nav args.
        final effectiveAstrologerId = (session.astrologerId.isEmpty ||
                    session.astrologerId == 'unknown') &&
                _astrologer != null
            ? _astrologer!.astrologerId
            : session.astrologerId;
        if (effectiveAstrologerId.isNotEmpty) {
          // Check if we already have the correct astrologer
          final needsFetch =
              _astrologer == null ||
              _astrologer!.astrologerId != effectiveAstrologerId ||
              _astrologer!.id != effectiveAstrologerId;

          if (needsFetch) {
            try {
              // Store astrologerId in local variable to avoid null issues in closures
              final astrologerIdToFind = effectiveAstrologerId;

              if (kDebugMode)
                print('🔍 Fetching astrologer for ID: $astrologerIdToFind');

              // Use the centralized method to get astrologer by ID
              final foundAstrologer = await _astrologerService
                  .getAstrologerById(astrologerIdToFind);

              if (foundAstrologer != null) {
                _astrologer = foundAstrologer;
                // CRITICAL: Update reactive value IMMEDIATELY so UI updates
                // Assigning a new object reference ensures GetX detects the change
                astrologerRx.value = foundAstrologer;
                // Force UI update by triggering a rebuild
                // GetX should detect the change, but we can also update other reactive values
                if (pricePerMinute.value <= 0) {
                  pricePerMinute.value = foundAstrologer.chatPrice ?? 0.0;
                }
                if (kDebugMode) {
                  print(
                    '✅ Astrologer found and loaded: ${foundAstrologer.displayName}',
                  );
                  print(
                    '✅ Astrologer image: ${foundAstrologer.profilePicture}',
                  );
                  print(
                    '✅ Reactive value set: ${astrologerRx.value?.displayName}',
                  );
                }
              } else {
                if (kDebugMode) {
                  print('⚠️ Astrologer not found for ID: $astrologerIdToFind');
                  print('⚠️ Will show placeholder "Astrologer" in UI');
                }
                // Clear reactive value to show placeholder
                astrologerRx.value = null;
              }
            } catch (e, stackTrace) {
              if (kDebugMode) {
                print('❌ Error fetching astrologer: $e');
                print('Stack trace: $stackTrace');
              }
              // Clear reactive value on error to show placeholder
              astrologerRx.value = null;
            }
          } else {
            // We already have the correct astrologer, but ensure reactive value is set
            if (astrologerRx.value == null ||
                astrologerRx.value!.astrologerId != _astrologer!.astrologerId ||
                astrologerRx.value!.id != _astrologer!.id) {
              astrologerRx.value = _astrologer;
              if (kDebugMode)
                print(
                  '✅ Using existing astrologer data: ${_astrologer!.displayName}',
                );
            }
          }
        } else {
          if (kDebugMode) print('⚠️ Session has no astrologerId');
        }

        // CRITICAL: Fetch wallet balance BEFORE updating session state to prevent low balance flash
        // Always fetch to ensure we have the latest balance, even if session has one
        try {
          final realBalance = await _profileHelper.getWalletBalance();
          final priceToUse = pricePerMinute.value > 0
              ? pricePerMinute.value
              : (session.billingConfig.pricePerMinute > 0
                    ? session.billingConfig.pricePerMinute
                    : 0.0);

          if (realBalance > 0) {
            // Pre-set wallet balance so _updateSessionState uses it
            walletBalance.value = realBalance;
            // CRITICAL: Pre-calculate available minutes BEFORE UI renders
            // This prevents low balance banner from showing during initialization
            if (priceToUse > 0) {
              availableMinutes.value = (realBalance / priceToUse).floor();
              // CRITICAL: Reset low balance warning if user has sufficient balance
              if (availableMinutes.value >= 2) {
                showLowBalanceWarning.value = false;
              }
            }
            if (kDebugMode) {
              print('✓ Wallet balance pre-loaded: $realBalance');
              print(
                '✓ Available minutes calculated: ${availableMinutes.value}',
              );
              print(
                '✓ Low balance warning reset: ${showLowBalanceWarning.value}',
              );
            }
          } else if (session.walletBalance != null &&
              session.walletBalance! > 0) {
            // Fallback to session balance if profile fetch fails
            walletBalance.value = session.walletBalance!;
            if (priceToUse > 0) {
              availableMinutes.value = (session.walletBalance! / priceToUse)
                  .floor();
              if (availableMinutes.value >= 2) {
                showLowBalanceWarning.value = false;
              }
            }
          }
        } catch (e) {
          if (kDebugMode) print('Error fetching wallet balance: $e');
          // Fallback to session balance if available
          if (session.walletBalance != null && session.walletBalance! > 0) {
            walletBalance.value = session.walletBalance!;
            final priceToUse = session.billingConfig.pricePerMinute > 0
                ? session.billingConfig.pricePerMinute
                : 0.0;
            if (priceToUse > 0) {
              availableMinutes.value = (session.walletBalance! / priceToUse)
                  .floor();
              if (availableMinutes.value >= 2) {
                showLowBalanceWarning.value = false;
              }
            }
          }
        }

        // Now update session state with complete data (astrologer + wallet balance)
        _updateSessionState(session);
      } else {
        // CASE: Normal entry, check for existing sessions with this astrologer
        if (_astrologer == null) throw Exception('Astrologer details missing');

        final activeSessions = await _chatService.getActiveSessions();
        final matchingSession = activeSessions.firstWhereOrNull(
          (s) => s.astrologerId == _astrologer!.astrologerId,
        );

        if (matchingSession != null) {
          session = matchingSession;
        } else {
          // No session exists, create a new one (status will be CREATED or ACTIVE based on backend)
          session = await _chatService.startSession(_astrologer!.astrologerId);
        }

        _updateSessionState(session);
      }

      // Connect socket and load messages in parallel for faster initialization
      await Future.wait([_connectSocket(), _loadMessages()]);

      // After socket and messages are loaded, refresh session to ensure wallet balance is correct
      // This prevents showing 0 balance initially
      // Don't await - let it run in background to not block UI
      _refreshSessionAndSync().catchError((e) {
        if (kDebugMode) print('Error refreshing session: $e');
      });

      // SESSION START LOGIC (Strict)
      if (sessionStatus.value == 'CREATED') {
        if (kDebugMode)
          print('Session is CREATED. Attempting to start/notify...');
        try {
          await _chatService.startExistingSession(chatId.value);
        } catch (e) {
          if (kDebugMode) print('Non-fatal error in startExistingSession: $e');
        }
        _startStatusCheckTimer();
        _startAcceptTimeoutTimer();
      } else if (sessionStatus.value == 'ACTIVE') {
        if (kDebugMode) print('Session is already ACTIVE. Resuming...');
        _handleSessionActive();
      }
    } catch (e, s) {
      if (kDebugMode) print('Init Chat Error: $e');
      reportError(e, s, type: CrashErrorType.auth, reason: "CHAT_INIT_FAILED");
      showErrorMessage(message: 'Failed to initialize chat: ${e.toString()}');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSessionState(AstrologerChatSession session) {
    currentSession.value = session;
    final previousChatId = chatId.value;
    chatId.value = session.chatId;
    sessionStatus.value = session.status;

    if (session.status == 'ACTIVE') {
      _acceptTimeoutTimer?.cancel();
    }

    // If chatId changed and socket is connected, join the new room
    if (previousChatId != chatId.value &&
        _socket?.connected == true &&
        chatId.value.isNotEmpty) {
      if (kDebugMode) print('ChatId updated, joining room: ${chatId.value}');
      _joinChatRoom();
    }

    // Billing Updates - Prefer pre-loaded balance, but update if session has better data
    // Don't overwrite if we already have a valid balance (prevents low balance flash)
    if (session.walletBalance != null && session.walletBalance! > 0) {
      // Only update if current balance is 0 or less (not initialized)
      // Otherwise, use the higher value to prevent showing low balance incorrectly
      if (walletBalance.value <= 0) {
        walletBalance.value = session.walletBalance!;
      } else {
        // Use the higher value to prevent showing low balance incorrectly
        walletBalance.value = walletBalance.value > session.walletBalance!
            ? walletBalance.value
            : session.walletBalance!;
      }
    }
    // If wallet balance is still 0, it means initialization didn't work
    // This should be rare, but we'll keep the async fallback as last resort

    if (session.billingConfig.pricePerMinute > 0) {
      pricePerMinute.value = session.billingConfig.pricePerMinute;
    } else if (pricePerMinute.value <= 0) {
      pricePerMinute.value = astrologer.chatPrice ?? 0.0;
    }

    totalCost.value = session.totalAmount ?? 0.0;
    totalMinutes.value = session.totalMinutesBilled ?? 0;

    // CORE TIMER SYNC: Determine the anchor for visual remaining time
    // Only calculate if we have valid balance and price (prevents showing 0 initially)
    if (walletBalance.value > 0 && pricePerMinute.value > 0) {
      // Calculate available minutes if not already set (prevents showing 0 initially)
      if (availableMinutes.value <= 0) {
        availableMinutes.value = (walletBalance.value / pricePerMinute.value)
            .floor();
      }

      // CRITICAL: Reset low balance warning if user has sufficient balance
      // This prevents the banner from showing during initialization
      if (availableMinutes.value >= 2) {
        showLowBalanceWarning.value = false;
      }

      if (sessionStatus.value == 'ACTIVE') {
        _syncMoneyAnchor(walletBalance.value, pricePerMinute.value);
      } else {
        // For non-active, just calculate static
        visualSecondsRemaining.value =
            (walletBalance.value / pricePerMinute.value * 60).floor();
      }
    } else {
      // If balance or price is not available, ensure warning is not shown
      showLowBalanceWarning.value = false;
    }
  }

  /// Syncs the "Money Anchor" when balance or price changes significantly.
  /// This prevents the 10s "snap-back" loop by tracking elapsed time locally.
  void _syncMoneyAnchor(double wallet, double price) {
    if (price <= 0) return;
    int newMoneySeconds = (wallet / price * 60).floor();

    // If money changed by more than 2s (billed minute or recharge) OR first time
    if (_lastMoneySyncTime == null ||
        (newMoneySeconds - _moneySecondsAtSync).abs() > 2) {
      if (kDebugMode) {
        print(
          'Timer Anchor Synced: $newMoneySeconds seconds (Wallet: $wallet)',
        );
      }
      _moneySecondsAtSync = newMoneySeconds;
      _lastMoneySyncTime = DateTime.now();
      visualSecondsRemaining.value = _moneySecondsAtSync;
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

  Future<void> _connectSocket() async {
    try {
      CrashlyticsService.trackAction(
        "CHAT",
        "SOCKET_CONNECT",
        data: "url:$chatSocketUrl",
      );
      final token = UserData().accessToken ?? '';
      if (token.isEmpty) throw Exception('No authentication token');

      _socket = io.io(
        chatSocketUrl,
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
        if (kDebugMode) print('Socket connected successfully');
        CrashlyticsService.trackAction(
          "CHAT",
          "SOCKET_CONNECTED",
          data: "socketId:${_socket!.id}",
        );
        isConnected.value = true;
        if (chatId.value.isNotEmpty) {
          _joinChatRoom();
        } else {
          if (kDebugMode)
            print('Socket connected but chatId is empty, waiting...');
        }
      });

      _socket!.onDisconnect((_) {
        isConnected.value = false;
        isInChatRoom.value = false;
        if (kDebugMode) print('Socket disconnected');
      });

      _socket!.onError((error) {
        if (kDebugMode) print('Socket error: $error');
        CrashlyticsService.trackAction(
          "CHAT",
          "SOCKET_ERROR",
          data: error.toString(),
        );
        isConnected.value = false;
      });

      _socket!.onConnectError((error) {
        if (kDebugMode) print('Socket connection error: $error');
        isConnected.value = false;
      });

      // --- CHAT EVENTS ---
      _socket!.on('join_success', (data) {
        if (kDebugMode) print('Joined room: $data');
        isInChatRoom.value = true;
        isOtherPartyOnline.value = data['isOtherPartyOnline'] ?? false;
        if (data['sessionStatus'] != null) {
          sessionStatus.value = data['sessionStatus'];
        }
      });

      _socket!.on('chat_accepted', (data) {
        if (kDebugMode) print('Chat accepted: $data');
        _acceptTimeoutTimer?.cancel();
        sessionStatus.value = 'ACTIVE';
        _handleSessionActive();
        _joinChatRoom();
      });

      _socket!.on('chat_rejected', (data) {
        if (kDebugMode) print('Chat rejected: $data');
        sessionStatus.value = 'CANCELLED';
        showErrorMessage(message: data['reason'] ?? 'Chat request rejected');
        Get.back();
      });

      _socket!.on('participant_joined', (data) {
        if (data['role'] == 'astrologer') {
          isOtherPartyOnline.value = true;
          if (kDebugMode) print('Astrologer joined');
        }
      });

      _socket!.on('participant_left', (data) {
        isOtherPartyOnline.value = false;
        showInfoMessage(message: 'Astrologer left the chat');
      });

      _socket!.on('participant_offline', (data) {
        isOtherPartyOnline.value = false;
        showInfoMessage(message: 'Astrologer went offline');
      });

      _socket!.on('new_message', (data) {
        if (kDebugMode) print('New message: $data');
        _handleNewMessage(data);
      });

      _socket!.on('message_sent', (data) {
        if (kDebugMode) print('Message sent acknowledgment: $data');
        _handleMessageSentAck(data);
      });

      _socket!.on('message_failed', (data) {
        if (kDebugMode) print('Message failed: $data');
        _handleMessageFailed(data);
      });

      _socket!.on('message_status_updated', (data) {
        if (kDebugMode) print('Status updated: $data');
        _handleMessageStatusUpdate(data);
      });

      _socket!.on('messages_read', (data) {
        if (kDebugMode) print('Messages read: $data');
        _handleMessagesReadAck(data);
      });

      _socket!.on('typing_indicator', (data) {
        if (data['userId'] != UserData().getLoginData.user?.userId) {
          isAstrologerTyping.value = data['typing'] ?? false;
        }
      });

      _socket!.on('billing_update', (data) {
        if (kDebugMode) print('Billing update: $data');
        _handleBillingUpdate(data);
      });

      _socket!.on('low_balance_warning', (data) {
        showLowBalanceWarning.value = true;
        showInfoMessage(message: data['message'] ?? 'Low balance warning');
      });

      _socket!.on('session_expiring', (data) {
        sessionStatus.value = 'EXPIRING';
        showInfoMessage(message: data['message'] ?? 'Session expiring');
      });

      _socket!.on('session_expired', (data) {
        sessionStatus.value = 'COMPLETED';
        _handleSessionEnd(
          'COMPLETED',
          reason: data['message'] ?? 'Session expired',
        );
        _socket?.emit('leave_chat', {'chatId': chatId.value});
      });

      _socket!.on('chat_force_ended', (data) {
        sessionStatus.value = 'COMPLETED';
        _handleSessionEnd(
          'COMPLETED',
          reason: data['message'] ?? 'Session force ended',
        );
        _socket?.emit('leave_chat', {'chatId': chatId.value});
      });

      _socket!.on('error', (error) {
        reportError(
          error,
          StackTrace.current,
          type: CrashErrorType.socket,
          reason: "SOCKET_ON_ERROR",
        );
      });
      _socket!.on(
        'message_status_updated',
        (data) => _handleMessageStatusUpdate(data),
      );
      _socket!.on('participant_joined', (data) {
        if (data['role'] == 'astrologer') isOtherPartyOnline.value = true;
        // If we were waiting for astrologer to join/start
        if (sessionStatus.value == 'CREATED') _refreshSessionAndSync();
      });

      // --- BILLING & SESSION EVENTS (Strict Backend Authority) ---

      _socket!.on('session_started', (data) {
        if (kDebugMode) print('Session Started Event: $data');
        CrashlyticsService.trackAction(
          "CHAT",
          "SESSION_STARTED",
          data: data.toString(),
        );
        sessionStatus.value = 'ACTIVE';
        _handleSessionActive();
        _refreshSessionAndSync();
      });

      _socket!.on('billing_update', (data) {
        if (kDebugMode) print('Billing Update: $data');

        if (data['minutesBilled'] != null)
          totalMinutes.value = data['minutesBilled'];
        if (data['totalAmount'] != null)
          totalCost.value = (data['totalAmount'] as num).toDouble();
        if (data['remainingBalance'] != null) {
          final newBalance = (data['remainingBalance'] as num).toDouble();
          walletBalance.value = newBalance;

          // Authority update - anchor sync will only trigger if money actually changed
          _syncMoneyAnchor(walletBalance.value, pricePerMinute.value);

          // Update global WalletController if registered
          _updateGlobalWalletBalance(newBalance);
        }
      });

      _socket!.on('low_balance_warning', (data) {
        // Expected: { balance: 25, minutesRemaining: 1, message: "..." }
        showLowBalanceWarning.value = true;
        if (data['balance'] != null) {
          final newBalance = (data['balance'] as num).toDouble();
          walletBalance.value = newBalance;
          _updateGlobalWalletBalance(newBalance);
        }
        if (data['minutesRemaining'] != null) {
          availableMinutes.value = data['minutesRemaining'];
          // Use balance for precision if available
          if (data['balance'] != null && pricePerMinute.value > 0) {
            visualSecondsRemaining.value =
                (walletBalance.value / pricePerMinute.value * 60).floor();
          } else {
            visualSecondsRemaining.value = availableMinutes.value * 60;
          }
        }

        showInfoMessage(
          message:
              data['message'] ??
              'Your wallet balance is running low. Please recharge to continue.',
        );
      });

      _socket!.on('chat_force_ended', (data) async {
        // Expected: { reason: "INSUFFICIENT_BALANCE", message: "...", balance: 10 }
        if (kDebugMode) print('Force Ended (User Spec): $data');

        sessionStatus.value = 'COMPLETED';
        if (data['balance'] != null) {
          final newBalance = (data['balance'] as num).toDouble();
          walletBalance.value = newBalance;
          _updateGlobalWalletBalance(newBalance);
        }
        availableMinutes.value = 0;
        visualSecondsRemaining.value = 0;

        // Disable input immediately
        isSendingMessage.value = false;

        _handleSessionEnd(
          'COMPLETED',
          reason:
              data['message'] ??
              'Your wallet balance is insufficient to continue the chat',
        );

        // Disconnect immediately and navigate to recharge
        await _disconnectSocket();
      });

      _socket!.on('session_expired', (data) async {
        // Expected: { chatId, reason: 'TIME_EXPIRED', message, sessionDetails: {...} }
        if (kDebugMode) print('Session Expired: $data');

        sessionStatus.value = 'EXPIRED';
        availableMinutes.value = 0;
        visualSecondsRemaining.value = 0;
        isSendingMessage.value = false;

        _handleSessionEnd(
          'EXPIRED',
          reason: data['message'] ?? 'Your session time has expired',
        );

        await _disconnectSocket();
      });

      _socket!.on('session_ended', (data) {
        if (kDebugMode) print('📨 Received session_ended event: $data');

        // If we're waiting for this event (user initiated end), complete the completer
        // BUT don't call _handleSessionEnd here - let endChat() handle it
        if (_isEndingSession &&
            _sessionEndCompleter != null &&
            !_sessionEndCompleter!.isCompleted) {
          if (kDebugMode)
            print(
              '✅ Completing session end - user initiated, will handle in endChat()',
            );
          sessionStatus.value = 'COMPLETED';
          _sessionEndCompleter!.complete();
          // Don't call _handleSessionEnd here - endChat() will handle it
          return;
        }

        // Astrologer ended the chat
        if (sessionStatus.value != 'COMPLETED') {
          if (kDebugMode) print('ℹ️ Astrologer ended the chat session');
          sessionStatus.value = 'COMPLETED';
          isSendingMessage.value = false;
          _handleAstrologerEndedSession();
        }
      });
    } catch (e) {
      if (kDebugMode) print('Socket connection error: $e');
    }
  }

  void _joinChatRoom() {
    if (_socket?.connected == true && chatId.value.isNotEmpty) {
      if (kDebugMode) {
        print('=== JOINING CHAT ROOM ===');
        print('ChatId: ${chatId.value}');
        print('Socket connected: ${_socket?.connected}');
        print('Socket ID: ${_socket?.id}');
      }

      final joinPayload = {'chatId': chatId.value};

      if (kDebugMode) {
        print('Join payload: $joinPayload');
      }

      _socket!.emit('join_chat', joinPayload);

      if (kDebugMode) {
        print('Join_chat event emitted');
      }
    } else {
      if (kDebugMode) {
        print(
          'Cannot join room - Socket connected: ${_socket?.connected}, ChatId: ${chatId.value}',
        );
      }
    }
  }

  Future<void> _disconnectSocket({bool emitEvents = false}) async {
    if (_socket != null) {
      isInChatRoom.value = false;
      // Optionally emit events if called directly (not from endChat which already emitted them)
      if (emitEvents && chatId.value.isNotEmpty && _socket!.connected) {
        try {
          if (kDebugMode) print('🔔 Emitting events before disconnecting...');
          _socket!.emit('end_session', {
            'chatId': chatId.value,
            'reason': 'USER_ENDED',
          });
          _socket!.emit('leave_chat', {'chatId': chatId.value});
          _socket!.emit('user_ended', {
            'chatId': chatId.value,
            'reason': 'USER_ENDED',
          });
          // Brief delay to ensure events are sent
          await Future.delayed(const Duration(milliseconds: 200));
        } catch (e) {
          if (kDebugMode) print('⚠️ Error emitting events: $e');
        }
      }
      // Now disconnect
      if (kDebugMode) print('🔌 Disconnecting socket...');
      try {
        _socket!.disconnect();
        _socket!.dispose();
      } catch (e) {
        if (kDebugMode) print('⚠️ Error during socket disconnect: $e');
      }
      _socket = null;
      if (kDebugMode) print('✅ Socket disconnected');
    }
  }

  // --- LOGIC ---

  void _handleSessionActive() {
    _statusCheckTimer?.cancel();
    _startActiveSessionStatusCheck();
    isOtherPartyOnline.value = true;

    // Ensure socket is connected and in the chat room when session becomes active
    if (_socket?.connected == true &&
        chatId.value.isNotEmpty &&
        !isInChatRoom.value) {
      if (kDebugMode)
        print('Session became ACTIVE, ensuring we are in chat room...');
      _joinChatRoom();
    }

    _startVisualCountdown();
    // Only send profile message after session is ACTIVE
    _sendProfileMessageIfNeeded();
    _notifyGlobalOnSessionActive();
  }

  /// Visual Countdown - Monotonic & Anchored.
  /// Calculates: MoneyAtSync - ElapsedSinceSync.
  /// This stays stable even when server balance is lazy.
  void _startVisualCountdown() {
    _visualCountdownTimer?.cancel();

    // Ensure we have an initial anchor
    if (_lastMoneySyncTime == null) {
      _syncMoneyAnchor(walletBalance.value, pricePerMinute.value);
    }

    _visualCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sessionStatus.value != 'ACTIVE') {
        timer.cancel();
        return;
      }

      if (_lastMoneySyncTime != null) {
        final elapsed = DateTime.now()
            .difference(_lastMoneySyncTime!)
            .inSeconds;
        int remaining = _moneySecondsAtSync - elapsed;

        if (remaining < 0) remaining = 0;
        visualSecondsRemaining.value = remaining;
      }
    });
  }

  Future<void> endChat() async {
    if (kDebugMode) {
      print('🛑 endChat() called');
      print('🛑 chatId: ${chatId.value}');
      print('🛑 isLoading: ${isLoading.value}');
      print('🛑 _isEndingSession: $_isEndingSession');
    }

    if (chatId.value.isEmpty) {
      if (kDebugMode) print('❌ Cannot end chat - chatId is empty');
      return;
    }

    if (isLoading.value) {
      if (kDebugMode) print('❌ Cannot end chat - already loading');
      return;
    }

    if (_isEndingSession) {
      if (kDebugMode) print('❌ Cannot end chat - already ending');
      return;
    }

    try {
      isLoading.value = true;
      _isEndingSession = true;
      _sessionEndCompleter = Completer<void>();

      if (kDebugMode) print('🛑 User ending chat session...');

      // STEP 1: Call REST API to end session
      // Per strict guide: Only use REST API POST /api/chat/session/:chatId/end
      // No socket events for ending - backend will broadcast session_ended when REST API is called
      if (kDebugMode) print('📞 Calling REST API to end session...');
      try {
        final endedSession = await _chatService.endSession(chatId.value);
        if (kDebugMode) {
          print('✅ Session ended on server - Status: ${endedSession.status}');
        }
      } catch (e) {
        if (kDebugMode) print('❌ Error calling endSession API: $e');
        // Continue to local cleanup even if API fails
      }

      // STEP 2: Leave chat room
      if (_socket?.connected == true && chatId.value.isNotEmpty) {
        try {
          if (kDebugMode) print('🚪 Leaving chat room...');
          _socket!.emit('leave_chat', {'chatId': chatId.value});
          await Future.delayed(const Duration(milliseconds: 200));
        } catch (e) {
          if (kDebugMode) print('⚠️ Error leaving chat room: $e');
        }
      }

      // STEP 3: Update local state and handle session end (will disconnect socket)
      sessionStatus.value = 'COMPLETED';
      await _handleSessionEnd('COMPLETED', reason: 'User ended the chat');
    } catch (e) {
      if (kDebugMode) print('❌ End Chat Error: $e');
      // If anything fails, still end locally
      sessionStatus.value = 'COMPLETED';
      await _handleSessionEnd('COMPLETED', reason: 'Session ended');
    } finally {
      _isEndingSession = false;
      _sessionEndCompleter = null;
      isLoading.value = false;
    }
  }

  Future<void> followAstrologer() async {
    final astroId =
        _astrologer?.astrologerId ?? currentSession.value?.astrologerId;
    if (astroId == null || astroId.isEmpty) return;

    try {
      // Use the service default source (PROFILE) which the backend accepts.
      // Previously we passed 'CHAT' which caused a 400: Invalid source value.
      final result = await _astrologerService.followAstrologer(astroId);
      if (result['success'] == true) {
        showSuccessMessage(message: 'You are now following $astrologerName');
      } else {
        showErrorMessage(message: 'Failed to follow astrologer');
      }
    } catch (e) {
      if (kDebugMode) print('Follow Error: $e');
    }
  }

  Future<void> _showFollowDialogIfNeeded(String? reason) async {
    final astroId =
        _astrologer?.astrologerId ?? currentSession.value?.astrologerId;
    if (astroId == null || astroId.isEmpty) {
      _exitAfterChat(reason);
      return;
    }

    try {
      // Check follow status first
      final status = await _astrologerService.getFollowStatus(astroId);
      bool isFollowing = status?['isFollowing'] ?? false;

      if (isFollowing) {
        _exitAfterChat(reason);
        return;
      }

      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text('Follow $astrologerName?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Stay updated with their latest sessions and special offers!',
              ),
              if (kDebugMode) const Text('\n(User requested this popup)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                _exitAfterChat(reason);
              },
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back(); // close follow dialog
                await followAstrologer();
                _exitAfterChat(reason);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text(
                'Follow',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      _exitAfterChat(reason);
    }
  }

  void _exitAfterChat(String? reason) {
    final lowerReason = (reason ?? '').toLowerCase();
    if (lowerReason.contains('balance') || lowerReason.contains('money')) {
      Get.offNamed('/wallet');
    } else {
      // Exit the chat screen
      Get.back();
    }
  }

  Future<void> _refreshSessionAndSync() async {
    if (chatId.value.isEmpty) return;
    try {
      final session = await _chatService.getSession(chatId.value);
      _updateSessionState(session);

      if (session.status == 'ACTIVE') {
        if (_visualCountdownTimer == null || !_visualCountdownTimer!.isActive) {
          _handleSessionActive();
        }
      } else if (session.status == 'COMPLETED' || session.status == 'EXPIRED') {
        // CRITICAL FIX: Don't auto-end based on periodic status check alone
        // Only end if the local status is already COMPLETED/EXPIRED (meaning it was ended via socket event or user action)
        // This prevents false endings when server temporarily returns wrong status

        // If local status is still ACTIVE/CREATED, don't trust server's COMPLETED/EXPIRED status
        // Wait for explicit socket event (chat_force_ended, session_ended) which are authoritative
        if (sessionStatus.value == 'COMPLETED' ||
            sessionStatus.value == 'EXPIRED') {
          // Already ended locally, just ensure sync
          if (kDebugMode) {
            print(
              '✅ Session already ended locally (${sessionStatus.value}), server confirms: ${session.status}',
            );
          }
          // Don't call _handleSessionEnd again - it's already been called
        } else {
          // Server says COMPLETED/EXPIRED but we're still ACTIVE locally
          // This could be a false positive - only end if we truly have no balance
          if (walletBalance.value <= 0 &&
              availableMinutes.value <= 0 &&
              pricePerMinute.value > 0) {
            // User truly has no balance - this is a legitimate end
            if (kDebugMode) {
              print(
                '⚠️ Server reports ${session.status} and user has no balance - ending chat',
              );
              print(
                '⚠️ Wallet: ${walletBalance.value}, Minutes: ${availableMinutes.value}',
              );
            }
            _handleSessionEnd(session.status, reason: 'Insufficient balance');
          } else {
            // False positive - ignore server status, keep session active
            if (kDebugMode) {
              print(
                '⚠️ Server reports ${session.status} but session is ACTIVE locally',
              );
              print(
                '⚠️ Wallet: ${walletBalance.value}, Minutes: ${availableMinutes.value}',
              );
              print(
                '⚠️ Ignoring server status - waiting for explicit socket event',
              );
            }
            // Don't end - wait for authoritative socket event
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print('Sync Error: $e');
    }

    // AGGRESSIVE FALLBACK: If walletBalance is still 0, try fetching from profile helper
    if (walletBalance.value <= 0) {
      final realBalance = await _profileHelper.getWalletBalance();
      if (realBalance > 0) {
        walletBalance.value = realBalance;
        if (pricePerMinute.value > 0) {
          availableMinutes.value = (walletBalance.value / pricePerMinute.value)
              .floor();
          // Use the anchor for stability even in fallback
          _syncMoneyAnchor(walletBalance.value, pricePerMinute.value);
        }
      }
    }
  }

  void sendMessage() {
    if (kDebugMode) {
      print('=== sendMessage() called ===');
      print('Message text: ${messageController.text.trim()}');
      print('Session status: ${sessionStatus.value}');
      print('Socket connected: ${_socket?.connected}');
      print('In chat room: ${isInChatRoom.value}');
      print('ChatId: ${chatId.value}');
    }

    // Validation
    final text = messageController.text.trim();
    if (text.isEmpty) {
      if (kDebugMode) print('Message is empty, returning');
      return;
    }
    // Content moderation: block abusive words, phone numbers, and links
    final _moderationHelper = ModerationHelper(minWordLength: 2);
    final blocked = _moderationHelper.getBlockedContentResult(text);
    if (blocked.blocked) {
      showErrorMessage(message: blocked.userMessage);
      return;
    }
    if (sessionStatus.value != 'ACTIVE') {
      if (kDebugMode)
        print(
          'Session is not ACTIVE (${sessionStatus.value}), cannot send until astrologer accepts',
        );
      showErrorMessage(
        message: 'Please wait for astrologer to accept the chat.',
      );
      return;
    }

    isSendingMessage.value = true;
    final userData = UserData();
    final userId = userData.getLoginData.user?.userId;
    // clientMessageId = timestamp-based id as per guide
    final clientMsgId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    final replyToMessage = replyingToMessage.value;

    final newMessage = AstrologerChatMessage(
      messageId: clientMsgId, // Store clientMessageId as messageId initially
      chatId: chatId.value,
      senderId: userId ?? 'unknown',
      senderType: 'USER',
      messageType: 'TEXT',
      content: text,
      status: 'SENDING',
      sentAt: DateTime.now().toUtc(),
      replyTo: replyToMessage != null
          ? ReplyData(
              messageId: replyToMessage.messageId,
              senderId: replyToMessage.senderId,
              senderType: replyToMessage.senderType,
              snippet: replyToMessage.isImage
                  ? 'Image'
                  : (replyToMessage.content ?? 'Message'),
              messageType: replyToMessage.messageType,
            )
          : null,
    );

    messages.insert(0, newMessage);
    messageController.clear();
    replyingToMessage.value = null;

    // Ensure socket is connected and we're in the chat room before sending
    // Also allow sending if socket is connected and we've joined (even if flag not set yet)
    final canSend =
        _socket?.connected == true &&
        (isInChatRoom.value || chatId.value.isNotEmpty);

    if (canSend) {
      final messagePayload = {
        'chatId': chatId.value,
        'content': text,
        'messageType': 'TEXT',
        'clientMessageId': clientMsgId,
        'replyToId': newMessage.replyTo?.messageId,
      };

      if (kDebugMode) {
        print('=== SENDING MESSAGE VIA SOCKET ===');
        print('Payload: $messagePayload');
        print('Socket ID: ${_socket?.id}');
        print('Socket connected: ${_socket?.connected}');
        print('In chat room: ${isInChatRoom.value}');
        print('ChatId: ${chatId.value}');
        print('Session status: ${sessionStatus.value}');
      }

      try {
        _socket!.emit('send_message', messagePayload);

        if (kDebugMode) {
          print('✓ Message emit() called successfully');
          print('Waiting for server to broadcast via new_message event...');
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print('✗ ERROR emitting message: $e');
          print('Stack trace: $stackTrace');
        }
        showErrorMessage(message: 'Failed to send message. Please try again.');
        // Remove optimistic message
        final index = messages.indexWhere((m) => m.messageId == clientMsgId);
        if (index != -1) {
          messages.removeAt(index);
        }
      }
    } else {
      // Fallback or Error
      if (kDebugMode) {
        print(
          'Cannot send message - Socket connected: ${_socket?.connected}, In room: ${isInChatRoom.value}',
        );
        print('ChatId: ${chatId.value}');
      }

      // If socket is connected but not in room, try joining
      if (_socket?.connected == true &&
          !isInChatRoom.value &&
          chatId.value.isNotEmpty) {
        if (kDebugMode) print('Socket connected but not in room, joining...');
        _joinChatRoom();
        // Wait for join to complete, then retry send
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (isInChatRoom.value && _socket?.connected == true) {
            _socket!.emit('send_message', {
              'chatId': chatId.value,
              'content': text,
              'messageType': 'TEXT',
              'clientMessageId': clientMsgId,
              'replyToId': newMessage.replyTo?.messageId,
            });
            if (kDebugMode) print('Retried sending message after joining room');
          } else {
            showErrorMessage(
              message: 'Please wait for connection to establish.',
            );
            messages.removeAt(0); // Remove optimistic
          }
        });
        isSendingMessage.value = false;
        return;
      }

      if (kDebugMode) {
        print('Attempting to reconnect...');
      }

      // Try to reconnect and resend
      _connectSocket()
          .then((_) {
            if (_socket?.connected == true && chatId.value.isNotEmpty) {
              _joinChatRoom();
              // Wait a bit for join to complete, then retry send
              // Check periodically if we're in the room
              int attempts = 0;
              Timer.periodic(const Duration(milliseconds: 500), (timer) {
                attempts++;
                if (isInChatRoom.value && _socket?.connected == true) {
                  timer.cancel();
                  if (kDebugMode)
                    print('Reconnected and joined room, retrying message send');
                  _socket!.emit('send_message', {
                    'chatId': chatId.value,
                    'content': text,
                    'messageType': 'TEXT',
                    'clientMessageId': clientMsgId,
                    'replyToId': newMessage.replyTo?.messageId,
                  });
                } else if (attempts >= 10) {
                  // Timeout after 5 seconds (10 attempts * 500ms)
                  timer.cancel();
                  if (kDebugMode)
                    print('Timeout waiting for room join after reconnect');
                  showErrorMessage(
                    message: 'Connection timeout. Please try again.',
                  );
                  messages.removeAt(0); // Remove optimistic
                }
              });
            } else {
              showErrorMessage(message: 'Connection lost. Message not sent.');
              messages.removeAt(0); // Remove optimistic
            }
          })
          .catchError((e) {
            if (kDebugMode) print('Reconnection failed: $e');
            showErrorMessage(message: 'Connection lost. Message not sent.');
            messages.removeAt(0); // Remove optimistic
          });
    }

    isSendingMessage.value = false;
  }

  void _handleNewMessage(dynamic data) {
    if (kDebugMode) print('Handling new message: $data');

    final userData = UserData();
    final userId = userData.getLoginData.user?.userId;

    if (data['senderId'] == userId) {
      // Confirm own message sent
      _handleMessageSentAck(data);
    } else {
      // Incoming message from astrologer
      final message = AstrologerChatMessage.fromJson(data);
      if (!messages.any((m) => m.messageId == message.messageId)) {
        messages.insert(0, message);
        messages.refresh();

        // Emit message_delivered immediately as per guide
        _socket?.emit('message_delivered', {
          'chatId': chatId.value,
          'messageId': message.messageId,
        });

        // Automatically mark as read if in room
        if (isInChatRoom.value) {
          _markMessageAsRead(message.messageId);
        }

        // Transition from CREATED to ACTIVE if needed
        if (sessionStatus.value == 'CREATED') {
          _refreshSessionAndSync();
        }
      }
    }
  }

  void _handleMessageSentAck(dynamic data) {
    // guid: clientMessageId should match what we sent
    final clientMsgId = data['clientMessageId'];
    final serverMsgId = data['messageId'] ?? data['_id'];

    if (clientMsgId != null) {
      final index = messages.indexWhere((m) => m.messageId == clientMsgId);
      if (index != -1) {
        messages[index] = messages[index].copyWith(
          status: 'SENT',
          messageId: serverMsgId,
        );
        messages.refresh();
        if (kDebugMode) print('Message confirmed SENT: $serverMsgId');
      }
    }
  }

  void _handleMessageFailed(dynamic data) {
    final clientMsgId = data['clientMessageId'];
    if (clientMsgId != null) {
      final index = messages.indexWhere((m) => m.messageId == clientMsgId);
      if (index != -1) {
        messages[index] = messages[index].copyWith(status: 'FAILED');
        messages.refresh();
      }
    }
    showErrorMessage(message: data['message'] ?? 'Failed to send message');
  }

  void _handleMessageStatusUpdate(dynamic data) {
    final messageId = data['messageId'];
    final status = data['status']; // e.g., 'DELIVERED', 'READ'
    final index = messages.indexWhere((m) => m.messageId == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(status: status);
      messages.refresh();
      if (kDebugMode) print('Message $messageId status updated to $status');
    }
  }

  void _handleMessagesReadAck(dynamic data) {
    final List<dynamic>? messageIds = data['messageIds'];
    if (messageIds != null) {
      for (var id in messageIds) {
        final index = messages.indexWhere((m) => m.messageId == id);
        if (index != -1) {
          messages[index] = messages[index].copyWith(status: 'READ');
        }
      }
      messages.refresh();
    }
  }

  void _handleBillingUpdate(dynamic data) {
    if (data['remainingBalance'] != null) {
      final newBalance = (data['remainingBalance'] as num).toDouble();
      walletBalance.value = newBalance;
      _updateGlobalWalletBalance(newBalance);
      _syncMoneyAnchor(walletBalance.value, pricePerMinute.value);
    }
    if (data['minutesRemaining'] != null) {
      availableMinutes.value = (data['minutesRemaining'] as num).toInt();
    }
    if (data['minutesBilled'] != null) {
      totalMinutes.value = (data['minutesBilled'] as num).toInt();
    }
    if (data['totalAmount'] != null) {
      totalCost.value = (data['totalAmount'] as num).toDouble();
    }
  }

  void _markMessageAsRead(String messageId) {
    if (_socket?.connected == true) {
      _socket!.emit('message_read', {
        'chatId': chatId.value,
        'messageIds': [messageId],
      });
    }
  }

  // Helpers
  void _startStatusCheckTimer() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshSessionAndSync(),
    );
  }

  void _startAcceptTimeoutTimer() {
    _acceptTimeoutTimer?.cancel();
    acceptTimeoutSecondsRemaining.value = _acceptTimeoutSeconds;
    _acceptTimeoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sessionStatus.value != 'CREATED') {
        timer.cancel();
        return;
      }
      final next = acceptTimeoutSecondsRemaining.value - 1;
      acceptTimeoutSecondsRemaining.value = next.clamp(0, _acceptTimeoutSeconds);
      if (next <= 0) {
        timer.cancel();
        _acceptTimeoutTimer = null;
        acceptTimeoutSecondsRemaining.value = 0;
        if (sessionStatus.value == 'CREATED') {
          if (kDebugMode)
            print('2-minute accept timeout - astrologer did not accept');
          sessionStatus.value = 'CANCELLED';
          _statusCheckTimer?.cancel();
          final message = 'Astrologer did not accept the chat. Your request has been cancelled.';
          Get.back();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorMessage(message: message);
          });
        }
        return;
      }
    });
  }

  void _startActiveSessionStatusCheck() {
    _activeSessionStatusCheckTimer?.cancel();
    _activeSessionStatusCheckTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _refreshSessionAndSync(),
    );
  }

  Future<void> _loadMessages() async {
    isLoadingMessages.value = true;
    try {
      final result = await _chatService.getMessages(chatId.value);
      // Logic to parse messages similar to original
      if (result['messages'] is List) {
        final List<AstrologerChatMessage> loaded = (result['messages'] as List)
            .map(
              (e) => e is AstrologerChatMessage
                  ? e
                  : AstrologerChatMessage.fromJson(e),
            )
            .toList();
        messages.value = loaded.reversed.toList();
      } else {
        if (kDebugMode) {
          print(
            'CreateChat: messages is not a List: ${result['messages'].runtimeType}',
          );
          print('Full Result: $result');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Load Msgs Err: $e');
    } finally {
      isLoadingMessages.value = false;
    }
  }

  Future<void> _handleSessionEnd(String status, {String? reason}) async {
    // AUTHORITATIVE SYNC: End session for all locally
    sessionStatus.value = status;
    _visualCountdownTimer?.cancel();
    _statusCheckTimer?.cancel();
    _activeSessionStatusCheckTimer?.cancel();

    // Disable inputs
    isSendingMessage.value = false;

    // Disconnect socket if not already done
    // Note: If endChat() was called, socket is already disconnected
    // This is a safety check for other ending scenarios (expiry, force end, etc.)
    if (status == 'COMPLETED' || status == 'EXPIRED') {
      if (_socket != null && _socket!.connected) {
        if (kDebugMode)
          print(
            '⚠️ Socket still connected in _handleSessionEnd, disconnecting...',
          );
        await _disconnectSocket();
      } else {
        if (kDebugMode) print('✅ Socket already disconnected');
      }
    }

    // Show summary or rating
    if (status == 'COMPLETED' || status == 'EXPIRED') {
      final astroId =
          _astrologer?.astrologerId ?? currentSession.value?.astrologerId;
      _notifyGlobalOnSessionEnd();

      if (!_ratingDialogShown && astroId != null && astroId.isNotEmpty) {
        _ratingDialogShown = true;
        showRatingDialog.value = true;

        bool inlineFollowProvided = false;

        if (_astrologer != null) {
          // Preload user's existing review and follow status so dialog can
          // show correct actions (submit vs update) and inline Follow button.
          try {
            final reviewController = Get.put(
              AstrologerReviewController(),
              tag: astroId,
              permanent: false,
            );
            await reviewController.loadMyReview(astroId, serviceType: 'CHAT');
            final existing = reviewController.myReview.value;

            AstrologerReviewDialog.showPrompt(
              context: Get.context!,
              astrologer: _astrologer!,
              serviceType: 'CHAT',
              existingReview: existing,
              onMaybeLater: () => Get.back(),
            );
          } catch (e) {
            if (kDebugMode) print('Failed to preload review/follow: $e');
            AstrologerReviewDialog.show(
              context: Get.context!,
              astrologerId: astroId,
              astrologer: _astrologer!,
              serviceType: 'CHAT',
            );
          }
        } else {
          // Fallback if astrologer info is missing: just go back
          if (kDebugMode) print('No astrologer info to show rating dialog');
          Get.back();
        }

        // If we showed the inline Follow button in the rating dialog,
        // skip the separate follow popup to avoid closing the rating dialog.
        // We only show the separate follow popup if we didn't provide onFollow callback.
        if (!inlineFollowProvided) {
          Future.delayed(const Duration(seconds: 1), () {
            _showFollowDialogIfNeeded(reason);
          });
        }
      }
    }
  }

  void onTyping() {
    _emitTyping();
  }

  void _emitTyping() {
    if (_socket?.connected == true) {
      _socket!.emit('typing_start', {'chatId': chatId.value});
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (_socket?.connected == true) {
          _socket!.emit('typing_stop', {'chatId': chatId.value});
        }
      });
    }
  }

  // Profile Message logic
  Future<void> _sendProfileMessageIfNeeded() async {
    if (_profileMessageSent || chatProfile == null) return;
    _profileMessageSent = true;

    try {
      final name = chatProfile!.personalInfo?.fullName ?? 'User';
      // Correct mapping from ChatProfileDialog: DOB is in generatedAt
      final dob = chatProfile!.birthChart?.generatedAt ?? '';

      final birthTime = chatProfile!.birthChart?.birthTime;
      final tob =
          birthTime != null &&
              birthTime.hour != null &&
              birthTime.minute != null
          ? '${birthTime.hour.toString().padLeft(2, '0')}:${birthTime.minute.toString().padLeft(2, '0')}:${(birthTime.second ?? 0).toString().padLeft(2, '0')}'
          : '';

      final birthPlace = chatProfile!.birthChart?.birthPlace;
      final pob = [
        birthPlace?.city,
        birthPlace?.state,
        birthPlace?.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      final gender = chatProfile!.personalInfo?.gender ?? '';
      final marital = chatProfile!.personalInfo?.maritalStatus ?? '';
      final occupation = chatProfile!.personalInfo?.occupation ?? '';

      // Language mapping
      final langCode = chatProfile!.preferences?.language ?? 'en';
      final langMap = {
        'en': 'English',
        'hi': 'Hindi',
        'gu': 'Gujarati',
        'te': 'Telugu',
        'ta': 'Tamil',
        'kn': 'Kannada',
        'mr': 'Marathi',
        'ml': 'Malayalam',
        'bn': 'Bengali',
        'as': 'Assamese',
        'or': 'Odia',
      };
      final language = langMap[langCode.toLowerCase()] ?? langCode;

      final messageContent =
          'Hi,\n'
          'Below are my details:\n'
          'Full Name: $name\n'
          'Gender: $gender\n'
          'Language: $language\n'
          'Marital Status: $marital\n'
          'Date of Birth: $dob\n'
          'Time of Birth: $tob\n'
          'Place of Birth: $pob\n'
          'Occupation: $occupation';

      // clientMessageId = timestamp-based id as per guide
      final clientMsgId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

      // Send via socket - ensure we're connected AND in the chat room
      final canSend =
          _socket?.connected == true &&
          (isInChatRoom.value || chatId.value.isNotEmpty);

      if (canSend) {
        if (kDebugMode) {
          print(
            'Sending auto-profile message. Socket connected: ${_socket?.connected}, In room: ${isInChatRoom.value}',
          );
        }

        _socket!.emit('send_message', {
          'chatId': chatId.value,
          'content': messageContent,
          'messageType': 'TEXT',
          'clientMessageId': clientMsgId,
        });

        if (kDebugMode) {
          print('Auto-profile message emitted via socket');
        }

        // OPTIMISTIC UPDATE: Add to local list so user sees it
        // Use SENDING status so message_sent handler can update it
        final newMessage = AstrologerChatMessage(
          messageId: clientMsgId,
          chatId: chatId.value,
          senderId: UserData().getLoginData.user?.userId ?? 'user',
          senderType: 'USER',
          content: messageContent,
          messageType: 'TEXT',
          status: 'SENDING', // Changed to SENDING so handler can update it
          sentAt: DateTime.now(),
        );

        // Ensure we don't duplicate if socket is extremely fast
        if (!messages.any((m) => m.content == messageContent)) {
          messages.insert(0, newMessage);
        }
      } else {
        if (kDebugMode) {
          print(
            'Cannot send auto-profile message - Socket connected: ${_socket?.connected}, In room: ${isInChatRoom.value}',
          );
          print('Will retry when socket is ready...');
        }

        // Wait for socket to be ready, then retry
        int attempts = 0;
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
          attempts++;
          final canSendNow =
              _socket?.connected == true &&
              (isInChatRoom.value || chatId.value.isNotEmpty);

          if (canSendNow) {
            timer.cancel();
            if (kDebugMode) print('Retrying auto-profile message send...');
            _socket!.emit('send_message', {
              'chatId': chatId.value,
              'content': messageContent,
              'messageType': 'TEXT',
              'clientMessageId': clientMsgId,
            });

            // Add optimistic message
            final retryMessage = AstrologerChatMessage(
              messageId: clientMsgId,
              chatId: chatId.value,
              senderId: UserData().getLoginData.user?.userId ?? 'user',
              senderType: 'USER',
              content: messageContent,
              messageType: 'TEXT',
              status: 'SENDING',
              sentAt: DateTime.now(),
            );
            if (!messages.any((m) => m.content == messageContent)) {
              messages.insert(0, retryMessage);
            }
          } else if (attempts >= 20) {
            timer.cancel();
            if (kDebugMode)
              print('Timeout waiting for socket for auto-profile message');
          }
        });
      }
    } catch (e) {
      if (kDebugMode) print('Error sending auto-details: $e');
    }
  }

  void _notifyGlobalOnSessionActive() {
    if (currentSession.value != null) {
      Get.find<GlobalChatController>().notifySessionUpdate(
        currentSession.value!,
      );
    }
  }

  void _notifyGlobalOnSessionEnd() {
    final astroId =
        _astrologer?.astrologerId ?? currentSession.value?.astrologerId;
    if (astroId != null && astroId.isNotEmpty) {
      Get.find<GlobalChatController>().notifySessionEnded(astroId);
    } else if (currentSession.value != null) {
      // Fallback: Notify with chatId if astrologerId is missing
      Get.find<GlobalChatController>().notifySessionEnded(
        currentSession.value!.chatId,
      );
    }
  }

  // Reply and Navigation Helpers
  void setReplyTo(AstrologerChatMessage message) {
    replyingToMessage.value = message;
  }

  void cancelReply() {
    replyingToMessage.value = null;
  }

  void scrollToMessage(String messageId) {
    messageToScrollTo.value = messageId;
    // Reset after a short delay so it can be triggered again for same message if needed
    Future.delayed(const Duration(milliseconds: 500), () {
      messageToScrollTo.value = '';
    });
  }

  Future<void> onBackPressed() async {
    if (sessionStatus.value == 'ACTIVE' || sessionStatus.value == 'CREATED') {
      final choice = await Get.dialog<String>(
        AlertDialog(
          title: const Text('Chat Options'),
          content: const Text(
            'Minimize chat to continue later or end the session.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: 'cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: 'minimize'),
              child: const Text('Minimize'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: 'end'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'End Chat',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (choice == 'minimize' && Get.isRegistered<ChatMinimizeManager>()) {
        Get.find<ChatMinimizeManager>().minimizeAstrologerChat(
          astrologer: astrologer,
          restoreState: {
            'chatId': chatId.value,
            'sessionStatus': sessionStatus.value,
          },
        );
        Get.back();
      } else if (choice == 'end') {
        await endChat();
        if (Get.currentRoute.contains('chat')) {
          Get.back();
        }
      }
    } else {
      Get.back();
    }
  }

  void _handleAstrologerEndedSession() {
    _handleSessionEnd('COMPLETED', reason: 'Astrologer ended the chat session');
  }
}
