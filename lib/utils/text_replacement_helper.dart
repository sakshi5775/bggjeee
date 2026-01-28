/// Helper utility to easily replace AutoTranslateText with AutoTranslateText
/// 
/// Usage in IDE:
/// 1. Find: AutoTranslateText\(
/// 2. Replace: AutoTranslateText\(
/// 3. Make sure to import: import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
/// 
/// Or use the extension method:
/// 'Your text'.toAutoTranslate(style: TextStyle(...))

import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Global AutoTranslateText replacement - use this instead of AutoTranslateText for automatic translation
/// 
/// This is a drop-in replacement for AutoTranslateText that automatically translates
/// 
/// Example:
/// ```dart
/// // Before
/// AutoTranslateText('Hello', style: TextStyle(fontSize: 16))
/// 
/// // After  
/// T('Hello', style: TextStyle(fontSize: 16))
/// ```
class T extends AutoTranslateText {
  const T(
    super.text, {
    super.key,
    super.style,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.translate,
    super.sourceLanguageCode,
  });
}










