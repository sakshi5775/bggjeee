/// Yes/No Reading Response Model
class TarotYesNoResponse {
  final bool success;
  final String? id;
  final String? name;
  final String? direction;
  final String meaning; // "Yes" or "No"
  final String description;
  final Map<String, String> cardImage;
  final Map<String, String> cardImagesBack;
  final int? remainingApiCalls;

  TarotYesNoResponse({
    required this.success,
    this.id,
    this.name,
    this.direction,
    required this.meaning,
    required this.description,
    required this.cardImage,
    required this.cardImagesBack,
    this.remainingApiCalls,
  });

  factory TarotYesNoResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotYesNoResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      direction: response['direction']?.toString(),
      meaning: response['meaning']?.toString() ?? '',
      description: response['description']?.toString() ?? '',
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Career Guidance Response Model
class TarotCareerResponse {
  final bool success;
  final String? id;
  final String? name;
  final String? direction;
  final String description;
  final List<String> careerPaths;
  final Map<String, String> cardImage;
  final Map<String, String> cardImagesBack;
  final int? remainingApiCalls;

  TarotCareerResponse({
    required this.success,
    this.id,
    this.name,
    this.direction,
    required this.description,
    required this.careerPaths,
    required this.cardImage,
    required this.cardImagesBack,
    this.remainingApiCalls,
  });

  factory TarotCareerResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotCareerResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      direction: response['direction']?.toString(),
      description: response['description']?.toString() ?? '',
      careerPaths: response['careerPaths'] is List
          ? List<String>.from(
              (response['careerPaths'] as List).map((e) => e.toString()),
            )
          : [],
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Love Triangle Response Model
class TarotLoveTriangleResponse {
  final bool success;
  final TarotLoveCard self;
  final TarotLoveCard lover1;
  final TarotLoveCard lover2;
  final Map<String, String> cardImagesBack;
  final int? remainingApiCalls;

  TarotLoveTriangleResponse({
    required this.success,
    required this.self,
    required this.lover1,
    required this.lover2,
    required this.cardImagesBack,
    this.remainingApiCalls,
  });

  factory TarotLoveTriangleResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    final selfData = response['self'];
    final lover1Data = response['lover1'];
    final lover2Data = response['lover2'];
    
    return TarotLoveTriangleResponse(
      success: json['status'] == 200 || json['success'] == true,
      self: selfData is Map<String, dynamic>
          ? TarotLoveCard.fromJson(selfData)
          : TarotLoveCard(
              id: selfData?['id']?.toString() ?? '',
              name: selfData?['name']?.toString() ?? '',
              description: selfData?['description']?.toString() ?? '',
              traits: [],
              cardImage: {},
            ),
      lover1: lover1Data is Map<String, dynamic>
          ? TarotLoveCard.fromJson(lover1Data)
          : TarotLoveCard(
              id: lover1Data?['id']?.toString() ?? '',
              name: lover1Data?['name']?.toString() ?? '',
              description: lover1Data?['description']?.toString() ?? '',
              traits: [],
              cardImage: {},
            ),
      lover2: lover2Data is Map<String, dynamic>
          ? TarotLoveCard.fromJson(lover2Data)
          : TarotLoveCard(
              id: lover2Data?['id']?.toString() ?? '',
              name: lover2Data?['name']?.toString() ?? '',
              description: lover2Data?['description']?.toString() ?? '',
              traits: [],
              cardImage: {},
            ),
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Love Card Model (used in triangle and other love readings)
class TarotLoveCard {
  final String id;
  final String name;
  final String description;
  final List<String> traits;
  final Map<String, String> cardImage;

  TarotLoveCard({
    required this.id,
    required this.name,
    required this.description,
    required this.traits,
    required this.cardImage,
  });

  factory TarotLoveCard.fromJson(Map<String, dynamic> json) {
    return TarotLoveCard(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      traits: json['traits'] is List
          ? List<String>.from(
              (json['traits'] as List).map((e) => e.toString()),
            )
          : [],
      cardImage: json['card_image'] is Map
          ? Map<String, String>.from(
              json['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
    );
  }
}

/// In-Depth Love Response Model
class TarotInDepthLoveResponse {
  final bool success;
  final String? id;
  final String? name;
  final String description;
  final Map<String, String> cardImage;
  final Map<String, String> cardImagesBack;
  final int? remainingApiCalls;

  TarotInDepthLoveResponse({
    required this.success,
    this.id,
    this.name,
    required this.description,
    required this.cardImage,
    required this.cardImagesBack,
    this.remainingApiCalls,
  });

  factory TarotInDepthLoveResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotInDepthLoveResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      description: response['description']?.toString() ?? '',
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Erotic Love Response Model (same structure as in-depth)
class TarotEroticLoveResponse extends TarotInDepthLoveResponse {
  TarotEroticLoveResponse({
    required super.success,
    super.id,
    super.name,
    required super.description,
    required super.cardImage,
    required super.cardImagesBack,
    super.remainingApiCalls,
  });

  factory TarotEroticLoveResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotEroticLoveResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      description: response['description']?.toString() ?? '',
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Made for Each Other Response Model (same structure as in-depth)
class TarotMadeForEachOtherResponse extends TarotInDepthLoveResponse {
  TarotMadeForEachOtherResponse({
    required super.success,
    super.id,
    super.name,
    required super.description,
    required super.cardImage,
    required super.cardImagesBack,
    super.remainingApiCalls,
  });

  factory TarotMadeForEachOtherResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotMadeForEachOtherResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      description: response['description']?.toString() ?? '',
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Flirt Reading Response Model (same structure as in-depth)
class TarotFlirtReadingResponse extends TarotInDepthLoveResponse {
  TarotFlirtReadingResponse({
    required super.success,
    super.id,
    super.name,
    required super.description,
    required super.cardImage,
    required super.cardImagesBack,
    super.remainingApiCalls,
  });

  factory TarotFlirtReadingResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotFlirtReadingResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      description: response['description']?.toString() ?? '',
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Daily Guidance Response Model
class TarotDailyResponse {
  final bool success;
  final String? id;
  final String? name;
  final String health;
  final String relationship;
  final String career;
  final String finance;
  final Map<String, String> cardImage;
  final Map<String, String> cardImagesBack;
  final int? remainingApiCalls;

  TarotDailyResponse({
    required this.success,
    this.id,
    this.name,
    required this.health,
    required this.relationship,
    required this.career,
    required this.finance,
    required this.cardImage,
    required this.cardImagesBack,
    this.remainingApiCalls,
  });

  factory TarotDailyResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    return TarotDailyResponse(
      success: json['status'] == 200 || json['success'] == true,
      id: response['id']?.toString(),
      name: response['name']?.toString(),
      health: response['health']?.toString() ?? '',
      relationship: response['relationship']?.toString() ?? '',
      career: response['career']?.toString() ?? '',
      finance: response['finance']?.toString() ?? '',
      cardImage: response['card_image'] is Map
          ? Map<String, String>.from(
              response['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Romantic Breakup Response Model
class TarotRomanticBreakupResponse {
  final bool success;
  final TarotBreakupCard cause;
  final TarotBreakupCard advise;
  final Map<String, String> cardImagesBack;
  final int? remainingApiCalls;

  TarotRomanticBreakupResponse({
    required this.success,
    required this.cause,
    required this.advise,
    required this.cardImagesBack,
    this.remainingApiCalls,
  });

  factory TarotRomanticBreakupResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    final causeData = response['cause'];
    final adviseData = response['advise'];
    
    return TarotRomanticBreakupResponse(
      success: json['status'] == 200 || json['success'] == true,
      cause: causeData is Map<String, dynamic>
          ? TarotBreakupCard.fromJson(causeData)
          : TarotBreakupCard(
              id: causeData?['id']?.toString() ?? '',
              name: causeData?['name']?.toString() ?? '',
              description: causeData?['description']?.toString() ?? '',
              cardImage: {},
            ),
      advise: adviseData is Map<String, dynamic>
          ? TarotBreakupCard.fromJson(adviseData)
          : TarotBreakupCard(
              id: adviseData?['id']?.toString() ?? '',
              name: adviseData?['name']?.toString() ?? '',
              description: adviseData?['description']?.toString() ?? '',
              cardImage: {},
            ),
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Business Breakup Response Model (same structure as romantic)
class TarotBusinessBreakupResponse extends TarotRomanticBreakupResponse {
  TarotBusinessBreakupResponse({
    required super.success,
    required super.cause,
    required super.advise,
    required super.cardImagesBack,
    super.remainingApiCalls,
  });

  factory TarotBusinessBreakupResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json;
    final causeData = response['cause'];
    final adviseData = response['advise'];
    
    return TarotBusinessBreakupResponse(
      success: json['status'] == 200 || json['success'] == true,
      cause: causeData is Map<String, dynamic>
          ? TarotBreakupCard.fromJson(causeData)
          : TarotBreakupCard(
              id: causeData?['id']?.toString() ?? '',
              name: causeData?['name']?.toString() ?? '',
              description: causeData?['description']?.toString() ?? '',
              cardImage: {},
            ),
      advise: adviseData is Map<String, dynamic>
          ? TarotBreakupCard.fromJson(adviseData)
          : TarotBreakupCard(
              id: adviseData?['id']?.toString() ?? '',
              name: adviseData?['name']?.toString() ?? '',
              description: adviseData?['description']?.toString() ?? '',
              cardImage: {},
            ),
      cardImagesBack: response['card_images_back'] is Map
          ? Map<String, String>.from(
              response['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

/// Breakup Card Model
class TarotBreakupCard {
  final String id;
  final String name;
  final String description;
  final Map<String, String> cardImage;

  TarotBreakupCard({
    required this.id,
    required this.name,
    required this.description,
    required this.cardImage,
  });

  factory TarotBreakupCard.fromJson(Map<String, dynamic> json) {
    return TarotBreakupCard(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      cardImage: json['card_image'] is Map
          ? Map<String, String>.from(
              json['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
    );
  }
}

/// Fortune Cookie Response Model
class TarotFortuneCookieResponse {
  final bool success;
  final String message;
  final int? remainingApiCalls;

  TarotFortuneCookieResponse({
    required this.success,
    required this.message,
    this.remainingApiCalls,
  });

  factory TarotFortuneCookieResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? json['message'] ?? '';
    return TarotFortuneCookieResponse(
      success: json['status'] == 200 || json['success'] == true,
      message: response is String ? response : response.toString(),
      remainingApiCalls: json['remaining_api_calls'] is int
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

