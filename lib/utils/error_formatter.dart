/// Utility class to format errors in a production-friendly way
class ErrorFormatter {
  /// Format exception to user-friendly message
  static String formatError(dynamic error) {
    if (error == null) {
      return 'An unexpected error occurred. Please try again.';
    }

    final errorString = error.toString().toLowerCase();
    final errorMessage = error.toString();

    // Network errors
    if (errorString.contains('socketexception') ||
        errorString.contains('network') ||
        errorString.contains('connection refused') ||
        errorString.contains('failed host lookup')) {
      return 'No internet connection. Please check your network and try again.';
    }

    // Timeout errors
    if (errorString.contains('timeout') ||
        errorString.contains('timed out') ||
        errorString.contains('deadline exceeded')) {
      return 'Request timeout. The server took too long to respond. Please try again.';
    }

    // Connection closed errors
    if (errorString.contains('connection closed') ||
        errorString.contains('connection reset')) {
      return 'Connection error. Please try again with a smaller image or check your internet connection.';
    }

    // HTTP errors
    if (errorString.contains('statuscode')) {
      if (errorString.contains('401') || errorString.contains('unauthorized')) {
        return 'Authentication failed. Please login again.';
      }
      if (errorString.contains('403') || errorString.contains('forbidden')) {
        return 'Access denied. Please check your permissions.';
      }
      if (errorString.contains('404') || errorString.contains('not found')) {
        return 'Service not found. Please try again later.';
      }
      if (errorString.contains('500') ||
          errorString.contains('internal server error')) {
        return 'Server error. Please try again later.';
      }
      if (errorString.contains('503') ||
          errorString.contains('service unavailable')) {
        return 'Service temporarily unavailable. Please try again later.';
      }
      return 'Server error. Please try again later.';
    }

    // JSON parsing errors
    if (errorString.contains('json') ||
        errorString.contains('format exception') ||
        errorString.contains('unexpected character')) {
      return 'Invalid response from server. Please try again.';
    }

    // File/image errors
    if (errorString.contains('file') ||
        errorString.contains('image') ||
        errorString.contains('format')) {
      return 'Image format error. Please try with a different image.';
    }

    // Permission errors
    if (errorString.contains('permission') || errorString.contains('denied')) {
      return 'Permission denied. Please check app permissions.';
    }

    // If error message already looks user-friendly (contains common user-friendly phrases)
    if (errorMessage.contains('Please') ||
        errorMessage.contains('try again') ||
        errorMessage.contains('check') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout')) {
      // Return as is if it's already user-friendly
      return errorMessage
          .replaceAll('Exception: ', '')
          .replaceAll('Error: ', '')
          .trim();
    }

    // Default: return a generic user-friendly message
    // Extract meaningful part if it's an Exception
    if (errorMessage.startsWith('Exception: ')) {
      final message = errorMessage.substring(11).trim();
      if (message.isNotEmpty && message.length < 100) {
        return message;
      }
    }

    return 'An error occurred. Please try again.';
  }

  /// Format error for snackbar display
  static String formatErrorForSnackbar(dynamic error) {
    return formatError(error);
  }
}
