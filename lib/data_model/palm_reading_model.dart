class PalmReadingResponse {
  final bool success;
  final String message;
  final PalmReadingData? data;

  PalmReadingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PalmReadingResponse.fromJson(Map<String, dynamic> json) {
    return PalmReadingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PalmReadingData.fromJson(json['data']) : null,
    );
  }
}

class PalmReadingData {
  final String? readingId;
  final String handType;
  final List<PalmReadingItem> readings;
  final String overallReading;
  final String summary;
  final String? imageUrl;
  final String? processedImageUrl;
  final UserInput? userInput;
  final Map<String, dynamic>? metadata;
  final String? createdAt;
  final String? status;
  final String? errorMessage;

  PalmReadingData({
    this.readingId,
    required this.handType,
    required this.readings,
    required this.overallReading,
    required this.summary,
    this.imageUrl,
    this.processedImageUrl,
    this.userInput,
    this.metadata,
    this.createdAt,
    this.status,
    this.errorMessage,
  });

  factory PalmReadingData.fromJson(Map<String, dynamic> json) {
    return PalmReadingData(
      readingId: json['readingId'] ?? json['_id'] ?? json['id'] ?? '',
      handType: json['handType'] ?? '',
      readings: (json['readings'] as List<dynamic>?)
              ?.map((item) => PalmReadingItem.fromJson(item))
              .toList() ??
          [],
      overallReading: json['overallReading'] ?? '',
      summary: json['summary'] ?? '',
      imageUrl: json['imageUrl'],
      processedImageUrl: json['processedImageUrl'],
      userInput: json['userInput'] != null ? UserInput.fromJson(json['userInput']) : null,
      metadata: json['metadata'],
      createdAt: json['createdAt'],
      status: json['status'],
      errorMessage: json['errorMessage'],
    );
  }
}

class UserInput {
  final String? name;
  final String? dateOfBirth;
  final String? timeOfBirth;
  final String? gender;
  final String? language;

  UserInput({
    this.name,
    this.dateOfBirth,
    this.timeOfBirth,
    this.gender,
    this.language,
  });

  factory UserInput.fromJson(Map<String, dynamic> json) {
    return UserInput(
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      timeOfBirth: json['timeOfBirth'],
      gender: json['gender'],
      language: json['language'],
    );
  }
}

// Legacy model for backward compatibility
class PalmReadingModel {
  final String handType;
  final List<PalmReadingItem> readings;
  final String overallReading;
  final String summary;

  PalmReadingModel({
    required this.handType,
    required this.readings,
    required this.overallReading,
    required this.summary,
  });

  factory PalmReadingModel.fromPalmReadingData(PalmReadingData data) {
    return PalmReadingModel(
      handType: data.handType,
      readings: data.readings,
      overallReading: data.overallReading,
      summary: data.summary,
    );
  }
}

class PalmReadingItem {
  final String category;
  final String interpretation;
  final double? confidence;

  PalmReadingItem({
    required this.category,
    required this.interpretation,
    this.confidence,
  });

  factory PalmReadingItem.fromJson(Map<String, dynamic> json) {
    return PalmReadingItem(
      category: json['category'] ?? '',
      interpretation: json['interpretation'] ?? '',
      confidence: json['confidence']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'interpretation': interpretation,
      if (confidence != null) 'confidence': confidence,
    };
  }
}

class PalmReadingError {
  final bool error;
  final String message;

  PalmReadingError({
    required this.error,
    required this.message,
  });

  factory PalmReadingError.fromJson(Map<String, dynamic> json) {
    return PalmReadingError(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

