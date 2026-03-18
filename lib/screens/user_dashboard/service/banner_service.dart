import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:get/get.dart';

class BannerService {
  final ApiRepository _apiRepository = Get.find();

  /// Get a single banner by ID
  Future<BannerItem?> getBannerById(String id) async {
    final response = await _apiRepository.getApi(
      EndPoints.bannerById(id),
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body is Map<String, dynamic>) {
        return SingleBannerResponse.fromJson(body).banner;
      }
    }
    return null;
  }

  /// Try each category in order and return the first non-empty result.
  /// Always ends with [appgeneral, apphomescreen] so every screen gets banners.
  Future<List<BannerItem>> getBannersWithFallback(List<String> categories) async {
    final fullChain = [
      ...categories,
      'appgeneral',
      'apphomescreen',
    ];
    for (final cat in fullChain) {
      final list = await getBannersByCategory(cat);
      if (list.isNotEmpty) return list;
    }
    return [];
  }

  /// Get banners for a category (e.g. "home" for home screen ads).
  /// Returns an empty list when the category has no banners or the request fails,
  /// so callers can safely chain fallback categories without try/catch.
  Future<List<BannerItem>> getBannersByCategory(String category) async {
    try {
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
    } catch (_) {
      // Network error or parse failure — treat as empty so fallback can proceed
    }
    return [];
  }

  /// Get all banners; prefer "home" category, else merge all categories for home screen.
  /// Returns an empty list on failure instead of throwing.
  Future<List<BannerItem>> getHomeBanners() async {
    try {
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
    } catch (_) {
      // Network error or parse failure
    }
    return [];
  }
}
