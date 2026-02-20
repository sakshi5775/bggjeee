import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/e_mandir_dataModels/e_mandir_home_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';

class EMandirHomeService with ApiHelperMixin {
  final ApiRepository _apiRepository = ApiRepository(apiClient: Get.find());

  Future<EMandirHomeDataModel?> punyaWallet() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.sriMandirPunya);

      final data = response.body['data'];

      return EMandirHomeDataModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Fetch all festivals from the API.
  Future<FestivalsResponse?> getFestivals() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.sriMandirFestivals,
      );
      if (response.body != null) {
        return FestivalsResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // /// daily checkin api .
  // Future<bool> dailyCheckIn() async {
  //   try {
  //     final response = await _apiRepository.postApi(
  //       EndPoints.sriMandirDailyCheckIn,
  //       {},
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
