import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_category_model.dart';
import 'package:get/get.dart';

class GodCategoryService {
  final ApiRepository _apiRepository = Get.find();

  /// Fetch god categories from API
  Future<GodCategoriesResponse?> getGodCategories() async {
    try {
      var queryParameters = {'page': '1', "limit": "10"};
      final response = await _apiRepository.getApi(
        EndPoints.godCategories,
        query: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GodCategoriesResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching god categories: $e');
      return null;
    }
  }
}
