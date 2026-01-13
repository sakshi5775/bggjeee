import 'product_model.dart';

class WishlistModel {
  String? id;
  String? userId;
  List<WishlistItem>? items;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  WishlistModel({
    this.id,
    this.userId,
    this.items,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  WishlistModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    userId = json['user']?.toString();
    isDeleted = json['isDeleted'] is bool ? json['isDeleted'] : null;
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['items'] != null && json['items'] is List) {
      items = <WishlistItem>[];
      for (final entry in json['items']) {
        if (entry is Map<String, dynamic>) {
          items!.add(WishlistItem.fromJson(entry));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['user'] = userId;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (items != null) {
      data['items'] = items!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class WishlistItem {
  String? id;
  String? productId;
  ProductModel? product;
  ProductVariant? variant;
  String? addedAt;

  WishlistItem({
    this.id,
    this.productId,
    this.product,
    this.variant,
    this.addedAt,
  });

  WishlistItem.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    productId = json['product'] is String ? json['product']?.toString() : null;
    if (json['product'] != null && json['product'] is Map<String, dynamic>) {
      product = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
      productId = product?.id ?? product?.slug ?? product?.sku ?? productId;
    }
    if (json['variant'] != null && json['variant'] is Map<String, dynamic>) {
      variant = ProductVariant.fromJson(json['variant'] as Map<String, dynamic>);
    }
    addedAt = json['addedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['product'] = product?.toJson() ?? productId;
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    data['addedAt'] = addedAt;
    return data;
  }
}


