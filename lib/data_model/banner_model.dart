class BannerItem {
  final String id;
  final String? title;
  final String image;
  final String category;
  final int displayOrder;

  BannerItem({
    required this.id,
    this.title,
    required this.image,
    required this.category,
    this.displayOrder = 0,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      title: json['title'] as String?,
      image: json['image'] as String? ?? '',
      category: json['category'] as String? ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
    );
  }
}

class BannersByCategoryResponse {
  final bool success;
  final String message;
  final List<BannerItem> banners;

  BannersByCategoryResponse({
    required this.success,
    required this.message,
    required this.banners,
  });

  factory BannersByCategoryResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final list = data?['banners'] as List<dynamic>? ?? [];
    return BannersByCategoryResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      banners: list
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BannersAllResponse {
  final bool success;
  final String message;
  final Map<String, List<BannerItem>> bannersByCategory;
  final int totalCount;

  BannersAllResponse({
    required this.success,
    required this.message,
    required this.bannersByCategory,
    required this.totalCount,
  });

  factory BannersAllResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final bannersMap = data?['banners'] as Map<String, dynamic>? ?? {};
    final Map<String, List<BannerItem>> byCategory = {};
    for (final entry in bannersMap.entries) {
      final list = entry.value as List<dynamic>? ?? [];
      byCategory[entry.key] = list
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return BannersAllResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      bannersByCategory: byCategory,
      totalCount: data?['totalCount'] as int? ?? 0,
    );
  }
}
