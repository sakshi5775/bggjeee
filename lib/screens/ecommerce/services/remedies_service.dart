import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:get/get.dart';

class RemediesService extends GetxService {
  final ApiRepository _apiRepository = Get.find<ApiRepository>();

  // Fetch Store Categories (using existing categories API)
  Future<List<CategoryModel>> getStoreCategories() async {
    try {
      final response = await _apiRepository.getApi(
        'ecommerce/api/categories',
        query: {
          'page': '1',
          'limit': '10',
          'isActive': 'true',
          'isFeatured': 'true',
        },
      );

      if (response.status.hasError) {
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        // Check if data has 'items' or is a list directly.
        // Based on typical pagination in this app it might be data['items'] or just data as list.
        // CategoryModel structure usually implies a list here.
        // Retaining assumption from previous code or adapting to standard response.

        List itemsList = [];
        if (data is Map && data.containsKey('items')) {
          itemsList = data['items'];
        } else if (data is List) {
          itemsList = data;
        }

        return itemsList.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching store categories: $e");
      return [];
    }
  }

  // Fetch Remedy Categories
  Future<RemedyCategoryData?> getRemedyCategories({
    int page = 1,
    int limit = 20,
    String? searchQuery,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await _apiRepository.getApi(
        'ecommerce/api/remedy-categories',
        query: queryParams,
      );

      if (response.status.hasError) {
        return null;
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        // Assuming RemedyCategoryData expects the 'data' map which contains 'items', 'pagination' etc.
        return RemedyCategoryData.fromJson(response.body['data']);
      }
      return null;
    } catch (e) {
      print("Error fetching remedy categories: $e");
      return null;
    }
  }

  // Fetch Remedies by Category
  Future<List<RemedyModel>> getRemediesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        'ecommerce/api/remedy-services/category/$categoryId',
        query: {'page': page.toString(), 'limit': limit.toString()},
      );

      if (response.status.hasError) {
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        // The API returns { data: { items: [...], pagination: {...} } }
        // We can just parse the items list directly if that's all we need so far,
        // or parse the whole object if we need pagination metadata.
        // Based on the user's snippet, it returns standard pagination structure.
        final data = response.body['data'];
        List itemsList = [];
        if (data is Map && data.containsKey('items')) {
          itemsList = data['items'];
        }

        return itemsList.map((e) => RemedyModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching remedies by category: $e");
      return [];
    }
  }
}
