import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavtaraService with ApiHelperMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Get list of 27 Nakshatras
  Future<List<Nakshatra>> getNakshatras() async {
    final response = await _apiClient.getApi(EndPoints.navtaraNakshatras);
    if (response.body['success'] == true && response.body['data'] is List) {
      return (response.body['data'] as List)
          .map((e) => Nakshatra.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Analyze personal transit predictions
  Future<NavtaraAnalysis?> analyzeNavtara({
    required String janmaNakshatra,
    String analysisType = 'GENERAL',
    String? currentDate,
    String? question,
    String? language,
    String? name,
    String? dateOfBirth,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'janmaNakshatra': janmaNakshatra,
        'analysisType': analysisType,
      };
      if (currentDate != null) body['currentDate'] = currentDate;
      if (question != null) body['question'] = question;
      if (language != null) body['language'] = language;
      if (name != null) body['name'] = name;
      if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;

      debugPrint('Navtara Analyze Request: $body');
      debugPrint('Navtara Analyze URL: ${EndPoints.navtaraAnalyze}');

      final response = await _apiClient
          .postApi(EndPoints.navtaraAnalyze, body)
          .timeout(const Duration(seconds: 60));
      debugPrint('Navtara Analyze Response Code: ${response.statusCode}');
      debugPrint('Navtara Analyze Response Body: ${response.body}');

      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return NavtaraAnalysis.fromJson(response.body['data']);
      }
    } catch (e, stack) {
      debugPrint('Error in analyzeNavtara service: $e');
      debugPrint(stack.toString());
    }
    return null;
  }

  /// Check compatibility between two individuals
  Future<NavtaraCompatibility?> checkCompatibility({
    required String nakshatra1,
    required String nakshatra2,
    String? name1,
    String? name2,
    String relationshipType = 'ROMANTIC',
    String? language,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'person1': {'name': name1 ?? 'Person 1', 'janmaNakshatra': nakshatra1},
        'person2': {'name': name2 ?? 'Person 2', 'janmaNakshatra': nakshatra2},
        'relationshipType': relationshipType,
      };
      if (language != null) body['language'] = language;

      debugPrint('Navtara Compatibility Request: $body');
      debugPrint(
        'Navtara Compatibility URL: ${EndPoints.navtaraCompatibility}',
      );

      final response = await _apiClient
          .postApi(EndPoints.navtaraCompatibility, body)
          .timeout(const Duration(seconds: 60));
      debugPrint('Navtara Compatibility Response Code: ${response.statusCode}');
      debugPrint('Navtara Compatibility Response Body: ${response.body}');

      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return NavtaraCompatibility.fromJson(response.body['data']);
      }
    } catch (e, stack) {
      debugPrint('Error in checkCompatibility service: $e');
      debugPrint(stack.toString());
    }
    return null;
  }

  /// Find auspicious timing for activities
  Future<NavtaraTiming?> findTiming({
    required String janmaNakshatra,
    required String activityType,
    required String startDate, // Expected as YYYY-MM-DD
    required String endDate, // Expected as YYYY-MM-DD
    String? language,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'janmaNakshatra': janmaNakshatra,
        'activityType': activityType,
        'dateRange': {'startDate': startDate, 'endDate': endDate},
      };
      if (language != null) body['language'] = language;

      debugPrint('Navtara Timing Request: $body');
      debugPrint('Navtara Timing URL: ${EndPoints.navtaraTiming}');

      final response = await _apiClient
          .postApi(EndPoints.navtaraTiming, body)
          .timeout(const Duration(seconds: 60));
      debugPrint('Navtara Timing Response Code: ${response.statusCode}');
      debugPrint('Navtara Timing Response Body: ${response.body}');

      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return NavtaraTiming.fromJson(response.body['data']);
      }
    } catch (e, stack) {
      debugPrint('Error in findTiming service: $e');
      debugPrint(stack.toString());
    }
    return null;
  }

  /// Get reading history with optional filters
  Future<List<dynamic>> getHistory({
    String? status,
    String? analysisType,
  }) async {
    final Map<String, dynamic> query = {};
    if (status != null) query['status'] = status;
    if (analysisType != null) query['analysisType'] = analysisType;

    final response = await _apiClient.getApi(
      EndPoints.navtaraHistory,
      query: query,
    );
    if (response.body['success'] == true && response.body['data'] is List) {
      return response.body['data'];
    }
    return [];
  }

  /// Get user statistics
  Future<NavtaraStats?> getStats() async {
    final response = await _apiClient.getApi(EndPoints.navtaraStats);
    if (response.body['success'] == true &&
        response.body['data'] is Map<String, dynamic>) {
      return NavtaraStats.fromJson(response.body['data']);
    }
    return null;
  }

  /// Get specific reading by ID
  Future<dynamic> getReadingById(String readingId) async {
    final response = await _apiClient.getApi(
      EndPoints.navtaraReadingById(readingId),
    );
    if (response.body['success'] == true) {
      return response.body['data'];
    }
    return null;
  }

  /// Delete a reading
  Future<bool> deleteReading(String readingId) async {
    final response = await _apiClient.deleteRequest(
      EndPoints.navtaraReadingById(readingId),
      null,
    );
    return response.body['success'] == true;
  }
}
