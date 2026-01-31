class RemedyCategoryModel {
  String? id;
  String? title;
  String? image;
  String? offerLine;
  String? status;
  int? sortOrder;
  String? slug;
  int? servicesCount;
  String? createdAt;
  String? updatedAt;

  RemedyCategoryModel({
    this.id,
    this.title,
    this.image,
    this.offerLine,
    this.status,
    this.sortOrder,
    this.slug,
    this.servicesCount,
    this.createdAt,
    this.updatedAt,
  });

  RemedyCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    title = json['title'];
    image = json['image'];
    offerLine = json['offerLine'];
    status = json['status'];
    sortOrder = json['sortOrder'];
    slug = json['slug'];
    servicesCount = json['servicesCount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['offerLine'] = offerLine;
    data['status'] = status;
    data['sortOrder'] = sortOrder;
    data['slug'] = slug;
    data['servicesCount'] = servicesCount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class RemedyCategoryResponse {
  bool? success;
  String? message;
  RemedyCategoryData? data;

  RemedyCategoryResponse({this.success, this.message, this.data});

  RemedyCategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? RemedyCategoryData.fromJson(json['data'])
        : null;
  }
}

class RemedyCategoryData {
  List<RemedyCategoryModel>? items;
  Pagination? pagination;

  RemedyCategoryData({this.items, this.pagination});

  RemedyCategoryData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <RemedyCategoryModel>[];
      json['items'].forEach((v) {
        items!.add(RemedyCategoryModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Pagination {
  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? limit;

  Pagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    limit = json['limit'];
  }
}
