import 'category_model.dart';

class ProductModel {
  String? id;
  String? name;
  String? shortDescription;
  String? description;
  String? slug;
  String? sku;
  String? category;
  String? subcategory;
  String? productType;
  ProductCategory? categoryObj;
  ProductSubcategory? subcategoryObj;
  List<ProductImage>? images;
  List<ProductVideo>? videos;
  double? basePrice;
  double? discountedPrice;
  double? discountPercentage;
  double? currentPrice;
  double? taxRate;
  bool? hasVariants;
  ProductSpecifications? specifications;
  ProductCertification? certification;
  bool? isEnergized;
  List<String>? spiritualBenefits;
  String? usageInstructions;
  String? authenticityGuarantee;
  List<String>? purpose;
  List<String>? tags;
  String? status;
  bool? isFeatured;
  bool? isTopSelling;
  int? viewsCount;
  int? salesCount;
  double? averageRating;
  int? reviewCount;
  List<String>? metaKeywords;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  bool? inStock;
  List<ProductVariant>? variants;
  List<ProductInventory>? inventory;
  double? relevanceScore;

  ProductModel({
    this.id,
    this.name,
    this.shortDescription,
    this.description,
    this.slug,
    this.sku,
    this.category,
    this.subcategory,
    this.productType,
    this.categoryObj,
    this.subcategoryObj,
    this.images,
    this.videos,
    this.basePrice,
    this.discountedPrice,
    this.discountPercentage,
    this.currentPrice,
    this.taxRate,
    this.hasVariants,
    this.specifications,
    this.certification,
    this.isEnergized,
    this.spiritualBenefits,
    this.usageInstructions,
    this.authenticityGuarantee,
    this.purpose,
    this.tags,
    this.status,
    this.isFeatured,
    this.isTopSelling,
    this.viewsCount,
    this.salesCount,
    this.averageRating,
    this.reviewCount,
    this.metaKeywords,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.inStock,
    this.variants,
    this.inventory,
    this.relevanceScore,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['_id'] ?? json['id'];
      name = json['name'];
      shortDescription = json['shortDescription'];
      description = json['description'];
      slug = json['slug'];
      sku = json['sku'];
      category = json['category'] is String
          ? json['category']
          : (json['category'] is Map
              ? (json['category']?['_id'] ?? json['category']?['id'])
              : null);
      subcategory = json['subcategory'] is String
          ? json['subcategory']
          : (json['subcategory'] is Map
              ? (json['subcategory']?['_id'] ?? json['subcategory']?['id'])
              : null);
      productType = json['productType'];
      categoryObj = json['category'] != null && json['category'] is Map
          ? ProductCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null;
      subcategoryObj = json['subcategory'] != null && json['subcategory'] is Map
          ? ProductSubcategory.fromJson(json['subcategory'] as Map<String, dynamic>)
          : null;
      if (json['images'] != null && json['images'] is List) {
        images = <ProductImage>[];
        (json['images'] as List).forEach((v) {
          if (v is Map<String, dynamic>) {
            try {
              images!.add(ProductImage.fromJson(v));
            } catch (e) {
              print('Error parsing image: $e');
            }
          }
        });
      }
      if (json['videos'] != null && json['videos'] is List) {
        videos = <ProductVideo>[];
        (json['videos'] as List).forEach((v) {
          if (v is Map<String, dynamic>) {
            try {
              videos!.add(ProductVideo.fromJson(v));
            } catch (e) {
              print('Error parsing video: $e');
            }
          }
        });
      }
      basePrice = json['basePrice']?.toDouble();
      discountedPrice = json['discountedPrice']?.toDouble();
      discountPercentage = json['discountPercentage']?.toDouble();
      currentPrice = json['currentPrice']?.toDouble() ?? 
                     (discountedPrice ?? basePrice);
      taxRate = json['taxRate']?.toDouble();
      hasVariants = json['hasVariants'] is bool ? json['hasVariants'] : null;
      if (json['specifications'] != null && json['specifications'] is Map) {
        try {
          specifications = ProductSpecifications.fromJson(json['specifications'] as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing specifications: $e');
          specifications = null;
        }
      } else {
        specifications = null;
      }
      if (json['certification'] != null && json['certification'] is Map) {
        try {
          certification = ProductCertification.fromJson(json['certification'] as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing certification: $e');
          certification = null;
        }
      } else {
        certification = null;
      }
      isEnergized = json['isEnergized'] is bool ? json['isEnergized'] : null;
      
      // Parse spiritualBenefits safely
      spiritualBenefits = [];
      if (json['spiritualBenefits'] != null) {
        try {
          final benefitsValue = json['spiritualBenefits'];
          if (benefitsValue is List) {
            spiritualBenefits = benefitsValue.map<String>((e) {
              try {
                return e.toString();
              } catch (e) {
                return '';
              }
            }).where((e) => e.isNotEmpty).toList();
          }
        } catch (e) {
          print('Error parsing spiritualBenefits: $e');
          spiritualBenefits = [];
        }
      }
      
      usageInstructions = json['usageInstructions']?.toString();
      authenticityGuarantee = json['authenticityGuarantee']?.toString();
      purpose = [];
      if (json['purpose'] != null) {
        try {
          final purposeValue = json['purpose'];
          if (purposeValue is List) {
            purpose = purposeValue
                .map<String>((e) => e?.toString() ?? '')
                .where((e) => e.isNotEmpty)
                .toList();
          }
        } catch (e) {
          purpose = [];
        }
      }
      // Parse tags safely
      tags = [];
      if (json['tags'] != null) {
        try {
          final tagsValue = json['tags'];
          if (tagsValue is List) {
            tags = tagsValue.map<String>((e) {
              try {
                return e.toString();
              } catch (e) {
                return '';
              }
            }).where((e) => e.isNotEmpty).toList();
          }
        } catch (e) {
          print('Error parsing tags: $e');
          tags = [];
        }
      }
      
      status = json['status']?.toString();
      isFeatured = json['isFeatured'] is bool ? json['isFeatured'] : null;
      isTopSelling = json['isTopSelling'] is bool ? json['isTopSelling'] : null;
      viewsCount = json['viewsCount'] is int ? json['viewsCount'] : null;
      salesCount = json['salesCount'] is int ? json['salesCount'] : null;
      averageRating = json['averageRating']?.toDouble() ?? 0.0;
      reviewCount = json['reviewCount'] is int ? json['reviewCount'] : 0;
      
      // Parse metaKeywords safely
      metaKeywords = [];
      if (json['metaKeywords'] != null) {
        try {
          final keywordsValue = json['metaKeywords'];
          if (keywordsValue is List) {
            metaKeywords = keywordsValue.map<String>((e) {
              try {
                return e.toString();
              } catch (e) {
                return '';
              }
            }).where((e) => e.isNotEmpty).toList();
          }
        } catch (e) {
          print('Error parsing metaKeywords: $e');
          metaKeywords = [];
        }
      }
      isDeleted = json['isDeleted'] is bool ? json['isDeleted'] : null;
      createdAt = json['createdAt']?.toString();
      updatedAt = json['updatedAt']?.toString();
      inStock = json['inStock'] is bool ? json['inStock'] : null;
      relevanceScore = json['relevanceScore']?.toDouble();
    } catch (e) {
      print('Error parsing ProductModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['description'] = description;
    data['slug'] = slug;
    data['sku'] = sku;
    data['category'] = category;
    data['subcategory'] = subcategory;
    data['productType'] = productType;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['basePrice'] = basePrice;
    data['discountedPrice'] = discountedPrice;
    data['discountPercentage'] = discountPercentage;
    data['currentPrice'] = currentPrice;
    data['taxRate'] = taxRate;
    data['hasVariants'] = hasVariants;
    if (specifications != null) {
      data['specifications'] = specifications!.toJson();
    }
    if (certification != null) {
      data['certification'] = certification!.toJson();
    }
    data['isEnergized'] = isEnergized;
    data['spiritualBenefits'] = spiritualBenefits;
    data['usageInstructions'] = usageInstructions;
    data['authenticityGuarantee'] = authenticityGuarantee;
    data['purpose'] = purpose;
    data['tags'] = tags;
    data['status'] = status;
    data['isFeatured'] = isFeatured;
    data['isTopSelling'] = isTopSelling;
    data['viewsCount'] = viewsCount;
    data['salesCount'] = salesCount;
    data['averageRating'] = averageRating;
    data['reviewCount'] = reviewCount;
    data['metaKeywords'] = metaKeywords;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['inStock'] = inStock;
    return data;
  }
}

class ProductCategory {
  String? id;
  String? name;
  String? slug;

  ProductCategory({this.id, this.name, this.slug});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class ProductSubcategory {
  String? id;
  String? name;
  String? slug;

  ProductSubcategory({this.id, this.name, this.slug});

  ProductSubcategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class ProductImage {
  String? id;
  String? url;
  String? alt;
  bool? isPrimary;
  int? displayOrder;

  ProductImage({
    this.id,
    this.url,
    this.alt,
    this.isPrimary,
    this.displayOrder,
  });

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    url = json['url'];
    alt = json['alt'];
    isPrimary = json['isPrimary'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['url'] = url;
    data['alt'] = alt;
    data['isPrimary'] = isPrimary;
    data['displayOrder'] = displayOrder;
    return data;
  }
}

class ProductVideo {
  String? id;
  String? url;
  String? thumbnail;
  String? alt;
  int? displayOrder;

  ProductVideo({
    this.id,
    this.url,
    this.thumbnail,
    this.alt,
    this.displayOrder,
  });

  ProductVideo.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    alt = json['alt'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['alt'] = alt;
    data['displayOrder'] = displayOrder;
    return data;
  }
}

class ProductSpecifications {
  ProductWeight? weight;
  ProductDimensions? dimensions;
  String? origin;
  int? mukhiCount;
  String? material;
  String? size;
  int? beadCount;
  String? quality;

  ProductSpecifications({
    this.weight,
    this.dimensions,
    this.origin,
    this.mukhiCount,
    this.material,
    this.size,
    this.beadCount,
    this.quality,
  });

  ProductSpecifications.fromJson(Map<String, dynamic> json) {
    try {
      if (json['weight'] != null && json['weight'] is Map) {
        weight = ProductWeight.fromJson(json['weight'] as Map<String, dynamic>);
      } else {
        weight = null;
      }
      if (json['dimensions'] != null && json['dimensions'] is Map) {
        dimensions = ProductDimensions.fromJson(json['dimensions'] as Map<String, dynamic>);
      } else {
        dimensions = null;
      }
      origin = json['origin']?.toString();
      mukhiCount = json['mukhiCount'] is int ? json['mukhiCount'] : null;
      material = json['material']?.toString();
      size = json['size']?.toString();
      beadCount = json['beadCount'] is int ? json['beadCount'] : null;
      quality = json['quality']?.toString();
    } catch (e) {
      print('Error parsing ProductSpecifications: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weight != null) {
      data['weight'] = weight!.toJson();
    }
    if (dimensions != null) {
      data['dimensions'] = dimensions!.toJson();
    }
    data['origin'] = origin;
    data['mukhiCount'] = mukhiCount;
    data['material'] = material;
    data['size'] = size;
    data['beadCount'] = beadCount;
    data['quality'] = quality;
    return data;
  }
}

class ProductWeight {
  double? value;
  String? unit;

  ProductWeight({this.value, this.unit});

  ProductWeight.fromJson(Map<String, dynamic> json) {
    value = json['value']?.toDouble();
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['unit'] = unit;
    return data;
  }
}

class ProductDimensions {
  double? length;
  double? width;
  double? height;
  String? unit;

  ProductDimensions({this.length, this.width, this.height, this.unit});

  ProductDimensions.fromJson(Map<String, dynamic> json) {
    length = json['length']?.toDouble();
    width = json['width']?.toDouble();
    height = json['height']?.toDouble();
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['unit'] = unit;
    return data;
  }
}

class ProductCertification {
  bool? isCertified;
  String? certificateNumber;
  String? certificateUrl;
  String? certifyingAuthority;
  String? certificationDate;

  ProductCertification({
    this.isCertified,
    this.certificateNumber,
    this.certificateUrl,
    this.certifyingAuthority,
    this.certificationDate,
  });

  ProductCertification.fromJson(Map<String, dynamic> json) {
    isCertified = json['isCertified'];
    certificateNumber = json['certificateNumber'];
    certificateUrl = json['certificateUrl'];
    certifyingAuthority = json['certifyingAuthority'];
    certificationDate = json['certificationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCertified'] = isCertified;
    data['certificateNumber'] = certificateNumber;
    data['certificateUrl'] = certificateUrl;
    data['certifyingAuthority'] = certifyingAuthority;
    data['certificationDate'] = certificationDate;
    return data;
  }
}

class ProductVariant {
  String? id;
  String? name;
  String? sku;
  double? price;
  int? stock;

  ProductVariant({
    this.id,
    this.name,
    this.sku,
    this.price,
    this.stock,
  });

  ProductVariant.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price']?.toDouble();
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['sku'] = sku;
    data['price'] = price;
    data['stock'] = stock;
    return data;
  }
}

class ProductInventory {
  String? id;
  String? variantId;
  int? quantity;
  int? quantityAvailable;
  int? quantityReserved;
  int? totalStock;
  String? location;

  ProductInventory({
    this.id,
    this.variantId,
    this.quantity,
    this.quantityAvailable,
    this.quantityReserved,
    this.totalStock,
    this.location,
  });

  ProductInventory.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    variantId = json['variantId']?.toString();
    quantity = _toInt(json['quantity']);
    quantityAvailable = _toInt(json['quantityAvailable']);
    quantityReserved = _toInt(json['quantityReserved']);
    totalStock = _toInt(json['totalStock']);
    location = json['location']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['variantId'] = variantId;
    data['quantity'] = quantity;
    data['quantityAvailable'] = quantityAvailable;
    data['quantityReserved'] = quantityReserved;
    data['totalStock'] = totalStock;
    data['location'] = location;
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

class ProductReview {
  String? id;
  String? productId;
  String? userId;
  String? userName;
  int? rating;
  String? title;
  String? comment;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;

  ProductReview({
    this.id,
    this.productId,
    this.userId,
    this.userName,
    this.rating,
    this.title,
    this.comment,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  ProductReview.fromJson(Map<String, dynamic> json) {
    try {
      id = json['_id'] ?? json['id'];
      productId = json['productId']?.toString();
      userId = json['userId']?.toString();
      userName = json['userName']?.toString() ?? json['user']?.toString();
      rating = json['rating'] is int ? json['rating'] : (json['rating'] is num ? json['rating'].toInt() : null);
      title = json['title']?.toString();
      comment = json['comment']?.toString() ?? json['reviewText']?.toString();
      isVerified = json['isVerified'] is bool ? json['isVerified'] : null;
      createdAt = json['createdAt']?.toString();
      updatedAt = json['updatedAt']?.toString();
    } catch (e) {
      print('Error parsing ProductReview: $e');
      print('JSON data: $json');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['productId'] = productId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['rating'] = rating;
    data['title'] = title;
    data['comment'] = comment;
    data['isVerified'] = isVerified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ProductReviewResponse {
  bool? success;
  String? message;
  ProductReviewData? data;

  ProductReviewResponse({this.success, this.message, this.data});

  ProductReviewResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ProductReviewData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductReviewData {
  List<ProductReview>? items;
  Pagination? pagination;

  ProductReviewData({this.items, this.pagination});

  ProductReviewData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null && json['items'] is List) {
      items = <ProductReview>[];
      (json['items'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          try {
            items!.add(ProductReview.fromJson(v));
          } catch (e) {
            print('Error parsing review item: $e');
          }
        }
      });
    }
    pagination = json['pagination'] != null && json['pagination'] is Map
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ProductResponse {
  bool? success;
  String? message;
  ProductData? data;

  ProductResponse({this.success, this.message, this.data});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ProductData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductData {
  List<ProductModel>? items;
  Pagination? pagination;

  ProductData({this.items, this.pagination});

  ProductData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null && json['items'] is List) {
      items = <ProductModel>[];
      (json['items'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          items!.add(ProductModel.fromJson(v));
        }
      });
    }
    pagination = json['pagination'] != null && json['pagination'] is Map
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ProductDetailResponse {
  bool? success;
  String? message;
  ProductDetailData? data;

  ProductDetailResponse({this.success, this.message, this.data});

  ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ProductDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductDetailData {
  ProductModel? product;
  List<ProductVariant>? variants;
  List<ProductInventory>? inventory;

  ProductDetailData({this.product, this.variants, this.inventory});

  ProductDetailData.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null
        ? ProductModel.fromJson(json['product'])
        : null;
    if (json['variants'] != null && json['variants'] is List) {
      variants = <ProductVariant>[];
      (json['variants'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          variants!.add(ProductVariant.fromJson(v));
        }
      });
    }
    if (json['inventory'] != null && json['inventory'] is List) {
      inventory = <ProductInventory>[];
      (json['inventory'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          inventory!.add(ProductInventory.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (inventory != null) {
      data['inventory'] = inventory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

