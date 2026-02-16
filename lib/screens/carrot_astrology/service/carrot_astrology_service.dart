import 'dart:async';
import 'dart:convert';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/carrot_astrology_model.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';

class CarrotAstrologyService {
  final ApiRepository _apiRepository = Get.find();

  /// Analyze carrot astrology
  Future<CarrotAstrologyData> analyzeCarrotAstrology({
    required String zodiacSign,
    String language = 'english',
    Duration? timeout,
  }) async {
    try {
      final body = {'zodiacSign': zodiacSign};

      final response = await _apiRepository.postApi(
        EndPoints.carrotAstrologyAnalyze,
        body,
        useAuthHeader: true,
        timeout: timeout ?? const Duration(minutes: 5),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        Map<String, dynamic> jsonData;

        // Handle both string and Map responses
        if (responseBody is String) {
          jsonData = json.decode(responseBody);
        } else {
          jsonData = responseBody as Map<String, dynamic>;
        }

        final carrotAstrologyResponse = CarrotAstrologyResponse.fromJson(
          jsonData,
        );

        if (carrotAstrologyResponse.success &&
            carrotAstrologyResponse.data != null) {
          return carrotAstrologyResponse.data!;
        } else {
          throw Exception(
            carrotAstrologyResponse.message.isNotEmpty
                ? carrotAstrologyResponse.message
                : 'Carrot astrology analysis failed',
          );
        }
      } else {
        throw Exception(
          'Failed to analyze carrot astrology: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(ErrorFormatter.formatError(e));
    }
  }

  /// Get carrot astrology history
  Future<CarrotAstrologyHistoryResponse> getCarrotAstrologyHistory({
    int page = 1,
    int limit = 10,
    String? status,
    String? zodiacSign,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (zodiacSign != null && zodiacSign.isNotEmpty) {
        queryParams['zodiacSign'] = zodiacSign;
      }

      final response = await _apiRepository.getApi(
        EndPoints.carrotAstrologyHistory,
        query: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        Map<String, dynamic> jsonData;

        // Handle both string and Map responses
        if (responseBody is String) {
          jsonData = json.decode(responseBody);
        } else {
          jsonData = responseBody as Map<String, dynamic>;
        }

        return CarrotAstrologyHistoryResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to get carrot astrology history: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(ErrorFormatter.formatError(e));
    }
  }

  /// Get carrot astrology statistics
  Future<CarrotAstrologyStats> getCarrotAstrologyStats() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.carrotAstrologyStats,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        Map<String, dynamic> jsonData;

        // Handle both string and Map responses
        if (responseBody is String) {
          jsonData = json.decode(responseBody);
        } else {
          jsonData = responseBody as Map<String, dynamic>;
        }

        final statsResponse = CarrotAstrologyStatsResponse.fromJson(jsonData);

        if (statsResponse.success && statsResponse.data != null) {
          return statsResponse.data!;
        } else {
          throw Exception(
            statsResponse.message.isNotEmpty
                ? statsResponse.message
                : 'Failed to get carrot astrology stats',
          );
        }
      } else {
        throw Exception(
          'Failed to get carrot astrology stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(ErrorFormatter.formatError(e));
    }
  }

  /// Get carrot astrology reading by ID
  Future<CarrotAstrologyData> getCarrotAstrologyById(String readingId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.carrotAstrologyGetById(readingId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        Map<String, dynamic> jsonData;

        // Handle both string and Map responses
        if (responseBody is String) {
          jsonData = json.decode(responseBody);
        } else {
          jsonData = responseBody as Map<String, dynamic>;
        }

        final carrotAstrologyResponse = CarrotAstrologyResponse.fromJson(
          jsonData,
        );

        if (carrotAstrologyResponse.success &&
            carrotAstrologyResponse.data != null) {
          return carrotAstrologyResponse.data!;
        } else {
          throw Exception(
            carrotAstrologyResponse.message.isNotEmpty
                ? carrotAstrologyResponse.message
                : 'Carrot astrology reading not found',
          );
        }
      } else {
        throw Exception(
          'Failed to get carrot astrology reading: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(ErrorFormatter.formatError(e));
    }
  }
}
