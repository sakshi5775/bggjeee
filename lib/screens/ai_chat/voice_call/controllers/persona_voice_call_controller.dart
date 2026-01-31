import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/services/language_service.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/voice_call/services/persona_voice_call_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceCallController extends BaseController {
  final PersonaModel persona;
  final String platform;
  final VoiceCallService _service = VoiceCallService();

  VoiceCallController({
    required this.persona,
    this.platform = 'android',
  });

  final RxString callId = ''.obs;
  final RxString sessionId = ''.obs;
  final RxString websocketUrl = ''.obs;
  final RxString status = 'INITIATED'.obs;

  static const int callMaxSeconds = 600;
  final RxInt remainingSeconds = callMaxSeconds.obs;
  Timer? _ticker;
  WebSocket? _ws;
  
  // Ping/keepalive timer to prevent server from closing connection
  Timer? _pingTimer;
  static const int _pingIntervalSeconds = 15; // Send ping every 15 seconds
  
  // Reconnection state
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;
  
  // Track the working port for reconnection
  int? _lastWorkingPort;

  // Audio recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  final RxBool isRecording = false.obs;
  final RxBool isProcessing = false.obs;
  StreamSubscription<Uint8List>? _audioStreamSubscription;
  Timer? _silenceDetectionTimer;
  final List<Uint8List> _audioBuffer = [];
  
  // VAD (Voice Activity Detection) variables
  static const double _silenceThreshold = 0.005; // Lower threshold for better detection
  static const int _silenceDurationMs = 2000; // 2 seconds of silence after speech
  static const int _maxRecordingDurationMs = 15000; // 15 seconds max recording (reduced for smaller file size)
  static const int _minRecordingDurationMs = 2000; // Minimum 2 seconds before allowing silence detection to stop
  static const int _sampleRate = 16000; // 16kHz is sufficient for voice (reduces file size vs 44.1kHz)
  DateTime? _lastSpeechTime;
  DateTime? _recordingStartTime;
  int _consecutiveSilentChunks = 0;
  static const int _minChunksForSpeech = 10; // Minimum chunks before considering speech (increased)
  bool _hasDetectedSpeech = false; // Track if we've detected actual speech
  Timer? _maxRecordingTimer;

  // Audio playback
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final List<Uint8List> _audioResponseChunks = []; // Accumulate audio response chunks
  StreamSubscription<PlayerState>? _audioPlayerStateSubscription;

  // UI state
  final RxString transcription = ''.obs;
  final RxString aiResponse = ''.obs;
  final RxString connectionStatus = 'Connecting...'.obs;
  
  // Token tracking for deduction
  int? _lastResponseTotalTokens;

  String get formattedRemaining {
    final m = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Calculate deducted seconds based on token count
  /// Formula: min(max(20, (total_tokens / 700 * 40).ceil()), 180)
  /// - Minimum: 20 seconds
  /// - Normal: 40 seconds per 700 tokens
  /// - Maximum: 180 seconds (3 minutes)
  int _calculateDeductedSeconds(int totalTokens) {
    if (totalTokens <= 0) return 20; // Default minimum
    
    // Calculate: (total_tokens / 700 * 40).ceil()
    final calculated = (totalTokens / 700 * 40).ceil();
    
    // Apply min/max bounds: min(max(20, calculated), 180)
    final deducted = calculated.clamp(20, 180);
    
    return deducted;
  }

  @override
  void onInit() {
    super.onInit();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      showErrorMessage(message: 'Microphone permission is required for voice calls');
    }
  }

  Future<void> initiate() async {
    try {
      // Reset reconnection state for new call
      _isReconnecting = false;
      _reconnectAttempts = 0;
      
      // Always try to clean up any remote active call first (handles back / restart cases)
      await _cancelRemoteActiveIfAny();

      setLoadingState(true);
      
      // Get current language code
      String? languageCode;
      try {
        final currentLang = await LanguageService.getCurrentLanguage();
        languageCode = currentLang.code;
      } catch (e) {
        debugPrint('Error getting current language: $e');
        languageCode = 'en'; // Default to English
      }
      
      final data = await _service.initiateCall(
        personaId: persona.id,
        platform: platform,
        language: languageCode,
      );
      setLoadingState(false);
      if (data == null) {
        // Check if there's an active call and offer to end it
        final activeId = await _findActiveCallId();
        if (activeId != null) {
          await _promptEndExistingAndCancel(activeId);
        } else {
          showErrorMessage(message: 'Unable to start call. Please try again.');
        }
        Get.back();
        return;
      }
      callId.value = data['callId']?.toString() ?? '';
      sessionId.value = data['sessionId']?.toString() ?? '';
      websocketUrl.value = data['websocketUrl']?.toString() ?? '';
      status.value = data['status']?.toString() ?? 'INITIATED';
      _startTimer();
      // Add a small delay to allow server to fully initialize the WebSocket endpoint
      await Future.delayed(const Duration(milliseconds: 500));
      await _tryConnectWs();
    } catch (e) {
      setLoadingState(false);
      showErrorMessage(message: 'Failed to initiate call');
      Get.back();
    }
  }

  Future<String?> _findActiveCallId() async {
    try {
      // Get most recent call (any persona), then check if it's still active.
      final data = await _service.getHistory(
        limit: 1,
        skip: 0,
        sortBy: 'createdAt',
        sortOrder: 'desc',
      );
      final list = (data?['calls'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (list.isEmpty) return null;
      final c = list.first;
      final status = (c['status'] ?? '').toString();
      if (status == 'INITIATED' || status == 'CONNECTED' || status == 'IN_PROGRESS') {
        final id = (c['id'] ?? c['_id'] ?? '').toString();
        if (id.isNotEmpty) return id;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _cancelRemoteActiveIfAny() async {
    try {
      final existingId = await _findActiveCallId();
      if (existingId != null) {
        await _service.cancel(existingId);
      }
    } catch (_) {}
  }

  Future<void> _promptEndExistingAndCancel(String existingCallId) async {
    await Get.dialog(
      AlertDialog(
        title: const AutoTranslateText('Active Call Detected'),
        content: const AutoTranslateText('You already have an active call. Do you want to end it now?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const AutoTranslateText('No')),
          TextButton(
            onPressed: () async {
              try {
                await _service.cancel(existingCallId);
              } finally {
                Get.back();
              }
            },
            child: const AutoTranslateText('End Call'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void _startTimer() {
    _ticker?.cancel();
    remainingSeconds.value = callMaxSeconds;
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (remainingSeconds.value <= 0) {
        t.cancel();
        await cancelCall(auto: true);
        return;
      }
      remainingSeconds.value = remainingSeconds.value - 1;
    });
  }

  Future<void> _tryConnectWs() async {
    if (sessionId.isEmpty) return;
    final token = UserData().accessToken ?? '';
    final apiClient = Get.find<ApiClient>();
    final baseUrl = apiClient.appBaseUrl ?? '';
    final baseUri = Uri.parse(baseUrl);
    final wsScheme = baseUri.scheme == 'https' ? 'wss' : 'ws';

    // Construct WebSocket URL for port 8000 WITH duplication: /api/users/api/users/voice/stream/{sessionId}
    // Base URL: http://3.109.91.254:8000/api/
    // WebSocket path from API: /api/users/voice/stream/{sessionId}
    // For port 8000, we need: /api/users/api/users/voice/stream/{sessionId} (WITH duplication)
    String wsPath;
    if (websocketUrl.value.isNotEmpty) {
      // If websocketUrl is provided, check if it's a full URL or just a path
      if (websocketUrl.value.startsWith('ws://') || websocketUrl.value.startsWith('wss://') ||
          websocketUrl.value.startsWith('http://') || websocketUrl.value.startsWith('https://')) {
        // Full URL provided - parse it and use as-is, just add token
        final wsUrl = websocketUrl.value.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://');
        final wsUri = Uri.parse(wsUrl);
        final finalUri = wsUri.replace(queryParameters: {
          if (wsUri.queryParameters.isNotEmpty) ...wsUri.queryParameters,
          'token': token,
        });
        if (kDebugMode) {
          print('Connecting Voice WS (full URL): $finalUri');
        }
        // Retry connection with exponential backoff and fallback
        await _connectWithRetryAndFallback(finalUri.toString(), baseUri, sessionId.value);
        return;
      } else {
        // Path provided - transform it to have duplication for port 8000
        // API returns: /api/users/voice/stream/{sessionId}
        // For port 8000, we need: /api/users/api/users/voice/stream/{sessionId}
        String path = websocketUrl.value.startsWith('/') 
            ? websocketUrl.value 
            : '/${websocketUrl.value}';
        
        // Check if path matches the pattern /api/users/voice/stream/{sessionId}
        final pattern = RegExp(r'^/api/users/voice/stream/(.+)$');
        final match = pattern.firstMatch(path);
        
        if (match != null && match.groupCount > 0) {
          // Extract sessionId and reconstruct with duplication for port 8000
          final extractedSessionId = match.group(1);
          wsPath = '/api/users/api/users/voice/stream/$extractedSessionId';
        } else {
          // If pattern doesn't match, try to use sessionId directly
          if (sessionId.isNotEmpty) {
            wsPath = '/api/users/api/users/voice/stream/$sessionId';
          } else {
            // Fallback: use path as-is (shouldn't happen, but just in case)
            wsPath = path;
          }
        }
      }
    } else {
      // Fallback: construct path with duplication for port 8000
      wsPath = '/api/users/api/users/voice/stream/$sessionId';
    }

    // Build final WebSocket URI for port 8000 (WITH duplication)
    final wsUri = Uri(
      scheme: wsScheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: wsPath,
      queryParameters: {'token': token},
    );

    if (kDebugMode) {
      print('Connecting Voice WS (port 8000 with duplication): $wsUri');
      print('Base URL: $baseUrl, SessionId: $sessionId, WebSocketUrl: ${websocketUrl.value}, Final Path: $wsPath');
    }

    // Retry connection with exponential backoff and fallback to port 8002 (WITHOUT duplication)
    await _connectWithRetryAndFallback(wsUri.toString(), baseUri, sessionId.value);
  }

  /// Try to connect using multiple ports - tries last working port first, then others
  Future<void> _tryConnectWithPorts(Uri baseUri, String sessionId, String token) async {
    final wsScheme = baseUri.scheme == 'https' ? 'wss' : 'ws';
    
    // Port configurations: (port, path, description)
    // Port 8002 WITHOUT duplication is more reliable based on logs, so try it first
    final portConfigs = <Map<String, dynamic>>[];
    
    // If we have a last working port, prioritize it
    if (_lastWorkingPort == 8002) {
      portConfigs.add({
        'port': 8002,
        'path': '/api/users/voice/stream/$sessionId',
        'desc': 'port 8002 (last working, without duplication)',
      });
      portConfigs.add({
        'port': baseUri.hasPort ? baseUri.port : 8000,
        'path': '/api/users/api/users/voice/stream/$sessionId',
        'desc': 'port 8000 (with duplication)',
      });
    } else if (_lastWorkingPort == 8000 || _lastWorkingPort == baseUri.port) {
      portConfigs.add({
        'port': baseUri.hasPort ? baseUri.port : 8000,
        'path': '/api/users/api/users/voice/stream/$sessionId',
        'desc': 'port 8000 (last working, with duplication)',
      });
      portConfigs.add({
        'port': 8002,
        'path': '/api/users/voice/stream/$sessionId',
        'desc': 'port 8002 (without duplication)',
      });
    } else {
      // No last working port - try 8002 first as it's more reliable in logs
      portConfigs.add({
        'port': 8002,
        'path': '/api/users/voice/stream/$sessionId',
        'desc': 'port 8002 (without duplication)',
      });
      portConfigs.add({
        'port': baseUri.hasPort ? baseUri.port : 8000,
        'path': '/api/users/api/users/voice/stream/$sessionId',
        'desc': 'port 8000 (with duplication)',
      });
    }
    
    Exception? lastError;
    
    for (final config in portConfigs) {
      final port = config['port'] as int;
      final path = config['path'] as String;
      final desc = config['desc'] as String;
      
      final wsUri = Uri(
        scheme: wsScheme,
        host: baseUri.host,
        port: port,
        path: path,
        queryParameters: {'token': token},
      );
      
      if (kDebugMode) {
        print('Trying Voice WS connection on $desc: $wsUri');
      }
      
      // Try to connect with retry on this port
      for (int attempt = 1; attempt <= 2; attempt++) {
        try {
          _ws = await WebSocket.connect(wsUri.toString()).timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              throw Exception('WebSocket connection timeout');
            },
          );
          
          // Connection successful
          _lastWorkingPort = port;
          connectionStatus.value = 'Connected';
          _setupWebSocketListeners();
          
          if (kDebugMode) {
            print('Voice WS connected successfully on $desc (attempt $attempt)');
          }
          return;
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          
          if (kDebugMode) {
            print('Voice WS connect failed on $desc (attempt $attempt): $e');
          }
          
          // Only retry on this port if it's a potentially transient error
          final errorStr = e.toString().toLowerCase();
          final isRetryable = errorStr.contains('connection closed') ||
              errorStr.contains('full header') ||
              errorStr.contains('timeout');
          
          if (!isRetryable || attempt >= 2) {
            break; // Move to next port
          }
          
          // Brief delay before retry
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
    }
    
    // All ports failed
    connectionStatus.value = 'Connection Failed';
    throw lastError ?? Exception('Failed to connect to WebSocket');
  }

  /// Connect to WebSocket with retry logic and fallback ports
  /// Port 8000: /api/users/api/users/voice/stream/{sessionId} (WITH duplication)
  /// Port 8002: /api/users/voice/stream/{sessionId} (WITHOUT duplication)
  Future<void> _connectWithRetryAndFallback(String wsUrl, Uri baseUri, String sessionId) async {
    final token = Uri.parse(wsUrl).queryParameters['token'] ?? UserData().accessToken ?? '';
    
    try {
      await _tryConnectWithPorts(baseUri, sessionId, token);
    } catch (e) {
      if (kDebugMode) {
        print('Voice WS all connection attempts failed: $e');
      }
      connectionStatus.value = 'Connection Failed';
      showErrorMessage(message: 'Failed to connect. Please try again.');
    }
  }

  void _setupWebSocketListeners() {
    // Start ping timer to keep connection alive
    _startPingTimer();
    
    _ws?.listen(
      (event) {
        _handleWebSocketMessage(event);
      },
      onError: (error) {
        if (kDebugMode) {
          print('Voice WS error: $error');
        }
        connectionStatus.value = 'Error';
        _stopPingTimer();
        // Try to reconnect on error
        _attemptReconnect();
      },
      onDone: () {
        if (kDebugMode) {
          print('Voice WS closed');
        }
        _stopPingTimer();
        // Only attempt reconnect if not intentionally disconnecting
        if (status.value != 'CANCELLED' && status.value != 'ENDED' && callId.isNotEmpty) {
          connectionStatus.value = 'Reconnecting...';
          _attemptReconnect();
        } else {
          connectionStatus.value = 'Disconnected';
        }
      },
      cancelOnError: false,
    );
  }
  
  /// Start ping timer to keep WebSocket connection alive
  void _startPingTimer() {
    _stopPingTimer();
    _pingTimer = Timer.periodic(const Duration(seconds: _pingIntervalSeconds), (timer) {
      if (_ws != null && _ws!.readyState == WebSocket.open) {
        try {
          final pingMessage = json.encode({'type': 'ping', 'timestamp': DateTime.now().toIso8601String()});
          _ws!.add(pingMessage);
          if (kDebugMode) {
            print('Voice WS ping sent');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Voice WS ping failed: $e');
          }
        }
      }
    });
  }
  
  /// Stop ping timer
  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }
  
  /// Attempt to reconnect the WebSocket
  Future<void> _attemptReconnect() async {
    if (_isReconnecting || _reconnectAttempts >= _maxReconnectAttempts) {
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        connectionStatus.value = 'Connection Failed';
        showErrorMessage(message: 'Connection lost. Please try again.');
      }
      return;
    }
    
    _isReconnecting = true;
    _reconnectAttempts++;
    
    if (kDebugMode) {
      print('Voice WS reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts');
    }
    
    // Wait before reconnecting with exponential backoff
    final delayMs = 500 * (1 << (_reconnectAttempts - 1));
    await Future.delayed(Duration(milliseconds: delayMs));
    
    // Try to reconnect using the last working port if known
    try {
      final token = UserData().accessToken ?? '';
      final apiClient = Get.find<ApiClient>();
      final baseUrl = apiClient.appBaseUrl ?? '';
      final baseUri = Uri.parse(baseUrl);
      
      await _tryConnectWithPorts(baseUri, sessionId.value, token);
      
      // Reset reconnect attempts on success
      _reconnectAttempts = 0;
      _isReconnecting = false;
      
      // Resume recording if it was active
      if (!isRecording.value && !isProcessing.value && !isPlaying.value) {
        Future.delayed(const Duration(milliseconds: 500), () {
          startRecording();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Voice WS reconnect failed: $e');
      }
      _isReconnecting = false;
      
      // Try again if we haven't exhausted attempts
      if (_reconnectAttempts < _maxReconnectAttempts) {
        _attemptReconnect();
      } else {
        connectionStatus.value = 'Connection Failed';
        showErrorMessage(message: 'Connection lost. Please try again.');
      }
    }
  }

  void _handleWebSocketMessage(dynamic event) {
    try {
      // Check if it's binary (audio data) or text (JSON)
      if (event is List<int> || event is Uint8List) {
        // Binary audio data - accumulate chunks (server may send multiple chunks)
        final audioData = event is Uint8List ? event : Uint8List.fromList(event);
        _audioResponseChunks.add(audioData);
        if (kDebugMode) {
          print('Received audio chunk: ${audioData.length} bytes (total chunks: ${_audioResponseChunks.length})');
        }
      } else if (event is String) {
        // JSON message
        final message = json.decode(event) as Map<String, dynamic>;
        final type = message['type'] as String?;

        if (kDebugMode) {
          print('Voice WS message type: $type, data: $message');
        }

        switch (type) {
          case 'session_ready':
            connectionStatus.value = 'Ready';
            status.value = 'CONNECTED';
            // Auto-start recording when session is ready
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!isRecording.value && !isProcessing.value) {
                startRecording();
              }
            });
            break;

          case 'audio_buffered':
            // Server acknowledged audio chunk
            break;

          case 'processing_started':
            isProcessing.value = true;
            connectionStatus.value = 'Processing...';
            // Clear any old audio chunks when new processing starts
            _audioResponseChunks.clear();
            break;

          case 'transcription':
            // Don't display transcription - audio only mode
            if (kDebugMode) {
              final text = message['text']?.toString() ?? message['transcription']?.toString() ?? '';
              print('Transcription (not displayed): $text');
            }
            break;

          case 'ai_response':
            // Don't display AI response text - audio only mode
            if (kDebugMode) {
              final text = message['text']?.toString() ?? message['response']?.toString() ?? message['message']?.toString() ?? '';
              print('AI Response (not displayed): $text');
            }
            // Extract token count for deduction calculation
            try {
              final metadata = message['metadata'] as Map<String, dynamic>?;
              if (metadata != null) {
                final tokens = metadata['tokens'] as Map<String, dynamic>?;
                if (tokens != null) {
                  _lastResponseTotalTokens = tokens['total'] as int?;
                  if (kDebugMode && _lastResponseTotalTokens != null) {
                    print('Total tokens for this response: $_lastResponseTotalTokens');
                  }
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error extracting tokens: $e');
              }
            }
            break;

          case 'processing_complete':
            isProcessing.value = false;
            connectionStatus.value = 'Ready';
            // Clear transcription and response (audio only mode - no text display)
            transcription.value = '';
            aiResponse.value = '';
            
            // Calculate and deduct seconds based on token count
            // Always deduct - use minimum if tokens not available
            final totalTokens = _lastResponseTotalTokens ?? 0;
            final deductedSeconds = _calculateDeductedSeconds(totalTokens);
            if (deductedSeconds > 0) {
              remainingSeconds.value = (remainingSeconds.value - deductedSeconds).clamp(0, callMaxSeconds);
              if (kDebugMode) {
                if (_lastResponseTotalTokens != null) {
                  print('Deducted $deductedSeconds seconds (tokens: $_lastResponseTotalTokens, remaining: ${remainingSeconds.value}s)');
                } else {
                  print('Deducted $deductedSeconds seconds (minimum, tokens not available, remaining: ${remainingSeconds.value}s)');
                }
              }
            }
            _lastResponseTotalTokens = null; // Reset for next response
            
            // Play accumulated audio response chunks
            if (_audioResponseChunks.isNotEmpty) {
              // Combine all audio chunks
              final totalSize = _audioResponseChunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
              final completeAudio = Uint8List(totalSize);
              int offset = 0;
              for (final chunk in _audioResponseChunks) {
                completeAudio.setRange(offset, offset + chunk.length, chunk);
                offset += chunk.length;
              }
              _audioResponseChunks.clear();
              
              // Play the complete audio response
              _playAudioResponse(completeAudio);
            } else {
              // No audio received, restart recording immediately
              Future.delayed(const Duration(milliseconds: 500), () {
                if (!isRecording.value && !isProcessing.value && !isPlaying.value && _ws != null && _ws!.readyState == WebSocket.open) {
                  startRecording();
                }
              });
            }
            break;

          case 'processing_aborted':
            isProcessing.value = false;
            connectionStatus.value = 'Aborted';
            break;

          case 'interrupt_acknowledged':
            isProcessing.value = false;
            _audioBuffer.clear();
            _audioResponseChunks.clear(); // Clear any accumulated audio chunks
            break;

          case 'error':
            isProcessing.value = false;
            final errorMsg = message['error']?.toString() ?? message['message']?.toString() ?? 'Unknown error';
            showErrorMessage(message: errorMsg);
            connectionStatus.value = 'Error';
            break;

          case 'pong':
            // Heartbeat response
            break;

          default:
            if (kDebugMode) {
              print('Unknown message type: $type');
            }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling WebSocket message: $e');
      }
    }
  }

  Future<void> _playAudioResponse(Uint8List audioData) async {
    try {
      // Stop current recording if playing response
      if (isRecording.value) {
        await stopRecording();
      }

      // Cancel previous state subscription if any
      await _audioPlayerStateSubscription?.cancel();

      // Save audio to temporary file
      final tempDir = await getTemporaryDirectory();
      final audioFile = File('${tempDir.path}/voice_response_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await audioFile.writeAsBytes(audioData);

      // Play audio
      isPlaying.value = true;
      connectionStatus.value = 'Playing...';
      await _audioPlayer.setFilePath(audioFile.path);
      await _audioPlayer.play();

      if (kDebugMode) {
        print('Playing audio response: ${audioData.length} bytes');
      }

      // Listen for completion - restart recording after audio finishes
      _audioPlayerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaying.value = false;
          connectionStatus.value = 'Ready';
          
          // Clean up temp file
          audioFile.delete().catchError((_) => audioFile);
          
          // Auto-start recording again after audio playback completes
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!isRecording.value && !isProcessing.value && !isPlaying.value && _ws != null && _ws!.readyState == WebSocket.open) {
              startRecording();
            }
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error playing audio: $e');
      }
      isPlaying.value = false;
      connectionStatus.value = 'Ready';
      
      // Restart recording even if audio playback failed
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isRecording.value && !isProcessing.value && !isPlaying.value && _ws != null && _ws!.readyState == WebSocket.open) {
          startRecording();
        }
      });
    }
  }

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  Future<void> startRecording() async {
    try {
      // Check permission
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        showErrorMessage(message: 'Microphone permission is required');
        return;
      }

      // Check if already processing or playing
      if (isProcessing.value || isPlaying.value) {
        // Don't start recording while audio is playing - wait for it to finish
        if (isPlaying.value) {
          if (kDebugMode) {
            print('Cannot start recording - audio is currently playing');
          }
          return;
        }
        if (isProcessing.value) {
          showInfoMessage(message: 'Please wait for current processing to complete');
          return;
        }
      }

      // Clear previous buffer
      _audioBuffer.clear();

      // We'll use PCM16 stream for both VAD and sending to server
      // The server should accept raw PCM16 audio data

      isRecording.value = true;
      connectionStatus.value = 'Recording...';
      _lastSpeechTime = DateTime.now();
      _recordingStartTime = DateTime.now();
      _consecutiveSilentChunks = 0;
      _hasDetectedSpeech = false; // Reset speech detection flag

      // Set maximum recording duration timer
      _maxRecordingTimer?.cancel();
      _maxRecordingTimer = Timer(Duration(milliseconds: _maxRecordingDurationMs), () {
        if (isRecording.value && !isProcessing.value) {
          if (kDebugMode) {
            print('Max recording duration reached, stopping recording');
          }
          stopRecording();
        }
      });

      // VAD: Analyze audio chunks from file for silence detection
      // We'll check the audio data we read from the file

      // Use PCM16 stream for VAD - optimized for smaller file size
      // Lower sample rate (16kHz) and mono channel reduces file size significantly
      final vadStream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: _sampleRate, // 16kHz is sufficient for voice
          numChannels: 1, // Mono channel (half the size of stereo)
        ),
      );

      // Listen to VAD stream for silence detection
      // We'll accumulate PCM chunks and send them as WAV when speech ends
      _audioStreamSubscription = vadStream.listen(
        (audioChunk) {
          // Detect voice activity
          final hasVoice = _detectVoiceActivityFromWav(audioChunk);
          
          if (hasVoice) {
            _lastSpeechTime = DateTime.now();
            _consecutiveSilentChunks = 0;
            // Mark that we've detected actual speech
            if (_audioBuffer.length >= _minChunksForSpeech) {
              _hasDetectedSpeech = true;
            }
          } else {
            _consecutiveSilentChunks++;
          }

          // Accumulate PCM chunks (don't send yet - we'll send as WAV when speech ends)
          _audioBuffer.add(audioChunk);

          // Calculate recording duration
          final recordingDuration = _recordingStartTime != null 
              ? DateTime.now().difference(_recordingStartTime!).inMilliseconds
              : 0;

          // Only check for silence if:
          // 1. We've recorded for at least minimum duration
          // 2. We've accumulated enough chunks
          // 3. We've detected actual speech (not just silence from the start)
          if (recordingDuration >= _minRecordingDurationMs && 
              _audioBuffer.length > _minChunksForSpeech && 
              _hasDetectedSpeech) {
            final silenceDuration = _lastSpeechTime != null 
                ? DateTime.now().difference(_lastSpeechTime!).inMilliseconds
                : 0;
            
            // If we have enough consecutive silent chunks OR enough silence duration after speech
            if (_consecutiveSilentChunks > 10 || silenceDuration >= _silenceDurationMs) {
              // Silence detected after speech, stop recording and send speech_end
              if (isRecording.value && !isProcessing.value) {
                if (kDebugMode) {
                  print('Silence detected after speech: consecutiveChunks=$_consecutiveSilentChunks, silenceDuration=${silenceDuration}ms, recordingDuration=${recordingDuration}ms');
                }
                stopRecording();
              }
            }
          } else if (kDebugMode && _audioBuffer.length % 50 == 0) {
            // Debug: log status periodically
            print('Recording: duration=${recordingDuration}ms, chunks=${_audioBuffer.length}, hasSpeech=$_hasDetectedSpeech, consecutiveSilent=$_consecutiveSilentChunks');
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Audio stream error: $error');
          }
          showErrorMessage(message: 'Recording error: $error');
          stopRecording();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error starting recording: $e');
      }
      showErrorMessage(message: 'Failed to start recording: $e');
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    try {
      _silenceDetectionTimer?.cancel();
      _silenceDetectionTimer = null;
      _maxRecordingTimer?.cancel();
      _maxRecordingTimer = null;

      // Stop recording stream
      await _audioRecorder.stop();
      _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;

      isRecording.value = false;

      // Convert PCM16 chunks to WAV format and send
      if (_ws != null && _ws!.readyState == WebSocket.open && _audioBuffer.isNotEmpty) {
        try {
          // Combine all PCM chunks
          final totalSize = _audioBuffer.fold<int>(0, (sum, chunk) => sum + chunk.length);
          
          // Check if we detected actual speech
          if (!_hasDetectedSpeech) {
            if (kDebugMode) {
              print('No speech detected, skipping send (audio size: ${totalSize} bytes)');
            }
            _audioBuffer.clear();
            _hasDetectedSpeech = false;
            // Restart recording to wait for actual speech
            Future.delayed(const Duration(milliseconds: 300), () {
              if (!isRecording.value && !isProcessing.value && !isPlaying.value && _ws != null && _ws!.readyState == WebSocket.open) {
                startRecording();
              }
            });
            return;
          }
          
          // Check minimum audio size (at least 1 second of audio)
          final minAudioSize = (_sampleRate * 2 * 1.0).round(); // 1 second at 16kHz, 16-bit, mono
          if (totalSize < minAudioSize) {
            if (kDebugMode) {
              print('Audio too short (${totalSize} bytes), skipping send');
            }
            _audioBuffer.clear();
            _hasDetectedSpeech = false;
            // Restart recording
            Future.delayed(const Duration(milliseconds: 300), () {
              if (!isRecording.value && !isProcessing.value && !isPlaying.value && _ws != null && _ws!.readyState == WebSocket.open) {
                startRecording();
              }
            });
            return;
          }
          
          final pcmData = Uint8List(totalSize);
          int offset = 0;
          for (final chunk in _audioBuffer) {
            pcmData.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }

          // Trim silence from beginning and end to reduce file size
          final trimmedPcmData = _trimSilence(pcmData);
          
          if (trimmedPcmData.isEmpty) {
            if (kDebugMode) {
              print('No audio detected after trimming silence');
            }
            _audioBuffer.clear();
            return;
          }

          // Create WAV file with header (optimized for smaller size)
          final wavFile = _createWavFile(trimmedPcmData, sampleRate: _sampleRate, channels: 1, bitsPerSample: 16);
          
          if (kDebugMode) {
            final sizeKB = (wavFile.length / 1024).toStringAsFixed(2);
            final duration = (trimmedPcmData.length / (_sampleRate * 2)).toStringAsFixed(2);
            print('Created WAV file: ${sizeKB} KB (${wavFile.length} bytes), duration: ${duration}s');
          }
          
          // Send WAV file in chunks (8KB each for smooth streaming)
          const chunkSize = 8192;
          for (int i = 0; i < wavFile.length; i += chunkSize) {
            final chunk = wavFile.sublist(i, (i + chunkSize < wavFile.length) ? i + chunkSize : wavFile.length);
            _ws!.add(chunk);
          }

          // Send speech_end signal
          final speechEndMessage = json.encode({'type': 'speech_end'});
          _ws!.add(speechEndMessage);
          connectionStatus.value = 'Sending...';
          
          if (kDebugMode) {
            final recordingDuration = _recordingStartTime != null 
                ? DateTime.now().difference(_recordingStartTime!).inMilliseconds 
                : 0;
            print('Sent WAV file (${wavFile.length} bytes) and speech_end signal (duration: ${recordingDuration}ms)');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error creating WAV file: $e');
          }
          showErrorMessage(message: 'Failed to process audio');
        }
      } else if (kDebugMode) {
        print('Not sending speech_end: ws=${_ws != null}, readyState=${_ws?.readyState}, bufferSize=${_audioBuffer.length}');
      }

      _audioBuffer.clear();
      _consecutiveSilentChunks = 0;
      _lastSpeechTime = null;
      _recordingStartTime = null;
      _hasDetectedSpeech = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping recording: $e');
      }
      isRecording.value = false;
    }
  }

  /// Trim silence from beginning and end of PCM data to reduce file size
  Uint8List _trimSilence(Uint8List pcmData) {
    if (pcmData.isEmpty || pcmData.length < 4) return pcmData;
    
    const silenceThreshold = 500; // Amplitude threshold for silence
    const minSilenceDuration = _sampleRate ~/ 10; // 100ms of silence to trim
    
    int startIndex = 0;
    int endIndex = pcmData.length;
    
    // Find start of audio (skip initial silence)
    int consecutiveSilent = 0;
    for (int i = 0; i < pcmData.length - 1; i += 2) {
      final int16 = (pcmData[i] | (pcmData[i + 1] << 8));
      final sample = int16 > 32767 ? int16 - 65536 : int16;
      final amplitude = sample.abs();
      
      if (amplitude < silenceThreshold) {
        consecutiveSilent++;
      } else {
        // Found audio - check if we had enough silence before this
        if (consecutiveSilent >= minSilenceDuration) {
          startIndex = i;
        } else if (startIndex == 0) {
          startIndex = i; // First audio found
        }
        consecutiveSilent = 0;
      }
    }
    
    // Find end of audio (skip trailing silence)
    consecutiveSilent = 0;
    for (int i = pcmData.length - 2; i >= startIndex; i -= 2) {
      final int16 = (pcmData[i] | (pcmData[i + 1] << 8));
      final sample = int16 > 32767 ? int16 - 65536 : int16;
      final amplitude = sample.abs();
      
      if (amplitude < silenceThreshold) {
        consecutiveSilent++;
      } else {
        // Found audio - check if we had enough silence after this
        if (consecutiveSilent >= minSilenceDuration) {
          endIndex = i + 2;
        } else if (endIndex == pcmData.length) {
          endIndex = i + 2; // Last audio found
        }
        break; // Stop at first audio from the end
      }
    }
    
    // Ensure we have at least some audio (minimum 0.5 seconds)
    final trimmedSize = endIndex - startIndex;
    final minSize = (_sampleRate * 2 * 0.5).round(); // 0.5 seconds minimum
    if (trimmedSize < minSize) {
      return pcmData; // Return original if trimmed would be too short
    }
    
    return pcmData.sublist(startIndex, endIndex);
  }

  /// Create a WAV file from PCM16 data
  Uint8List _createWavFile(Uint8List pcmData, {int sampleRate = 16000, int channels = 1, int bitsPerSample = 16}) {
    final dataSize = pcmData.length;
    final fileSize = 36 + dataSize; // 36 bytes header + data
    
    final wavFile = Uint8List(44 + dataSize); // 44 bytes header + data
    int offset = 0;
    
    // RIFF header
    wavFile[offset++] = 0x52; // 'R'
    wavFile[offset++] = 0x49; // 'I'
    wavFile[offset++] = 0x46; // 'F'
    wavFile[offset++] = 0x46; // 'F'
    
    // File size - 8
    wavFile[offset++] = fileSize & 0xFF;
    wavFile[offset++] = (fileSize >> 8) & 0xFF;
    wavFile[offset++] = (fileSize >> 16) & 0xFF;
    wavFile[offset++] = (fileSize >> 24) & 0xFF;
    
    // WAVE
    wavFile[offset++] = 0x57; // 'W'
    wavFile[offset++] = 0x41; // 'A'
    wavFile[offset++] = 0x56; // 'V'
    wavFile[offset++] = 0x45; // 'E'
    
    // fmt chunk
    wavFile[offset++] = 0x66; // 'f'
    wavFile[offset++] = 0x6D; // 'm'
    wavFile[offset++] = 0x74; // 't'
    wavFile[offset++] = 0x20; // ' '
    
    // Subchunk1Size (16 for PCM)
    wavFile[offset++] = 16;
    wavFile[offset++] = 0;
    wavFile[offset++] = 0;
    wavFile[offset++] = 0;
    
    // AudioFormat (1 for PCM)
    wavFile[offset++] = 1;
    wavFile[offset++] = 0;
    
    // NumChannels
    wavFile[offset++] = channels;
    wavFile[offset++] = 0;
    
    // SampleRate
    wavFile[offset++] = sampleRate & 0xFF;
    wavFile[offset++] = (sampleRate >> 8) & 0xFF;
    wavFile[offset++] = (sampleRate >> 16) & 0xFF;
    wavFile[offset++] = (sampleRate >> 24) & 0xFF;
    
    // ByteRate
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    wavFile[offset++] = byteRate & 0xFF;
    wavFile[offset++] = (byteRate >> 8) & 0xFF;
    wavFile[offset++] = (byteRate >> 16) & 0xFF;
    wavFile[offset++] = (byteRate >> 24) & 0xFF;
    
    // BlockAlign
    final blockAlign = channels * (bitsPerSample ~/ 8);
    wavFile[offset++] = blockAlign;
    wavFile[offset++] = 0;
    
    // BitsPerSample
    wavFile[offset++] = bitsPerSample;
    wavFile[offset++] = 0;
    
    // data chunk
    wavFile[offset++] = 0x64; // 'd'
    wavFile[offset++] = 0x61; // 'a'
    wavFile[offset++] = 0x74; // 't'
    wavFile[offset++] = 0x61; // 'a'
    
    // Subchunk2Size (data size)
    wavFile[offset++] = dataSize & 0xFF;
    wavFile[offset++] = (dataSize >> 8) & 0xFF;
    wavFile[offset++] = (dataSize >> 16) & 0xFF;
    wavFile[offset++] = (dataSize >> 24) & 0xFF;
    
    // PCM data
    wavFile.setRange(offset, offset + dataSize, pcmData);
    
    return wavFile;
  }

  /// Detect voice activity from WAV PCM data
  /// Returns true if voice is detected, false otherwise
  bool _detectVoiceActivityFromWav(Uint8List pcmData) {
    if (pcmData.isEmpty) return false;

    // Calculate RMS (Root Mean Square) for volume detection
    double sum = 0.0;
    int sampleCount = 0;
    
    for (int i = 0; i < pcmData.length; i += 2) {
      if (i + 1 < pcmData.length) {
        // Convert bytes to 16-bit signed integer (little-endian)
        final int16 = (pcmData[i] | (pcmData[i + 1] << 8));
        final sample = int16 > 32767 ? int16 - 65536 : int16;
        sum += sample * sample;
        sampleCount++;
      }
    }
    
    if (sampleCount == 0) return false;
    
    final rms = (sum / sampleCount);
    final volume = rms / (32768.0 * 32768.0); // Normalize to 0-1 range
    
    // Consider it voice if volume exceeds threshold
    final hasVoice = volume > _silenceThreshold;
    
    if (kDebugMode && _audioBuffer.length % 50 == 0) {
      // Log every 50th chunk to avoid spam
      print('VAD: volume=$volume, threshold=$_silenceThreshold, hasVoice=$hasVoice, chunks=${_audioBuffer.length}');
    }
    
    return hasVoice;
  }


  Future<void> sendInterrupt() async {
    if (_ws != null && _ws!.readyState == WebSocket.open) {
      final interruptMessage = json.encode({'type': 'interrupt'});
      _ws!.add(interruptMessage);
      
      // Stop current recording if any
      if (isRecording.value) {
        await stopRecording();
      }
      
      // Stop audio playback
      await _audioPlayer.stop();
      isPlaying.value = false;
    }
  }

  Future<void> cancelCall({bool auto = false}) async {
    // Set status to CANCELLED to prevent reconnection attempts
    status.value = 'CANCELLED';
    
    if (callId.isEmpty) {
      _cleanup();
      Get.back();
      return;
    }
    try {
      await _service.cancel(callId.value);
    } catch (_) {}
    _cleanup();
    if (auto) {
      showInfoMessage(message: 'Call ended automatically after 10 minutes.');
    }
    Get.back();
  }

  void _cleanup() {
    // Mark as ended to prevent reconnection attempts
    status.value = 'ENDED';
    
    _ticker?.cancel();
    _ticker = null;
    
    _silenceDetectionTimer?.cancel();
    _silenceDetectionTimer = null;
    
    _maxRecordingTimer?.cancel();
    _maxRecordingTimer = null;
    
    // Stop ping timer
    _stopPingTimer();
    
    // Reset reconnection state
    _isReconnecting = false;
    _reconnectAttempts = 0;
    
    _audioStreamSubscription?.cancel();
    _audioStreamSubscription = null;
    
    _audioPlayerStateSubscription?.cancel();
    _audioPlayerStateSubscription = null;
    
    _audioResponseChunks.clear();
    
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    
    try {
      _ws?.close();
    } catch (_) {}
    _ws = null;
    
    _audioBuffer.clear();
    _consecutiveSilentChunks = 0;
    _lastSpeechTime = null;
    _recordingStartTime = null;
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
}
