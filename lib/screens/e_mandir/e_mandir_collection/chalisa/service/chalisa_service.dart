import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/chalisa_model.dart';
import 'package:astrobharataiuser/data_model/chalisa_detail_model.dart';

class ChalisaService {
  final ApiRepository _apiRepository = Get.find();

  /// Fetch list of chalisas
  Future<ChalisaListResponse?> getChalisas() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.chalisas);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChalisaListResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching chalisas: $e');
      return null;
    }
  }

  /// Fetch chalisa detail by ID
  Future<ChalisaDetailResponse?> getChalisaById(String id) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.chalisaById(id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChalisaDetailResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching chalisa detail: $e');
      return null;
    }
  }

  /// Fetch list of aartis (same model as chalisa)
  Future<ChalisaListResponse?> getAartis() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.aartis);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChalisaListResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching aartis: $e');
      return null;
    }
  }

  /// Fetch aarti detail by ID (same model as chalisa detail)
  Future<ChalisaDetailResponse?> getAartiById(String id) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.aartiById(id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChalisaDetailResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching aarti detail: $e');
      return null;
    }
  }
}
