class PrashnaQuestionResponse {
  final bool success;
  final String message;
  final List<PrashnaQuestion> data;

  PrashnaQuestionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PrashnaQuestionResponse.fromJson(Map<String, dynamic> json) =>
      PrashnaQuestionResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<PrashnaQuestion>.from(
                json["data"].map((x) => PrashnaQuestion.fromJson(x)),
              ),
      );
}

class PrashnaQuestion {
  final int id;
  final String question;
  final String category;
  final String description;

  PrashnaQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.description,
  });

  factory PrashnaQuestion.fromJson(Map<String, dynamic> json) =>
      PrashnaQuestion(
        id: json["id"] ?? 0,
        question: json["question"] ?? "",
        category: json["category"] ?? "",
        description: json["description"] ?? "",
      );
}

class PrashnaAnalysisRequest {
  final int questionId;
  final PrashnaLocation location;

  PrashnaAnalysisRequest({required this.questionId, required this.location});

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "location": location.toJson(),
  };
}

class PrashnaLocation {
  final String city;
  final double latitude;
  final double longitude;
  final double timezone;

  PrashnaLocation({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  Map<String, dynamic> toJson() => {
    "city": city,
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezone,
  };

  factory PrashnaLocation.fromJson(Map<String, dynamic> json) =>
      PrashnaLocation(
        city: json["city"] ?? "",
        latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
        longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
        timezone: (json["timezone"] as num?)?.toDouble() ?? 5.5,
      );
}

class PrashnaReadingResponse {
  final bool success;
  final String message;
  final PrashnaReading? data;

  PrashnaReadingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PrashnaReadingResponse.fromJson(Map<String, dynamic> json) =>
      PrashnaReadingResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : PrashnaReading.fromJson(json["data"]),
      );
}

class PrashnaReading {
  final String readingId;
  final String questionAsked;
  final String questionCategory;
  final DateTime? askTime;
  final String city;
  final PrashnaInsights? prashnaInsights;
  final List<PrashnaInterpretation> readings;
  final String answerToQuestion;
  final String timingAdvice;
  final String overallReading;
  final String summary;
  final PrashnaRemedies? remedies;
  final AiMetadata? aiMetadata;
  final DateTime? createdAt;

  PrashnaReading({
    required this.readingId,
    required this.questionAsked,
    required this.questionCategory,
    this.askTime,
    required this.city,
    this.prashnaInsights,
    required this.readings,
    required this.answerToQuestion,
    required this.timingAdvice,
    required this.overallReading,
    required this.summary,
    this.remedies,
    this.aiMetadata,
    this.createdAt,
  });

  factory PrashnaReading.fromJson(Map<String, dynamic> json) {
    // Handle both direct data structure and nested structure (from history)
    Map<String, dynamic> data = json;

    // In history API, location is nested
    String city = "";
    if (data["location"] != null && data["location"] is Map) {
      city = data["location"]["city"] ?? "";
    } else if (data["userInput"] != null &&
        data["userInput"]["location"] != null) {
      city = data["userInput"]["location"]["city"] ?? "";
    }

    return PrashnaReading(
      readingId: data["readingId"] ?? data["_id"] ?? "",
      questionAsked:
          data["questionAsked"] ??
          (data["userInput"] != null ? data["userInput"]["questionText"] : ""),
      questionCategory:
          data["questionCategory"] ??
          (data["userInput"] != null
              ? data["userInput"]["questionCategory"]
              : ""),
      askTime: data["askTime"] != null
          ? DateTime.parse(data["askTime"])
          : (data["userInput"] != null && data["userInput"]["askTime"] != null
                ? DateTime.parse(data["userInput"]["askTime"])
                : null),
      city: city,
      prashnaInsights: data["prashnaInsights"] == null
          ? null
          : PrashnaInsights.fromJson(data["prashnaInsights"]),
      readings: data["readings"] == null
          ? []
          : List<PrashnaInterpretation>.from(
              data["readings"].map((x) => PrashnaInterpretation.fromJson(x)),
            ),
      answerToQuestion: data["answerToQuestion"] ?? "",
      timingAdvice: data["timingAdvice"] ?? "",
      overallReading: data["overallReading"] ?? "",
      summary: data["summary"] ?? "",
      remedies: data["remedies"] == null
          ? null
          : PrashnaRemedies.fromJson(data["remedies"]),
      aiMetadata: data["aiMetadata"] == null
          ? null
          : AiMetadata.fromJson(data["aiMetadata"]),
      createdAt: data["createdAt"] == null
          ? null
          : DateTime.parse(data["createdAt"]),
    );
  }
}

class PrashnaInsights {
  final String lagnaAnalysis;
  final String moonPosition;
  final String planetaryInfluence;
  final String horaLord;
  final String currentDasha;

  PrashnaInsights({
    required this.lagnaAnalysis,
    required this.moonPosition,
    required this.planetaryInfluence,
    required this.horaLord,
    required this.currentDasha,
  });

  factory PrashnaInsights.fromJson(Map<String, dynamic> json) =>
      PrashnaInsights(
        lagnaAnalysis: json["lagnaAnalysis"] ?? "",
        moonPosition: json["moonPosition"] ?? "",
        planetaryInfluence: json["planetaryInfluence"] ?? "",
        horaLord: json["horaLord"] ?? "",
        currentDasha: json["currentDasha"] ?? "",
      );
}

class PrashnaInterpretation {
  final String category;
  final String interpretation;

  PrashnaInterpretation({required this.category, required this.interpretation});

  factory PrashnaInterpretation.fromJson(Map<String, dynamic> json) =>
      PrashnaInterpretation(
        category: json["category"] ?? "",
        interpretation: json["interpretation"] ?? "",
      );
}

class PrashnaRemedies {
  final List<String> mantras;
  final List<String> charities;
  final List<String> behaviors;
  final List<String> practicalAdvice;
  final List<String> gemstones;
  final List<String> colors;

  PrashnaRemedies({
    required this.mantras,
    required this.charities,
    required this.behaviors,
    required this.practicalAdvice,
    required this.gemstones,
    required this.colors,
  });

  factory PrashnaRemedies.fromJson(Map<String, dynamic> json) =>
      PrashnaRemedies(
        mantras: json["mantras"] == null
            ? []
            : List<String>.from(json["mantras"].map((x) => x)),
        charities: json["charities"] == null
            ? []
            : List<String>.from(json["charities"].map((x) => x)),
        behaviors: json["behaviors"] == null
            ? []
            : List<String>.from(json["behaviors"].map((x) => x)),
        practicalAdvice: json["practicalAdvice"] == null
            ? []
            : List<String>.from(json["practicalAdvice"].map((x) => x)),
        gemstones: json["gemstones"] == null
            ? []
            : List<String>.from(json["gemstones"].map((x) => x)),
        colors: json["colors"] == null
            ? []
            : List<String>.from(json["colors"].map((x) => x)),
      );
}

class AiMetadata {
  final String model;
  final int responseTime;

  AiMetadata({required this.model, required this.responseTime});

  factory AiMetadata.fromJson(Map<String, dynamic> json) => AiMetadata(
    model: json["model"] ?? "",
    responseTime: json["responseTime"] ?? 0,
  );
}

class PrashnaHistoryResponse {
  final bool success;
  final String message;
  final List<PrashnaReading> data;
  final Pagination? pagination;

  PrashnaHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory PrashnaHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PrashnaHistoryResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<PrashnaReading>.from(
                json["data"].map((x) => PrashnaReading.fromJson(x)),
              ),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalReadings;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalReadings,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["currentPage"] ?? 1,
    totalPages: json["totalPages"] ?? 1,
    totalReadings: json["totalReadings"] ?? 0,
    hasNextPage: json["hasNextPage"] ?? false,
    hasPrevPage: json["hasPrevPage"] ?? false,
  );
}
