import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/daily_quote_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data_model/user_profile_model.dart';

class DailyQuoteService {
  final ApiRepository _apiRepository = Get.find();

  /// Get daily quote
  Future<DailyQuoteResponse?> getDailyQuote({bool useAuthHeader = true}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.dailyQuote,
        useAuthHeader: useAuthHeader,
      );

      if (kDebugMode) {
        debugPrint('Daily Quote API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return DailyQuoteResponse.fromJson(response.body);
        } catch (e) {
          debugPrint('Error parsing DailyQuoteResponse: $e');
          debugPrint('Response body: ${response.body}');
          return null;
        }
      }
      debugPrint(
        'Daily Quote API returned status code: ${response.statusCode}',
      );
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Daily Quote: $e');
      }
      return null;
    }
  }

  /// Get available languages for daily quote
  Future<Map<String, dynamic>?> getDailyQuoteLanguages({
    bool useAuthHeader = true,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.dailyQuoteLanguages,
        useAuthHeader: useAuthHeader,
      );

      if (kDebugMode) {
        debugPrint('Daily Quote Languages API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body as Map<String, dynamic>?;
      }
      debugPrint(
        'Daily Quote Languages API returned status code: ${response.statusCode}',
      );
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Daily Quote Languages: $e');
      }
      return null;
    }
  }

  /// Get daily quote history
  Future<Map<String, dynamic>?> getDailyQuoteHistory({
    int offset = 0,
    bool useAuthHeader = true,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.dailyQuoteHistory(offset: offset),
        query: {'offset': offset},
        useAuthHeader: useAuthHeader,
      );

      if (kDebugMode) {
        debugPrint('Daily Quote History API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body as Map<String, dynamic>?;
      }
      debugPrint(
        'Daily Quote History API returned status code: ${response.statusCode}',
      );
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Daily Quote History: $e');
      }
      return null;
    }
  }
}
