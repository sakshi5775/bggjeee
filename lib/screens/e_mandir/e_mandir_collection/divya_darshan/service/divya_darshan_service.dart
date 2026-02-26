import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/divya_darshan/data_model/divya_darshan_model.dart';
import 'package:get/get.dart';

class DivyaDarshanService {
  final ApiRepository _apiRepository = Get.find();

  Future<DivyaDarshanResponse?> getDivyaDarshanItems() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.divyaDarshan);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DivyaDarshanResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching divya darshan items: $e');
      return null;
    }
  }
}
