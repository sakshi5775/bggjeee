import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/puja_item_category_model.dart';
import 'package:get/get.dart';

class PujaItemCategoryService {
  final ApiRepository _apiRepository = Get.find();

  /// Fetch all puja item categories
  Future<PujaItemCategoriesResponse?> getCategories() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.pujaItemCategories,
        query: {'page': '1', 'limit': '20'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PujaItemCategoriesResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching puja item categories: $e');
      return null;
    }
  }

  /// Fetch category details with items by category ID
  Future<PujaItemCategoryDetailResponse?> getCategoryById(
    String categoryId,
  ) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.pujaItemCategoryById(categoryId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PujaItemCategoryDetailResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching category detail: $e');
      return null;
    }
  }
}
