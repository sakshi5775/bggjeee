class PujaModel {
  String? id;
  String? title;
  String? subheading;
  String? timing;
  String? longDescription;
  String? image;
  String? slug;
  String? status;
  int? displayOrder;
  bool? isFeatured;
  bool? isPopular;
  PujaTemple? temple;
  List<PujaBenefit>? benefits;
  List<PujaProcessStep>? processSteps;
  List<PujaPackage>? packages;
  PujaStats? stats;
  String? createdAt;
  String? updatedAt;

  PujaModel({
    this.id,
    this.title,
    this.subheading,
    this.timing,
    this.longDescription,
    this.image,
    this.slug,
    this.status,
    this.displayOrder,
    this.isFeatured,
    this.isPopular,
    this.temple,
    this.benefits,
    this.processSteps,
    this.packages,
    this.stats,
    this.createdAt,
    this.updatedAt,
  });

  PujaModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    title = json['title'];
    subheading = json['subheading'];
    timing = json['timing'];
    longDescription = json['longDescription'];
    image = json['image'];
    slug = json['slug'];
    status = json['status'];
    displayOrder = json['displayOrder'];
    isFeatured = json['isFeatured'];
    isPopular = json['isPopular'];
    temple = json['temple'] != null ? PujaTemple.fromJson(json['temple']) : null;
    if (json['benefits'] != null) {
      benefits = <PujaBenefit>[];
      json['benefits'].forEach((v) {
        benefits!.add(PujaBenefit.fromJson(v));
      });
    }
    if (json['processSteps'] != null) {
      processSteps = <PujaProcessStep>[];
      json['processSteps'].forEach((v) {
        processSteps!.add(PujaProcessStep.fromJson(v));
      });
    }
    if (json['packages'] != null) {
      packages = <PujaPackage>[];
      json['packages'].forEach((v) {
        packages!.add(PujaPackage.fromJson(v));
      });
    }
    stats = json['stats'] != null ? PujaStats.fromJson(json['stats']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['title'] = title;
    data['subheading'] = subheading;
    data['timing'] = timing;
    data['longDescription'] = longDescription;
    data['image'] = image;
    data['slug'] = slug;
    data['status'] = status;
    data['displayOrder'] = displayOrder;
    data['isFeatured'] = isFeatured;
    data['isPopular'] = isPopular;
    if (temple != null) {
      data['temple'] = temple!.toJson();
    }
    if (benefits != null) {
      data['benefits'] = benefits!.map((v) => v.toJson()).toList();
    }
    if (processSteps != null) {
      data['processSteps'] = processSteps!.map((v) => v.toJson()).toList();
    }
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PujaTemple {
  String? id;
  String? name;
  String? slug;
  String? description;
  PujaLocation? location;
  String? image;
  String? fullAddress;

  PujaTemple({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.location,
    this.image,
    this.fullAddress,
  });

  PujaTemple.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    location = json['location'] != null ? PujaLocation.fromJson(json['location']) : null;
    image = json['image'];
    fullAddress = json['fullAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['image'] = image;
    data['fullAddress'] = fullAddress;
    return data;
  }
}

class PujaLocation {
  String? city;
  String? state;
  String? pincode;
  String? country;

  PujaLocation({this.city, this.state, this.pincode, this.country});

  PujaLocation.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['country'] = country;
    return data;
  }
}

class PujaBenefit {
  String? title;
  String? description;

  PujaBenefit({this.title, this.description});

  PujaBenefit.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class PujaProcessStep {
  int? stepNumber;
  String? title;
  String? description;

  PujaProcessStep({this.stepNumber, this.title, this.description});

  PujaProcessStep.fromJson(Map<String, dynamic> json) {
    stepNumber = json['stepNumber'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stepNumber'] = stepNumber;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class PujaPackage {
  String? id;
  int? personCount;
  String? packageName;
  List<String>? inclusions;
  double? price;
  bool? isRecommended;

  PujaPackage({
    this.id,
    this.personCount,
    this.packageName,
    this.inclusions,
    this.price,
    this.isRecommended,
  });

  PujaPackage.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    personCount = json['personCount'];
    packageName = json['packageName'];
    inclusions = json['inclusions'] != null ? List<String>.from(json['inclusions']) : null;
    price = json['price']?.toDouble();
    isRecommended = json['isRecommended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['personCount'] = personCount;
    data['packageName'] = packageName;
    data['inclusions'] = inclusions;
    data['price'] = price;
    data['isRecommended'] = isRecommended;
    return data;
  }
}

class PujaStats {
  int? totalBookings;
  int? totalParticipants;
  double? averageRating;
  int? totalReviews;

  PujaStats({
    this.totalBookings,
    this.totalParticipants,
    this.averageRating,
    this.totalReviews,
  });

  PujaStats.fromJson(Map<String, dynamic> json) {
    totalBookings = json['totalBookings'];
    totalParticipants = json['totalParticipants'];
    averageRating = json['averageRating']?.toDouble();
    totalReviews = json['totalReviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBookings'] = totalBookings;
    data['totalParticipants'] = totalParticipants;
    data['averageRating'] = averageRating;
    data['totalReviews'] = totalReviews;
    return data;
  }
}

class PujaResponse {
  bool? success;
  String? message;
  PujaData? data;

  PujaResponse({this.success, this.message, this.data});

  PujaResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PujaData.fromJson(json['data']) : null;
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

class PujaData {
  List<PujaModel>? items;
  PujaPagination? pagination;

  PujaData({this.items, this.pagination});

  PujaData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <PujaModel>[];
      json['items'].forEach((v) {
        items!.add(PujaModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? PujaPagination.fromJson(json['pagination']) : null;
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

class PujaPagination {
  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? limit;

  PujaPagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
  });

  PujaPagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['hasNextPage'] = hasNextPage;
    data['hasPrevPage'] = hasPrevPage;
    data['limit'] = limit;
    return data;
  }
}
