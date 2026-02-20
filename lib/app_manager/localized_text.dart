import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Reusable LocalizedText widget that automatically handles translations
/// For static text, use easy_localization directly: 'key'.tr()
/// This widget is kept for backward compatibility and dynamic content
class LocalizedText extends StatelessWidget {
  /// Translation key for static strings (uses easy_localization)
  /// Example: 'auth.login'.tr()
  final String? translationKey;

  /// Direct text value (for dynamic content from API)
  /// If provided, translationKey will be ignored
  /// This will be used as-is or translated if translationMap is provided
  final String? text;

  /// Map of language codes to translated text for dynamic content
  /// Format: {'en': 'English text', 'hi': 'Hindi text'}
  /// If provided with text, it will use the appropriate translation
  final Map<String, String>? translationMap;

  /// Fallback text if translation not found
  final String? fallback;

  /// AutoTranslateText style
  final TextStyle? style;

  /// AutoTranslateText alignment
  final TextAlign? textAlign;

  /// Maximum lines
  final int? maxLines;

  /// AutoTranslateText overflow
  final TextOverflow? overflow;

  /// Soft wrap
  final bool? softWrap;

  const LocalizedText({
    super.key,
    this.translationKey,
    this.text,
    this.translationMap,
    this.fallback,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : assert(
         translationKey != null || text != null,
         'Either translationKey or text must be provided',
       );

  @override
  Widget build(BuildContext context) {
    String displayText;

    // Priority 1: Use custom translation service for static text (translationKey)
    if (translationKey != null) {
      // Use GetBuilder to rebuild when translation service changes
      // This ensures widgets rebuild when locale changes, even for problematic languages
      return GetBuilder<CustomTranslationService>(
        builder: (translationService) {
          // Get translation - this will rebuild when language changes
          final translatedText = translationService.tr(translationKey!);
          
          return AutoTranslateText(
            translatedText,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap,
          );
        },
      );
    }

    // Priority 2: Use direct text with translation map (for dynamic API content)
    if (text != null && translationMap != null) {
      return Obx(() {
        // Get current language from controller
        AppLanguageModel? currentLanguage;
        if (Get.isRegistered<LanguageController>()) {
          try {
            currentLanguage = Get.find<LanguageController>().currentLanguage.value;
          } catch (e) {
            // Fallback to English if controller not available
            currentLanguage = null;
          }
        }

        final languageCode = currentLanguage?.code ?? 'en';
        displayText = translationMap![languageCode] ??
            translationMap!['en'] ??
            text!;

        return AutoTranslateText(
          displayText,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
        );
      });
    }

    // Priority 3: Use direct text without translation map
    displayText = text ?? fallback ?? '';

    return AutoTranslateText(
      displayText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

/// Extension methods for easy text styling
extension LocalizedTextExtensions on LocalizedText {
  /// Apply MyTextTheme styles
  LocalizedText withStyle(TextStyle Function(String) styleBuilder) {
    final defaultText = translationKey ?? text ?? fallback ?? '';
    return LocalizedText(
      translationKey: translationKey,
      text: text,
      translationMap: translationMap,
      fallback: fallback,
      style: styleBuilder(defaultText),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
