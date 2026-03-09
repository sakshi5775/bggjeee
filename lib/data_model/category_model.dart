class CategoryModel {
  String? id;
  String? name;
  String? description;
  CategoryParent? parent;
  String? image;
  String? icon;
  int? displayOrder;
  bool? isActive;
  bool? isFeatured;
  bool? isDeleted;
  String? slug;
  List<String>? metaKeywords;
  /// From categories/search: "root" or "subcategory"
  String? level;
  List<CategoryModel>? children;
  /// From get-by-id/slug: same structure as children
  List<CategoryModel>? subcategories;
  int? productCount;
  String? createdAt;
  String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.parent,
    this.image,
    this.icon,
    this.displayOrder,
    this.isActive,
    this.isFeatured,
    this.isDeleted,
    this.slug,
    this.metaKeywords,
    this.level,
    this.children,
    this.subcategories,
    this.productCount,
    this.createdAt,
    this.updatedAt,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name']?.toString();
    description = json['description']?.toString();
    parent = json['parent'] != null && json['parent'] is Map
        ? CategoryParent.fromJson(json['parent'] as Map<String, dynamic>)
        : null;
    image = json['image']?.toString();
    icon = json['icon']?.toString();
    displayOrder = _toInt(json['displayOrder']);
    isActive = json['isActive'] is bool ? json['isActive'] : null;
    isFeatured = json['isFeatured'] is bool ? json['isFeatured'] : null;
    isDeleted = json['isDeleted'] is bool ? json['isDeleted'] : null;
    slug = json['slug']?.toString();
    productCount = _toInt(json['productCount']);
    level = json['level']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['metaKeywords'] != null && json['metaKeywords'] is List) {
      metaKeywords = (json['metaKeywords'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (json['children'] != null && json['children'] is List) {
      children = <CategoryModel>[];
      for (final child in json['children']) {
        if (child is Map<String, dynamic>) {
          children!.add(CategoryModel.fromJson(child));
        }
      }
    }
    if (json['subcategories'] != null && json['subcategories'] is List) {
      subcategories = <CategoryModel>[];
      for (final sub in json['subcategories']) {
        if (sub is Map<String, dynamic>) {
          subcategories!.add(CategoryModel.fromJson(sub));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    if (parent != null) {
      data['parent'] = parent!.toJson();
    }
    data['image'] = image;
    data['icon'] = icon;
    data['displayOrder'] = displayOrder;
    data['isActive'] = isActive;
    data['isFeatured'] = isFeatured;
    data['isDeleted'] = isDeleted;
    data['slug'] = slug;
    data['metaKeywords'] = metaKeywords;
    data['level'] = level;
    data['productCount'] = productCount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (children != null) {
      data['children'] = children!.map((child) => child.toJson()).toList();
    }
    if (subcategories != null) {
      data['subcategories'] =
          subcategories!.map((child) => child.toJson()).toList();
    }
    return data;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class CategoryParent {
  String? id;
  String? name;
  String? slug;

  CategoryParent({this.id, this.name, this.slug});

  CategoryParent.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name']?.toString();
    slug = json['slug']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class CategoryData {
  List<CategoryModel>? items;
  Pagination? pagination;

  CategoryData({this.items, this.pagination});

  CategoryData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null && json['items'] is List) {
      items = <CategoryModel>[];
      for (final item in json['items']) {
        if (item is Map<String, dynamic>) {
          items!.add(CategoryModel.fromJson(item));
        }
      }
    }
    pagination = json['pagination'] != null && json['pagination'] is Map
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((item) => item.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class CategoryResponse {
  bool? success;
  String? message;
  CategoryData? data;

  CategoryResponse({this.success, this.message, this.data});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] is bool ? json['success'] : null;
    message = json['message']?.toString();
    data = json['data'] != null && json['data'] is Map
        ? CategoryData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final dataMap = <String, dynamic>{};
    dataMap['success'] = success;
    dataMap['message'] = message;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class CategoryTreeResponse {
  bool? success;
  String? message;
  List<CategoryModel>? data;

  CategoryTreeResponse({this.success, this.message, this.data});

  CategoryTreeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] is bool ? json['success'] : null;
    message = json['message']?.toString();
    if (json['data'] != null && json['data'] is List) {
      data = <CategoryModel>[];
      for (final item in json['data']) {
        if (item is Map<String, dynamic>) {
          data!.add(CategoryModel.fromJson(item));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final dataMap = <String, dynamic>{};
    dataMap['success'] = success;
    dataMap['message'] = message;
    if (data != null) {
      dataMap['data'] = data!.map((item) => item.toJson()).toList();
    }
    return dataMap;
  }
}

class Pagination {
  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? limit;
  Map<String, dynamic>? aggregations;
  /// From categories/search response
  String? searchQuery;
  String? type;
  /// From products-by-category response: category info in pagination
  Map<String, dynamic>? category;

  Pagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
    this.aggregations,
    this.searchQuery,
    this.type,
    this.category,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = _toInt(json['totalItems']);
    currentPage = _toInt(json['currentPage']);
    totalPages = _toInt(json['totalPages']);
    hasNextPage = json['hasNextPage'] is bool ? json['hasNextPage'] : null;
    hasPrevPage = json['hasPrevPage'] is bool ? json['hasPrevPage'] : null;
    limit = _toInt(json['limit']);
    searchQuery = json['searchQuery']?.toString();
    type = json['type']?.toString();
    if (json['aggregations'] != null && json['aggregations'] is Map) {
      aggregations = Map<String, dynamic>.from(json['aggregations'] as Map);
    }
    if (json['category'] != null && json['category'] is Map) {
      category = Map<String, dynamic>.from(json['category'] as Map);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['hasNextPage'] = hasNextPage;
    data['hasPrevPage'] = hasPrevPage;
    data['limit'] = limit;
    data['aggregations'] = aggregations;
    data['searchQuery'] = searchQuery;
    data['type'] = type;
    data['category'] = category;
    return data;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}





