class ChalisaDetailResponse {
  final bool success;
  final String message;
  final ChalisaDetailData? data;

  ChalisaDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ChalisaDetailResponse.fromJson(Map<String, dynamic> json) {
    return ChalisaDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ChalisaDetailData.fromJson(json['data'])
          : null,
    );
  }
}

class ChalisaDetailData {
  final ChalisaDetail? chalisa;

  ChalisaDetailData({this.chalisa});

  factory ChalisaDetailData.fromJson(Map<String, dynamic> json) {
    // Handles both chalisa ('chalisa') and aarti ('aarti') response keys
    final detailJson = json['chalisa'] ?? json['aarti'];
    return ChalisaDetailData(
      chalisa: detailJson != null ? ChalisaDetail.fromJson(detailJson) : null,
    );
  }
}

class ChalisaDetail {
  final String id;
  final String title;
  final String slug;
  final ChalisaDetailGodCategory? godCategory;
  final String coverImage;
  final String description;
  final List<ChalisaSection> sections;

  ChalisaDetail({
    required this.id,
    required this.title,
    required this.slug,
    this.godCategory,
    required this.coverImage,
    required this.description,
    required this.sections,
  });

  factory ChalisaDetail.fromJson(Map<String, dynamic> json) {
    return ChalisaDetail(
      id: json['_id'] ?? '',
      // Handles both chalisa ('title') and aarti ('mainTitle')
      title: json['title'] ?? json['mainTitle'] ?? '',
      slug: json['slug'] ?? '',
      godCategory: json['godCategory'] != null
          ? ChalisaDetailGodCategory.fromJson(json['godCategory'])
          : null,
      // Handles both chalisa ('coverImage') and aarti ('thumbnailImage')
      coverImage: json['coverImage'] ?? json['thumbnailImage'] ?? '',
      description: json['description'] ?? json['startingDoha'] ?? '',
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => ChalisaSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ChalisaDetailGodCategory {
  final String id;
  final String godName;
  final String slug;
  final String godImage;
  final String description;

  ChalisaDetailGodCategory({
    required this.id,
    required this.godName,
    required this.slug,
    required this.godImage,
    required this.description,
  });

  factory ChalisaDetailGodCategory.fromJson(Map<String, dynamic> json) {
    return ChalisaDetailGodCategory(
      id: json['_id'] ?? '',
      godName: json['godName'] ?? '',
      slug: json['slug'] ?? '',
      godImage: json['godImage'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ChalisaSection {
  final String id;
  final String type;
  final String sectionTitle;
  final List<ChalisaVerse> verses;
  final int displayOrder;

  ChalisaSection({
    required this.id,
    required this.type,
    required this.sectionTitle,
    required this.verses,
    required this.displayOrder,
  });

  factory ChalisaSection.fromJson(Map<String, dynamic> json) {
    return ChalisaSection(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      sectionTitle: json['sectionTitle'] ?? '',
      verses:
          (json['verses'] as List<dynamic>?)
              ?.map((e) => ChalisaVerse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}

class ChalisaVerse {
  final String id;
  final String text;
  final int displayOrder;

  ChalisaVerse({
    required this.id,
    required this.text,
    required this.displayOrder,
  });

  factory ChalisaVerse.fromJson(Map<String, dynamic> json) {
    return ChalisaVerse(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}
