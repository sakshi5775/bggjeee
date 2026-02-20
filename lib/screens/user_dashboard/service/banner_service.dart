import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:get/get.dart';

class BannerService {
  final ApiRepository _apiRepository = Get.find();

  /// Get banners for a category (e.g. "home" for home screen ads)
  Future<List<BannerItem>> getBannersByCategory(String category) async {
    final response = await _apiRepository.getApi(
      EndPoints.bannersByCategory(category),
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body is Map<String, dynamic>) {
        final parsed = BannersByCategoryResponse.fromJson(body);
        final list = parsed.banners
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        return list;
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to load banners';
  }

  /// Get all banners; prefer "home" category, else merge all categories for home screen
  Future<List<BannerItem>> getHomeBanners() async {
    final response = await _apiRepository.getApi(
      EndPoints.bannersAll,
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body is Map<String, dynamic>) {
        final parsed = BannersAllResponse.fromJson(body);
        var list = parsed.bannersByCategory['home'] ?? [];
        if (list.isEmpty) {
          for (final categoryList in parsed.bannersByCategory.values) {
            list = [...list, ...categoryList];
          }
          list.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        } else {
          list.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        }
        return list;
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to load home banners';
  }
}
