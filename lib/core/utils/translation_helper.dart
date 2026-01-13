import 'package:astrobharataiuser/core/services/mlkit_translation_service.dart';

/// Helper class for translation operations
/// Provides utilities for translating dynamic content
class TranslationHelper {
  /// Translate dynamic content using MLKit
  /// Use this for API content, chat messages, etc.
  static Future<String> translateDynamicContent({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
  }) async {
    // If source and target are same, return original
    if (sourceLanguageCode == targetLanguageCode) {
      return text;
    }

    // If target is English, return original (assuming content is in English)
    if (targetLanguageCode == 'en') {
      return text;
    }

    // Use MLKit to translate
    final translationService = MLKitTranslationService();
    return await translationService.translateText(
      text: text,
      sourceLanguageCode: sourceLanguageCode,
      targetLanguageCode: targetLanguageCode,
    );
  }

  /// Check if language is supported for translation
  static bool isLanguageSupportedForTranslation(String languageCode) {
    final translationService = MLKitTranslationService();
    return translationService.isLanguageSupported(languageCode);
  }

  /// Get all supported languages for translation
  static List<String> getSupportedTranslationLanguages() {
    final translationService = MLKitTranslationService();
    return translationService.getSupportedLanguages();
  }
}

