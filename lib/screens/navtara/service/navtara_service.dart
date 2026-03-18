import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/utils/port_fallback_helper.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/utils/nakshatra_name_normalizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavtaraService with ApiHelperMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Last error message from compatibility API (500 or success: false) for UI to show
  static String? lastCompatibilityErrorMessage;

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
    Duration? timeout,
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

      final response = await _apiClient.postApi(
        EndPoints.navtaraAnalyze,
        body,
        // timeout: timeout ?? const Duration(minutes: 5),
      );
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
  /// Uses port 8002 directly (similar to matchmaking profile API)
  Future<NavtaraCompatibility?> checkCompatibility({
    required String nakshatra1,
    required String nakshatra2,
    String? name1,
    String? name2,
    String relationshipType = 'ROMANTIC',
    String? language,
    Duration? timeout,
  }) async {
    try {
      // Try 8000/api/users first, fallback to 8002
      const String navtaraPath = '/api/users/navtara/compatibility';

      // Normalize nakshatra names to API-expected format
      final normalizedNakshatra1 = NakshatraNameNormalizer.normalize(nakshatra1);
      final normalizedNakshatra2 = NakshatraNameNormalizer.normalize(nakshatra2);

      debugPrint('Original nakshatras: $nakshatra1, $nakshatra2');
      debugPrint('Normalized nakshatras: $normalizedNakshatra1, $normalizedNakshatra2');

      final Map<String, dynamic> body = {
        'person1': {'name': name1 ?? 'Person 1', 'janmaNakshatra': normalizedNakshatra1},
        'person2': {'name': name2 ?? 'Person 2', 'janmaNakshatra': normalizedNakshatra2},
        'relationshipType': relationshipType,
      };
      if (language != null) body['language'] = language;

      debugPrint('Navtara Compatibility Request: $body');

      // Get authorization token
      final currentToken = UserData().accessToken?.trim();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (currentToken != null && currentToken.isNotEmpty)
          'Authorization': 'Bearer $currentToken',
      };
      final encodedBody = json.encode(body);
      // Backend typically takes 2–3 minutes; use a long timeout so the request is not cut off
      final effectiveTimeout = timeout ?? const Duration(minutes: 5);

      debugPrint('Navtara Compatibility URL (primary): ${PortFallbackHelper.usersApiPrimary}$navtaraPath');

      final response = await PortFallbackHelper.callWithFallback(
        primary: () => http
            .post(Uri.parse('${PortFallbackHelper.usersApiPrimary}$navtaraPath'),
                headers: headers, body: encodedBody)
            .timeout(effectiveTimeout, onTimeout: () {
          lastCompatibilityErrorMessage =
              'The analysis is taking longer than expected. Please try again.';
          throw Exception('Request timeout');
        }),
        fallback: () => http
            .post(Uri.parse('${PortFallbackHelper.usersApiFallback}$navtaraPath'),
                headers: headers, body: encodedBody)
            .timeout(effectiveTimeout, onTimeout: () {
          lastCompatibilityErrorMessage =
              'The analysis is taking longer than expected. Please try again.';
          throw Exception('Request timeout');
        }),
      );

      debugPrint('Navtara Compatibility Response Code: ${response.statusCode}');
      debugPrint('Navtara Compatibility Response Body: ${response.body}');

      Map<String, dynamic>? jsonData;
      try {
        final decoded = json.decode(response.body);
        jsonData = decoded is Map ? Map<String, dynamic>.from(decoded) : null;
      } catch (_) {
        jsonData = null;
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonData != null &&
            jsonData['success'] == true &&
            jsonData['data'] is Map<String, dynamic>) {
          try {
            lastCompatibilityErrorMessage = null;
            return NavtaraCompatibility.fromJson(
              jsonData['data'] as Map<String, dynamic>,
            );
          } catch (parseError, parseStack) {
            debugPrint('Error parsing Navtara compatibility response: $parseError');
            debugPrint(parseStack.toString());
            lastCompatibilityErrorMessage =
                'Failed to parse compatibility result. Please try again.';
          }
        } else {
          lastCompatibilityErrorMessage = (jsonData?['message'] as String?) ??
              'Failed to generate compatibility analysis. Please try again.';
        }
      } else {
        lastCompatibilityErrorMessage = (jsonData?['message'] as String?) ??
            'Failed to generate compatibility analysis. Please try again.';
      }
    } catch (e, stack) {
      debugPrint('Error in checkCompatibility service: $e');
      debugPrint(stack.toString());
      lastCompatibilityErrorMessage =
          'Network or server error. Please try again.';
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
    Duration? timeout,
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

      final response = await _apiClient.postApi(
        EndPoints.navtaraTiming,
        body,
        // timeout: timeout ?? const Duration(minutes: 5),
      );
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
