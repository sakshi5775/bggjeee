class DailyWallpaperResponse {
  final bool success;
  final String message;
  final DailyWallpaperData? data;

  DailyWallpaperResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DailyWallpaperResponse.fromJson(Map<String, dynamic> json) {
    return DailyWallpaperResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? DailyWallpaperData.fromJson(json['data'])
          : null,
    );
  }
}

class DailyWallpaperData {
  final String day;
  final GodCategory? godCategory;
  final List<WallpaperItem> wallpapers;

  DailyWallpaperData({
    required this.day,
    this.godCategory,
    required this.wallpapers,
  });

  factory DailyWallpaperData.fromJson(Map<String, dynamic> json) {
    return DailyWallpaperData(
      day: json['day']?.toString() ?? '',
      godCategory: json['godCategory'] != null
          ? GodCategory.fromJson(json['godCategory'])
          : null,
      wallpapers:
          (json['wallpapers'] as List<dynamic>?)
              ?.map((e) {
                if (e is String) return WallpaperItem(imageUrl: e);
                if (e is Map<String, dynamic>) return WallpaperItem.fromJson(e);
                return WallpaperItem(imageUrl: '');
              })
              .where((w) => w.imageUrl.isNotEmpty)
              .toList() ??
          [],
    );
  }
}

class GodCategory {
  final String id;
  final String godName;
  final String slug;
  final String godImage;
  final String description;

  GodCategory({
    required this.id,
    required this.godName,
    required this.slug,
    required this.godImage,
    required this.description,
  });

  factory GodCategory.fromJson(Map<String, dynamic> json) {
    return GodCategory(
      id: json['_id']?.toString() ?? '',
      godName: json['godName']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      godImage: json['godImage']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

class WallpaperItem {
  final String id;
  final String imageUrl;

  WallpaperItem({this.id = '', required this.imageUrl});

  factory WallpaperItem.fromJson(Map<String, dynamic> json) {
    return WallpaperItem(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
    );
  }
}
