import 'package:astrobharataiuser/data_model/remedy_category_model.dart';

class RemedyModel {
  String? id;
  String? title;
  RemedyCategoryModel? category;
  String? image;
  double? price;
  String? description;
  String? status;
  bool? isFeatured;
  int? sortOrder;
  String? createdBy;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? slug;

  RemedyModel({
    this.id,
    this.title,
    this.category,
    this.image,
    this.price,
    this.description,
    this.status,
    this.isFeatured,
    this.sortOrder,
    this.createdBy,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.slug,
  });

  RemedyModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    category = json['category'] != null
        ? RemedyCategoryModel.fromJson(json['category'])
        : null;
    image = json['image'];
    price = (json['price'] as num?)?.toDouble();
    description = json['description'];
    status = json['status'];
    isFeatured = json['isFeatured'];
    sortOrder = json['sortOrder'];
    createdBy = json['createdBy'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['image'] = image;
    data['price'] = price;
    data['description'] = description;
    data['status'] = status;
    data['isFeatured'] = isFeatured;
    data['sortOrder'] = sortOrder;
    data['createdBy'] = createdBy;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['slug'] = slug;
    return data;
  }
}

class RemedyResponse {
  bool? success;
  String? message;
  RemedyData? data;

  RemedyResponse({this.success, this.message, this.data});

  RemedyResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? RemedyData.fromJson(json['data']) : null;
  }
}

class RemedyData {
  List<RemedyModel>? items;
  Pagination? pagination;

  RemedyData({this.items, this.pagination});

  RemedyData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <RemedyModel>[];
      json['items'].forEach((v) {
        items!.add(RemedyModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}
