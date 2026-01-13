class CarrotAstrologyResponse {
  final bool success;
  final String message;
  final CarrotAstrologyData? data;

  CarrotAstrologyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CarrotAstrologyResponse.fromJson(Map<String, dynamic> json) {
    return CarrotAstrologyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CarrotAstrologyData.fromJson(json['data']) : null,
    );
  }
}

class CarrotAstrologyData {
  final String? readingId;
  final ZodiacInfo? zodiacInfo;
  final VegetableMatch? vegetableMatch;
  final Remedies? remedies;
  final String? overallReading;
  final String? summary;
  final UserInput? userInput;
  final AiMetadata? aiMetadata;
  final String? status;
  final String? errorMessage;
  final String? createdAt;
  final String? updatedAt;

  CarrotAstrologyData({
    this.readingId,
    this.zodiacInfo,
    this.vegetableMatch,
    this.remedies,
    this.overallReading,
    this.summary,
    this.userInput,
    this.aiMetadata,
    this.status,
    this.errorMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory CarrotAstrologyData.fromJson(Map<String, dynamic> json) {
    return CarrotAstrologyData(
      readingId: json['readingId'] ?? json['_id'] ?? json['id'],
      zodiacInfo: json['zodiacInfo'] != null ? ZodiacInfo.fromJson(json['zodiacInfo']) : null,
      vegetableMatch: json['vegetableMatch'] != null ? VegetableMatch.fromJson(json['vegetableMatch']) : null,
      remedies: json['remedies'] != null ? Remedies.fromJson(json['remedies']) : null,
      overallReading: json['overallReading'],
      summary: json['summary'],
      userInput: json['userInput'] != null ? UserInput.fromJson(json['userInput']) : null,
      aiMetadata: json['aiMetadata'] != null ? AiMetadata.fromJson(json['aiMetadata']) : null,
      status: json['status'],
      errorMessage: json['errorMessage'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class CarrotAstrologyHistoryResponse {
  final bool success;
  final String message;
  final List<CarrotAstrologyData> data;
  final PaginationInfo? pagination;

  CarrotAstrologyHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory CarrotAstrologyHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CarrotAstrologyHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => CarrotAstrologyData.fromJson(item))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'])
          : null,
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalReadings;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalReadings,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalReadings: json['totalReadings'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}

class CarrotAstrologyStatsResponse {
  final bool success;
  final String message;
  final CarrotAstrologyStats? data;

  CarrotAstrologyStatsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CarrotAstrologyStatsResponse.fromJson(Map<String, dynamic> json) {
    return CarrotAstrologyStatsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CarrotAstrologyStats.fromJson(json['data']) : null,
    );
  }
}

class CarrotAstrologyStats {
  final int totalReadings;
  final int completedReadings;
  final int failedReadings;
  final String? firstReading;
  final String? lastReading;
  final List<ZodiacDistribution>? zodiacDistribution;

  CarrotAstrologyStats({
    required this.totalReadings,
    required this.completedReadings,
    required this.failedReadings,
    this.firstReading,
    this.lastReading,
    this.zodiacDistribution,
  });

  factory CarrotAstrologyStats.fromJson(Map<String, dynamic> json) {
    return CarrotAstrologyStats(
      totalReadings: json['totalReadings'] ?? 0,
      completedReadings: json['completedReadings'] ?? 0,
      failedReadings: json['failedReadings'] ?? 0,
      firstReading: json['firstReading'],
      lastReading: json['lastReading'],
      zodiacDistribution: json['zodiacDistribution'] != null
          ? (json['zodiacDistribution'] as List<dynamic>)
              .map((item) => ZodiacDistribution.fromJson(item))
              .toList()
          : null,
    );
  }
}

class ZodiacDistribution {
  final String sign;
  final int count;

  ZodiacDistribution({
    required this.sign,
    required this.count,
  });

  factory ZodiacDistribution.fromJson(Map<String, dynamic> json) {
    return ZodiacDistribution(
      sign: json['sign'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class ZodiacInfo {
  final String? sign;
  final List<String>? traits;
  final String? rulingPlanet;
  final String? element;
  final String? vegetableEssence;

  ZodiacInfo({
    this.sign,
    this.traits,
    this.rulingPlanet,
    this.element,
    this.vegetableEssence,
  });

  factory ZodiacInfo.fromJson(Map<String, dynamic> json) {
    return ZodiacInfo(
      sign: json['sign'],
      traits: json['traits'] != null ? List<String>.from(json['traits']) : null,
      rulingPlanet: json['rulingPlanet'],
      element: json['element'],
      vegetableEssence: json['vegetableEssence'],
    );
  }
}

class VegetableMatch {
  final String? name;
  final String? essenceDescription;
  final String? symbolism;

  VegetableMatch({
    this.name,
    this.essenceDescription,
    this.symbolism,
  });

  factory VegetableMatch.fromJson(Map<String, dynamic> json) {
    return VegetableMatch(
      name: json['name'],
      essenceDescription: json['essenceDescription'],
      symbolism: json['symbolism'],
    );
  }
}

class Remedies {
  final List<String>? food;
  final List<String>? lifestyle;
  final List<String>? meditation;
  final List<String>? colorStone;

  Remedies({
    this.food,
    this.lifestyle,
    this.meditation,
    this.colorStone,
  });

  factory Remedies.fromJson(Map<String, dynamic> json) {
    return Remedies(
      food: json['food'] != null ? List<String>.from(json['food']) : null,
      lifestyle: json['lifestyle'] != null ? List<String>.from(json['lifestyle']) : null,
      meditation: json['meditation'] != null ? List<String>.from(json['meditation']) : null,
      colorStone: json['colorStone'] != null ? List<String>.from(json['colorStone']) : null,
    );
  }
}

class UserInput {
  final String? zodiacSign;
  final String? language;

  UserInput({
    this.zodiacSign,
    this.language,
  });

  factory UserInput.fromJson(Map<String, dynamic> json) {
    return UserInput(
      zodiacSign: json['zodiacSign'],
      language: json['language'],
    );
  }
}

class AiMetadata {
  final String? model;
  final int? responseTime;
  final Map<String, dynamic>? tokens;

  AiMetadata({
    this.model,
    this.responseTime,
    this.tokens,
  });

  factory AiMetadata.fromJson(Map<String, dynamic> json) {
    return AiMetadata(
      model: json['model'],
      responseTime: json['responseTime'],
      tokens: json['tokens'],
    );
  }
}

