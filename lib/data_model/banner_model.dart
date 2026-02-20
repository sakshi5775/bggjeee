class BannerItem {
  final String id;
  final String? title;
  final String image; // Legacy field for backward compatibility
  final String category;
  final int displayOrder;

  // New media fields
  final String? mediaPrimary;
  final String? mediaPrimaryType; // "image" or "video"
  final String? mediaThumbnail;

  // Media metadata
  final int? mediaSize;
  final int? mediaDuration;
  final int? mediaWidth;
  final int? mediaHeight;

  BannerItem({
    required this.id,
    this.title,
    required this.image,
    required this.category,
    this.displayOrder = 0,
    this.mediaPrimary,
    this.mediaPrimaryType,
    this.mediaThumbnail,
    this.mediaSize,
    this.mediaDuration,
    this.mediaWidth,
    this.mediaHeight,
  });

  /// Check if this banner is a video
  bool get isVideo {
    if (mediaPrimaryType?.toLowerCase() == 'video') return true;
    final url = mediaUrl.toLowerCase();
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.avi') ||
        url.endsWith('.mkv');
  }

  /// Check if this banner is an image
  bool get isImage =>
      mediaPrimaryType?.toLowerCase() == 'image' || mediaPrimaryType == null;

  /// Check if this banner is an SVG
  bool get isSvg {
    final url = mediaUrl.toLowerCase();
    return url.endsWith('.svg');
  }

  /// Get the media URL (prefer new media.primary, fallback to legacy image field)
  String get mediaUrl => mediaPrimary ?? image;

  /// Get thumbnail URL if available, otherwise return primary media URL
  String get thumbnailUrl => mediaThumbnail ?? mediaUrl;

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    // Parse media object
    final media = json['media'] as Map<String, dynamic>?;
    final mediaMetadata = json['mediaMetadata'] as Map<String, dynamic>?;

    final banner = BannerItem(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      title: json['title'] as String?,
      image: json['image'] as String? ?? json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
      // New media fields
      mediaPrimary: media?['primary'] as String?,
      mediaPrimaryType: media?['primaryType'] as String?,
      mediaThumbnail: media?['thumbnail'] as String?,
      // Media metadata
      mediaSize: mediaMetadata?['size'] as int?,
      mediaDuration: mediaMetadata?['duration'] as int?,
      mediaWidth: mediaMetadata?['width'] as int?,
      mediaHeight: mediaMetadata?['height'] as int?,
    );

    // Debug logging
    print('🎬 BannerItem parsed: ${banner.toString()}');

    return banner;
  }

  @override
  String toString() {
    return 'BannerItem(id: $id, type: $mediaPrimaryType, isVideo: $isVideo, isSvg: $isSvg, url: $mediaUrl)';
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
