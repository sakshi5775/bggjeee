import 'dart:convert';
import 'package:astrobharataiuser/utils/app_constant.dart'; // Correct path to constants
import 'package:astrobharataiuser/core/localization/translation_overrides.dart';
import 'package:http/http.dart' as http;

/// Service for translating content using Google Cloud Translation API
/// Supports 100+ languages with neural machine translation.
class GoogleCloudTranslationService {
  static final GoogleCloudTranslationService _instance =
      GoogleCloudTranslationService._internal();
  factory GoogleCloudTranslationService() => _instance;
  GoogleCloudTranslationService._internal();

  /// Cache for translations: "source_target_text" -> translated text
  final Map<String, String> _cache = {};

  /// Max cache size
  static const int _maxCacheSize = 2000;

  /// Translate text using Google Cloud API
  Future<String> translateText({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'en',
  }) async {
    // Basic validation / early exit
    if (text.trim().isEmpty) return text;
    if (sourceLanguage == targetLanguage) return text;

    // Check manual overrides first (for specific terms like "AI" -> "एआई")
    final override = TranslationOverrides.getOverride(
      text.trim(),
      targetLanguage,
    );
    if (override != null && override.isNotEmpty) {
      return override;
    }

    // Check cache
    final cacheKey = '${sourceLanguage}_${targetLanguage}_${text.trim()}';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final url = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2',
      );

      final response = await http.post(
        url,
        body: {
          'q': text,
          'target': targetLanguage,
          'format':
              'text', // Use 'text' to avoid HTML entities if possible, or 'html'
          'source': sourceLanguage,
          'key': AppConstant.googleTranslateApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null &&
            data['data']['translations'] != null &&
            (data['data']['translations'] as List).isNotEmpty) {
          String translatedText =
              data['data']['translations'][0]['translatedText'];

          // Decode HTML entities (e.g., &#39; -> ') if 'html' format is used/returned
          // Simple replacement for common entities if needed, or rely on a package like html_unescape
          // For now, assuming format: 'text' returns clean text usually.

          _addToCache(cacheKey, translatedText);
          return translatedText;
        }
      } else {
        print(
          'Google Translate API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Google Translate Exception: $e');
    }

    // Fallback to original text
    return text;
  }

  void _addToCache(String key, String value) {
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }
}
