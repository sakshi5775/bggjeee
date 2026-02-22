import 'dart:async';
import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/live_stream_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_service.dart';
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';

class LiveStreamController extends BaseController {
  final LiveStreamService _liveStreamService = LiveStreamService();
  final AstrologerService _astrologerService = AstrologerService();
  final UserData _userData = UserData();

  // Stream data (mutable to support in-place navigation)
  LiveStreamModel stream;
  String? astrologerName;
  String? astrologerProfilePicture;
  final RxString rxAstrologerName = ''.obs;
  final RxString rxAstrologerProfile = ''.obs;

  LiveStreamController({
    required this.stream,
    this.astrologerName,
    this.astrologerProfilePicture,
  }) {
    rxAstrologerName.value = astrologerName ?? stream.astrologerName;
    rxAstrologerProfile.value = astrologerProfilePicture ?? '';
  }

  // Socket.io connection for chat, gifts, and reactions
  IO.Socket? _socket;
  // Socket server (calls service) - use direct service port first, then gateway
  static const String streamSocketUrl = 'http://3.109.91.254:8009';
  static const String streamSocketUrlFallback = 'http://3.109.91.254:8000';

  // State
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isConnected = false.obs;
  final RxBool isStreamJoined = false.obs;
  final RxInt currentViewers = 0.obs;
  final RxBool isMuted = false.obs;
  final RxBool isVideoVisible = true.obs;

  // Agora
  RtcEngine? engine;
  final RxnInt remoteUid = RxnInt();
  final RxBool isAgoraInitialized = false.obs;
  bool _agoraHandlersSet = false;
  bool _socketDisabled =
      false; // disable further socket attempts when incompatible

  // Remote user media state (astrologer's camera/mic status)
  // Default to false - show video by default, only hide if explicitly muted
  final RxBool isRemoteVideoMuted = false.obs;
  final RxBool isRemoteAudioMuted = false.obs;

  // Stream end state
  final RxBool isStreamEnded = false.obs;

  // Follow state
  final RxBool isFollowing = false.obs;
  final RxBool isTogglingFollow = false.obs;

  // RSVP state
  final RxBool isRsvped = false.obs;
  final RxBool isTogglingRsvp = false.obs;
  final RxInt rsvpCount = 0.obs;

  // Chat
  final RxList<StreamMessage> messages = <StreamMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  // Gifts
  final RxList<Gift> availableGifts = <Gift>[].obs;
  final RxList<Reaction> availableReactions = <Reaction>[].obs;
  final RxList<GiftReceived> recentGifts = <GiftReceived>[].obs;
  final Rx<GiftReceived?> currentGiftOverlay = Rx<GiftReceived?>(null);
  final Rx<StreamMessage?> currentReactionOverlay = Rx<StreamMessage?>(null);
  final RxBool showGiftPanel = false.obs;
  final RxInt giftPanelTabIndex = 0.obs; // 0 = Gifts, 1 = Reactions

  // Playlist navigation
  final RxList<LiveStreamModel> livePlaylist = <LiveStreamModel>[].obs;
  final RxInt currentIndex = 0.obs;

  // Leave modal
  final RxBool showLeaveModal = false.obs;
  final RxList<LiveStreamModel> otherLiveStreams = <LiveStreamModel>[].obs;
  final RxBool isLoadingOtherStreams = false.obs;

  // Cache for other astrologer details
  final RxMap<String, String?> otherAstrologerProfilePictures =
      <String, String?>{}.obs;
  final RxMap<String, String?> otherAstrologerNames = <String, String?>{}.obs;

  // Join response
  JoinStreamResponse? joinResponse;
  Timer? _giftOverlayTimer;
  Timer? _reactionOverlayTimer;

  @override
  void onInit() {
    super.onInit();
    // Ensure playlist has at least the current stream before network calls
    _buildPlaylist();
    _initializeStream();
    _loadFollowStatus();
    _loadRsvpStatus();
    _loadOtherLiveStreams().then((_) => _buildPlaylist());
  }

  // Load other live streams (excluding current stream)
  Future<void> _loadOtherLiveStreams() async {
    try {
      isLoadingOtherStreams.value = true;
      final response = await _liveStreamService.getLiveStreams();
      if (response != null && response.streams.isNotEmpty) {
        // Filter out current stream and get up to 10 other live streams
        final filtered = response.streams
            .where((s) => s.status == 'LIVE')
            .take(20)
            .toList();
        otherLiveStreams.value = filtered;
        debugPrint('✅ Loaded ${otherLiveStreams.length} other live streams');

        // Load astrologer details for other streams
        await _loadOtherAstrologerDetails(filtered);
      }
      // Rebuild playlist after fetching
      _buildPlaylist();
    } catch (e) {
      debugPrint('Error loading other live streams: $e');
    } finally {
      isLoadingOtherStreams.value = false;
    }
  }

  void _buildPlaylist() {
    final list = <LiveStreamModel>[stream, ...otherLiveStreams];
    final seen = <String>{};
    final unique = <LiveStreamModel>[];
    for (final s in list) {
      if (!seen.contains(s.streamId)) {
        seen.add(s.streamId);
        unique.add(s);
      }
    }
    livePlaylist.assignAll(unique);
    final idx = livePlaylist.indexWhere((s) => s.streamId == stream.streamId);
    currentIndex.value = idx >= 0 ? idx : 0;
    debugPrint(
      'Playlist built with ${livePlaylist.length} items, currentIndex=${currentIndex.value}',
    );
  }

  // Load astrologer details for other streams
  Future<void> _loadOtherAstrologerDetails(
    List<LiveStreamModel> streams,
  ) async {
    try {
      // Get all astrologers to find matches
      final astrologerResponse = await _astrologerService.getAstrologers(
        limit: 100,
      );
      if (astrologerResponse != null) {
        // Create maps of astrologerId -> profilePicture and astrologerId -> name
        final Map<String, String?> profileMap = {};
        final Map<String, String?> nameMap = {};

        for (final astrologer in astrologerResponse.astrologers) {
          // Use displayName if available, otherwise use fullName
          final name = astrologer.displayName.isNotEmpty
              ? astrologer.displayName
              : astrologer.name;

          profileMap[astrologer.astrologerId] = astrologer.profilePicture;
          profileMap[astrologer.id] =
              astrologer.profilePicture; // Also map by _id

          nameMap[astrologer.astrologerId] = name;
          nameMap[astrologer.id] = name; // Also map by _id
        }

        // Update the reactive maps
        otherAstrologerProfilePictures.value = profileMap;
        otherAstrologerNames.value = nameMap;

        // For streams without matches, use stream data
        for (final stream in streams) {
          final astrologerId = stream.astrologerId;
          if (!nameMap.containsKey(astrologerId) &&
              !nameMap.containsKey(stream.astrologerId)) {
            otherAstrologerNames[astrologerId] =
                stream.astrologerName != 'Unknown'
                ? stream.astrologerName
                : 'Astrologer';
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading astrologer details: $e');
      // Fallback: use stream data
      for (final stream in streams) {
        final astrologerId = stream.astrologerId;
        if (!otherAstrologerNames.containsKey(astrologerId)) {
          otherAstrologerNames[astrologerId] =
              stream.astrologerName != 'Unknown'
              ? stream.astrologerName
              : 'Astrologer';
        }
      }
    }
  }

  // Get profile picture for other astrologer
  String? getProfilePictureForAstrologer(String astrologerId) {
    return otherAstrologerProfilePictures[astrologerId];
  }

  // Get name for other astrologer
  String getAstrologerName(String astrologerId) {
    return otherAstrologerNames[astrologerId] ?? 'Astrologer';
  }

  // Show leave modal
  void showLeaveModalDialog() {
    showLeaveModal.value = true;
    _loadOtherLiveStreams(); // Refresh other streams
  }

  // Hide leave modal
  void hideLeaveModal() {
    showLeaveModal.value = false;
  }

  bool get hasPrev => currentIndex.value > 0 && livePlaylist.isNotEmpty;
  bool get hasNext =>
      livePlaylist.isNotEmpty && currentIndex.value < livePlaylist.length - 1;

  void goPrev() {
    if (livePlaylist.isEmpty || currentIndex.value < 0) {
      Get.snackbar(
        'Info',
        'No previous astrologer',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!hasPrev) {
      Get.snackbar(
        'Info',
        'No previous astrologer',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final nextIndex = currentIndex.value - 1;
    final target = livePlaylist[nextIndex];
    switchToStream(target, nextIndex);
  }

  void goNext() {
    if (livePlaylist.isEmpty || currentIndex.value < 0) {
      Get.snackbar(
        'Info',
        'No next astrologer',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!hasNext) {
      Get.snackbar(
        'Info',
        'No next astrologer',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final nextIndex = currentIndex.value + 1;
    final target = livePlaylist[nextIndex];
    switchToStream(target, nextIndex);
  }

  Future<void> switchToStream(LiveStreamModel nextStream, int nextIndex) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Clean overlays and chat state
      _giftOverlayTimer?.cancel();
      _reactionOverlayTimer?.cancel();
      currentGiftOverlay.value = null;
      currentReactionOverlay.value = null;
      messages.clear();
      recentGifts.clear();

      // Preflight join API BEFORE leaving current channel to avoid ending up in blank state
      final preflight = await _liveStreamService.joinStream(
        nextStream.streamId,
      );
      if (preflight == null) {
        errorMessage.value = 'Failed to join stream';
        isLoading.value = false;
        return;
      }

      // Leave current connections using previous stream id
      final previousStreamId = stream.streamId;
      await _disposeConnections(previousStreamId);

      // Update stream references
      stream = nextStream;
      currentIndex.value = nextIndex;
      astrologerName = getAstrologerName(nextStream.astrologerId);
      astrologerProfilePicture = getProfilePictureForAstrologer(
        nextStream.astrologerId,
      );
      rxAstrologerName.value = astrologerName ?? nextStream.astrologerName;
      rxAstrologerProfile.value = astrologerProfilePicture ?? '';

      // Apply preflight join response
      joinResponse = preflight;
      currentViewers.value = preflight.streamInfo.currentViewers;

      // Reset Agora/socket state for new join
      isAgoraInitialized.value = false;
      remoteUid.value = null;
      isRemoteVideoMuted.value = false;
      isRemoteAudioMuted.value = false;
      isStreamJoined.value = false;
      isStreamEnded.value = false;

      // Join Agora channel (reuse engine; leave+join)
      await _joinAgoraChannel(preflight);

      // Connect socket for the new stream
      _connectSocket();

      isLoading.value = false;
    } catch (e) {
      debugPrint('Error switching stream: $e');
      errorMessage.value = 'Error: ${e.toString()}';
      isLoading.value = false;
    }
  }

  Future<void> _disposeConnections(String? previousStreamId) async {
    try {
      if (engine != null) {
        await engine!.leaveChannel();
        isAgoraInitialized.value = false;
        remoteUid.value = null;
        isRemoteVideoMuted.value = false;
        isRemoteAudioMuted.value = false;
      }
    } catch (e) {
      debugPrint('Error releasing Agora: $e');
    }

    try {
      if (_socket != null) {
        if (_socket!.connected && isStreamJoined.value) {
          _socket!.emit('leave_stream', {
            'streamId': previousStreamId ?? stream.streamId,
          });
        }
        _socket!.disconnect();
        _socket!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    } finally {
      _socket = null;
      isConnected.value = false;
      isStreamJoined.value = false;
    }
  }

  // Leave stream without following
  Future<void> leaveStreamOnly() async {
    hideLeaveModal();
    await _leaveStream();
    Get.back();
  }

  // Follow astrologer and leave stream
  Future<void> followAndLeave() async {
    if (isTogglingFollow.value) return;

    // If already following, just leave
    if (isFollowing.value) {
      hideLeaveModal();
      await _leaveStream();
      Get.back();
      return;
    }

    // Follow first, then leave
    try {
      isTogglingFollow.value = true;
      final result = await _astrologerService.followAstrologer(
        stream.astrologerId,
        source: 'LIVE_STREAM',
      );

      if (result['success'] == true) {
        // Update follow state
        isFollowing.value = true;
        debugPrint('✅ Followed astrologer before leaving');
      } else {
        debugPrint('⚠️ Failed to follow astrologer, but proceeding to leave');
      }
    } catch (e) {
      debugPrint('Error following astrologer: $e');
      // Continue to leave even if follow fails
    } finally {
      isTogglingFollow.value = false;
    }

    // Hide modal and leave stream
    hideLeaveModal();
    await _leaveStream();
    Get.back();
  }

  Future<void> _initializeStream() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      CrashlyticsService.trackAction(
        "STREAM",
        "INIT",
        data:
            "streamId:${stream.streamId}, astrologerId:${stream.astrologerId}",
      );
      rxAstrologerName.value = astrologerName ?? stream.astrologerName;
      rxAstrologerProfile.value = astrologerProfilePicture ?? '';

      // Load gifts catalog
      _loadGiftsCatalog();

      // Preflight join API
      debugPrint('Calling join API for stream: ${stream.streamId}');
      final response = await _liveStreamService.joinStream(stream.streamId);

      if (response == null) {
        debugPrint('❌ Join API returned null - failed to join stream');
        errorMessage.value = 'Failed to join stream';
        isLoading.value = false;
        return;
      }

      debugPrint('✅ Join API successful!');
      joinResponse = response;
      currentViewers.value = response.streamInfo.currentViewers;

      // Reset remote state
      isAgoraInitialized.value = false;
      remoteUid.value = null;
      isRemoteVideoMuted.value = false;
      isRemoteAudioMuted.value = false;
      isStreamJoined.value = false;
      isStreamEnded.value = false;

      // Ensure engine + handlers, then join channel
      await _joinAgoraChannel(response);

      // Connect Socket.io for chat, gifts, and reactions
      _connectSocket();

      isLoading.value = false;
    } catch (e, stack) {
      debugPrint('❌ Error initializing stream: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      errorMessage.value = 'Error: ${e.toString()}';
      isLoading.value = false;
      reportError(
        e,
        stack,
        type: CrashErrorType.network,
        reason: "STREAM_INIT_FAILED",
      );
    }
  }

  // Load gifts catalog
  Future<void> _loadGiftsCatalog() async {
    try {
      debugPrint('Loading gifts catalog from API...');
      final catalog = await _liveStreamService.getGiftsCatalog();
      if (catalog != null) {
        // Ensure all gifts are loaded - no filtering
        availableGifts.value = List<Gift>.from(catalog.gifts);
        availableReactions.value = List<Reaction>.from(catalog.reactions);
        debugPrint(
          '✅ Loaded ${catalog.gifts.length} gifts and ${catalog.reactions.length} reactions from API',
        );
        for (var i = 0; i < catalog.gifts.length; i++) {
          final gift = catalog.gifts[i];
          debugPrint(
            '  Gift ${i + 1}: ${gift.name} (${gift.type}) - ₹${gift.value} - ${gift.icon}',
          );
        }
        for (var i = 0; i < catalog.reactions.length; i++) {
          final reaction = catalog.reactions[i];
          debugPrint(
            '  Reaction ${i + 1}: ${reaction.name} (${reaction.type}) - ${reaction.icon}',
          );
        }
        debugPrint('Total gifts in availableGifts: ${availableGifts.length}');
        debugPrint(
          'Total reactions in availableReactions: ${availableReactions.length}',
        );
      } else {
        debugPrint('⚠️ Gifts catalog returned null from API');
      }
    } catch (e) {
      debugPrint('Error loading gifts catalog: $e');
    }
  }

  // Connect Socket.io for chat, gifts, and reactions
  Future<void> _connectSocket() async {
    if (_socketDisabled) {
      debugPrint(
        '⚠️ Socket disabled due to previous incompatibility. Skipping socket connect.',
      );
      return;
    }
    try {
      final token = UserData().accessToken ?? '';
      if (token.isEmpty) {
        debugPrint('No authentication token for socket connection');
        return; // Don't throw, just return - video can still work
      }

      debugPrint('Token present: ${token.isNotEmpty}');
      debugPrint('Stream ID: ${stream.streamId}');

      CrashlyticsService.trackAction(
        "STREAM",
        "SOCKET_CONNECT",
        data: "url:$streamSocketUrl",
      );

      // Dispose existing socket if any
      if (_socket != null) {
        try {
          _socket!.disconnect();
          _socket!.dispose();
        } catch (e) {
          debugPrint('Error disposing old socket: $e');
        }
        _socket = null;
      }

      // Try connecting to the primary URL (calls service direct socket)
      _tryConnectSocket(streamSocketUrl, token);

      // Wait a bit to see if primary connection succeeds
      await Future.delayed(const Duration(seconds: 2));

      // If connection still not established, try gateway with explicit /calls path
      if (_socket == null || !_socket!.connected) {
        debugPrint(
          'Primary connection failed, trying gateway on port 8000 with /calls path...',
        );
        // Dispose the failed socket first
        if (_socket != null) {
          try {
            _socket!.disconnect();
            _socket!.dispose();
          } catch (e) {
            debugPrint('Error disposing failed socket: $e');
          }
          _socket = null;
        }
        _tryConnectSocket(
          streamSocketUrlFallback,
          token,
          socketPath: '/calls/socket.io',
        );
        // Wait for fallback
        await Future.delayed(const Duration(seconds: 2));
      }

      // Final attempt: gateway default path (in case server is not under /calls)
      if (_socket == null || !_socket!.connected) {
        debugPrint(
          'Gateway /calls path failed, trying gateway default socket path...',
        );
        if (_socket != null) {
          try {
            _socket!.disconnect();
            _socket!.dispose();
          } catch (e) {
            debugPrint('Error disposing failed socket: $e');
          }
          _socket = null;
        }
        _tryConnectSocket(
          streamSocketUrlFallback,
          token,
          socketPath: '/socket.io',
        );
        await Future.delayed(const Duration(seconds: 2));
      }

      // Final check - if still not connected, log but don't block
      if (_socket == null || !_socket!.connected) {
        debugPrint(
          '⚠️ Socket.io connection unavailable - chat/gifts will not work, but video streaming is active',
        );
        debugPrint(
          'This is normal if the Socket.io server is not configured for live streams',
        );
      }
    } catch (e) {
      debugPrint('Error connecting socket: $e');
      // Don't set error message - video can still work without socket
      // Socket is only for chat, gifts, and reactions
      isConnected.value = false;
    }
  }

  bool _isSocketVersionMismatch(dynamic error) {
    final msg = error?.toString() ?? '';
    return msg.contains('v2.x with a v3.x client') ||
        msg.contains('not upgraded to websocket') ||
        msg.contains('HTTP status code: 404');
  }

  void _disableSocketWithReason(String reason) {
    _socketDisabled = true;
    try {
      _socket?.disconnect();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    debugPrint('⚠️ Socket permanently disabled: $reason');
  }

  Future<void> _tryConnectSocket(
    String url,
    String token, {
    String socketPath = '/socket.io',
  }) async {
    try {
      _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports([
              'websocket',
              'polling',
            ]) // Try websocket first (same as chat)
            .setAuth({'token': token}) // Token in auth (same as chat)
            .setPath(socketPath) // Explicit path for gateway routing
            .disableAutoConnect()
            .enableForceNew()
            .setReconnectionAttempts(2) // Try a couple times
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(3000)
            .setTimeout(10000) // Same timeout as chat
            .build(),
      );

      _socket!.connect();

      _socket!.onConnect((_) {
        isConnected.value = true;
        debugPrint('✅ Socket connected successfully');
        CrashlyticsService.trackAction(
          "STREAM",
          "SOCKET_CONNECTED",
          data: "socketId:${_socket?.id}",
        );
        // Wait a bit longer to ensure socket is fully ready
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (_socket != null && _socket!.connected) {
            _joinStreamSocket();
          } else {
            debugPrint('⚠️ Socket not connected when trying to join stream');
            debugPrint('  Socket state: ${_socket?.connected}');
          }
        });
      });

      _socket!.onConnectError((error) {
        isConnected.value = false;
        debugPrint('❌ Socket connection error: $error');
        if (_isSocketVersionMismatch(error)) {
          _disableSocketWithReason('Socket.io version mismatch');
        }
        // Don't set error message - video can still work without socket
        // Socket is only for chat, gifts, and reactions
      });

      _socket!.onDisconnect((reason) {
        isConnected.value = false;
        debugPrint('Socket disconnected: $reason');
        // Only log, don't show error to user - video can still work
        if (reason != 'io server disconnect' && reason != 'transport close') {
          debugPrint('Unexpected disconnect: $reason');
        }
      });

      _socket!.onError((error) {
        debugPrint('Socket error: $error');
        reportError(
          error,
          StackTrace.current,
          type: CrashErrorType.socket,
          reason: "STREAM_SOCKET_ERROR",
        );
        if (_isSocketVersionMismatch(error)) {
          _disableSocketWithReason('Socket.io version mismatch');
        }
        // Don't block the UI for socket errors
      });

      _socket!.onReconnect((attempt) {
        debugPrint('✅ Socket reconnected after $attempt attempts');
        // Don't set isConnected here - wait for onConnect event
        // The onConnect handler will handle joining the stream
      });

      _socket!.onReconnectAttempt((attempt) {
        debugPrint('Socket reconnection attempt $attempt');
      });

      _socket!.onReconnectError((error) {
        debugPrint('Socket reconnection error: $error');
        if (_isSocketVersionMismatch(error)) {
          _disableSocketWithReason('Socket.io version mismatch');
          return;
        }
        // Stop trying after errors - socket might not be available
        _socket?.disconnect();
        _socket?.dispose();
        _socket = null;
      });

      _socket!.onReconnectFailed((_) {
        debugPrint('Socket reconnection failed - giving up');
        // Stop trying - socket server might not be available
        _socket?.disconnect();
        _socket?.dispose();
        _socket = null;
      });

      // Stream events
      _socket!.on('viewer_joined', (data) {
        final viewerCount = (data['viewerCount'] as num?)?.toInt() ?? 0;
        currentViewers.value = viewerCount;
      });

      _socket!.on('viewer_left', (data) {
        final viewerCount = (data['viewerCount'] as num?)?.toInt() ?? 0;
        currentViewers.value = viewerCount;
      });

      _socket!.on('gift_received', (data) {
        try {
          final parsed = _safeToMap(data);
          GiftReceived gift;
          String senderName = 'Someone';
          if (parsed != null) {
            // Clean animation field to avoid type cast issues when server sends string
            final cleaned = Map<String, dynamic>.from(parsed);
            final anim = parsed['animation'];
            if (anim is Map<String, dynamic>) {
              cleaned['animation'] = anim;
            } else if (anim is Map) {
              cleaned['animation'] = Map<String, dynamic>.from(anim);
            } else if (anim is String) {
              try {
                final decoded = jsonDecode(anim);
                if (decoded is Map<String, dynamic>) {
                  cleaned['animation'] = decoded;
                } else if (decoded is Map) {
                  cleaned['animation'] = Map<String, dynamic>.from(decoded);
                } else {
                  cleaned['animation'] = null;
                }
              } catch (_) {
                cleaned['animation'] = null;
              }
            } else {
              cleaned['animation'] = null;
            }
            gift = GiftReceived.fromJson(cleaned);
            senderName = cleaned['senderName'] as String? ?? senderName;
            // Update gift with senderName if available
            if (senderName != 'Someone') {
              gift = GiftReceived(
                giftId: gift.giftId,
                senderId: gift.senderId,
                senderName: senderName,
                giftType: gift.giftType,
                giftValue: gift.giftValue,
                giftIcon: gift.giftIcon,
                giftName: gift.giftName,
                animation: gift.animation,
              );
            }
          } else {
            // Fallback: build a minimal gift from a string payload
            final giftType = data?.toString() ?? 'UNKNOWN';
            final meta = availableGifts.firstWhereOrNull(
              (g) => g.type == giftType,
            );
            gift = GiftReceived(
              giftId: const Uuid().v4(),
              senderId: 'unknown',
              senderName: null,
              giftType: giftType,
              giftValue: meta?.value ?? 0,
              giftIcon: meta?.icon ?? '🎁',
              giftName: meta?.name ?? giftType,
              animation: null,
            );
            debugPrint('Parsed gift using fallback for payload: $data');
          }
          _showGiftOverlay(gift);
          // Also surface gift into chat feed
          messages.add(
            StreamMessage(
              messageId: const Uuid().v4(),
              senderId: gift.senderId,
              senderName: senderName,
              senderType: 'USER',
              messageType: 'GIFT',
              content: gift.giftName,
              reactionType: gift.giftIcon, // reuse field to carry icon
              sentAt: DateTime.now(),
            ),
          );
          _scrollChatToBottom();
          recentGifts.insert(0, gift);
          // Keep only last 10 gifts
          if (recentGifts.length > 10) {
            recentGifts.removeLast();
          }
        } catch (e) {
          debugPrint('Error parsing gift: $e');
        }
      });

      _socket!.on('new_stream_message', (data) {
        try {
          final parsed = _safeToMap(data);
          if (parsed == null) {
            debugPrint(
              'Error parsing message: payload is not a map or valid JSON -> $data',
            );
            return;
          }
          final message = StreamMessage.fromJson(parsed);
          messages.add(message);
          _scrollChatToBottom();
        } catch (e) {
          debugPrint('Error parsing message: $e');
        }
      });

      _socket!.on('stream_reaction', (data) {
        try {
          debugPrint('✨ Reaction received: $data');
          final parsed = _safeToMap(data);
          if (parsed == null) {
            debugPrint(
              'Error parsing reaction: payload is not a map or valid JSON -> $data',
            );
            return;
          }
          // Map reactionType to icon from availableReactions
          final reactionType = parsed['reactionType'] as String?;
          String? reactionIcon = '✨'; // Default icon
          if (reactionType != null) {
            final reactionData = availableReactions.firstWhereOrNull(
              (r) => r.type == reactionType,
            );
            reactionIcon = reactionData?.icon ?? reactionIcon;
          }
          final reaction = StreamMessage(
            messageId: const Uuid().v4(),
            senderId: parsed['senderId'] as String? ?? 'unknown',
            senderName: parsed['senderName'] as String? ?? 'Anonymous',
            senderType: 'USER',
            messageType: 'REACTION',
            reactionType: reactionIcon, // Store icon instead of type
            sentAt: DateTime.now(),
          );
          _showReactionOverlay(reaction);
          messages.add(reaction);
          _scrollChatToBottom();
        } catch (e) {
          debugPrint('Error parsing reaction: $e');
        }
      });

      _socket!.on('stream_ended', (data) {
        Get.snackbar(
          'Stream Ended',
          'The stream has ended',
          snackPosition: SnackPosition.BOTTOM,
        );
        Future.delayed(const Duration(seconds: 2), () => Get.back());
      });

      _socket!.on('stream_crashed', (data) {
        debugPrint('⚠️ Stream crashed: $data');
        _handleStreamEnded();
      });
    } catch (e) {
      debugPrint('Error connecting socket: $e');
      // Don't set error message - video can still work without socket
      // Socket is only for chat, gifts, and reactions
      isConnected.value = false;
    }
  }

  void _joinStreamSocket() {
    if (_socket == null) {
      debugPrint('⚠️ Cannot join stream: socket is null');
      // Retry after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (_socket != null && _socket!.connected) {
          _joinStreamSocket();
        }
      });
      return;
    }

    if (!_socket!.connected) {
      debugPrint('⚠️ Cannot join stream: socket not connected');
      debugPrint('  Socket connected state: ${_socket!.connected}');
      // Retry after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (_socket != null && _socket!.connected) {
          _joinStreamSocket();
        }
      });
      return;
    }

    try {
      debugPrint('📡 Emitting join_stream event for: ${stream.streamId}');
      _socket!.emit('join_stream', {'streamId': stream.streamId});
      isStreamJoined.value = true;
      debugPrint('✅ Joined stream via socket: ${stream.streamId}');
    } catch (e) {
      debugPrint('❌ Error joining stream via socket: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      // Retry after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (_socket != null && _socket!.connected && !isStreamJoined.value) {
          _joinStreamSocket();
        }
      });
    }
  }

  void _scrollChatToBottom() {
    if (chatScrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _initializeAgora(JoinStreamResponse joinResponse) async {
    try {
      debugPrint('=== Initializing Agora RTC Engine ===');
      debugPrint('App ID: ${joinResponse.appId}');
      debugPrint('Channel Name: ${joinResponse.channelName}');
      debugPrint(
        'Token (first 20 chars): ${joinResponse.viewerToken.substring(0, joinResponse.viewerToken.length > 20 ? 20 : joinResponse.viewerToken.length)}...',
      );
      if (engine == null) {
        // Initialize Agora engine once
        engine = createAgoraRtcEngine();
        await engine!.initialize(
          RtcEngineContext(
            appId: joinResponse.appId,
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          ),
        );
        debugPrint('✅ Agora engine initialized');
      } else {
        debugPrint('Reusing existing Agora engine');
      }

      // Set client role as audience (viewer)
      await engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
      debugPrint('✅ Client role set to audience');

      // Enable video
      await engine!.enableVideo();
      debugPrint('✅ Video enabled');

      // Register event handlers once
      if (!_agoraHandlersSet) {
        engine!.registerEventHandler(
          RtcEngineEventHandler(
            onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
              debugPrint('✅✅✅ Agora: Joined channel successfully!');
              debugPrint('  - Channel: ${connection.channelId}');
              debugPrint('  - Elapsed time: ${elapsed}ms');
              isAgoraInitialized.value = true;
              isLoading.value = false;
            },
            onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
              debugPrint('✅✅✅ Agora: Remote user joined: $remoteUid');
              debugPrint('  - Channel: ${connection.channelId}');
              debugPrint('  - Elapsed time: ${elapsed}ms');
              this.remoteUid.value = remoteUid;
              // Reset mute states when user joins - assume video/audio are ON by default
              isRemoteVideoMuted.value = false;
              isRemoteAudioMuted.value = false;
              debugPrint(
                '  - Reset video/audio mute states to false (assuming ON by default)',
              );
            },
            onUserOffline:
                (
                  RtcConnection connection,
                  int remoteUid,
                  UserOfflineReasonType reason,
                ) {
                  debugPrint(
                    '⚠️ Agora: Remote user offline: $remoteUid (reason: $reason)',
                  );

                  // If this is the broadcaster going offline, the stream has ended
                  if (this.remoteUid.value == remoteUid &&
                      !isStreamEnded.value) {
                    debugPrint('📺 Stream ended - broadcaster went offline');
                    _handleStreamEnded();
                  }

                  this.remoteUid.value = null;
                  // Reset mute states when user goes offline
                  isRemoteVideoMuted.value = false;
                  isRemoteAudioMuted.value = false;
                },
            onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
              debugPrint(
                '📽️ Agora: Remote user video ${muted ? "muted" : "unmuted"}: $remoteUid',
              );
              if (this.remoteUid.value == remoteUid) {
                isRemoteVideoMuted.value = muted;
              }
            },
            onUserMuteAudio: (RtcConnection connection, int remoteUid, bool muted) {
              debugPrint(
                '🔊 Agora: Remote user audio ${muted ? "muted" : "unmuted"}: $remoteUid',
              );
              if (this.remoteUid.value == remoteUid) {
                isRemoteAudioMuted.value = muted;
              }
            },
            onRemoteVideoStateChanged:
                (
                  RtcConnection connection,
                  int remoteUid,
                  RemoteVideoState state,
                  RemoteVideoStateReason reason,
                  int elapsed,
                ) {
                  debugPrint(
                    '📽️ Agora: Remote video state changed: $remoteUid, state: $state, reason: $reason',
                  );
                  if (this.remoteUid.value == remoteUid) {
                    // Check if stream has ended (user offline or failed)
                    if (reason ==
                        RemoteVideoStateReason
                            .remoteVideoStateReasonRemoteOffline) {
                      // Stream ended - broadcaster went offline
                      if (!isStreamEnded.value) {
                        debugPrint(
                          '📺 Stream ended - detected via video state (remote offline)',
                        );
                        _handleStreamEnded();
                      }
                      isRemoteVideoMuted.value = true;
                      return;
                    }

                    // Only set muted if we're absolutely sure video is off
                    // Default to showing video unless explicitly stopped with muted reason
                    if (state == RemoteVideoState.remoteVideoStateStopped) {
                      // Video stopped - only set muted if reason explicitly says muted
                      if (reason ==
                          RemoteVideoStateReason
                              .remoteVideoStateReasonRemoteMuted) {
                        debugPrint('📽️ Video explicitly muted by remote user');
                        isRemoteVideoMuted.value = true;
                      } else {
                        // Video stopped for other reasons (might be temporary) - don't assume muted
                        debugPrint(
                          '📽️ Video stopped but reason is not muted, keeping video visible',
                        );
                        // Keep current state, don't change it
                      }
                    } else if (state ==
                        RemoteVideoState.remoteVideoStateFailed) {
                      // Video failed - hide video but don't assume stream ended (could be network issue)
                      debugPrint('📽️ Video failed');
                      isRemoteVideoMuted.value = true;
                    } else if (state ==
                            RemoteVideoState.remoteVideoStateStarting ||
                        state == RemoteVideoState.remoteVideoStateDecoding) {
                      // Video is starting or decoding - show video
                      debugPrint('📽️ Video starting/decoding - showing video');
                      isRemoteVideoMuted.value = false;
                    }
                  }
                },
            onError: (ErrorCodeType err, String msg) {
              debugPrint('❌❌❌ Agora error: $err - $msg');
              errorMessage.value = 'Agora error: $msg';
            },
          ),
        );
        _agoraHandlersSet = true;
        debugPrint('✅ Event handlers registered');
      }
    } catch (e) {
      debugPrint('❌❌❌ Error initializing Agora: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      errorMessage.value = 'Failed to initialize video: ${e.toString()}';
      isLoading.value = false;
    }
  }

  Future<void> _joinAgoraChannel(JoinStreamResponse resp) async {
    // Ensure engine + handlers are ready
    await _initializeAgora(resp);

    // Leave current channel cleanly before joining (ignore errors)
    try {
      await engine!.leaveChannel();
    } catch (e) {
      debugPrint('Leave channel error (ignored): $e');
    }

    // Reset remote state before join
    isAgoraInitialized.value = false;
    remoteUid.value = null;
    isRemoteVideoMuted.value = false;
    isRemoteAudioMuted.value = false;

    debugPrint(
      'Joining Agora channel as VIEWER (audience role)... ${resp.channelName}',
    );
    await engine!.joinChannel(
      token: resp.viewerToken,
      channelId: resp.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
      ),
    );
    debugPrint('✅ Join channel request sent (as viewer/audience)');
  }

  // Send chat message
  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      Get.snackbar(
        'Error',
        'Message cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!isConnected.value || !isStreamJoined.value) {
      Get.snackbar(
        'Connection Error',
        'Not connected to chat. Please wait...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    try {
      _socket!.emit('stream_message', {
        'streamId': stream.streamId,
        'content': text,
      });
      messageController.clear();
      debugPrint('💬 Message sent: $text');
    } catch (e) {
      debugPrint('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Send reaction
  void sendReaction(String reactionType) {
    if (!isConnected.value || !isStreamJoined.value) {
      Get.snackbar(
        'Connection Error',
        'Not connected. Please wait...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    try {
      _socket!.emit('stream_reaction', {
        'streamId': stream.streamId,
        'reactionType': reactionType,
      });
      debugPrint('✨ Reaction sent: $reactionType');
    } catch (e) {
      debugPrint('Error sending reaction: $e');
      Get.snackbar(
        'Error',
        'Failed to send reaction',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Wallet Service
  final WalletService _walletService = WalletService();

  // Send gift with balance check
  Future<void> sendGift(String giftType) async {
    if (!isConnected.value || !isStreamJoined.value) {
      Get.snackbar(
        'Connection Error',
        'Not connected. Please wait...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // 1. Find the gift to get its value
      final gift = availableGifts.firstWhereOrNull((g) => g.type == giftType);
      if (gift == null) {
        debugPrint('⚠️ Gift type not found: $giftType');
        return;
      }

      // 2. Check wallet balance
      // Use UserData to get the correct user ID (source of truth)
      final userId = _userData.getLoginData.user?.userId;
      if (userId == null) {
        debugPrint('⚠️ Cannot fetch balance: User ID not found in session');
        Get.snackbar(
          'Error',
          'User session invalid',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      debugPrint('💰 Checking balance for User ID: $userId');

      final balanceResponse = await _walletService.getWalletBalance(userId);

      if (balanceResponse == null ||
          !balanceResponse.success ||
          balanceResponse.data == null) {
        Get.snackbar(
          'Error',
          'Failed to fetch wallet balance',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final currentBalance = balanceResponse.data!.balance.toDouble();

      if (currentBalance < gift.value) {
        // 3. Insufficient Balance - Show Recharge Dialog
        showGiftPanel.value = false; // Close gift panel

        Get.dialog(
          WalletRechargeDialog(
            currentBalance: currentBalance,
            requiredBalance: gift.value.toDouble(),
            astrologerName: astrologerName ?? 'Astrologer',
          ),
          barrierDismissible: true,
        );
        return;
      }

      // 4. Sufficient Balance - Proceed to send
      _socket!.emit('send_gift', {
        'streamId': stream.streamId,
        'giftType': giftType,
      });

      showGiftPanel.value = false;
      debugPrint('🎁 Gift sent: $giftType');

      // Optimistically show animation for sender
      _showGiftOverlay(
        GiftReceived(
          giftId: const Uuid().v4(),
          senderId: userId,
          senderName: 'You',
          giftType: gift.type,
          giftName: gift.name,
          giftValue: gift.value,
          giftIcon: gift.icon,
          animation: null,
        ),
      );
    } catch (e) {
      debugPrint('Error sending gift: $e');
      Get.snackbar(
        'Error',
        'Failed to send gift',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // NOTE: Chat scrolling removed - will be added later with Socket.io
  // void _scrollChatToBottom() {
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (chatScrollController.hasClients) {
  //       chatScrollController.animateTo(
  //         chatScrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  void toggleMute() {
    // For viewers, mute is typically not applicable, but we can toggle audio
    isMuted.value = !isMuted.value;
  }

  void toggleVideoVisibility() {
    isVideoVisible.value = !isVideoVisible.value;
  }

  void toggleGiftPanel() {
    showGiftPanel.value = !showGiftPanel.value;
  }

  // Load follow status
  Future<void> _loadFollowStatus() async {
    try {
      final status = await _astrologerService.getFollowStatus(
        stream.astrologerId,
      );
      if (status != null) {
        isFollowing.value = status['isFollowing'] as bool? ?? false;
        debugPrint('📺 Follow status loaded: ${isFollowing.value}');
      }
    } catch (e) {
      debugPrint('Error loading follow status: $e');
    }
  }

  // Toggle follow/unfollow
  Future<void> toggleFollow() async {
    if (isTogglingFollow.value) return;

    final currentState = isFollowing.value;
    try {
      isTogglingFollow.value = true;
      final result = currentState
          ? await _astrologerService.unfollowAstrologer(stream.astrologerId)
          : await _astrologerService.followAstrologer(
              stream.astrologerId,
              source: 'LIVE_STREAM',
            );

      if (result['success'] == true) {
        // Update follow state
        isFollowing.value = !currentState;

        Get.snackbar(
          'Success',
          currentState
              ? 'Unfollowed ${astrologerName ?? 'Astrologer'}'
              : 'Following ${astrologerName ?? 'Astrologer'}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to ${currentState ? 'unfollow' : 'follow'} astrologer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${currentState ? 'unfollow' : 'follow'}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isTogglingFollow.value = false;
    }
  }

  // RSVP for upcoming stream
  Future<void> toggleRsvp() async {
    if (isTogglingRsvp.value) return;

    // Only allow RSVP for scheduled/upcoming streams, not live streams
    if (stream.status == 'LIVE') {
      Get.snackbar(
        'Info',
        'RSVP is only available for scheduled streams',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final currentState = isRsvped.value;
    try {
      isTogglingRsvp.value = true;

      if (currentState) {
        // Cancel RSVP
        final success = await _liveStreamService.cancelRsvp(stream.streamId);
        if (success) {
          isRsvped.value = false;
          rsvpCount.value = (rsvpCount.value - 1)
              .clamp(0, double.infinity)
              .toInt();
          Get.snackbar(
            'Success',
            'RSVP cancelled',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to cancel RSVP',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Create RSVP
        final success = await _liveStreamService.rsvpStream(stream.streamId);
        if (success) {
          isRsvped.value = true;
          rsvpCount.value = rsvpCount.value + 1;
          Get.snackbar(
            'Success',
            'RSVP created',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to create RSVP',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${currentState ? 'cancel' : 'create'} RSVP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isTogglingRsvp.value = false;
    }
  }

  // Load RSVP status
  Future<void> _loadRsvpStatus() async {
    try {
      // Get RSVP count
      final count = await _liveStreamService.getRsvpCount(stream.streamId);
      if (count != null) {
        rsvpCount.value = count;
      }

      // Check if user has RSVPed
      final userRsvps = await _liveStreamService.getUserRsvps();
      if (userRsvps != null) {
        isRsvped.value = userRsvps.any(
          (rsvp) => (rsvp['streamId'] as String?) == stream.streamId,
        );
      }
    } catch (e) {
      debugPrint('Error loading RSVP status: $e');
    }
  }

  // Handle stream ended by astrologer
  void _handleStreamEnded() {
    if (isStreamEnded.value) {
      return; // Already handled
    }

    isStreamEnded.value = true;
    debugPrint('📺 Handling stream end - showing message and navigating back');
    debugPrint('📺 Current route: ${Get.currentRoute}');
    debugPrint('📺 Previous route: ${Get.previousRoute}');

    // Show "LIVE IS ENDED" message
    Get.snackbar(
      'LIVE IS ENDED',
      'The astrologer has ended the live stream',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
      borderRadius: 8.r,
      isDismissible: false,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );

    // Also set a flag that the view can check
    // This allows the view to handle navigation if controller method fails

    // Wait 2 seconds then navigate back to previous screen
    Future.delayed(const Duration(seconds: 2), () async {
      if (!isStreamEnded.value) {
        return; // Stream was resumed or something changed
      }

      debugPrint('📺 Navigating back after stream end');
      debugPrint('📺 Current route: ${Get.currentRoute}');
      debugPrint('📺 Previous route: ${Get.previousRoute}');

      // Clean up Agora connection first
      await _leaveStream();

      // Close any open snackbars first
      if (Get.isSnackbarOpen == true) {
        Get.closeAllSnackbars();
      }

      // Note: Navigation is now handled in the view using ever() listener
      // This ensures we have BuildContext for reliable navigation
      debugPrint('📺 Stream ended flag set - view will handle navigation');
    });
  }

  void leaveStream() {
    _leaveStream();
    Get.back();
  }

  Future<void> _leaveStream() async {
    try {
      // Tell server we are leaving so viewer stats stay accurate
      if (_socket?.connected == true && isStreamJoined.value) {
        try {
          _socket!.emit('leave_stream', {'streamId': stream.streamId});
          debugPrint('📡 Emitted leave_stream for ${stream.streamId}');
        } catch (e) {
          debugPrint('Error emitting leave_stream: $e');
        }
      }

      // Leave Agora channel
      if (engine != null) {
        await engine!.leaveChannel();
        await engine!.release();
        engine = null;
      }

      // NOTE: Socket disconnect removed - will be added later
      // _socket?.disconnect();
      // _socket?.dispose();
      // _socket = null;
    } catch (e) {
      debugPrint('Error leaving stream: $e');
    }
  }

  /// Safely convert socket payloads to Map<String, dynamic>
  Map<String, dynamic>? _safeToMap(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      if (data is String) {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error converting payload to map: $e');
      return null;
    }
  }

  void _showGiftOverlay(GiftReceived gift) {
    currentGiftOverlay.value = gift;
    _giftOverlayTimer?.cancel();
    _giftOverlayTimer = Timer(const Duration(seconds: 3), () {
      currentGiftOverlay.value = null;
    });
  }

  void _showReactionOverlay(StreamMessage reaction) {
    currentReactionOverlay.value = reaction;
    _reactionOverlayTimer?.cancel();
    _reactionOverlayTimer = Timer(const Duration(seconds: 2), () {
      currentReactionOverlay.value = null;
    });
  }

  @override
  void onClose() {
    _leaveStream();
    _giftOverlayTimer?.cancel();
    _reactionOverlayTimer?.cancel();
    messageController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}
