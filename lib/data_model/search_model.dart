import 'package:astrobharataiuser/data_model/product_model.dart';

class SearchResponse {
  SearchResponse({
    List<ProductModel>? items,
    this.pagination,
    this.aggregations,
    this.query,
  }) : items = items ?? const [];

  SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] is List) {
      items = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    }
    if (json['pagination'] is Map<String, dynamic>) {
      pagination = SearchPagination.fromJson(json['pagination'] as Map<String, dynamic>);
    }
    if (json['aggregations'] is Map<String, dynamic>) {
      aggregations = SearchAggregations.fromJson(json['aggregations'] as Map<String, dynamic>);
    }
    query = json['query']?.toString() ??
        (json['pagination'] is Map ? (json['pagination'] as Map)['query']?.toString() : null);
  }

  List<ProductModel> items = const [];
  SearchPagination? pagination;
  SearchAggregations? aggregations;
  String? query;
}

class SearchPagination {
  SearchPagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
  });

  SearchPagination.fromJson(Map<String, dynamic> json) {
    totalItems = _toInt(json['totalItems']);
    currentPage = _toInt(json['currentPage']);
    totalPages = _toInt(json['totalPages']);
    hasNextPage = json['hasNextPage'] as bool?;
    hasPrevPage = json['hasPrevPage'] as bool?;
    limit = _toInt(json['limit']);
  }

  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? limit;
}

class SearchAggregations {
  SearchAggregations({
    this.priceRange,
    List<SearchCategoryAggregation>? categories,
  }) : categories = categories ?? const [];

  SearchAggregations.fromJson(Map<String, dynamic> json) {
    if (json['priceRange'] is Map<String, dynamic>) {
      priceRange = SearchPriceRange.fromJson(json['priceRange'] as Map<String, dynamic>);
    }
    if (json['categories'] is List) {
      categories = (json['categories'] as List)
          .whereType<Map<String, dynamic>>()
          .map(SearchCategoryAggregation.fromJson)
          .toList();
    }
  }

  SearchPriceRange? priceRange;
  List<SearchCategoryAggregation> categories = const [];
}

class SearchPriceRange {
  SearchPriceRange({
    this.minPrice,
    this.maxPrice,
  });

  SearchPriceRange.fromJson(Map<String, dynamic> json) {
    minPrice = _toDouble(json['minPrice']);
    maxPrice = _toDouble(json['maxPrice']);
  }

  double? minPrice;
  double? maxPrice;
}

class SearchCategoryAggregation {
  SearchCategoryAggregation({
    this.id,
    this.name,
    this.count,
    this.slug,
  });

  SearchCategoryAggregation.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    name = json['name']?.toString();
    slug = json['slug']?.toString();
    count = _toInt(json['count']);
  }

  String? id;
  String? name;
  String? slug;
  int? count;
}

class SearchSuggestions {
  SearchSuggestions({
    List<ProductModel>? products,
    List<SearchSuggestionCategory>? categories,
  })  : products = products ?? const [],
        categories = categories ?? const [];

  SearchSuggestions.fromJson(Map<String, dynamic> json) {
    if (json['products'] is List) {
      products = (json['products'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    }
    if (json['categories'] is List) {
      categories = (json['categories'] as List)
          .whereType<Map<String, dynamic>>()
          .map(SearchSuggestionCategory.fromJson)
          .toList();
    }
  }

  List<ProductModel> products = const [];
  List<SearchSuggestionCategory> categories = const [];
}

class SearchSuggestionCategory {
  SearchSuggestionCategory({
    this.id,
    this.name,
    this.slug,
    this.type,
  });

  SearchSuggestionCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    name = json['name']?.toString();
    slug = json['slug']?.toString();
    type = json['type']?.toString();
  }

  String? id;
  String? name;
  String? slug;
  String? type;
}

class SearchPopularTerm {
  SearchPopularTerm({
    this.term,
    this.slug,
    this.type,
  });

  SearchPopularTerm.fromJson(Map<String, dynamic> json) {
    term = json['term']?.toString();
    slug = json['slug']?.toString();
    type = json['type']?.toString();
  }

  String? term;
  String? slug;
  String? type;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

