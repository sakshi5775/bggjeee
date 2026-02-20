class BlogResponse {
  bool? success;
  String? message;
  List<Blog>? data;
  Pagination? pagination;

  BlogResponse({this.success, this.message, this.data, this.pagination});

  BlogResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Blog>[];
      json['data'].forEach((v) {
        data!.add(Blog.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Blog {
  Seo? seo;
  String? id;
  String? title;
  String? slug;
  String? excerpt;
  String? content;
  String? featuredImage;
  String? author;
  String? authorType;
  List<Category>? categories;
  List<Tag>? tags;
  String? status;
  String? publishDate;
  int? viewsCount;
  bool? isFeatured;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? readingTime;
  String? reviewedAt;
  String? reviewedBy;

  Blog({
    this.seo,
    this.id,
    this.title,
    this.slug,
    this.excerpt,
    this.content,
    this.featuredImage,
    this.author,
    this.authorType,
    this.categories,
    this.tags,
    this.status,
    this.publishDate,
    this.viewsCount,
    this.isFeatured,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.readingTime,
    this.reviewedAt,
    this.reviewedBy,
  });

  Blog.fromJson(Map<String, dynamic> json) {
    seo = json['seo'] != null ? Seo.fromJson(json['seo']) : null;
    id = json['_id'] ?? json['id'];
    title = json['title'];
    slug = json['slug'];
    excerpt = json['excerpt'];
    content = json['content'];
    featuredImage = json['featuredImage'];
    author = json['author'];
    authorType = json['authorType'];
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    status = json['status'];
    publishDate = json['publishDate'];
    viewsCount = json['viewsCount'];
    isFeatured = json['isFeatured'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    readingTime = json['readingTime'];
    reviewedAt = json['reviewedAt'];
    reviewedBy = json['reviewedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (seo != null) {
      data['seo'] = seo!.toJson();
    }
    data['_id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['excerpt'] = excerpt;
    data['content'] = content;
    data['featuredImage'] = featuredImage;
    data['author'] = author;
    data['authorType'] = authorType;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['publishDate'] = publishDate;
    data['viewsCount'] = viewsCount;
    data['isFeatured'] = isFeatured;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['readingTime'] = readingTime;
    data['reviewedAt'] = reviewedAt;
    data['reviewedBy'] = reviewedBy;
    return data;
  }
}

class Seo {
  String? metaTitle;
  String? metaDescription;
  List<String>? keywords;

  Seo({this.metaTitle, this.metaDescription, this.keywords});

  Seo.fromJson(Map<String, dynamic> json) {
    metaTitle = json['metaTitle'];
    metaDescription = json['metaDescription'];
    keywords = json['keywords']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['metaTitle'] = metaTitle;
    data['metaDescription'] = metaDescription;
    data['keywords'] = keywords;
    return data;
  }
}

class Category {
  String? id;
  String? slug;
  String? name;

  Category({this.id, this.slug, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    slug = json['slug'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    return data;
  }
}

class Tag {
  String? id;
  String? slug;
  String? name;

  Tag({this.id, this.slug, this.name});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    slug = json['slug'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? nextPage;
  int? prevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
    this.hasNextPage,
    this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    nextPage = json['nextPage'];
    prevPage = json['prevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalItems'] = totalItems;
    data['itemsPerPage'] = itemsPerPage;
    data['hasNextPage'] = hasNextPage;
    data['hasPrevPage'] = hasPrevPage;
    data['nextPage'] = nextPage;
    data['prevPage'] = prevPage;
    return data;
  }
}

class CreateBlogRequest {
  String? title;
  String? content;
  String? excerpt;
  String? featuredImage;
  List<String>? categories;
  List<String>? tags;
  String? status;
  String? publishDate;
  Seo? seo;

  CreateBlogRequest({
    this.title,
    this.content,
    this.excerpt,
    this.featuredImage,
    this.categories,
    this.tags,
    this.status,
    this.publishDate,
    this.seo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['excerpt'] = excerpt;
    data['featuredImage'] = featuredImage;
    data['categories'] = categories;
    data['tags'] = tags;
    data['status'] = status;
    data['publishDate'] = publishDate;
    if (seo != null) {
      data['seo'] = seo!.toJson();
    }
    return data;
  }
}
