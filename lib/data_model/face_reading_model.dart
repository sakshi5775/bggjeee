class FaceReadingResponse {
  final bool success;
  final String message;
  final FaceReadingData? data;

  FaceReadingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory FaceReadingResponse.fromJson(Map<String, dynamic> json) {
    return FaceReadingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? FaceReadingData.fromJson(json['data']) : null,
    );
  }
}

class FaceReadingData {
  final String? readingId;
  final String? faceShape;
  final List<FaceReadingCategory> readings;
  final String? overallReading;
  final String? summary;
  final List<String>? keyRemedies;
  final FaceReadingDetailedAnalysis? detailedAnalysis;
  final String? imageUrl;
  final UserInput? userInput;
  final Map<String, dynamic>? metadata;
  final String? createdAt;
  final String? errorMessage;
  final String? status;

  FaceReadingData({
    this.readingId,
    this.faceShape,
    required this.readings,
    this.overallReading,
    this.summary,
    this.keyRemedies,
    this.detailedAnalysis,
    this.imageUrl,
    this.userInput,
    this.metadata,
    this.createdAt,
    this.errorMessage,
    this.status,
  });

  factory FaceReadingData.fromJson(Map<String, dynamic> json) {
    return FaceReadingData(
      readingId: json['readingId'] ?? json['_id'] ?? json['id'],
      faceShape: json['faceShape'],
      readings: (json['readings'] as List<dynamic>?)
              ?.map((item) => FaceReadingCategory.fromJson(item))
              .toList() ??
          [],
      overallReading: json['overallReading'],
      summary: json['summary'],
      keyRemedies: json['keyRemedies'] != null
          ? List<String>.from(json['keyRemedies'])
          : null,
      detailedAnalysis: json['detailedAnalysis'] != null
          ? FaceReadingDetailedAnalysis.fromJson(json['detailedAnalysis'])
          : null,
      imageUrl: json['imageUrl'],
      userInput: json['userInput'] != null
          ? UserInput.fromJson(json['userInput'])
          : null,
      metadata: json['metadata'],
      createdAt: json['createdAt'],
      errorMessage: json['errorMessage'],
      status: json['status'],
    );
  }
}

class FaceReadingCategory {
  final String category;
  final String? interpretation;
  final bool? hasIssue;
  final String? issueDescription;
  final String? remedy;

  FaceReadingCategory({
    required this.category,
    this.interpretation,
    this.hasIssue,
    this.issueDescription,
    this.remedy,
  });

  factory FaceReadingCategory.fromJson(Map<String, dynamic> json) {
    return FaceReadingCategory(
      category: json['category'] ?? '',
      interpretation: json['interpretation'],
      hasIssue: json['hasIssue'],
      issueDescription: json['issueDescription'],
      remedy: json['remedy'],
    );
  }
}

class FaceReadingDetailedAnalysis {
  final FaceReadingOverview? overview;
  final FaceReadingCategories? categories;
  final FaceReadingFeatures? features;
  final FaceReadingLists? lists;

  FaceReadingDetailedAnalysis({
    this.overview,
    this.categories,
    this.features,
    this.lists,
  });

  factory FaceReadingDetailedAnalysis.fromJson(Map<String, dynamic> json) {
    return FaceReadingDetailedAnalysis(
      overview: json['overview'] != null
          ? FaceReadingOverview.fromJson(json['overview'])
          : null,
      categories: json['categories'] != null
          ? FaceReadingCategories.fromJson(json['categories'])
          : null,
      features: json['features'] != null
          ? FaceReadingFeatures.fromJson(json['features'])
          : null,
      lists: json['lists'] != null
          ? FaceReadingLists.fromJson(json['lists'])
          : null,
    );
  }
}

class FaceReadingOverview {
  final int? score;
  final List<String>? tags;

  FaceReadingOverview({
    this.score,
    this.tags,
  });

  factory FaceReadingOverview.fromJson(Map<String, dynamic> json) {
    return FaceReadingOverview(
      score: json['score'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }
}

class FaceReadingCategories {
  final FaceReadingCategoryDetail? personality;
  final FaceReadingCategoryDetail? career;
  final FaceReadingCategoryDetail? love;
  final FaceReadingCategoryDetail? wealth;
  final FaceReadingCategoryDetail? health;

  FaceReadingCategories({
    this.personality,
    this.career,
    this.love,
    this.wealth,
    this.health,
  });

  factory FaceReadingCategories.fromJson(Map<String, dynamic> json) {
    return FaceReadingCategories(
      personality: json['personality'] != null
          ? FaceReadingCategoryDetail.fromJson(json['personality'])
          : null,
      career: json['career'] != null
          ? FaceReadingCategoryDetail.fromJson(json['career'])
          : null,
      love: json['love'] != null
          ? FaceReadingCategoryDetail.fromJson(json['love'])
          : null,
      wealth: json['wealth'] != null
          ? FaceReadingCategoryDetail.fromJson(json['wealth'])
          : null,
      health: json['health'] != null
          ? FaceReadingCategoryDetail.fromJson(json['health'])
          : null,
    );
  }
}

class FaceReadingCategoryDetail {
  final int? score;
  final String? title;
  final List<String>? keywords;
  final String? description;

  FaceReadingCategoryDetail({
    this.score,
    this.title,
    this.keywords,
    this.description,
  });

  factory FaceReadingCategoryDetail.fromJson(Map<String, dynamic> json) {
    return FaceReadingCategoryDetail(
      score: json['score'],
      title: json['title'],
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : null,
      description: json['description'],
    );
  }
}

class FaceReadingFeatures {
  final FaceReadingFeature? forehead;
  final FaceReadingFeature? eyes;
  final FaceReadingFeature? nose;
  final FaceReadingFeature? mouth;
  final FaceReadingFeature? chin;
  final FaceReadingFeature? faceShape;

  FaceReadingFeatures({
    this.forehead,
    this.eyes,
    this.nose,
    this.mouth,
    this.chin,
    this.faceShape,
  });

  factory FaceReadingFeatures.fromJson(Map<String, dynamic> json) {
    return FaceReadingFeatures(
      forehead: json['forehead'] != null
          ? FaceReadingFeature.fromJson(json['forehead'])
          : null,
      eyes: json['eyes'] != null
          ? FaceReadingFeature.fromJson(json['eyes'])
          : null,
      nose: json['nose'] != null
          ? FaceReadingFeature.fromJson(json['nose'])
          : null,
      mouth: json['mouth'] != null
          ? FaceReadingFeature.fromJson(json['mouth'])
          : null,
      chin: json['chin'] != null
          ? FaceReadingFeature.fromJson(json['chin'])
          : null,
      faceShape: json['faceShape'] != null
          ? FaceReadingFeature.fromJson(json['faceShape'])
          : null,
    );
  }
}

class FaceReadingFeature {
  final String? rating;
  final String? text;

  FaceReadingFeature({
    this.rating,
    this.text,
  });

  factory FaceReadingFeature.fromJson(Map<String, dynamic> json) {
    return FaceReadingFeature(
      rating: json['rating'],
      text: json['text'],
    );
  }
}

class FaceReadingLists {
  final List<String>? strengths;
  final List<String>? areasForGrowth;
  final List<String>? socialTraits;
  final List<String>? recommendations;

  FaceReadingLists({
    this.strengths,
    this.areasForGrowth,
    this.socialTraits,
    this.recommendations,
  });

  factory FaceReadingLists.fromJson(Map<String, dynamic> json) {
    return FaceReadingLists(
      strengths: json['strengths'] != null
          ? List<String>.from(json['strengths'])
          : null,
      areasForGrowth: json['areasForGrowth'] != null
          ? List<String>.from(json['areasForGrowth'])
          : null,
      socialTraits: json['socialTraits'] != null
          ? List<String>.from(json['socialTraits'])
          : null,
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : null,
    );
  }
}

class UserInput {
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final int? age;
  final String? language;

  UserInput({
    this.name,
    this.dateOfBirth,
    this.gender,
    this.age,
    this.language,
  });

  factory UserInput.fromJson(Map<String, dynamic> json) {
    return UserInput(
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      age: json['age'],
      language: json['language'],
    );
  }
}

class FaceReadingHistoryResponse {
  final bool success;
  final String message;
  final FaceReadingHistoryData? data;

  FaceReadingHistoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory FaceReadingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return FaceReadingHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? FaceReadingHistoryData.fromJson(json['data']) : null,
    );
  }
}

class FaceReadingHistoryData {
  final List<FaceReadingData> readings;
  final PaginationInfo? pagination;

  FaceReadingHistoryData({
    required this.readings,
    this.pagination,
  });

  factory FaceReadingHistoryData.fromJson(Map<String, dynamic> json) {
    return FaceReadingHistoryData(
      readings: (json['readings'] as List<dynamic>?)
              ?.map((item) => FaceReadingData.fromJson(item))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'])
          : null,
    );
  }
}

class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
    );
  }
}

