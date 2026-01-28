// Ramal Shastra Data Models

class RamalShastraResponse {
  final bool success;
  final String message;
  final RamalShastraData? data;

  RamalShastraResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RamalShastraResponse.fromJson(Map<String, dynamic> json) {
    return RamalShastraResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RamalShastraData.fromJson(json['data']) : null,
    );
  }
}

class RamalShastraData {
  final String? readingId;
  final String? question;
  final String? category;
  final RamalJudgment? judgment;
  final RamalInterpretation? interpretation;
  final RamalChart? chart;
  final RamalChartData? chartData;
  final RamalAIMetadata? aiMetadata;
  final String? createdAt;
  final String? status;
  final String? errorMessage;

  RamalShastraData({
    this.readingId,
    this.question,
    this.category,
    this.judgment,
    this.interpretation,
    this.chart,
    this.chartData,
    this.aiMetadata,
    this.createdAt,
    this.status,
    this.errorMessage,
  });

  factory RamalShastraData.fromJson(Map<String, dynamic> json) {
    return RamalShastraData(
      readingId: json['readingId'] ?? json['_id'] ?? json['id'],
      question: json['question'],
      category: json['category'],
      judgment: json['judgment'] != null ? RamalJudgment.fromJson(json['judgment']) : null,
      interpretation: json['interpretation'] != null ? RamalInterpretation.fromJson(json['interpretation']) : null,
      chart: json['chart'] != null ? RamalChart.fromJson(json['chart']) : null,
      chartData: json['chartData'] != null ? RamalChartData.fromJson(json['chartData']) : null,
      aiMetadata: json['aiMetadata'] != null ? RamalAIMetadata.fromJson(json['aiMetadata']) : null,
      createdAt: json['createdAt'],
      status: json['status'],
      errorMessage: json['errorMessage'],
    );
  }
}

class RamalJudgment {
  final String? outcome;
  final double? confidence;
  final String? explanation;
  final int? judgeStrength;
  final int? reconcilerStrength;

  RamalJudgment({
    this.outcome,
    this.confidence,
    this.explanation,
    this.judgeStrength,
    this.reconcilerStrength,
  });

  factory RamalJudgment.fromJson(Map<String, dynamic> json) {
    return RamalJudgment(
      outcome: json['outcome'],
      confidence: (json['confidence'] as num?)?.toDouble(),
      explanation: json['explanation'],
      judgeStrength: json['judgeStrength'],
      reconcilerStrength: json['reconcilerStrength'],
    );
  }
}

class RamalJudgmentSummary {
  final String? outcome;
  final double? confidence;
  final String? explanation;

  RamalJudgmentSummary({
    this.outcome,
    this.confidence,
    this.explanation,
  });

  factory RamalJudgmentSummary.fromJson(Map<String, dynamic> json) {
    return RamalJudgmentSummary(
      outcome: json['outcome'],
      confidence: (json['confidence'] as num?)?.toDouble(),
      explanation: json['explanation'],
    );
  }
}

class RamalInterpretation {
  final RamalJudgmentSummary? judgmentSummary;
  final String? answerToQuestion;
  final List<RamalKeyHouse>? keyHouses;
  final String? summary;
  final String? detailedAnalysis;
  final String? timing;
  final List<String>? strengths;
  final List<String>? challenges;
  final List<String>? advice;
  final RamalRemedies? remedies;

  RamalInterpretation({
    this.judgmentSummary,
    this.answerToQuestion,
    this.keyHouses,
    this.summary,
    this.detailedAnalysis,
    this.timing,
    this.strengths,
    this.challenges,
    this.advice,
    this.remedies,
  });

  factory RamalInterpretation.fromJson(Map<String, dynamic> json) {
    return RamalInterpretation(
      judgmentSummary: json['judgmentSummary'] != null ? RamalJudgmentSummary.fromJson(json['judgmentSummary']) : null,
      answerToQuestion: json['answerToQuestion'],
      keyHouses: json['keyHouses'] != null ? (json['keyHouses'] as List).map((e) => RamalKeyHouse.fromJson(e)).toList() : null,
      summary: json['summary'],
      detailedAnalysis: json['detailedAnalysis'],
      timing: json['timing'],
      strengths: json['strengths'] != null ? List<String>.from(json['strengths']) : null,
      challenges: json['challenges'] != null ? List<String>.from(json['challenges']) : null,
      advice: json['advice'] != null ? List<String>.from(json['advice']) : null,
      remedies: json['remedies'] != null ? RamalRemedies.fromJson(json['remedies']) : null,
    );
  }
}

class RamalKeyHouse {
  final int? houseNumber;
  final String? name;
  final String? element;
  final int? strength;
  final String? interpretation;

  RamalKeyHouse({
    this.houseNumber,
    this.name,
    this.element,
    this.strength,
    this.interpretation,
  });

  factory RamalKeyHouse.fromJson(Map<String, dynamic> json) {
    return RamalKeyHouse(
      houseNumber: json['houseNumber'],
      name: json['name'],
      element: json['element'],
      strength: json['strength'],
      interpretation: json['interpretation'],
    );
  }
}

class RamalChart {
  final List<RamalHouse>? houses;
  final RamalRelationships? relationships;

  RamalChart({
    this.houses,
    this.relationships,
  });

  factory RamalChart.fromJson(Map<String, dynamic> json) {
    return RamalChart(
      houses: json['houses'] != null ? (json['houses'] as List).map((e) => RamalHouse.fromJson(e)).toList() : null,
      relationships: json['relationships'] != null ? RamalRelationships.fromJson(json['relationships']) : null,
    );
  }
}

class RamalChartData {
  final List<RamalHouseDetailed>? houses;
  final List<List<int>>? matrix;
  final List<List<int>>? shakals;
  final RamalRelationships? relationships;

  RamalChartData({
    this.houses,
    this.matrix,
    this.shakals,
    this.relationships,
  });

  factory RamalChartData.fromJson(Map<String, dynamic> json) {
    return RamalChartData(
      houses: json['houses'] != null ? (json['houses'] as List).map((e) => RamalHouseDetailed.fromJson(e)).toList() : null,
      matrix: json['matrix'] != null ? (json['matrix'] as List).map((e) => List<int>.from(e)).toList() : null,
      shakals: json['shakals'] != null ? (json['shakals'] as List).map((e) => List<int>.from(e)).toList() : null,
      relationships: json['relationships'] != null ? RamalRelationships.fromJson(json['relationships']) : null,
    );
  }
}

class RamalHouse {
  final int? houseNumber;
  final String? name;
  final String? element;
  final int? strength;
  final bool? isJudge;
  final bool? isReconciler;

  RamalHouse({
    this.houseNumber,
    this.name,
    this.element,
    this.strength,
    this.isJudge,
    this.isReconciler,
  });

  factory RamalHouse.fromJson(Map<String, dynamic> json) {
    return RamalHouse(
      houseNumber: json['houseNumber'],
      name: json['name'],
      element: json['element'],
      strength: json['strength'],
      isJudge: json['isJudge'],
      isReconciler: json['isReconciler'],
    );
  }
}

class RamalHouseDetailed {
  final int? houseNumber;
  final String? name;
  final String? type;
  final String? element;
  final String? gender;
  final int? strength;
  final String? meaning;
  final String? domain;
  final List<int>? shakal;
  final List<String>? keywords;

  RamalHouseDetailed({
    this.houseNumber,
    this.name,
    this.type,
    this.element,
    this.gender,
    this.strength,
    this.meaning,
    this.domain,
    this.shakal,
    this.keywords,
  });

  factory RamalHouseDetailed.fromJson(Map<String, dynamic> json) {
    return RamalHouseDetailed(
      houseNumber: json['houseNumber'],
      name: json['name'],
      type: json['type'],
      element: json['element'],
      gender: json['gender'],
      strength: json['strength'],
      meaning: json['meaning'],
      domain: json['domain'],
      shakal: json['shakal'] != null ? List<int>.from(json['shakal']) : null,
      keywords: json['keywords'] != null ? List<String>.from(json['keywords']) : null,
    );
  }
}

class RamalRelationships {
  final Map<String, int>? elementDistribution;
  final List<int>? strongHouses;
  final List<int>? weakHouses;
  final List<int>? neutralHouses;
  final List<int>? fireHouses;
  final List<int>? waterHouses;

  RamalRelationships({
    this.elementDistribution,
    this.strongHouses,
    this.weakHouses,
    this.neutralHouses,
    this.fireHouses,
    this.waterHouses,
  });

  factory RamalRelationships.fromJson(Map<String, dynamic> json) {
    return RamalRelationships(
      elementDistribution: json['elementDistribution'] != null ? Map<String, int>.from(json['elementDistribution']) : null,
      strongHouses: json['strongHouses'] != null ? List<int>.from(json['strongHouses']) : null,
      weakHouses: json['weakHouses'] != null ? List<int>.from(json['weakHouses']) : null,
      neutralHouses: json['neutralHouses'] != null ? List<int>.from(json['neutralHouses']) : null,
      fireHouses: json['fireHouses'] != null ? List<int>.from(json['fireHouses']) : null,
      waterHouses: json['waterHouses'] != null ? List<int>.from(json['waterHouses']) : null,
    );
  }
}

class RamalRemedies {
  final List<String>? mantras;
  final List<String>? charities;
  final List<String>? behaviors;
  final List<String>? practicalAdvice;
  final List<String>? colors;

  RamalRemedies({
    this.mantras,
    this.charities,
    this.behaviors,
    this.practicalAdvice,
    this.colors,
  });

  factory RamalRemedies.fromJson(Map<String, dynamic> json) {
    return RamalRemedies(
      mantras: json['mantras'] != null ? List<String>.from(json['mantras']) : null,
      charities: json['charities'] != null ? List<String>.from(json['charities']) : null,
      behaviors: json['behaviors'] != null ? List<String>.from(json['behaviors']) : null,
      practicalAdvice: json['practicalAdvice'] != null ? List<String>.from(json['practicalAdvice']) : null,
      colors: json['colors'] != null ? List<String>.from(json['colors']) : null,
    );
  }
}

class RamalAIMetadata {
  final String? model;
  final int? responseTime;
  final RamalTokens? tokens;

  RamalAIMetadata({
    this.model,
    this.responseTime,
    this.tokens,
  });

  factory RamalAIMetadata.fromJson(Map<String, dynamic> json) {
    return RamalAIMetadata(
      model: json['model'],
      responseTime: json['responseTime'],
      tokens: json['tokens'] != null ? RamalTokens.fromJson(json['tokens']) : null,
    );
  }
}

class RamalTokens {
  final int? prompt;
  final int? completion;
  final int? total;

  RamalTokens({
    this.prompt,
    this.completion,
    this.total,
  });

  factory RamalTokens.fromJson(Map<String, dynamic> json) {
    return RamalTokens(
      prompt: json['prompt'],
      completion: json['completion'],
      total: json['total'],
    );
  }
}

// History Response Models
class RamalHistoryResponse {
  final bool success;
  final String message;
  final RamalHistoryData? data;
  final RamalPagination? pagination;

  RamalHistoryResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
  });

  factory RamalHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RamalHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RamalHistoryData.fromJson(json['data']) : null,
      pagination: json['pagination'] != null ? RamalPagination.fromJson(json['pagination']) : null,
    );
  }
}

class RamalHistoryData {
  final List<RamalShastraData> readings;

  RamalHistoryData({
    required this.readings,
  });

  factory RamalHistoryData.fromJson(Map<String, dynamic> json) {
    return RamalHistoryData(
      readings: (json['readings'] as List<dynamic>?)
              ?.map((item) => RamalShastraData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class RamalPagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? itemsPerPage;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  RamalPagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory RamalPagination.fromJson(Map<String, dynamic> json) {
    return RamalPagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      itemsPerPage: json['itemsPerPage'],
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
    );
  }
}

// Stats Response Models
class RamalStatsResponse {
  final bool success;
  final String message;
  final RamalStatsData? data;

  RamalStatsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RamalStatsResponse.fromJson(Map<String, dynamic> json) {
    return RamalStatsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RamalStatsData.fromJson(json['data']) : null,
    );
  }
}

class RamalStatsData {
  final int? totalReadings;
  final int? completedReadings;
  final int? failedReadings;
  final List<RamalCategoryDistribution>? categoryDistribution;
  final List<RamalJudgmentDistribution>? judgmentDistribution;

  RamalStatsData({
    this.totalReadings,
    this.completedReadings,
    this.failedReadings,
    this.categoryDistribution,
    this.judgmentDistribution,
  });

  factory RamalStatsData.fromJson(Map<String, dynamic> json) {
    return RamalStatsData(
      totalReadings: json['totalReadings'],
      completedReadings: json['completedReadings'],
      failedReadings: json['failedReadings'],
      categoryDistribution: json['categoryDistribution'] != null
          ? (json['categoryDistribution'] as List).map((e) => RamalCategoryDistribution.fromJson(e)).toList()
          : null,
      judgmentDistribution: json['judgmentDistribution'] != null
          ? (json['judgmentDistribution'] as List).map((e) => RamalJudgmentDistribution.fromJson(e)).toList()
          : null,
    );
  }
}

class RamalCategoryDistribution {
  final String? category;
  final int? count;

  RamalCategoryDistribution({
    this.category,
    this.count,
  });

  factory RamalCategoryDistribution.fromJson(Map<String, dynamic> json) {
    return RamalCategoryDistribution(
      category: json['category'],
      count: json['count'],
    );
  }
}

class RamalJudgmentDistribution {
  final String? outcome;
  final int? count;

  RamalJudgmentDistribution({
    this.outcome,
    this.count,
  });

  factory RamalJudgmentDistribution.fromJson(Map<String, dynamic> json) {
    return RamalJudgmentDistribution(
      outcome: json['outcome'],
      count: json['count'],
    );
  }
}
