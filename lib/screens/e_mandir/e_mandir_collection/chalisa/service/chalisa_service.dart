import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/chalisa_model.dart';
import 'package:astrobharataiuser/data_model/chalisa_detail_model.dart';

class ChalisaService {
  final ApiRepository _apiRepository = Get.find();

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
}
