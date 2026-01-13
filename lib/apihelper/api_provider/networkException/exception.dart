import 'dart:convert';

import 'package:get/get_connect.dart';

dynamic returnException(Response response) {
  // For 403 errors, return a silent exception that won't trigger error display
  if (response.statusCode == 403) {
    return FetchDataException('Access denied');
  }

  String message = 'Error occurred while communicating with server';

  try {
    if (response.body == null) {
      message = 'Server did not respond';
    } else if (response.body is String) {
      // Try to parse as JSON
      try {
        final decodedBody = json.decode(response.body as String);
        if (decodedBody is Map<String, dynamic>) {
          message = _extractErrorMessage(decodedBody, message);
        }
      } catch (e) {
        // If parsing fails, use the string as message if it's not empty
        final bodyStr = response.body as String;
        if (bodyStr.trim().isNotEmpty) {
          message = bodyStr;
        }
      }
    } else if (response.body is Map) {
      message = _extractErrorMessage(response.body as Map, message);
    }
  } catch (e) {
    // If all else fails, use status code in message
    message = 'Server error (${response.statusCode})';
  }

  // Filter out "account has been deactivated" messages
  final msgLower = message.toLowerCase();
  if (msgLower.contains('account has been deactivated')) {
    message = 'Access denied';
  }

  // Include status code in message for better debugging
  if (message == 'Error occurred while communicating with server' ||
      message == 'Server did not respond') {
    message = '$message (${response.statusCode})';
  }

  switch (response.statusCode) {
    case 400:
      return BadRequestException(message);
    case 401:
      return UnauthorisedException(message);
    case 404:
      return UnauthorisedException(message);
    case 429:
      return FetchDataException('Too many requests. Please try again later.');
    case 500:
    case 502:
    case 503:
    case 504:
      return FetchDataException(message);
    default:
      return FetchDataException(message);
  }
}

String _extractErrorMessage(Map<dynamic, dynamic> body, String defaultMessage) {
  String? extractedMessage;
  
  // Try to extract message from various possible locations
  if (body['message'] != null) {
    final msg = body['message'];
    if (msg is String && msg.isNotEmpty) {
      extractedMessage = msg;
    }
  }

  if (extractedMessage == null && body['error'] != null) {
    final err = body['error'];
    if (err is String && err.isNotEmpty) {
      extractedMessage = err;
    } else if (err is Map) {
      // Handle nested error object
      final nestedMsg = err['message'] ?? err['msg'];
      if (nestedMsg is String && nestedMsg.isNotEmpty) {
        extractedMessage = nestedMsg;
      }
    }
  }

  if (extractedMessage == null && body['errors'] != null) {
    final errors = body['errors'];
    if (errors is List && errors.isNotEmpty) {
      final firstError = errors.first;
      if (firstError is Map) {
        final errorMsg = firstError['message'] ?? firstError['msg'];
        if (errorMsg is String && errorMsg.isNotEmpty) {
          extractedMessage = errorMsg;
        }
      } else if (firstError is String && firstError.isNotEmpty) {
        extractedMessage = firstError;
      }
    }
  }

  if (extractedMessage == null && body['data'] != null) {
    final data = body['data'];
    if (data is Map) {
      final dataMsg = data['message'] ?? data['error'];
      if (dataMsg is String && dataMsg.isNotEmpty) {
        extractedMessage = dataMsg;
      }
    } else if (data is String && data.isNotEmpty) {
      extractedMessage = data;
    }
  }

  // Filter out "account has been deactivated" messages
  if (extractedMessage != null) {
    final msgLower = extractedMessage.toLowerCase();
    if (msgLower.contains('account has been deactivated') ||
        msgLower.contains('your account has been deactivated')) {
      // Return a generic message instead
      return 'Access denied';
    }
    return extractedMessage;
  }

  return defaultMessage;
}

class NetworkException implements Exception {
  final dynamic _message;
  final dynamic _prefix;

  NetworkException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class FetchDataException extends NetworkException {
  FetchDataException([String? message])
    : super(message, "Error During Communication: ");
}

class BadRequestException extends NetworkException {
  BadRequestException([message]) : super(message, "Error: ");
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException([message]) : super(message, "Error: ");
}

class AlreadyReportedException extends NetworkException {
  final String _message;
  
  AlreadyReportedException([String? message]) 
    : _message = message ?? 'You have already reported this stream',
      super(message, "");
  
  @override
  String toString() {
    return _message;
  }
}
