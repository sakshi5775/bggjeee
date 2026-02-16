/// Festival model for the sri-mandir festivals API.
class FestivalModel {
  final String id;
  final String title;
  final String slug;
  final String image;
  final String shortDescription;
  final String longDescription;
  final int displayOrder;
  final bool isActive;
  final bool isUpcoming;

  FestivalModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.shortDescription,
    required this.longDescription,
    this.displayOrder = 0,
    this.isActive = true,
    this.isUpcoming = false,
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) {
    return FestivalModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      shortDescription: json['shortDescription']?.toString() ?? '',
      longDescription: json['longDescription']?.toString() ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isUpcoming: json['isUpcoming'] as bool? ?? false,
    );
  }
}

/// API response wrapper for festivals.
class FestivalsResponse {
  final bool success;
  final String message;
  final List<FestivalModel> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  FestivalsResponse({
    required this.success,
    required this.message,
    required this.items,
    this.totalItems = 0,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasNextPage = false,
  });

  factory FestivalsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final pagination = data?['pagination'] as Map<String, dynamic>?;

    return FestivalsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      items:
          (data?['items'] as List<dynamic>?)
              ?.map((e) => FestivalModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: pagination?['totalItems'] as int? ?? 0,
      currentPage: pagination?['currentPage'] as int? ?? 1,
      totalPages: pagination?['totalPages'] as int? ?? 1,
      hasNextPage: pagination?['hasNextPage'] as bool? ?? false,
    );
  }
}
