import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService {
  // Use lazy getter to ensure the box is accessed only after GetStorage.init() in main()
  static GetStorage get _storage => GetStorage('language');
  static const _languageKey = 'current_language';

  /// Get current language from storage
  static Future<AppLanguageModel> getCurrentLanguage() async {
    final languageCode = _storage.read(_languageKey);
    if (languageCode == null) {
      return await LanguageModelService.getDefaultLanguage();
    }

    final language = await LanguageModelService.getLanguageByCode(languageCode);
    return language ?? await LanguageModelService.getDefaultLanguage();
  }

  /// Save language preference
  static Future<void> setLanguage(AppLanguageModel language) async {
    await _storage.write(_languageKey, language.code);
  }

  /// Clear language preference
  static Future<void> clearLanguage() async {
    await _storage.remove(_languageKey);
  }

  /// Check if language preference exists
  static bool hasLanguagePreference() {
    return _storage.hasData(_languageKey);
  }
}
