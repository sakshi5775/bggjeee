class DailyThoughtResponse {
  final bool success;
  final String message;
  final DailyThoughtData? data;

  DailyThoughtResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DailyThoughtResponse.fromJson(Map<String, dynamic> json) {
    return DailyThoughtResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? DailyThoughtData.fromJson(json['data'])
          : null,
    );
  }
}

class DailyThoughtData {
  final List<DailyThoughtItem> items;
  final Pagination? pagination;

  DailyThoughtData({required this.items, this.pagination});

  factory DailyThoughtData.fromJson(Map<String, dynamic> json) {
    return DailyThoughtData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => DailyThoughtItem.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class DailyThoughtItem {
  final String id;
  final String category;
  final String imageUrl;
  final String title;
  final int displayOrder;

  DailyThoughtItem({
    required this.id,
    required this.category,
    required this.imageUrl,
    required this.title,
    required this.displayOrder,
  });

  factory DailyThoughtItem.fromJson(Map<String, dynamic> json) {
    return DailyThoughtItem(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}

class Pagination {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int limit;

  Pagination({
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['totalItems'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
      limit: json['limit'] ?? 10,
    );
  }
}
