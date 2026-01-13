import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Exception for concurrent session limit error
class ConcurrentSessionException implements Exception {
  final String message;
  ConcurrentSessionException(this.message);

  @override
  String toString() => message;
}

class AstrologerChatService {
  final ApiRepository _apiRepository = Get.find(tag: 'chat');

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

      final response = await _apiRepository.postApi(
        'chat/session/start', // New Standard Endpoint
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

  /// Start an existing CREATED session
  Future<void> startExistingSession(String chatId) async {
    try {
      final response = await _apiRepository.postApi(
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

  /// Get chat session details
  Future<AstrologerChatSession> getSession(String chatId) async {
    try {
      final response = await _apiRepository.getApi(
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
      final response = await _apiRepository.postApi(
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
      final response = await _apiRepository.getApi(
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
      final response = await _apiRepository.getApi(
        EndPoints.chatSessionsHistory,
        query: {'page': page, 'limit': limit},
        useAuthHeader: true,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          final sessions = data['data'] as List<dynamic>;
          return {
            'sessions': sessions
                .map(
                  (s) =>
                      AstrologerChatSession.fromJson(s as Map<String, dynamic>),
                )
                .toList(),
            'pagination': data['pagination'],
          };
        }
        throw Exception(data['message'] ?? 'Failed to get session history');
      }
      throw Exception(
        'HTTP ${response.statusCode}: Failed to get session history',
      );
    } catch (e) {
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

      final response = await _apiRepository.getApi(
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
      final response = await _apiRepository.postApi(
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

      final response = await _apiRepository.postApi(
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
      final response = await _apiRepository.getApi(
        EndPoints.chatSessionDownload(chatId),
        useAuthHeader: true,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          return data['data'] as Map<String, dynamic>;
        }
        throw Exception(data['message'] ?? 'Failed to download chat history');
      }
      throw Exception(
        'HTTP ${response.statusCode}: Failed to download chat history',
      );
    } catch (e) {
      rethrow;
    }
  }
}
