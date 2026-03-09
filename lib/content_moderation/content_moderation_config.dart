/// How to react when harmful text is detected.
enum ModerationAction {
  /// Prevent the word from being entered (revert last word).
  block,

  /// Remove the offending word from the text.
  remove,

  /// Replace the word with a mask (e.g. f***).
  mask,
}

/// Configuration for the content moderation system.
class ContentModerationConfig {
  const ContentModerationConfig({
    this.action = ModerationAction.block,
    this.warningMessage = 'Please avoid offensive language.',
    this.maskChar = '*',
    this.minWordLength = 2,
    this.checkOnWordBoundary = true,
  });

  /// What to do when harmful text is detected.
  final ModerationAction action;

  /// Message shown to the user (e.g. via SnackBar).
  final String warningMessage;

  /// Character used when [action] is [ModerationAction.mask].
  final String maskChar;

  /// Minimum length of token to run moderation (avoids false positives on "a", "i").
  final int minWordLength;

  /// If true, only run check when user types a word boundary (space/punctuation).
  final bool checkOnWordBoundary;

  ContentModerationConfig copyWith({
    ModerationAction? action,
    String? warningMessage,
    String? maskChar,
    int? minWordLength,
    bool? checkOnWordBoundary,
  }) {
    return ContentModerationConfig(
      action: action ?? this.action,
      warningMessage: warningMessage ?? this.warningMessage,
      maskChar: maskChar ?? this.maskChar,
      minWordLength: minWordLength ?? this.minWordLength,
      checkOnWordBoundary: checkOnWordBoundary ?? this.checkOnWordBoundary,
    );
  }
}
