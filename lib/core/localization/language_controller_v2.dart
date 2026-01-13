import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/services/language_service.dart';
import 'package:astrobharataiuser/core/services/mlkit_translation_service_v2.dart';
import 'package:get/get.dart';

/// Lightweight global language controller (single source of truth)
/// 
/// Features:
/// - No heavy rebuilds on language change
/// - Instant language switching
/// - Minimal memory footprint
/// - Notifies only required widgets
class LanguageControllerV2 extends GetxController {
  /// Current language (observable)
  final currentLanguage = Rxn<AppLanguageModel>();
  
  /// Current language code (for quick access)
  String _currentLanguageCode = 'en';
  
  /// Translation service instance
  final _translationService = MLKitTranslationServiceV2();
  
  /// Is initializing
  final isLoading = false.obs;

  /// Get current language code (fast access, no observable overhead)
  String get currentLanguageCode => _currentLanguageCode;
  
  /// Get current language
  AppLanguageModel? get currentLanguageValue => currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  /// Load saved language preference
  Future<void> _loadLanguage() async {
    try {
      isLoading.value = true;
      final savedLanguage = await LanguageService.getCurrentLanguage();
      await changeLanguage(savedLanguage, skipSave: true);
    } catch (e) {
      print('Error loading language: $e');
      // Fallback to default
      final defaultLanguage = await LanguageModelService.getDefaultLanguage();
      await changeLanguage(defaultLanguage, skipSave: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// Change language instantly (Chrome-style)
  /// 
  /// [skipSave] - Skip saving to storage (useful for initial load)
  Future<void> changeLanguage(
    AppLanguageModel language, {
    bool skipSave = false,
  }) async {
    // Early return if same language
    if (_currentLanguageCode == language.code && currentLanguage.value?.code == language.code) {
      print('LanguageControllerV2: Already on language ${language.code}');
      return;
    }

    print('LanguageControllerV2: Changing language to ${language.code} (${language.nameEn})');

    // Update state immediately (no blocking)
    _currentLanguageCode = language.code;
    currentLanguage.value = language;

    // Save preference (non-blocking)
    if (!skipSave) {
      await LanguageService.setLanguage(language).catchError((e) {
        print('Error saving language: $e');
      });
      print('LanguageControllerV2: Language preference saved');
    }

    // Pre-download language model if needed (background task, non-blocking)
    if (_translationService.isLanguageSupported(language.code)) {
      print('LanguageControllerV2: Language ${language.code} is supported by ML Kit');
      // Download model in background - don't block language change
      _translationService.downloadLanguageModels([language.code]).catchError((e) {
        print('Error downloading language model: $e');
        // Non-critical - model will download on first translation
      });
    } else {
      print('LanguageControllerV2: Language ${language.code} is NOT supported by ML Kit - will show English');
    }

    // Notify listeners (lightweight - no heavy rebuilds)
    update();
    print('LanguageControllerV2: Notified all listeners - language changed to ${language.code}');
  }

  /// Check if current language is a specific code
  bool isLanguage(String code) => _currentLanguageCode == code;

  /// Check if language is supported by ML Kit
  bool isLanguageSupported(String code) {
    return _translationService.isLanguageSupported(code);
  }

  @override
  void onClose() {
    // Cleanup if needed
    super.onClose();
  }
}

