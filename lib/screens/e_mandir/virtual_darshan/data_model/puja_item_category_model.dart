/// Puja Item Category model for API response
class PujaItemCategory {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? image;
  final String? icon;
  final int displayOrder;
  final bool isActive;

  PujaItemCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.image,
    this.icon,
    this.displayOrder = 0,
    this.isActive = true,
  });

  factory PujaItemCategory.fromJson(Map<String, dynamic> json) {
    return PujaItemCategory(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      icon: json['icon']?.toString(),
      displayOrder: json['displayOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Puja Item Categories list response
class PujaItemCategoriesResponse {
  final bool success;
  final String message;
  final List<PujaItemCategory> items;

  PujaItemCategoriesResponse({
    required this.success,
    required this.message,
    required this.items,
  });

  factory PujaItemCategoriesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return PujaItemCategoriesResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      items:
          (data?['items'] as List<dynamic>?)
              ?.map((e) => PujaItemCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Single Puja Item (used inside a category)
class PujaItem {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String? image;
  final int displayOrder;
  final bool isPopular;
  final bool isFeatured;
  final int? coin;

  PujaItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.image,
    this.displayOrder = 0,
    this.isPopular = false,
    this.isFeatured = false,
    this.coin,
  });

  factory PujaItem.fromJson(Map<String, dynamic> json) {
    return PujaItem(
      id: json['_id']?.toString() ?? '',
      categoryId: json['category']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString(),
      displayOrder: json['displayOrder'] as int? ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      coin: json['coin'] as int? ?? 0,
    );
  }
}

/// Category detail with items response
class PujaItemCategoryDetailResponse {
  final bool success;
  final String message;
  final PujaItemCategoryDetail? category;

  PujaItemCategoryDetailResponse({
    required this.success,
    required this.message,
    this.category,
  });

  factory PujaItemCategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return PujaItemCategoryDetailResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      category: data?['category'] != null
          ? PujaItemCategoryDetail.fromJson(
              data!['category'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Category detail with its items
class PujaItemCategoryDetail {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? image;
  final String? icon;
  final int displayOrder;
  final bool isActive;
  final List<PujaItem> items;

  PujaItemCategoryDetail({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.image,
    this.icon,
    this.displayOrder = 0,
    this.isActive = true,
    required this.items,
  });

  factory PujaItemCategoryDetail.fromJson(Map<String, dynamic> json) {
    return PujaItemCategoryDetail(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      icon: json['icon']?.toString(),
      displayOrder: json['displayOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PujaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
