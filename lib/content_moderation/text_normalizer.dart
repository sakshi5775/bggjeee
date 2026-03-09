/// Normalizes text for content moderation so that obfuscated or
/// leetspeak variants can be matched against a word list.
class TextNormalizer {
  TextNormalizer._();

  /// Characters commonly used to replace letters in bypass attempts.
  static const Map<String, String> _replacementMap = {
    '0': 'o',
    '1': 'i',
    '3': 'e',
    '4': 'a',
    '5': 's',
    '7': 't',
    '8': 'b',
    '9': 'g',
    '@': 'a',
    '!': 'i',
    '\$': 's',
    '+': 't',
    '|': 'i',
    '€': 'e',
    '£': 'e',
  };

  /// Punctuation and symbols that can separate letters in words.
  static final RegExp _punctuationRegex = RegExp(r'[^\w\s]');
  static final RegExp _repeatedCharsRegex = RegExp(r'(.)\1{2,}');
  static final RegExp _multipleSpacesRegex = RegExp(r'\s+');

  /// Normalizes a single word for moderation check.
  /// - Converts to lowercase
  /// - Replaces common character substitutions (0→o, @→a, etc.)
  /// - Removes punctuation and special characters between letters
  /// - Collapses repeated characters (e.g. "fuuuck" → "fuck")
  /// - Trims and collapses spaces
  static String normalizeWord(String word) {
    if (word.isEmpty) return '';

    String normalized = word.toLowerCase().trim();

    // Replace known character substitutions
    for (final entry in _replacementMap.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }

    // Remove punctuation and special chars (keeps letters and digits for now)
    normalized = normalized.replaceAll(_punctuationRegex, '');

    // Collapse repeated characters to at most 2 (e.g. "fuuuck" -> "fuuck")
    normalized = _collapseRepeated(normalized);

    // Final cleanup: only letters (support multiple scripts)
    normalized = _keepOnlyWordChars(normalized);

    return normalized.trim();
  }

  /// Collapses 3+ repeated characters to 2.
  static String _collapseRepeated(String input) {
    return input.replaceAllMapped(_repeatedCharsRegex, (match) {
      final char = match.group(1) ?? '';
      return char + char;
    });
  }

  /// Keeps only characters that form words (letters from any script, numbers).
  static String _keepOnlyWordChars(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      if (_isWordChar(char)) buffer.write(char);
    }
    return buffer.toString();
  }

  static bool _isWordChar(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    // Latin, digits
    if ((code >= 0x30 && code <= 0x39) ||
        (code >= 0x61 && code <= 0x7a) ||
        (code >= 0x41 && code <= 0x5a)) {
      return true;
    }
    // Devanagari (Hindi)
    if (code >= 0x0900 && code <= 0x097F) return true;
    // Common extended Latin
    if (code >= 0x00C0 && code <= 0x024F) return true;
    return false;
  }

  /// Extracts the last "word" from text (text after last space or start).
  /// Handles multiple spaces and trims.
  static String getLastWord(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';

    final lastSpace = trimmed.lastIndexOf(RegExp(r'\s'));
    if (lastSpace == -1) return trimmed;

    return trimmed.substring(lastSpace + 1).trim();
  }

  /// Returns the start index of the last word in [text] (for substring/replace).
  static int getLastWordStartIndex(String text) {
    final trimmed = text.trimRight();
    if (trimmed.isEmpty) return 0;
    final lastSpace = trimmed.lastIndexOf(RegExp(r'\s'));
    return lastSpace == -1 ? 0 : lastSpace + 1;
  }

  /// Returns true if [char] is a word-boundary character (space, punctuation).
  static bool isWordBoundary(String char) {
    if (char.isEmpty) return false;
    return char == ' ' ||
        char == '\n' ||
        char == '\t' ||
        _punctuationRegex.hasMatch(char);
  }
}
