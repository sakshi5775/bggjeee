class UserFriendlyError {
  static String message(
    dynamic raw, {
    String fallback = 'Something went wrong. Please try again.',
  }) {
    if (raw == null) return fallback;

    String input = raw.toString().trim();
    if (input.isEmpty) return fallback;

    input = input.replaceFirst('Exception: ', '').trim();
    input = input.replaceFirst('Error During Communication: ', '').trim();

    final lower = input.toLowerCase();
    if (lower == 'null' ||
        lower == 'undefined' ||
        lower.contains('undifined') ||
        lower.contains('Notice :') ||
        lower.contains('Notice') ||
        lower.contains('2: undefined') ||
        lower.contains('2: undifined')) {
      return fallback;
    }

    if (lower.contains('error during communication') ||
        lower.contains('exception:') ||
        lower.contains('dioexception') ||
        lower.contains('dio error')) {
      return fallback;
    }

    if (lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (lower.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (lower.contains('validation failed') ||
        lower.contains('unprocessable entity')) {
      return 'Some details are invalid. Please check and try again.';
    }

    if (lower.contains('unauthorized') ||
        lower.contains('invalid token') ||
        lower.contains('token expired') ||
        lower.contains('session expired')) {
      return 'Session expired. Please login again.';
    }

    if (lower.contains('forbidden') || lower.contains('access denied')) {
      return 'You do not have permission to perform this action.';
    }

    if (lower.contains('internal server error') ||
        lower.contains('status 500') ||
        lower.contains('status code 500')) {
      return 'Server error. Please try again in a while.';
    }

    if (lower.contains('payment cancelled') || lower.contains('user cancelled')) {
      return 'Payment was cancelled.';
    }

    // Avoid exposing raw server-side internal HTML/error blobs.
    if (input.contains('<html') || input.contains('</')) {
      return fallback;
    }

    return input;
  }
}
