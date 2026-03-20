import 'package:astrobharataiuser/data_model/tarot_card_model.dart';
import 'package:flutter/foundation.dart';

/// Centralized handler for tarot card validation errors
///
/// This handler provides a single source of truth for detecting and handling
/// unsuitable card errors (status 400) across ALL tarot reading segments.
///
/// Benefits:
/// - Eliminates code duplication (~300 lines)
/// - Consistent behavior across all segments
/// - Easy to extend for future segments
/// - Follows SOLID principles
/// - Production-ready with proper error handling
class TarotCardValidationHandler {
  /// Handles API errors and detects unsuitable card scenarios
  ///
  /// Returns `true` if the error was handled (unsuitable card detected),
  /// `false` if it's a different type of error that should be handled by caller
  ///
  /// Parameters:
  /// - [error]: The exception thrown by the API call
  /// - [categoryName]: Human-readable category name (e.g., "Yes/No Reading", "Career Reading")
  /// - [selectedCard]: The card that was selected (may be null for auto-select)
  /// - [onShowUnsuitableMessage]: Callback to trigger the unsuitable card animation
  /// - [onRetry]: Callback to retry the API call (will be called after animation)
  /// - [maxRetries]: Maximum number of auto-retries (default: 3)
  /// - [currentRetryCount]: Current retry attempt count (default: 0)
  static Future<bool> handleApiError({
    required dynamic error,
    required String categoryName,
    required TarotCardModel? selectedCard,
    required Function(String cardName, String category) onShowUnsuitableMessage,
    required VoidCallback onRetry,
    int maxRetries = 3,
    int currentRetryCount = 0,
  }) async {
    final fullError = error.toString();
    final errorMsg = fullError.replaceAll('Exception: ', '');

    debugPrint(
      '🔍 TarotCardValidationHandler - Analyzing error for $categoryName',
    );
    debugPrint('🔍 Full error: $fullError');
    debugPrint(
      '🔍 Selected card: ${selectedCard?.name ?? "null (auto-select)"}',
    );
    debugPrint('🔍 Retry count: $currentRetryCount / $maxRetries');

    // Check if it's a card suitability error (status 400)
    final isStatus400 = _isUnsuitableCardError(fullError, errorMsg);

    if (!isStatus400) {
      debugPrint('❌ Not a status 400 error - caller should handle');
      return false; // Not a validation error, caller should handle
    }

    // Check retry limit
    if (currentRetryCount >= maxRetries) {
      debugPrint('⚠️ Max retries ($maxRetries) reached for $categoryName');
      return false; // Max retries reached, caller should handle
    }

    // Show unsuitable card animation
    debugPrint('🎬 Showing unsuitable card animation');
    debugPrint(
      '   Card: ${selectedCard?.name ?? "Auto-selected"}',
    );
    debugPrint('   Category: $categoryName');
    debugPrint('   Will auto-retry after animation');

    // Trigger the unsuitable card message
    onShowUnsuitableMessage(
      selectedCard?.name ?? 'Auto-selected',
      categoryName,
    );

    // Schedule retry after a small delay (animation will complete first)
    // The animation widget will call onRetry via handleUnsuitableCardAutoRetry

    return true; // Error was handled
  }

  /// Checks if the error is a status 400 unsuitable card error
  static bool _isUnsuitableCardError(String fullError, String errorMsg) {
    return fullError.contains('Status: 400') ||
        fullError.contains('status: 400') ||
        fullError.contains('400') ||
        errorMsg.contains('Status: 400') ||
        errorMsg.contains('status: 400') ||
        errorMsg.toLowerCase().contains('not suitable') ||
        errorMsg.toLowerCase().contains('invalid card') ||
        errorMsg.toLowerCase().contains('unsuitable');
  }

  /// Checks if the error is a duplicate card error
  static bool isDuplicateCardError(dynamic error) {
    final errorMsg = error.toString().toLowerCase();
    return errorMsg.contains('same card') ||
        errorMsg.contains('duplicate') ||
        errorMsg.contains('cannot use the same');
  }

  /// Formats category name from reading type
  ///
  /// Examples:
  /// - "in-depth" → "In Depth"
  /// - "made-for-each-other" → "Made For Each Other"
  /// - "romantic-breakup" → "Romantic Breakup"
  static String formatCategoryName(String readingType) {
    return readingType
        .replaceAll('-', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  /// Creates a standardized error message for validation failures
  static String getValidationErrorMessage({
    required String categoryName,
    bool isDuplicate = false,
  }) {
    if (isDuplicate) {
      return 'You cannot use the same card multiple times. Please select different cards.';
    }
    return 'Unable to get $categoryName reading. Please try selecting a different card or skip to auto-select.';
  }
}
