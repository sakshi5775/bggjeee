import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/prashna_kundali_model.dart';
import 'package:get/get.dart';

class PrashnaKundaliService {
  final ApiRepository _apiRepository = Get.find();

  Future<List<PrashnaQuestion>> getQuestions() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.prashnaKundaliQuestions,
      );
      if (response.statusCode == 200) {
        final List data = response.body['data'];
        return data.map((json) => PrashnaQuestion.fromJson(json)).toList();
      }
      throw Exception(response.body?['message'] ?? 'Failed to load questions');
    } catch (e) {
      rethrow;
    }
  }

  Future<PrashnaReading> analyzePrashna(PrashnaAnalysisRequest request) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.prashnaKundaliAnalyze,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PrashnaReading.fromJson(response.body['data']);
      }
      throw Exception(response.body?['message'] ?? 'Analysis failed');
    } catch (e) {
      rethrow;
    }
  }

  Future<PrashnaHistoryResponse> getHistory({int page = 1}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.prashnaKundaliHistory,
        query: {'page': page.toString()},
      );

      if (response.statusCode == 200) {
        return PrashnaHistoryResponse.fromJson(response.body);
      }
      throw Exception(response.body?['message'] ?? 'Failed to load history');
    } catch (e) {
      rethrow;
    }
  }

  Future<PrashnaReading> getReadingById(String id) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.prashnaKundaliGetById(id),
      );

      if (response.statusCode == 200) {
        return PrashnaReading.fromJson(response.body['data']);
      }
      throw Exception(response.body?['message'] ?? 'Failed to load reading');
    } catch (e) {
      rethrow;
    }
  }
}
