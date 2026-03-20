import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/daily_quote_model.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';
import 'package:get/get.dart';

class DailyQuoteService {
  final ApiRepository _apiRepository = Get.find();

  /// Get daily quote
  Future<DailyQuoteResponse?> getDailyQuote({bool useAuthHeader = true}) async {
    final response = await _apiRepository.getApi(
      EndPoints.dailyQuote,
      useAuthHeader: useAuthHeader,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DailyQuoteResponse.fromJson(response.body);
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Failed to load daily quote',
    );
  }

  /// Get available languages for daily quote
  Future<Map<String, dynamic>?> getDailyQuoteLanguages({
    bool useAuthHeader = true,
  }) async {
    final response = await _apiRepository.getApi(
      EndPoints.dailyQuoteLanguages,
      useAuthHeader: useAuthHeader,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body as Map<String, dynamic>?;
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Failed to load daily quote languages',
    );
  }

  /// Get daily quote history
  Future<Map<String, dynamic>?> getDailyQuoteHistory({
    int offset = 0,
    bool useAuthHeader = true,
  }) async {
    final response = await _apiRepository.getApi(
      EndPoints.dailyQuoteHistory(offset: offset),
      query: {'offset': offset},
      useAuthHeader: useAuthHeader,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body as Map<String, dynamic>?;
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Failed to load daily quote history',
    );
  }
}
