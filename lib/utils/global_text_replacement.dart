/// Global AutoTranslateText Replacement Utility
/// 
/// This file provides utilities to help replace AutoTranslateText widgets with AutoTranslateText
/// across the entire app.
/// 
/// Usage in IDE:
/// 1. Open any file
/// 2. Find: AutoTranslateText\(
/// 3. Replace: AutoTranslateText\(
/// 4. Add import if not present: import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
/// 
/// IMPORTANT: Some AutoTranslateText widgets should NOT be replaced:
/// - User input fields (TextField, TextFormField)
/// - Dynamic API content (already translated by backend)
/// - Numbers, dates, codes
/// - Error messages from backend

import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Short alias for AutoTranslateText - use T() instead of AutoTranslateText() for automatic translation
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










