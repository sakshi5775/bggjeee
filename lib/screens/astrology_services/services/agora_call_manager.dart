import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/utils/plugin_safe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

enum CallState {
  idle,
  initializing,
  ringing, // New state for when user joins but astrologer hasn't
  joining,
  joined,
  leaving,
  error,
  timeout, // New state for call timeout
  notAnswered, // New state for astrologer not answering
  endedByRemote, // New state for astrologer ending call
}

class AgoraCallManager {
  RtcEngine? _engine;
  CallState _callState = CallState.idle;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerEnabled = false;
  int? _localUid;
  int? _remoteUid;
  Timer? _callTimer;
  int _callDuration = 0;
  String? _channelName;
  String? _appId;
  Timer? _timeoutTimer; // Timer for call timeout
  int _timeoutSeconds = 60; // From API response

  // Getters
  CallState get callState => _callState;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isSpeakerEnabled => _isSpeakerEnabled;
  int? get localUid => _localUid;
  int? get remoteUid => _remoteUid;
  int get callDuration => _callDuration;

  // Callbacks
  Function(CallState)? onCallStateChanged;
  Function(int uid)? onUserJoined;
  Function(int uid)? onUserOffline;
  Function(int duration)? onCallDurationChanged;
  Function(String error)? onError;
  Function(bool isMuted)? onRemoteVideoMuted;

  void _notifyUi(String tag, void Function() fn) {
    guardPluginCallback('AGORA_$tag', fn, type: CrashErrorType.ui);
  }

  /// Initialize Agora RTC Engine
  Future<bool> initialize({
    required String appId,
    bool isVideoCall = true,
    int timeoutSeconds = 60, // Default timeout
  }) async {
    try {
      _appId = appId;
      _timeoutSeconds = timeoutSeconds;
      _callState = CallState.initializing;
      _notifyUi('init_start', () => onCallStateChanged?.call(_callState));

      // Request permissions
      if (isVideoCall) {
        await _requestVideoPermissions();
      } else {
        await _requestAudioPermissions();
      }

      // Create RTC engine instance
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      // Enable video if it's a video call
      if (isVideoCall) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      } else {
        await _engine!.enableAudio();
      }

      // Register event handlers
      _registerEventHandlers();

      _callState = CallState.idle;
      _notifyUi('init_done', () => onCallStateChanged?.call(_callState));
      return true;
    } catch (e, stack) {
      debugPrint('Error initializing Agora: $e');
      CrashlyticsService.recordError(
        e,
        stack,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'AGORA_INIT',
      );
      _callState = CallState.error;
      _notifyUi('init_state', () => onCallStateChanged?.call(_callState));
      _notifyUi('init_err', () => onError?.call(e.toString()));
      return false;
    }
  }

  /// Request audio permissions
  Future<void> _requestAudioPermissions() async {
    await [
      Permission.microphone,
    ].request();
  }

  /// Request video permissions
  Future<void> _requestVideoPermissions() async {
    await [
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  /// Register event handlers
  void _registerEventHandlers() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _notifyUi('join_local', () {
            debugPrint('Local user joined channel: ${connection.channelId}');
            _localUid = connection.localUid;
            _callState = CallState.ringing;
            onCallStateChanged?.call(_callState);
            _startTimeoutTimer();
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _notifyUi('user_joined', () {
            debugPrint('Remote user joined: $remoteUid');
            _remoteUid = remoteUid;
            _callState = CallState.joined;
            onCallStateChanged?.call(_callState);
            _stopTimeoutTimer();
            _startCallTimer();
            onUserJoined?.call(remoteUid);
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          _notifyUi('user_offline', () {
            debugPrint('Remote user offline: $remoteUid, reason: $reason');
            _remoteUid = null;
            onUserOffline?.call(remoteUid);
            _stopCallTimer();
            _stopTimeoutTimer();

            if (_callState == CallState.ringing) {
              _callState = CallState.notAnswered;
              onCallStateChanged?.call(_callState);
              onError?.call('Busy');
            } else if (_callState == CallState.joined) {
              _callState = CallState.endedByRemote;
              onCallStateChanged?.call(_callState);
              onError?.call('Call Ended');
            }
          });
        },
        onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
          _notifyUi('mute_video', () {
            debugPrint(
              'Remote user video ${muted ? 'muted' : 'unmuted'}: $remoteUid',
            );
            onRemoteVideoMuted?.call(muted);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          _notifyUi('leave_ch', () {
            debugPrint('Left channel');
            _localUid = null;
            _remoteUid = null;
            _callState = CallState.idle;
            onCallStateChanged?.call(_callState);
            _stopCallTimer();
          });
        },
        onError: (ErrorCodeType err, String msg) {
          _notifyUi('engine_err', () {
            final errorMsg = msg.isNotEmpty ? msg : err.toString();
            debugPrint('Agora error: $err - $errorMsg');
            debugPrint(
              'Error details - Channel: $_channelName, LocalUID: $_localUid',
            );

            String userFriendlyError = errorMsg;
            if (err == ErrorCodeType.errInvalidToken) {
              userFriendlyError =
                  'Invalid token. Please check backend token generation:\n• Token must be generated for UID 0 (auto-assigned)\n• Token must match exact channel name\n• Token must use correct App ID\n• Token must not be expired';
              debugPrint('=== TOKEN ERROR DEBUG INFO ===');
              debugPrint('Channel Name: $_channelName');
              debugPrint('Local UID: $_localUid');
              debugPrint('Expected UID: 0 (auto-assigned)');
              debugPrint('App ID: ${_appId ?? "not set"}');
              debugPrint('');
              debugPrint('Backend token generation requirements:');
              debugPrint('1. UID must be 0 (for auto-assigned UID)');
              debugPrint('2. Channel name must match exactly: $_channelName');
              debugPrint('3. App ID must be: 0eccfe1cd2044ed8b781d40ad755e365');
              debugPrint('4. Token must be generated using Agora Token Builder');
              debugPrint('================================');
            } else if (err == ErrorCodeType.errJoinChannelRejected) {
              userFriendlyError = 'Failed to join channel. Please try again.';
            }

            _callState = CallState.error;
            onCallStateChanged?.call(_callState);
            onError?.call(userFriendlyError);
          });
        },
      ),
    );
  }

  /// Join a channel
  Future<bool> joinChannel({
    required String token,
    required String channelName,
    int uid = 0, // 0 means Agora will assign a UID
  }) async {
    try {
      if (_engine == null) {
        _notifyUi(
          'no_engine',
          () => onError?.call('Engine not initialized'),
        );
        return false;
      }

      // Validate inputs
      if (channelName.isEmpty) {
        _notifyUi(
          'empty_channel',
          () => onError?.call('Channel name cannot be empty'),
        );
        return false;
      }
      
      // For development/testing: If token is empty or "null", use empty string
      // In production, always use the token from API
      final finalToken = token.isEmpty || token.toLowerCase() == 'null' ? '' : token;
      
      if (finalToken.isEmpty) {
        debugPrint('Warning: Using empty token (development mode)');
      }

      _channelName = channelName;
      _callState = CallState.joining;
      _notifyUi('joining', () => onCallStateChanged?.call(_callState));

      debugPrint('Joining channel: $channelName');
      debugPrint('Token length: ${finalToken.length}');
      debugPrint('Token preview: ${finalToken.length > 20 ? finalToken.substring(0, 20) + "..." : finalToken}');
      debugPrint('UID: $uid');

      await _engine!.joinChannel(
        token: finalToken,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      debugPrint('Join channel request sent successfully');
      return true;
    } catch (e, stack) {
      debugPrint('Exception joining channel: $e');
      CrashlyticsService.recordError(
        e,
        stack,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'AGORA_JOIN_CHANNEL',
      );
      _callState = CallState.error;
      _notifyUi('join_ex_state', () => onCallStateChanged?.call(_callState));
      _notifyUi(
        'join_ex_err',
        () => onError?.call('Failed to join channel: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Leave the channel
  Future<void> leaveChannel() async {
    try {
      _stopCallTimer();
      _callState = CallState.leaving;
      _notifyUi('leaving', () => onCallStateChanged?.call(_callState));

      if (_engine != null) {
        await _engine!.leaveChannel();
      }
    } catch (e, s) {
      debugPrint('Error leaving channel: $e');
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'AGORA_LEAVE',
      );
    }
  }

  /// Toggle mute
  Future<void> toggleMute() async {
    try {
      if (_engine == null) return;

      _isMuted = !_isMuted;
      await _engine!.muteLocalAudioStream(_isMuted);
    } catch (e) {
      debugPrint('Error toggling mute: $e');
    }
  }

  /// Toggle video
  Future<void> toggleVideo() async {
    try {
      if (_engine == null) return;

      _isVideoEnabled = !_isVideoEnabled;
      // muteLocalVideoStream: true = muted (video off), false = unmuted (video on)
      await _engine!.muteLocalVideoStream(!_isVideoEnabled);
    } catch (e) {
      debugPrint('Error toggling video: $e');
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    try {
      if (_engine == null) return;
      await _engine!.switchCamera();
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  /// Toggle speaker
  Future<void> toggleSpeaker() async {
    try {
      if (_engine == null) return;

      _isSpeakerEnabled = !_isSpeakerEnabled;
      await _engine!.setEnableSpeakerphone(_isSpeakerEnabled);
    } catch (e) {
      debugPrint('Error toggling speaker: $e');
    }
  }

  /// Start call timer
  void _startCallTimer() {
    _callDuration = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration++;
      _notifyUi(
        'duration',
        () => onCallDurationChanged?.call(_callDuration),
      );
    });
  }

  /// Stop call timer
  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
    _callDuration = 0;
  }

  /// Start call timeout timer (only for ringing state - waiting for astrologer to accept)
  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(Duration(seconds: _timeoutSeconds), () {
      _notifyUi('timeout', () {
        if (_callState == CallState.ringing) {
          debugPrint(
            'Call timed out after $_timeoutSeconds seconds - astrologer did not accept.',
          );
          _callState = CallState.timeout;
          onCallStateChanged?.call(_callState);
          onError?.call('Busy');
          leaveChannel();
        }
      });
    });
  }

  /// Stop call timeout timer
  void _stopTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  /// Get local video view widget (for video calls)
  Widget? getLocalVideoView() {
    if (_engine == null) return null;
    try {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } catch (e, s) {
      debugPrint('Error getting local video view: $e');
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'AGORA_LOCAL_VIEW',
      );
      return null;
    }
  }

  /// Get remote video view widget (for video calls)
  Widget? getRemoteVideoView(int uid) {
    if (_engine == null || _localUid == null) return null;
    try {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: _channelName ?? '', localUid: _localUid!),
        ),
      );
    } catch (e, s) {
      debugPrint('Error getting remote video view: $e');
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'AGORA_REMOTE_VIEW',
      );
      return null;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      _stopCallTimer();
      _stopTimeoutTimer();
      await leaveChannel();
      await _engine?.release();
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'AGORA_DISPOSE',
      );
    }
    _engine = null;
    _callState = CallState.idle;
  }
}

