class SpecialBhogResponse {
  final bool success;
  final String message;
  final SpecialBhogData? data;

  SpecialBhogResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SpecialBhogResponse.fromJson(Map<String, dynamic> json) {
    return SpecialBhogResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SpecialBhogData.fromJson(json['data'])
          : null,
    );
  }
}

class SpecialBhogData {
  final String day;
  final BhogGodCategory? godCategory;
  final List<BhogItem> bhogs;
  final int total;

  SpecialBhogData({
    required this.day,
    this.godCategory,
    required this.bhogs,
    required this.total,
  });

  factory SpecialBhogData.fromJson(Map<String, dynamic> json) {
    return SpecialBhogData(
      day: json['day'] ?? '',
      godCategory: json['godCategory'] != null
          ? BhogGodCategory.fromJson(json['godCategory'])
          : null,
      bhogs:
          (json['bhogs'] as List<dynamic>?)
              ?.map((e) => BhogItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}

class BhogGodCategory {
  final String id;
  final String godName;
  final String slug;
  final String godImage;
  final String godThumbnail;

  BhogGodCategory({
    required this.id,
    required this.godName,
    required this.slug,
    required this.godImage,
    required this.godThumbnail,
  });

  factory BhogGodCategory.fromJson(Map<String, dynamic> json) {
    return BhogGodCategory(
      id: json['_id'] ?? '',
      godName: json['godName'] ?? '',
      slug: json['slug'] ?? '',
      godImage: json['godImage'] ?? '',
      godThumbnail: json['godThumbnail'] ?? '',
    );
  }
}

class BhogItem {
  final String id;
  final String bhogName;
  final int coin;
  final String image;
  final String thumbnail;
  final String description;

  BhogItem({
    required this.id,
    required this.bhogName,
    required this.coin,
    required this.image,
    required this.thumbnail,
    required this.description,
  });

  factory BhogItem.fromJson(Map<String, dynamic> json) {
    return BhogItem(
      id: json['_id'] ?? '',
      bhogName: json['bhogName'] ?? '',
      coin: json['coin'] ?? 0,
      image: json['image'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
