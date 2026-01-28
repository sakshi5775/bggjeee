import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:get/get.dart';

/// Mixin to add language parameter to API calls
/// Use this in your controllers when making API calls
mixin LanguageApiMixin {
  /// Get current language code for API calls
  String get currentLanguageCode {
    try {
      if (Get.isRegistered<LanguageController>()) {
        return Get.find<LanguageController>().currentLanguageCode;
      }
    } catch (e) {
      // If controller not found, default to English
    }
    return 'en';
  }

  /// Add language parameter to query parameters
  /// Usage:
  /// ```dart
  /// final query = {'page': 1, 'limit': 10};
  /// addLanguageParam(query);
  /// // query now contains {'page': 1, 'limit': 10, 'lang': 'en'}
  /// ```
  Map<String, dynamic> addLanguageParam(Map<String, dynamic>? query) {
    final queryParams = query ?? <String, dynamic>{};
    queryParams['lang'] = currentLanguageCode;
    return queryParams;
  }

  /// Create query parameters with language
  /// Usage:
  /// ```dart
  /// final query = createQueryWithLanguage({'page': 1, 'limit': 10});
  /// ```
  Map<String, dynamic> createQueryWithLanguage(
    Map<String, dynamic>? otherParams,
  ) {
    return addLanguageParam(otherParams);
  }
}
