import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Custom localized text widget that uses CustomTranslationService
/// This is more reliable than easy_localization for all 23 languages
class LocalizedTextCustom extends StatelessWidget {
  /// Translation key for static strings
  final String? translationKey;

  /// Direct text value (for dynamic content from API)
  final String? text;

  /// Map of language codes to translated text for dynamic content
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

  const LocalizedTextCustom({
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
    // Priority 1: Use translation key
    if (translationKey != null) {
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

    // Priority 2: Use direct text with translation map
    if (text != null && translationMap != null) {
      return GetBuilder<CustomTranslationService>(
        builder: (translationService) {
          final languageCode = translationService.currentLanguageCode;
          final displayText = translationMap![languageCode] ??
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
        },
      );
    }

    // Priority 3: Use direct text without translation map
    final displayText = text ?? fallback ?? '';
    
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








