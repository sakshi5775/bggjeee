import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Service for translating dynamic content using Google MLKit Translation
/// Use this for translating API content, chat messages, etc.
class MLKitTranslationService {
  static final MLKitTranslationService _instance = MLKitTranslationService._internal();
  factory MLKitTranslationService() => _instance;
  MLKitTranslationService._internal();

  /// Map of language codes to TranslateLanguage
  /// Only includes languages supported by MLKit
  static final Map<String, TranslateLanguage?> _languageMap = {
    'en': TranslateLanguage.english,
    'hi': TranslateLanguage.hindi,
    'bn': TranslateLanguage.bengali,
    'te': TranslateLanguage.telugu,
    'mr': TranslateLanguage.marathi,
    'ta': TranslateLanguage.tamil,
    'gu': TranslateLanguage.gujarati,
    'ur': TranslateLanguage.urdu,
    'kn': TranslateLanguage.kannada,
    // MLKit doesn't support these directly, will use fallback
    'ml': TranslateLanguage.english, // Malayalam not directly supported
    'or': TranslateLanguage.english, // Odia not directly supported
    'pa': TranslateLanguage.english, // Punjabi not directly supported
    'as': TranslateLanguage.english, // Assamese not directly supported
    'mai': TranslateLanguage.english, // Maithili not supported
    'bh': TranslateLanguage.english, // Bodo not supported
    'ks': TranslateLanguage.english, // Kashmiri not supported
    'kok': TranslateLanguage.english, // Konkani not supported
    'ne': TranslateLanguage.english, // Nepali - check if available
    'sd': TranslateLanguage.english, // Sindhi not supported
    'sa': TranslateLanguage.english, // Sanskrit not supported
    'mni': TranslateLanguage.english, // Manipuri not supported
    'sat': TranslateLanguage.english, // Santali not supported
    'doi': TranslateLanguage.english, // Dogri not supported
  };

  /// Translate text from source language to target language
  /// Returns original text if translation fails or language not supported
  Future<String> translateText({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
  }) async {
    try {
      // If source and target are same, return original
      if (sourceLanguageCode == targetLanguageCode) {
        return text;
      }

      // Get language objects
      final sourceLanguage = _languageMap[sourceLanguageCode] ?? TranslateLanguage.english;
      final targetLanguage = _languageMap[targetLanguageCode];
      
      // If target language is not supported by MLKit, return original
      if (targetLanguage == null || (targetLanguage == TranslateLanguage.english && targetLanguageCode != 'en')) {
        return text;
      }

      // Create translator
      final translator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );

      // Translate text
      final translatedText = await translator.translateText(text);

      // Close translator
      await translator.close();

      return translatedText;
    } catch (e) {
      // If translation fails, return original text
      print('Translation error: $e');
      return text;
    }
  }

  /// Check if language is supported by MLKit
  bool isLanguageSupported(String languageCode) {
    final language = _languageMap[languageCode];
    return language != null && 
        language != TranslateLanguage.english && 
        languageCode != 'en';
  }

  /// Get supported languages
  List<String> getSupportedLanguages() {
    return _languageMap.entries
        .where((entry) => entry.value != TranslateLanguage.english || entry.key == 'en')
        .map((entry) => entry.key)
        .toList();
  }
}

