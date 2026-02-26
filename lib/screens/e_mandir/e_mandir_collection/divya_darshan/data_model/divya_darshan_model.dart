class DivyaDarshanResponse {
  final bool success;
  final String message;
  final List<DivyaDarshanItem> items;

  DivyaDarshanResponse({
    required this.success,
    required this.message,
    required this.items,
  });

  factory DivyaDarshanResponse.fromJson(Map<String, dynamic> json) {
    return DivyaDarshanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      items: json['data']?['items'] != null
          ? List<DivyaDarshanItem>.from(
              json['data']['items'].map((x) => DivyaDarshanItem.fromJson(x)),
            )
          : [],
    );
  }
}

class DivyaDarshanItem {
  final String id;
  final LocalizedText title;
  final LocalizedText subtitle;
  final String mediaType;
  final String mediaUrl;
  final String thumbnailUrl;
  final DivyaDarshanGodCategory? godCategory;

  DivyaDarshanItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.mediaType,
    required this.mediaUrl,
    required this.thumbnailUrl,
    this.godCategory,
  });

  factory DivyaDarshanItem.fromJson(Map<String, dynamic> json) {
    return DivyaDarshanItem(
      id: json['_id'] ?? '',
      title: LocalizedText.fromJson(json['title'] ?? {}),
      subtitle: LocalizedText.fromJson(json['subtitle'] ?? {}),
      mediaType: json['mediaType'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      godCategory: json['godCategory'] != null
          ? DivyaDarshanGodCategory.fromJson(json['godCategory'])
          : null,
    );
  }
}

class DivyaDarshanGodCategory {
  final String godName;
  final String godId;
  final String godImageUrl;

  DivyaDarshanGodCategory({
    required this.godName,
    required this.godId,
    required this.godImageUrl,
  });

  factory DivyaDarshanGodCategory.fromJson(Map<String, dynamic> json) {
    return DivyaDarshanGodCategory(
      godName: json['godName'] ?? '',
      godId: json['godId'] ?? '',
      godImageUrl: json['godImageUrl'] ?? '',
    );
  }
}

class LocalizedText {
  final String en;
  final String hi;

  LocalizedText({required this.en, required this.hi});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(en: json['en'] ?? '', hi: json['hi'] ?? '');
  }
}
