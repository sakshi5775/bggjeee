class HandwritingResponse {
  final bool success;
  final String message;
  final HandwritingData? data;

  HandwritingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory HandwritingResponse.fromJson(Map<String, dynamic> json) {
    return HandwritingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? HandwritingData.fromJson(json['data']) : null,
    );
  }
}

class HandwritingData {
  final String? readingId;
  final List<String>? imageUrls;
  final HandwritingOverview? overview;
  final HandwritingCategories? categories;
  final HandwritingFeatures? features;
  final HandwritingLists? lists;
  final String? summary;
  final String? language;
  final HandwritingUserInput? userInput;
  final Map<String, dynamic>? aiMetadata;
  final String? createdAt;
  final String? updatedAt;
  final String? status;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  HandwritingData({
    this.readingId,
    this.imageUrls,
    this.overview,
    this.categories,
    this.features,
    this.lists,
    this.summary,
    this.language,
    this.userInput,
    this.aiMetadata,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.errorMessage,
    this.metadata,
  });

  factory HandwritingData.fromJson(Map<String, dynamic> json) {
    return HandwritingData(
      readingId: json['readingId'] ?? json['_id'] ?? json['id'],
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
      overview: json['overview'] != null
          ? HandwritingOverview.fromJson(json['overview'])
          : null,
      categories: json['categories'] != null
          ? HandwritingCategories.fromJson(json['categories'])
          : null,
      features: json['features'] != null
          ? HandwritingFeatures.fromJson(json['features'])
          : null,
      lists: json['lists'] != null
          ? HandwritingLists.fromJson(json['lists'])
          : null,
      summary: json['summary'],
      language: json['language'],
      userInput: json['userInput'] != null
          ? HandwritingUserInput.fromJson(json['userInput'])
          : null,
      aiMetadata: json['aiMetadata'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      status: json['status'],
      errorMessage: json['errorMessage'],
      metadata: json['metadata'],
    );
  }
}

class HandwritingOverview {
  final int? score;
  final List<String>? tags;

  HandwritingOverview({
    this.score,
    this.tags,
  });

  factory HandwritingOverview.fromJson(Map<String, dynamic> json) {
    return HandwritingOverview(
      score: json['score'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }
}

class HandwritingCategories {
  final HandwritingCategoryDetail? emotionalIntelligence;
  final HandwritingCategoryDetail? ambition;
  final HandwritingCategoryDetail? communication;
  final HandwritingCategoryDetail? creativity;
  final HandwritingCategoryDetail? stability;

  HandwritingCategories({
    this.emotionalIntelligence,
    this.ambition,
    this.communication,
    this.creativity,
    this.stability,
  });

  factory HandwritingCategories.fromJson(Map<String, dynamic> json) {
    return HandwritingCategories(
      emotionalIntelligence: json['emotionalIntelligence'] != null
          ? HandwritingCategoryDetail.fromJson(json['emotionalIntelligence'])
          : null,
      ambition: json['ambition'] != null
          ? HandwritingCategoryDetail.fromJson(json['ambition'])
          : null,
      communication: json['communication'] != null
          ? HandwritingCategoryDetail.fromJson(json['communication'])
          : null,
      creativity: json['creativity'] != null
          ? HandwritingCategoryDetail.fromJson(json['creativity'])
          : null,
      stability: json['stability'] != null
          ? HandwritingCategoryDetail.fromJson(json['stability'])
          : null,
    );
  }
}

class HandwritingCategoryDetail {
  final int? score;
  final String? title;
  final List<String>? keywords;
  final String? description;

  HandwritingCategoryDetail({
    this.score,
    this.title,
    this.keywords,
    this.description,
  });

  factory HandwritingCategoryDetail.fromJson(Map<String, dynamic> json) {
    return HandwritingCategoryDetail(
      score: json['score'],
      title: json['title'],
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : null,
      description: json['description'],
    );
  }
}

class HandwritingFeatures {
  final HandwritingFeature? letterSize;
  final HandwritingFeature? slant;
  final HandwritingFeature? pressure;
  final HandwritingFeature? spacing;
  final HandwritingFeature? baseline;
  final HandwritingFeature? zones;
  final HandwritingFeature? loops;
  final HandwritingFeature? connections;

  HandwritingFeatures({
    this.letterSize,
    this.slant,
    this.pressure,
    this.spacing,
    this.baseline,
    this.zones,
    this.loops,
    this.connections,
  });

  factory HandwritingFeatures.fromJson(Map<String, dynamic> json) {
    return HandwritingFeatures(
      letterSize: json['letterSize'] != null
          ? HandwritingFeature.fromJson(json['letterSize'])
          : null,
      slant: json['slant'] != null
          ? HandwritingFeature.fromJson(json['slant'])
          : null,
      pressure: json['pressure'] != null
          ? HandwritingFeature.fromJson(json['pressure'])
          : null,
      spacing: json['spacing'] != null
          ? HandwritingFeature.fromJson(json['spacing'])
          : null,
      baseline: json['baseline'] != null
          ? HandwritingFeature.fromJson(json['baseline'])
          : null,
      zones: json['zones'] != null
          ? HandwritingFeature.fromJson(json['zones'])
          : null,
      loops: json['loops'] != null
          ? HandwritingFeature.fromJson(json['loops'])
          : null,
      connections: json['connections'] != null
          ? HandwritingFeature.fromJson(json['connections'])
          : null,
    );
  }
}

class HandwritingFeature {
  final String? rating;
  final String? text;

  HandwritingFeature({
    this.rating,
    this.text,
  });

  factory HandwritingFeature.fromJson(Map<String, dynamic> json) {
    return HandwritingFeature(
      rating: json['rating'],
      text: json['text'],
    );
  }
}

class HandwritingLists {
  final List<String>? strengths;
  final List<String>? areasForGrowth;
  final List<String>? careerAptitudes;
  final List<String>? recommendations;

  HandwritingLists({
    this.strengths,
    this.areasForGrowth,
    this.careerAptitudes,
    this.recommendations,
  });

  factory HandwritingLists.fromJson(Map<String, dynamic> json) {
    return HandwritingLists(
      strengths: json['strengths'] != null
          ? List<String>.from(json['strengths'])
          : null,
      areasForGrowth: json['areasForGrowth'] != null
          ? List<String>.from(json['areasForGrowth'])
          : null,
      careerAptitudes: json['careerAptitudes'] != null
          ? List<String>.from(json['careerAptitudes'])
          : null,
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : null,
    );
  }
}

class HandwritingUserInput {
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final String? language;
  final String? additionalNotes;

  HandwritingUserInput({
    this.name,
    this.dateOfBirth,
    this.gender,
    this.language,
    this.additionalNotes,
  });

  factory HandwritingUserInput.fromJson(Map<String, dynamic> json) {
    return HandwritingUserInput(
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      language: json['language'],
      additionalNotes: json['additionalNotes'],
    );
  }
}

class HandwritingHistoryResponse {
  final bool success;
  final String message;
  final List<HandwritingData>? data;
  final HandwritingPagination? pagination;

  HandwritingHistoryResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
  });

  factory HandwritingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return HandwritingHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((item) => HandwritingData.fromJson(item))
              .toList()
          : null,
      pagination: json['pagination'] != null
          ? HandwritingPagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class HandwritingPagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalReadings;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  HandwritingPagination({
    this.currentPage,
    this.totalPages,
    this.totalReadings,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory HandwritingPagination.fromJson(Map<String, dynamic> json) {
    return HandwritingPagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalReadings: json['totalReadings'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
    );
  }
}



