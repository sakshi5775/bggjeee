class TarotCardModel {
  final String id;
  final int index;
  final String name;
  final String direction; // 'upright' or 'reversed'
  final String? directionEn;
  final Map<String, String> cardImage; // {classic, artwork, dark, ghibli}
  final Map<String, String> cardImagesBack; // Map of back image URLs

  TarotCardModel({
    required this.id,
    required this.index,
    required this.name,
    required this.direction,
    this.directionEn,
    required this.cardImage,
    required this.cardImagesBack,
  });

  factory TarotCardModel.fromJson(Map<String, dynamic> json) {
    return TarotCardModel(
      id: json['id']?.toString() ?? '',
      index: json['index'] ?? 0,
      name: json['name'] ?? '',
      direction: json['direction'] ?? 'upright',
      directionEn: json['direction_en']?.toString(),
      cardImage: json['card_image'] is Map
          ? Map<String, String>.from(
              json['card_image'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
      cardImagesBack: json['card_images_back'] is Map
          ? Map<String, String>.from(
              json['card_images_back'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'name': name,
      'direction': direction,
      'direction_en': directionEn,
      'card_image': cardImage,
      'card_images_back': cardImagesBack,
    };
  }

  bool get isReversed => direction.toLowerCase() == 'reversed' || directionEn?.toLowerCase() == 'reverse';
  
  String getCardImageUrl(String theme) {
    return cardImage[theme] ?? cardImage['classic'] ?? '';
  }
  
  String getBackImageUrl({String backType = 'classic'}) {
    // Map UI back type to API key
    // API keys: classic, dark, indigo_star, playing_blue, playing_red, ghibli_sun, ghibli_tree
    String apiKey = backType;
    
    // Handle any mapping if needed (currently they match)
    if (cardImagesBack.containsKey(apiKey)) {
      return cardImagesBack[apiKey]!;
    }
    
    // Fallback chain: try classic, then any available
    if (cardImagesBack.containsKey('classic')) {
      return cardImagesBack['classic']!;
    }
    
    // Return first available if classic not found
    if (cardImagesBack.isNotEmpty) {
      return cardImagesBack.values.first;
    }
    
    return '';
  }
}

class TarotShuffleResponse {
  final bool success;
  final String message;
  final List<TarotCardModel> cards;
  final String? language;
  final int? remainingApiCalls; // API provides this field

  TarotShuffleResponse({
    required this.success,
    required this.message,
    required this.cards,
    this.language,
    this.remainingApiCalls,
  });

  factory TarotShuffleResponse.fromJson(Map<String, dynamic> json) {
    // API returns: { "status": 200, "response": [...], "remaining_api_calls": ... }
    final cardsList = json['response'] ?? json['cards'] ?? json['data'] ?? [];
    return TarotShuffleResponse(
      success: json['status'] == 200 || json['success'] == true,
      message: json['message'] ?? '',
      cards: cardsList is List
          ? List<dynamic>.from(cardsList)
              .map((card) => TarotCardModel.fromJson(card as Map<String, dynamic>))
              .toList()
          : [],
      language: json['language'],
      remainingApiCalls: json['remaining_api_calls'] is int 
          ? json['remaining_api_calls'] as int
          : json['remaining_api_calls'] is String
              ? int.tryParse(json['remaining_api_calls'] as String)
              : null,
    );
  }
}

