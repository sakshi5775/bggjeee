class DevotionalMusicResponse {
  final bool success;
  final String message;
  final DevotionalMusicData? data;

  DevotionalMusicResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DevotionalMusicResponse.fromJson(Map<String, dynamic> json) {
    return DevotionalMusicResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? DevotionalMusicData.fromJson(json['data'])
          : null,
    );
  }
}

class DevotionalMusicData {
  final List<DevotionalMusicItem> items;

  DevotionalMusicData({required this.items});

  factory DevotionalMusicData.fromJson(Map<String, dynamic> json) {
    return DevotionalMusicData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => DevotionalMusicItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class DevotionalMusicItem {
  final String id;
  final String title;
  final String slug;
  final DevotionalMusicGodCategory? godCategory;
  final String musicCategory;
  final String audioUrl;
  final String thumbnailUrl;
  final int duration; // in seconds
  final String description;
  final String artist;
  final String language;
  final int displayOrder;

  DevotionalMusicItem({
    required this.id,
    required this.title,
    required this.slug,
    this.godCategory,
    required this.musicCategory,
    required this.audioUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.description,
    required this.artist,
    required this.language,
    required this.displayOrder,
  });

  factory DevotionalMusicItem.fromJson(Map<String, dynamic> json) {
    return DevotionalMusicItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      godCategory: json['godCategory'] != null
          ? DevotionalMusicGodCategory.fromJson(json['godCategory'])
          : null,
      musicCategory: json['musicCategory'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      duration: json['duration'] ?? 0,
      description: json['description'] ?? '',
      artist: json['artist'] ?? '',
      language: json['language'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  /// Format duration as m:ss
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class DevotionalMusicGodCategory {
  final String id;
  final String godName;
  final String slug;
  final String godImage;

  DevotionalMusicGodCategory({
    required this.id,
    required this.godName,
    required this.slug,
    required this.godImage,
  });

  factory DevotionalMusicGodCategory.fromJson(Map<String, dynamic> json) {
    return DevotionalMusicGodCategory(
      id: json['_id'] ?? '',
      godName: json['godName'] ?? '',
      slug: json['slug'] ?? '',
      godImage: json['godImage'] ?? '',
    );
  }
}
