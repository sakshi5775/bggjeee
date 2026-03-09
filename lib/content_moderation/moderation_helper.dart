import 'package:astrobharataiuser/content_moderation/abusive_words_data.dart';
import 'package:astrobharataiuser/content_moderation/text_normalizer.dart';

/// Result of a moderation check.
class ModerationResult {
  const ModerationResult({
    required this.isHarmful,
    this.offendingWord,
    this.maskedText,
  });

  final bool isHarmful;
  final String? offendingWord;
  final String? maskedText;

  static const ModerationResult safe = ModerationResult(isHarmful: false);
}

/// Combines dictionary, regex, and normalization for real-time moderation.
class ModerationHelper {
  ModerationHelper({
    this.minWordLength = 2,
  }) {
    _compilePatterns();
  }

  final int minWordLength;
  late List<RegExp> _regexPatterns;

  void _compilePatterns() {
    // Patterns for common obfuscations (f*ck, f@ck, f.u.c.k, etc.)
    final basePatterns = [
      r'f[\W]*u[\W]*c[\W]*k',
      r's[\W]*h[\W]*i[\W]*t',
      r'b[\W]*i[\W]*t[\W]*c[\W]*h',
      r'a[\W]*s[\W]*s[\W]*h[\W]*o[\W]*l[\W]*e',
      r'm[\W]*a[\W]*d[\W]*a[\W]*r[\W]*c[\W]*h[\W]*o[\W]*d',
      r'm[\W]*a[\W]*d[\W]*e[\W]*r[\W]*c[\W]*h[\W]*o[\W]*d',
      r'b[\W]*h[\W]*e[\W]*n[\W]*c[\W]*h[\W]*o[\W]*d',
      r'b[\W]*e[\W]*h[\W]*e[\W]*n[\W]*c[\W]*h[\W]*o[\W]*d',
      r'c[\W]*h[\W]*u[\W]*t[\W]*i[\W]*y[\W]*a',
      r'c[\W]*h[\W]*o[\W]*d',
      r'g[\W]*a[\W]*n[\W]*d[\W]*u',
      r'r[\W]*a[\W]*n[\W]*d[\W]*i',
      r'h[\W]*a[\W]*r[\W]*a[\W]*m[\W]*i',
      r'l[\W]*a[\W]*u[\W]*d[\W]*a',
      r'l[\W]*u[\W]*n[\W]*d',
      r'g[\W]*a[\W]*a[\W]*n[\W]*d',
      r'b[\W]*s[\W]*d[\W]*k',
      r'b[\W]*h[\W]*o[\W]*s[\W]*d[\W]*i[\W]*k[\W]*e',
    ];
    _regexPatterns = basePatterns
        .map((p) => RegExp(p, caseSensitive: false))
        .toList();
  }

  /// Checks a single word (raw or normalized). Prefer passing normalized.
  ModerationResult checkWord(String word, {bool alreadyNormalized = false}) {
    final normalized = alreadyNormalized
        ? word
        : TextNormalizer.normalizeWord(word);

    if (normalized.length < minWordLength) return ModerationResult.safe;

    // 1) Dictionary lookup
    if (AbusiveWordsData.contains(normalized)) {
      return ModerationResult(isHarmful: true, offendingWord: word);
    }

    // 2) Regex on normalized form (catches dotted/starred variants)
    for (final re in _regexPatterns) {
      if (re.hasMatch(normalized)) {
        return ModerationResult(isHarmful: true, offendingWord: word);
      }
    }

    // 3) Regex on original word (for mixed punctuation)
    for (final re in _regexPatterns) {
      if (re.hasMatch(word)) {
        return ModerationResult(isHarmful: true, offendingWord: word);
      }
    }

    return ModerationResult.safe;
  }

  /// Checks the last word of [text]. Use when user just typed a space/punctuation.
  ModerationResult checkLastWord(String text) {
    final lastWord = TextNormalizer.getLastWord(text);
    if (lastWord.isEmpty || lastWord.length < minWordLength) {
      return ModerationResult.safe;
    }
    return checkWord(lastWord);
  }

  /// Returns masked version of [word] (e.g. "fuck" -> "f***").
  String maskWord(String word, String maskChar) {
    if (word.isEmpty) return maskChar * 3;
    if (word.length == 1) return maskChar * 3;
    if (word.length == 2) return '${word[0]}$maskChar';
    return '${word[0]}${maskChar * (word.length - 2)}${word[word.length - 1]}';
  }

  /// Removes the last word from [text] (after last space). Keeps one trailing space.
  String removeLastWord(String text) {
    final trimmed = text.trimRight();
    if (trimmed.isEmpty) return '';
    final lastSpace = trimmed.lastIndexOf(RegExp(r'\s'));
    if (lastSpace == -1) return ''; // entire input was one word
    return trimmed.substring(0, lastSpace + 1);
  }

  /// Returns true if [text] contains ANY harmful word (every token checked).
  /// Use before sending message so no abusive content is sent even without space.
  bool containsHarmfulWord(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    final words = trimmed.split(RegExp(r'\s+'));
    for (final word in words) {
      if (word.trim().length >= minWordLength && checkWord(word.trim()).isHarmful) {
        return true;
      }
    }
    return false;
  }

  /// Returns text with all harmful words masked. Used when blocking send.
  String maskHarmfulWords(String text, String maskChar) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return text;
    final words = trimmed.split(RegExp(r'(\s+)'));
    final buffer = StringBuffer();
    for (final segment in words) {
      final s = segment.trim();
      if (s.length >= minWordLength && checkWord(s).isHarmful) {
        buffer.write(maskWord(s, maskChar));
      } else {
        buffer.write(segment);
      }
    }
    return buffer.toString();
  }
}
