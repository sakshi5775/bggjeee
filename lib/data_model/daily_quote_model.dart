class DailyQuoteResponse {
  final bool success;
  final String message;
  final DailyQuoteData? data;

  DailyQuoteResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DailyQuoteResponse.fromJson(Map<String, dynamic> json) {
    return DailyQuoteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? DailyQuoteData.fromJson(json['data']) : null,
    );
  }
}

class DailyQuoteData {
  final String quoteDate;
  final SanskritQuote sanskrit;
  final List<LanguageInfo> availableTranslations;
  final bool isFallback;
  final String? generatedAt;

  DailyQuoteData({
    required this.quoteDate,
    required this.sanskrit,
    required this.availableTranslations,
    required this.isFallback,
    this.generatedAt,
  });

  factory DailyQuoteData.fromJson(Map<String, dynamic> json) {
    return DailyQuoteData(
      quoteDate: json['quoteDate'] ?? '',
      sanskrit: json['sanskrit'] != null
          ? SanskritQuote.fromJson(json['sanskrit'])
          : SanskritQuote(
              text: '',
              transliteration: '',
              meaning: '',
              source: '',
              category: '',
            ),
      availableTranslations: (json['availableTranslations'] as List<dynamic>?)
              ?.map((item) => LanguageInfo.fromJson(item))
              .toList() ??
          [],
      isFallback: json['isFallback'] ?? false,
      generatedAt: json['generatedAt'],
    );
  }
}

class SanskritQuote {
  final String text;
  final String transliteration;
  final String meaning;
  final String source;
  final String category;

  SanskritQuote({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.source,
    required this.category,
  });

  factory SanskritQuote.fromJson(Map<String, dynamic> json) {
    return SanskritQuote(
      text: json['text'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaning: json['meaning'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;

  LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  factory LanguageInfo.fromJson(Map<String, dynamic> json) {
    return LanguageInfo(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nativeName: json['nativeName'] ?? '',
    );
  }
}




