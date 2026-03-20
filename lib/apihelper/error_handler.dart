import 'dart:async';
import 'dart:io';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/apihelper/api_response.dart';
import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';

class ErrorHandler {
  /// Maps any error object to a user-friendly message.
  static String handle(dynamic error) {
    if (kDebugMode) {
      print('--- ERROR LOGGED ---');
      print('Error: $error');
      if (error is Error) {
        print('Stacktrace: ${error.stackTrace}');
      }
      print('--------------------');
    }

    // Report non-fatal error to Crashlytics
    final type = getErrorType(error);
    CrashlyticsService.recordError(
      error,
      error is Error
          ? (error.stackTrace ?? StackTrace.current)
          : StackTrace.current,
      type: _mapToCrashErrorType(type),
      reason: "API_PROVIDER_ERROR | type: ${type.name}",
    );

    if (error is SocketException) {
      return UserFriendlyError.message(
        error,
        fallback: "Network connection unavailable. Please check your internet.",
      );
    } else if (error is TimeoutException) {
      return UserFriendlyError.message(
        error,
        fallback: "Request timed out. Please check your connection and try again.",
      );
    } else if (error is FormatException) {
      return UserFriendlyError.message(
        error,
        fallback: "Something went wrong. Please try again later.",
      );
    } else if (error is HttpException) {
      return UserFriendlyError.message(
        error,
        fallback: "Network error. Please try again.",
      );
    } else if (error is NetworkException) {
      return UserFriendlyError.message(
        error.message,
        fallback: 'Unable to complete request right now. Please try again.',
      );
    } else if (error is Response) {
      return UserFriendlyError.message(
        _handleResponseError(error),
        fallback: "Could not connect to server.",
      );
    } else if (error is String) {
      return UserFriendlyError.message(error);
    }

    return UserFriendlyError.message(
      error,
      fallback: "An unexpected error occurred. Please try again.",
    );
  }

  /// Categorizes errors for logic handling.
  static ErrorType getErrorType(dynamic error) {
    if (error is SocketException) return ErrorType.network;
    if (error is TimeoutException) return ErrorType.timeout;
    if (error is Response) {
      final status = error.statusCode;
      if (status == 401) return ErrorType.unauthorized;
      if (status == 404) return ErrorType.notFound;
      if (status == 409) return ErrorType.conflict;
      if (status == 422) return ErrorType.validation;
      if (status != null && status >= 500) return ErrorType.server;
      if (status != null && status >= 400) return ErrorType.validation;
    }
    if (error is NetworkException) {
      if (error is BadRequestException) return ErrorType.validation;
      if (error is UnauthorisedException) return ErrorType.unauthorized;
    }
    return ErrorType.unknown;
  }

  static String _handleResponseError(Response response) {
    final status = response.statusCode;

    switch (status) {
      case 400:
        return "Invalid request. Please check your details.";
      case 401:
        return "Session expired. Please login again.";
      case 403:
        return "You don't have permission to perform this action.";
      case 404:
        return "Requested resource not found.";
      case 409:
        return "This record already exists.";
      case 422:
        return "Validation failed. Please check your input.";
      case 500:
        return "Server error. We're working on it.";
      case 503:
        return "Service temporarily unavailable. Please try later.";
      default:
        if (status != null && status >= 500) {
          return "Server is temporarily unavailable.";
        }
        return response.statusText ?? "Could not connect to server.";
    }
  }

  static CrashErrorType _mapToCrashErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
      case ErrorType.timeout:
        return CrashErrorType.network;
      case ErrorType.server:
        return CrashErrorType.network;
      case ErrorType.unauthorized:
        return CrashErrorType.auth;
      case ErrorType.validation:
      case ErrorType.notFound:
      case ErrorType.conflict:
        return CrashErrorType.network;
      case ErrorType.runtime:
        return CrashErrorType.unknown;
      case ErrorType.unknown:
        return CrashErrorType.unknown;
    }
  }
}
