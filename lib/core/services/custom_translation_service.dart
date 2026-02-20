import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/services/language_service.dart';

/// Custom translation service that directly loads JSON files
/// This is more reliable than easy_localization for all 23 languages
class CustomTranslationService extends GetxController {
  static CustomTranslationService? _instance;

  // Current translations map
  final _translations = <String, dynamic>{}.obs;

  // Current language code
  final _currentLanguageCode = 'en'.obs;

  // Language model
  final _currentLanguage = Rxn<AppLanguageModel>();

  // Is loading
  final isLoading = false.obs;

  // Track languages that failed to load assets to avoid repeated failed attempts
  final Set<String> _missingLanguages = {};
  static CustomTranslationService get instance {
    if (_instance != null) {
      return _instance!;
    }
    // Get from GetX if already registered, otherwise use the static instance
    if (Get.isRegistered<CustomTranslationService>()) {
      _instance = Get.find<CustomTranslationService>();
    } else {
      // If not registered, this means it wasn't initialized in main.dart
      // Fallback: register it now (shouldn't happen in normal flow)
      _instance = Get.put(CustomTranslationService(), permanent: true);
    }
    return _instance!;
  }

  // Get current language code
  String get currentLanguageCode => _currentLanguageCode.value;

  // Get current language
  AppLanguageModel? get currentLanguage => _currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialLanguage();
  }

  /// Load initial language
  Future<void> _loadInitialLanguage() async {
    try {
      final savedLanguage = await LanguageService.getCurrentLanguage();
      await changeLanguage(savedLanguage);
    } catch (e) {
      print('Error loading initial language: $e');
      // Default to English
      await changeLanguage(await LanguageModelService.getDefaultLanguage());
    }
  }

  /// Change language and load translations
  Future<void> changeLanguage(AppLanguageModel language) async {
    if (_currentLanguageCode.value == language.code &&
        _translations.isNotEmpty) {
      return; // Already loaded
    }

    try {
      isLoading.value = true;
      _currentLanguageCode.value = language.code;
      _currentLanguage.value = language;

      // Load translations from JSON file
      await _loadTranslations(language.code);

      // Save preference
      await LanguageService.setLanguage(language);

      // Force update to notify all listeners (defer to next frame to avoid build scope issues)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
    } catch (e) {
      print('Error changing language: $e');
      // Fallback to English
      if (language.code != 'en') {
        await _loadTranslations('en');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Load translations from JSON file
  Future<void> _loadTranslations(String languageCode) async {
    // If we already know this language asset is missing, don't try again
    if (_missingLanguages.contains(languageCode)) {
      _translations.value = {};
      return;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/translations/$languageCode.json',
      );
      final Map<String, dynamic> translations = json.decode(jsonString);
      _translations.value = translations;

      // Successfully loaded, ensure it's not in missing set
      _missingLanguages.remove(languageCode);

      // Don't call update here - let changeLanguage handle it to avoid build scope issues
    } catch (e) {
      // Mark as missing to avoid repeated failures
      _missingLanguages.add(languageCode);

      if (kDebugMode && languageCode == 'en') {
        print(
          'CustomTranslationService: Missing $languageCode asset. Using empty.',
        );
      }

      // Try to load English as fallback only if we haven't already marked it as missing
      if (languageCode != 'en' && !_missingLanguages.contains('en')) {
        try {
          final String jsonString = await rootBundle.loadString(
            'assets/translations/en.json',
          );
          final Map<String, dynamic> translations = json.decode(jsonString);
          _translations.value = translations;
        } catch (_) {
          _missingLanguages.add('en');
          _translations.value = {};
        }
      } else {
        _translations.value = {};
      }
    }
  }

  /// Get translation by key
  /// Supports nested keys like 'auth.login' or 'common.appName'
  String tr(String key, {Map<String, String>? args}) {
    try {
      final keys = key.split('.');
      dynamic value = _translations;

      for (final k in keys) {
        if (value is Map && value.containsKey(k)) {
          value = value[k];
        } else {
          // Key not found, return key itself
          return key;
        }
      }

      String translation = value.toString();

      // Replace arguments if provided
      if (args != null && args.isNotEmpty) {
        args.forEach((key, value) {
          translation = translation.replaceAll('{$key}', value);
        });
      }

      return translation;
    } catch (e) {
      print('Error getting translation for key: $key, error: $e');
      return key;
    }
  }

  /// Check if translation exists
  bool hasTranslation(String key) {
    try {
      final keys = key.split('.');
      dynamic value = _translations;

      for (final k in keys) {
        if (value is Map && value.containsKey(k)) {
          value = value[k];
        } else {
          return false;
        }
      }

      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Get all translations
  Map<String, dynamic> get allTranslations =>
      Map<String, dynamic>.from(_translations);
}

/// Extension method for easy translation access
extension StringTranslationExtension on String {
  /// Translate string using custom translation service
  String get tr {
    if (Get.isRegistered<CustomTranslationService>()) {
      return CustomTranslationService.instance.tr(this);
    }
    return this;
  }
}
