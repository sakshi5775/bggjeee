import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/core/services/insufficient_wallet_exception.dart';
import 'package:get/get.dart';

class VoiceCallService {
  final ApiRepository _apiRepository = Get.find();

  /// Initiates Persona AI voice call.
  /// Throws [InsufficientWalletException] on 402 for recharge flow.
  Future<Map<String, dynamic>?> initiateCall({
    required String personaId,
    String platform = 'web',
    String? language,
  }) async {
    try {
      final body = <String, dynamic>{
        'platform': platform,
      };

      if (language != null && language.isNotEmpty) {
        body['language'] = language;
      }

      final response = await _apiRepository.postApi(
        EndPoints.voiceInitiate(personaId),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.body['data'] ?? {});
      }

      // 402: Insufficient wallet balance - parse and throw for recharge flow
      if (response.statusCode == 402) {
        final body = response.body;
        final data = body is Map ? (body['data'] as Map<String, dynamic>?) : null;
        throw InsufficientWalletException(
          requiredAmount: (data?['requiredAmount'] as num?)?.toDouble() ?? 0,
          currentBalance: (data?['currentBalance'] as num?)?.toDouble() ?? 0,
          shortfall: (data?['shortfall'] as num?)?.toDouble() ?? 0,
          message: (body is Map ? body['message']?.toString() : null),
        );
      }
    } catch (e) {
      if (e is InsufficientWalletException) rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCallById(String callId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.voiceCallById(callId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.body['data'] ?? {});
      }
    } catch (_) {}
    return null;
  }

  Future<bool> cancel(String callId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.voiceCancel(callId),
        {},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getHistory({
    String? personaId,
    int limit = 20,
    int skip = 0,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    String? status,
  }) async {
    try {
      final query = <String, dynamic>{
        'limit': '$limit',
        'skip': '$skip',
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      };
      if (personaId != null && personaId.isNotEmpty) {
        query['personaId'] = personaId;
      }
      if (status != null && status.isNotEmpty) {
        query['status'] = status;
      }
      final response = await _apiRepository.getApi(
        EndPoints.voiceHistory,
        query: query,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.body['data'] ?? {});
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getStats({String? personaId}) async {
    try {
      final query = <String, dynamic>{};
      if (personaId != null && personaId.isNotEmpty) {
        query['personaId'] = personaId;
      }
      final response = await _apiRepository.getApi(
        EndPoints.voiceStats,
        query: query,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.body['data'] ?? {});
      }
    } catch (_) {}
    return null;
  }
}



