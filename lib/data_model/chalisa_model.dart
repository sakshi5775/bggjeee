class ChalisaListResponse {
  final bool success;
  final String message;
  final ChalisaListData? data;

  ChalisaListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ChalisaListResponse.fromJson(Map<String, dynamic> json) {
    return ChalisaListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ChalisaListData.fromJson(json['data'])
          : null,
    );
  }
}

class ChalisaListData {
  final List<ChalisaItem> items;

  ChalisaListData({required this.items});

  factory ChalisaListData.fromJson(Map<String, dynamic> json) {
    return ChalisaListData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ChalisaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ChalisaItem {
  final String id;
  final String title;
  final String slug;
  final ChalisaGodCategory? godCategory;
  final String coverImage;
  final String description;
  final int displayOrder;

  ChalisaItem({
    required this.id,
    required this.title,
    required this.slug,
    this.godCategory,
    required this.coverImage,
    required this.description,
    required this.displayOrder,
  });

  factory ChalisaItem.fromJson(Map<String, dynamic> json) {
    return ChalisaItem(
      id: json['_id'] ?? '',
      // Handles both chalisa ('title') and aarti ('mainTitle')
      title: json['title'] ?? json['mainTitle'] ?? '',
      slug: json['slug'] ?? '',
      godCategory: json['godCategory'] != null
          ? ChalisaGodCategory.fromJson(json['godCategory'])
          : null,
      // Handles both chalisa ('coverImage') and aarti ('thumbnailImage')
      coverImage: json['coverImage'] ?? json['thumbnailImage'] ?? '',
      // Handles both chalisa ('description') and aarti ('startingDoha')
      description: json['description'] ?? json['startingDoha'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}

class ChalisaGodCategory {
  final String id;
  final String godName;
  final String slug;
  final String godImage;

  ChalisaGodCategory({
    required this.id,
    required this.godName,
    required this.slug,
    required this.godImage,
  });

  factory ChalisaGodCategory.fromJson(Map<String, dynamic> json) {
    return ChalisaGodCategory(
      id: json['_id'] ?? '',
      godName: json['godName'] ?? '',
      slug: json['slug'] ?? '',
      godImage: json['godImage'] ?? '',
    );
  }
}
