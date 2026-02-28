/// God Category model for API response
class GodCategoryModel {
  final String id;
  final String godName;
  final String slug;
  final String godImage;
  final String? thumbnailImage;
  final String? description;
  final int displayOrder;
  final bool? isToday;

  GodCategoryModel({
    required this.id,
    required this.godName,
    required this.slug,
    required this.godImage,
    this.description,
    this.displayOrder = 0,
    this.thumbnailImage,
    this.isToday,
  });

  factory GodCategoryModel.fromJson(Map<String, dynamic> json) {
    return GodCategoryModel(
      id: json['_id']?.toString() ?? '',
      godName: json['godName']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      godImage: json['godImage']?.toString() ?? '',
      description: json['description']?.toString(),
      displayOrder: json['displayOrder'] as int? ?? 0,
      thumbnailImage: json['godThumbnail']?.toString(),
      isToday: json['isTodayGod'] as bool? ?? false,
    );
  }
}

/// God Categories API Response
class GodCategoriesResponse {
  final bool success;
  final String message;
  final List<GodCategoryModel> items;
  final GodCategoriesPagination? pagination;

  GodCategoriesResponse({
    required this.success,
    required this.message,
    required this.items,
    this.pagination,
  });

  factory GodCategoriesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return GodCategoriesResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      items:
          (data?['items'] as List<dynamic>?)
              ?.map((e) => GodCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: data?['pagination'] != null
          ? GodCategoriesPagination.fromJson(
              data!['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Pagination model for god categories
class GodCategoriesPagination {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int limit;

  GodCategoriesPagination({
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.limit,
  });

  factory GodCategoriesPagination.fromJson(Map<String, dynamic> json) {
    return GodCategoriesPagination(
      totalItems: json['totalItems'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
      limit: json['limit'] as int? ?? 10,
    );
  }
}
