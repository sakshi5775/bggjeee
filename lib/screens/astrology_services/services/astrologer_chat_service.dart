import 'dart:convert';
import 'dart:io';
import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/utils/port_fallback_helper.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Exception for concurrent session limit error
class ConcurrentSessionException implements Exception {
  final String message;
  ConcurrentSessionException(this.message);

  @override
  String toString() => message;
}

class AstrologerChatService {
  ApiRepository get _apiRepository {
    try {
      return Get.find(tag: 'chat');
    } catch (e) {
      if (kDebugMode) print('ERROR: Chat API repository not found: $e');
      try {
        final chatApiClient = Get.find<ApiClient>(tag: 'chat');
        return ApiRepository(apiClient: chatApiClient);
      } catch (e2) {
        if (kDebugMode) print('ERROR: Chat API client not found: $e2');
        rethrow;
      }
    }
  }

  ApiRepository get _fallbackApiRepository {
    try {
      return Get.find(tag: 'chat-fallback');
    } catch (_) {
      return _apiRepository;
    }
  }

  /// GET via primary (8000/api/calls/api/). On connection failure retries with port-8009 fallback.
  Future<Response<T>> _chatGet<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    bool useAuthHeader = true,
  }) async {
    try {
      return await _apiRepository.getApi<T>(
        endpoint,
        query: query,
        useAuthHeader: useAuthHeader,
      );
    } on SocketException {
      if (kDebugMode) print('[ChatFallback] GET SocketException → port 8009: $endpoint');
      return await _fallbackApiRepository.getApi<T>(
        endpoint,
        query: query,
        useAuthHeader: useAuthHeader,
      );
    } catch (e) {
      if (_isConnectionError(e)) {
        if (kDebugMode) print('[ChatFallback] GET connection error → port 8009: $endpoint');
        return await _fallbackApiRepository.getApi<T>(
          endpoint,
          query: query,
          useAuthHeader: useAuthHeader,
        );
      }
      rethrow;
    }
  }

  /// POST via primary (8000/api/calls/api/). On connection failure retries with port-8009 fallback.
  Future<Response> _chatPost(
    String endpoint,
    dynamic body, {
    bool useAuthHeader = true,
  }) async {
    try {
      return await _apiRepository.postApi(
        endpoint,
        body,
        useAuthHeader: useAuthHeader,
      );
    } on SocketException {
      if (kDebugMode) print('[ChatFallback] POST SocketException → port 8009: $endpoint');
      return await _fallbackApiRepository.postApi(
        endpoint,
        body,
        useAuthHeader: useAuthHeader,
      );
    } catch (e) {
      if (_isConnectionError(e)) {
        if (kDebugMode) print('[ChatFallback] POST connection error → port 8009: $endpoint');
        return await _fallbackApiRepository.postApi(
          endpoint,
          body,
          useAuthHeader: useAuthHeader,
        );
      }
      rethrow;
    }
  }

  bool _isConnectionError(dynamic e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('connection refused') ||
        msg.contains('connection failed') ||
        msg.contains('failed host lookup') ||
        msg.contains('network is unreachable') ||
        msg.contains('no route to host') ||
        msg.contains('socketexception');
  }

  /// Start chat session - Replaces purchaseSession
  Future<AstrologerChatSession> startSession(String astrologerId) async {
    try {
      if (kDebugMode) {
        print('Starting chat session with astrologer: $astrologerId');
        print(
          'Endpoint: ${EndPoints.chatSessionStart("session_start")}',
        ); // Note: Endpoint might need adjustment if it expects ID in path vs body for creation.
        // Based on API doc: POST /api/chat/session/start with { "astrologerId": "..." }
        // The EndPoints.chatSessionStart(chatId) takes an ID.
        // If the new API is /api/chat/session/start (no ID in path), we need to check EndPoints.
      }

      // The API doc says: POST /api/chat/session/start
      // But EndPoints.chatSessionStart(chatId) produces 'calls/api/chat/session/$chatId/start'
      // We need to fix EndPoints if the URL path changed, OR use a raw string here if EndPoints is rigid.
      // Let's assume we need to add a new endpoint constant for creation if the structure changed significantly.
      // Wait, the new API is `POST /api/chat/session/start`.
      // The existing `chatSessionStart(chatId)` was likely for RE-starting or something else.

      // Let's look at EndPoints again.
      // It has `chatSessionStart(chatId) => 'calls/api/chat/session/$chatId/start'`.
      // The NEW API is `calls/api/chat/session/start` (assuming base 'calls/api' matches 'api/').

      // I will use a direct string for now to be safe, or update EndPoints.
      // Actually, I should update EndPoints to add `chatSessionCreate`.

      final response = await _chatPost(
        'chat/session/start',
        {'astrologerId': astrologerId},
        useAuthHeader: true,
      );

      if (kDebugMode) {
        print('Start session response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          if (data['data'] != null) {
            return AstrologerChatSession.fromJson(data['data']);
          }
          return AstrologerChatSession.fromJson(data);
        }

        // Handle specific business errors
        if (data['error'] == 'INSUFFICIENT_BALANCE') {
          throw Exception(data['message'] ?? 'Insufficient wallet balance');
        }

        throw Exception(data['message'] ?? 'Failed to start session');
      }

      throw Exception('HTTP ${response.statusCode}: Failed to start session');
    } catch (e) {
      if (kDebugMode) {
        print('Error starting session: $e');
      }
      rethrow;
    }
  }

  /// Start an existing CREATED session (notify/activate so astrologer can accept).
  /// Uses chat ApiRepository (port 8009) and path chat/session/{chatId}/start —
  /// same server that created the session; port 8000 does not expose this route (404).
  Future<void> startExistingSession(String chatId) async {
    try {
      final response = await _chatPost(
        EndPoints.chatSessionStart(chatId),
        {},
        useAuthHeader: true,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'HTTP ${response.statusCode}: Failed to start existing session',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Call when app reopens after being closed from RAM. Checks active/paused/pending sessions and
  /// with [autoCleanup] true cleans up: CREATED >30min pending, PAUSED >30min inactive.
  /// Uses main ApiRepository (port 8000, calls service). Fire-and-forget; safe to call from onReady.
  static Future<void> checkActiveSessionsAndCleanup({bool autoCleanup = true}) async {
    try {
      final repo = Get.find<ApiRepository>();
      await repo.getApi(
        EndPoints.chatSessionsCheckActive,
        query: {'autoCleanup': autoCleanup.toString()},
        useAuthHeader: true,
      );
      if (kDebugMode) {
        print('ChatSessionCleanup: check-active?autoCleanup=$autoCleanup completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ChatSessionCleanup: check-active failed (non-fatal): $e');
      }
    }
  }

  /// Get chat session details
  Future<AstrologerChatSession> getSession(String chatId) async {
    try {
      final response = await _chatGet(
        EndPoints.chatSessionGet(chatId),
        useAuthHeader: true,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          return AstrologerChatSession.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to get session');
      }
      throw Exception('HTTP ${response.statusCode}: Failed to get session');
    } catch (e) {
      rethrow;
    }
  }

  /// End chat session
  Future<AstrologerChatSession> endSession(
    String chatId, {
    String? reason,
  }) async {
    try {
      final body = reason != null ? {'reason': reason} : {};
      final response = await _chatPost(
        EndPoints.chatSessionEnd(chatId),
        body,
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          return AstrologerChatSession.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to end session');
      }
      throw Exception('HTTP ${response.statusCode}: Failed to end session');
    } catch (e) {
      rethrow;
    }
  }

  /// Get active sessions
  Future<List<AstrologerChatSession>> getActiveSessions() async {
    try {
      final response = await _chatGet(
        EndPoints.chatSessionsActive,
        useAuthHeader: true,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          final sessions = data['data'] as List<dynamic>;
          return sessions
              .map(
                (s) =>
                    AstrologerChatSession.fromJson(s as Map<String, dynamic>),
              )
              .toList();
        }
        throw Exception(data['message'] ?? 'Failed to get active sessions');
      }
      throw Exception(
        'HTTP ${response.statusCode}: Failed to get active sessions',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error getting active sessions: $e');
      }
      rethrow;
    }
  }

  /// Get session history
  Future<Map<String, dynamic>> getSessionHistory({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      if (kDebugMode) {
        print('=== Fetching chat history ===');
        print('Page: $page, Limit: $limit');
        print('Endpoint: ${EndPoints.chatSessionsHistory}');
      }

      // Try using the API repository first
      Response? response;
      try {
        response = await _chatGet(
          EndPoints.chatSessionsHistory,
          query: {'page': page, 'limit': limit},
          useAuthHeader: true,
        );
      } catch (e) {
        if (kDebugMode) {
          print('API Repository failed, trying direct HTTP: $e');
        }
        // Fallback: Direct HTTP call
        response = await _getSessionHistoryDirect(page: page, limit: limit);
      }

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body type: ${response.body.runtimeType}');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'HTTP ${response.statusCode}: Failed to get session history',
        );
      }

      // Handle response body - GetConnect may auto-parse JSON
      dynamic body = response.body;
      
      // If body is a string, parse it
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          if (kDebugMode) {
            print('Failed to parse body as JSON: $e');
          }
          return _emptyHistoryResult();
        }
      }

      if (body == null) {
        if (kDebugMode) {
          print('ERROR: Response body is null');
        }
        return _emptyHistoryResult();
      }

      if (body is! Map<String, dynamic>) {
        if (kDebugMode) {
          print('ERROR: Response body is not Map, type: ${body.runtimeType}');
          print('Body content: $body');
        }
        return _emptyHistoryResult();
      }

      final data = body;
      
      if (kDebugMode) {
        print('Response data keys: ${data.keys.toList()}');
        print('Success: ${data['success']}');
      }

      if (data['success'] != true) {
        final errorMsg = data['message']?.toString() ?? 'Failed to get session history';
        if (kDebugMode) {
          print('ERROR: API returned success=false: $errorMsg');
        }
        throw Exception(errorMsg);
      }

      // Extract data array - API returns data as a direct list
      List<dynamic> rawList = [];
      final payload = data['data'];

      if (kDebugMode) {
        print('Payload type: ${payload.runtimeType}');
        print('Payload is List: ${payload is List}');
      }

      if (payload is List) {
        rawList = payload;
        if (kDebugMode) {
          print('Found ${rawList.length} sessions in data array');
        }
      } else if (payload == null) {
        if (kDebugMode) {
          print('WARNING: data field is null, trying alternative fields');
        }
        // Try alternative field names
        final altPayload = data['sessions'] ?? data['list'];
        if (altPayload is List) {
          rawList = altPayload;
          if (kDebugMode) {
            print('Found ${rawList.length} sessions in alternative field');
          }
        }
      }

      if (rawList.isEmpty) {
        if (kDebugMode) {
          print('INFO: No sessions found in response');
        }
        return {
          'sessions': <AstrologerChatSession>[],
          'pagination': data['pagination'],
        };
      }

      // Parse sessions
      final List<AstrologerChatSession> sessions = [];
      for (int i = 0; i < rawList.length; i++) {
        final s = rawList[i];
        try {
          if (s is Map<String, dynamic>) {
            // Add default astrologerId if missing (API doesn't always include it)
            final sessionData = Map<String, dynamic>.from(s);
            if (!sessionData.containsKey('astrologerId') &&
                !sessionData.containsKey('astrologer_id') &&
                !sessionData.containsKey('astrologer')) {
              sessionData['astrologerId'] = 'unknown';
            }
            
            final session = AstrologerChatSession.fromJson(sessionData);
            sessions.add(session);
            
            if (kDebugMode && i == 0) {
              print('Sample session parsed: chatId=${session.chatId}, status=${session.status}');
            }
          } else {
            if (kDebugMode) {
              print('WARNING: Session item $i is not a Map, type: ${s.runtimeType}');
            }
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print('ERROR parsing session $i: $e');
            print('Session data: $s');
            print('Stack trace: $stackTrace');
          }
        }
      }

      if (kDebugMode) {
        print('=== Parsing complete ===');
        print('Raw items: ${rawList.length}');
        print('Parsed sessions: ${sessions.length}');
      }

      final pagination = data['pagination'];
      return {
        'sessions': sessions,
        'pagination': pagination is Map<String, dynamic> ? pagination : null,
      };
    } on TypeError catch (e, stackTrace) {
      if (kDebugMode) {
        print('TypeError in chat history API: $e');
        print('Stack trace: $stackTrace');
      }
      return _emptyHistoryResult();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Exception in chat history API: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  Map<String, dynamic> _emptyHistoryResult() {
    return {'sessions': <AstrologerChatSession>[], 'pagination': null};
  }

  /// Direct HTTP call for getting session history (primary 8000/api/calls/, fallback 8009)
  Future<Response> _getSessionHistoryDirect({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final token = UserData().accessToken;
      if (token == null || token.isEmpty) {
        throw Exception('No access token available');
      }

      const String historyPath = '/api/chat/sessions/history';
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final primaryUri = Uri.parse('${PortFallbackHelper.callsApiPrimary}$historyPath')
          .replace(queryParameters: queryParams);
      final fallbackUri = Uri.parse('${PortFallbackHelper.callsApiFallback}$historyPath')
          .replace(queryParameters: queryParams);

      if (kDebugMode) print('Direct HTTP call (primary): $primaryUri');

      final httpResponse = await PortFallbackHelper.callWithFallback(
        primary: () => http.get(primaryUri, headers: headers).timeout(const Duration(seconds: 30)),
        fallback: () => http.get(fallbackUri, headers: headers).timeout(const Duration(seconds: 30)),
      );

      if (kDebugMode) {
        print('Direct HTTP response status: ${httpResponse.statusCode}');
        print('Direct HTTP response body: ${httpResponse.body}');
      }

      final body = jsonDecode(httpResponse.body);
      return Response(
        statusCode: httpResponse.statusCode,
        statusText: httpResponse.reasonPhrase,
        body: body,
        bodyString: httpResponse.body,
      );
    } catch (e) {
      if (kDebugMode) print('Direct HTTP call failed: $e');
      rethrow;
    }
  }

  /// Get messages
  Future<Map<String, dynamic>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 50,
    String? before,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (before != null) {
        query['before'] = before;
      }

      final response = await _chatGet(
        EndPoints.chatSessionMessages(chatId),
        query: query,
        useAuthHeader: true,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          List<dynamic> messagesList = [];
          if (data['data'] != null) {
            if (data['data'] is List) {
              messagesList = data['data'] as List<dynamic>;
            } else if (data['data'] is Map) {
              final dataMap = data['data'] as Map<String, dynamic>;
              if (dataMap['messages'] != null) {
                if (dataMap['messages'] is List) {
                  messagesList = dataMap['messages'] as List<dynamic>;
                }
              }
            }
          }

          final List<AstrologerChatMessage> parsedMessages = [];
          for (final m in messagesList) {
            try {
              if (m is Map<String, dynamic>) {
                parsedMessages.add(AstrologerChatMessage.fromJson(m));
              }
            } catch (e) {
              // Ignore parsing errors for individual messages
            }
          }

          return {
            'messages': parsedMessages,
            'pagination': data['pagination'] ?? {},
          };
        }
        throw Exception(data['message'] ?? 'Failed to get messages');
      }
      throw Exception('HTTP ${response.statusCode}: Failed to get messages');
    } catch (e) {
      rethrow;
    }
  }

  /// Mark messages as read
  Future<bool> markMessagesAsRead(
    String chatId,
    List<String> messageIds,
  ) async {
    try {
      final response = await _chatPost(
        EndPoints.chatSessionMessagesRead(chatId),
        {'messageIds': messageIds},
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Rate session
  Future<bool> rateSession(
    String chatId, {
    required int rating,
    String? review,
  }) async {
    try {
      final body = <String, dynamic>{'rating': rating};
      if (review != null && review.isNotEmpty) {
        body['review'] = review;
      }

      final response = await _chatPost(
        EndPoints.chatSessionRating(chatId),
        body,
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Download chat history
  Future<Map<String, dynamic>> downloadChatHistory(String chatId) async {
    try {
      if (kDebugMode) {
        print('=== Downloading chat history ===');
        print('ChatId: $chatId');
        print('Endpoint: ${EndPoints.chatSessionDownload(chatId)}');
      }

      Response response;
      try {
        response = await _chatGet(
          EndPoints.chatSessionDownload(chatId),
        useAuthHeader: true,
      );
      } catch (e) {
        if (kDebugMode) {
          print('API Repository failed, trying direct HTTP: $e');
        }
        // Fallback: Direct HTTP call
        response = await _downloadChatHistoryDirect(chatId);
      }

      if (kDebugMode) {
        print('Download response status: ${response.statusCode}');
        print('Download response body type: ${response.body.runtimeType}');
      }

      if (response.statusCode == 200) {
        dynamic body = response.body;
        
        // If body is a string, parse it
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            if (kDebugMode) {
              print('Failed to parse download body as JSON: $e');
            }
            throw Exception('Invalid JSON response');
          }
        }

        if (body is Map<String, dynamic>) {
          final data = body;
        if (data['success'] == true) {
            final result = data['data'] as Map<String, dynamic>?;
            if (result != null) {
              if (kDebugMode) {
                print('Download successful, messages count: ${result['messages']?.length ?? 0}');
              }
              return result;
            }
            throw Exception('No data in response');
        }
        throw Exception(data['message'] ?? 'Failed to download chat history');
        }
        throw Exception('Invalid response format');
      }
      throw Exception(
        'HTTP ${response.statusCode}: Failed to download chat history',
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Download chat history error: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Direct HTTP call for downloading chat history (primary 8000/api/calls/, fallback 8009)
  Future<Response> _downloadChatHistoryDirect(String chatId) async {
    try {
      final token = UserData().accessToken;
      if (token == null || token.isEmpty) {
        throw Exception('No access token available');
      }

      final downloadPath = '/api/chat/session/$chatId/download';
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final primaryUri = Uri.parse('${PortFallbackHelper.callsApiPrimary}$downloadPath');
      final fallbackUri = Uri.parse('${PortFallbackHelper.callsApiFallback}$downloadPath');

      if (kDebugMode) print('Direct HTTP download call (primary): $primaryUri');

      final httpResponse = await PortFallbackHelper.callWithFallback(
        primary: () => http.get(primaryUri, headers: headers).timeout(const Duration(seconds: 30)),
        fallback: () => http.get(fallbackUri, headers: headers).timeout(const Duration(seconds: 30)),
      );

      if (kDebugMode) {
        print('Direct HTTP download response status: ${httpResponse.statusCode}');
      }

      // Convert http.Response to GetConnect Response
      final body = jsonDecode(httpResponse.body);
      return Response(
        statusCode: httpResponse.statusCode,
        statusText: httpResponse.reasonPhrase,
        body: body,
        bodyString: httpResponse.body,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Direct HTTP download call failed: $e');
      }
      rethrow;
    }
  }
}
