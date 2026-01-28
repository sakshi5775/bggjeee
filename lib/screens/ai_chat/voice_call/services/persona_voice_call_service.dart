import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:get/get.dart';

class VoiceCallService {
  final ApiRepository _apiRepository = Get.find();

  Future<Map<String, dynamic>?> initiateCall({
    required String personaId,
    String platform = 'web',
    String? language,
  }) async {
    try {
      final body = <String, dynamic>{
        'platform': platform,
      };
      
      // Add language if provided
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
    } catch (_) {}
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



