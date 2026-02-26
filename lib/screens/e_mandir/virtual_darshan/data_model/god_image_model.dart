/// Model for a single god image within a category.
class GodImageModel {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final int displayOrder;

  GodImageModel({
    required this.id,
    required this.imageUrl,
    this.title = '',
    this.description = '',
    this.displayOrder = 0,
  });

  factory GodImageModel.fromJson(Map<String, dynamic> json) {
    return GodImageModel(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
    );
  }
}

/// API response wrapper for god category images.
class GodImagesResponse {
  final bool success;
  final String message;
  final List<GodImageModel> items;
  final GodImagesPagination? pagination;

  GodImagesResponse({
    required this.success,
    required this.message,
    required this.items,
    this.pagination,
  });

  factory GodImagesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return GodImagesResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      items:
          (data?['items'] as List<dynamic>?)
              ?.map((e) => GodImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: data?['pagination'] != null
          ? GodImagesPagination.fromJson(
              data!['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Pagination model for god category images.
class GodImagesPagination {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int limit;

  GodImagesPagination({
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.limit,
  });

  factory GodImagesPagination.fromJson(Map<String, dynamic> json) {
    return GodImagesPagination(
      totalItems: json['totalItems'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
      limit: json['limit'] as int? ?? 20,
    );
  }
}
