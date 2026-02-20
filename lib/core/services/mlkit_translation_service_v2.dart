import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:astrobharataiuser/core/localization/translation_overrides.dart';

/// High-performance ML Kit Translation Service with aggressive caching
///
/// Features:
/// - Translator reuse (not recreated per request)
/// - Aggressive translation caching
/// - Lazy translator initialization
/// - Thread-safe operations
/// - Memory-efficient design
class MLKitTranslationServiceV2 {
  static final MLKitTranslationServiceV2 _instance =
      MLKitTranslationServiceV2._internal();
  factory MLKitTranslationServiceV2() => _instance;
  MLKitTranslationServiceV2._internal();

  /// Cache for translations: "sourceLang_targetLang_text" -> translated text
  final Map<String, String> _translationCache = {};

  /// Active translators: "sourceLang_targetLang" -> OnDeviceTranslator
  final Map<String, OnDeviceTranslator> _activeTranslators = {};

  /// Maximum cache size (prevent memory bloat)
  static const int _maxCacheSize = 5000;

  /// Supported language mapping (ML Kit supported languages only)
  /// This is the SINGLE SOURCE OF TRUTH for language mapping
  /// Note: Languages not supported by ML Kit will fallback to English (no translation)
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
    'ml': null, // Malayalam - Fallback to English
    'or': null, // Oriya - Fallback to English
    'pa': null, // Punjabi - Fallback to English
    'as': null, // Assamese - Fallback to English
    'mai': null, // Maithili - Fallback to English
    'bh': null, // Bodo - Fallback to English
    'ks': null, // Kashmiri - Fallback to English
    'kok': null, // Konkani - Fallback to English
    'ne': null, // Nepali - Fallback to English
    'sd': null, // Sindhi - Fallback to English
    'sa': null, // Sanskrit - Fallback to English
    'mni': null, // Manipuri - Fallback to English
    'sat': null, // Santali - Fallback to English
    'doi': null, // Dogri - Fallback to English
  };

  /// Get supported language codes
  static List<String> getSupportedLanguageCodes() {
    return _languageMap.keys.toList();
  }

  /// Check if language is supported by ML Kit
  bool isLanguageSupported(String languageCode) {
    final lang = _languageMap[languageCode];
    return lang != null;
  }

  /// Get TranslateLanguage object for a language code
  TranslateLanguage? getTranslateLanguage(String languageCode) {
    return _languageMap[languageCode];
  }

  /// Translate text with aggressive caching
  ///
  /// Returns original text if:
  /// - Source and target languages are the same
  /// - Language is not supported
  /// - Translation fails
  Future<String> translateText({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
  }) async {
    // Early returns for performance
    if (text.isEmpty) return text;
    if (sourceLanguageCode == targetLanguageCode) return text;
    if (targetLanguageCode == 'en' && sourceLanguageCode == 'en') return text;

    // Check translation overrides first (for accurate UI term translations)
    final override = TranslationOverrides.getOverride(
      text.trim(),
      targetLanguageCode,
    );
    if (override != null && override.isNotEmpty) {
      print(
        'MLKitTranslationServiceV2: Using override for "$text" -> "$override"',
      );
      // Cache the override result
      final cacheKey = _getCacheKey(
        text,
        sourceLanguageCode,
        targetLanguageCode,
      );
      _cacheTranslation(cacheKey, override);
      return override;
    }

    // Check cache first
    final cacheKey = _getCacheKey(text, sourceLanguageCode, targetLanguageCode);
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    // Check if target language is supported
    if (!isLanguageSupported(targetLanguageCode)) {
      // Not supported - return original text
      return text;
    }

    // Check if source language is supported
    final sourceLang = getTranslateLanguage(sourceLanguageCode);
    final targetLang = getTranslateLanguage(targetLanguageCode);

    if (sourceLang == null || targetLang == null) {
      return text;
    }

    try {
      print(
        'MLKitTranslationServiceV2: Translating "$text" from $sourceLanguageCode to $targetLanguageCode',
      );

      // Get or create translator (reuse for performance)
      final translator = await _getOrCreateTranslator(
        sourceLanguageCode,
        targetLanguageCode,
        sourceLang,
        targetLang,
      );

      // Translate text
      final translatedText = await translator.translateText(text);

      print(
        'MLKitTranslationServiceV2: Translation result: "$text" -> "$translatedText"',
      );

      // Cache the result
      _cacheTranslation(cacheKey, translatedText);

      return translatedText;
    } catch (e, stackTrace) {
      // On error, return original text (fail-safe)
      print('MLKitTranslationServiceV2: Translation error: $e');
      print('Stack trace: $stackTrace');
      return text;
    }
  }

  /// Get or create translator (reused for performance)
  Future<OnDeviceTranslator> _getOrCreateTranslator(
    String sourceCode,
    String targetCode,
    TranslateLanguage sourceLang,
    TranslateLanguage targetLang,
  ) async {
    final translatorKey = '${sourceCode}_$targetCode';

    if (_activeTranslators.containsKey(translatorKey)) {
      return _activeTranslators[translatorKey]!;
    }

    // Create new translator
    final translator = OnDeviceTranslator(
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );

    // Store for reuse
    _activeTranslators[translatorKey] = translator;

    return translator;
  }

  /// Generate cache key
  String _getCacheKey(String text, String source, String target) {
    return '${source}_${target}_${text.hashCode}';
  }

  /// Cache translation with size limit
  void _cacheTranslation(String key, String translatedText) {
    // Prevent cache bloat
    if (_translationCache.length >= _maxCacheSize) {
      // Remove oldest entries (simple FIFO)
      final keysToRemove = _translationCache.keys.take(100).toList();
      for (final k in keysToRemove) {
        _translationCache.remove(k);
      }
    }

    _translationCache[key] = translatedText;
  }

  /// Clear translation cache
  void clearCache() {
    _translationCache.clear();
  }

  /// Close all active translators and clear resources
  Future<void> dispose() async {
    // Close all translators
    for (final translator in _activeTranslators.values) {
      try {
        await translator.close();
      } catch (e) {
        print('Error closing translator: $e');
      }
    }

    _activeTranslators.clear();
    _translationCache.clear();
  }

  /// Pre-download language models for better performance
  /// Call this during app initialization for target languages
  ///
  /// Note: ML Kit automatically downloads models on first translator creation.
  /// This method is a placeholder for future optimization if needed.
  /// Models are downloaded lazily when translators are first created, which
  /// is efficient and doesn't block app startup.
  Future<void> downloadLanguageModels(List<String> languageCodes) async {
    // ML Kit handles model downloading automatically on first translator creation.
    // This is more efficient than pre-downloading all models, as:
    // 1. Only languages actually used are downloaded
    // 2. Models are downloaded in background
    // 3. No blocking during app startup
    //
    // If pre-downloading is needed in future, implement using:
    // final modelManager = OnDeviceTranslatorModelManager();
    // await modelManager.downloadModel(languageCode); // Uses BCP code string
  }
}
