import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BannerService {
  final ApiRepository _apiRepository = Get.find();

  /// Get banners for a category (e.g. "home" for home screen ads)
  Future<List<BannerItem>> getBannersByCategory(String category) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.bannersByCategory(category),
        useAuthHeader: false,
      );

      if (kDebugMode) {
        debugPrint('Banners API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final body = response.body;
          if (body is Map<String, dynamic>) {
            final parsed = BannersByCategoryResponse.fromJson(body);
            final list = parsed.banners
              ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
            return list;
          }
        } catch (e) {
          debugPrint('Error parsing BannersByCategoryResponse: $e');
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching banners: $e');
      }
      return [];
    }
  }

  /// Get all banners; prefer "home" category, else merge all categories for home screen
  Future<List<BannerItem>> getHomeBanners() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.bannersAll,
        useAuthHeader: false,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return [];
      }
      try {
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
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error parsing BannersAllResponse: $e');
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching all banners: $e');
      }
      return [];
    }
  }
}
