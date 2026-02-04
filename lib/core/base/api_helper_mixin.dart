import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/apihelper/api_response.dart';
import 'package:astrobharataiuser/apihelper/error_handler.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';

mixin ApiHelperMixin {
  final RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  void setLoadingState(bool loading) {
    _isLoading.value = loading;
  }

  /// Legacy alias for backward compatibility.
  void showErrorMessage({String? title, required dynamic message}) {
    // Forward to centralized handler
    _handleErrorGlobally(message);
  }

  /// Legacy alias for backward compatibility.
  void showInfoMessage({String? title, required dynamic message}) {
    showWarningSnackbar(message);
  }

  /// Shows an error dialog for critical issues.
  void showErrorDialog({
    String? title,
    required dynamic error,
    VoidCallback? onRetry,
  }) {
    final message = ErrorHandler.handle(error);
    ErrorUiUtils.showErrorDialog(
      message: message,
      title: title,
      onRetry: onRetry,
    );
  }

  /// Shows a minor warning snackbar.
  void showWarningSnackbar(dynamic error) {
    final message = ErrorHandler.handle(error);
    ErrorUiUtils.showWarningSnackbar(message);
  }

  void showSuccessMessage({String? title, required String message}) {
    ErrorUiUtils.showSuccessSnackbar(message);
  }

  /// Private helper to handle errors based on type (401 -> Modal, else -> Snackbar)
  void _handleErrorGlobally(
    dynamic e, {
    bool useDialog = false,
    VoidCallback? onRetry,
  }) {
    final errorType = ErrorHandler.getErrorType(e);
    final isUnauthorized = errorType == ErrorType.unauthorized;
    final isGuest = LoginGuard.isGuest;

    if (isUnauthorized) {
      if (isGuest) {
        // For guest users, show the login required modal instead of a snackbar
        LoginGuard.showLoginRequiredModal(
          message: 'Please login to access this feature.',
        );
      } else {
        // For logged in users whose session expired, also show the modal
        LoginGuard.showLoginRequiredModal(
          message: 'Session expired. Please login again.',
        );
      }
    } else {
      // Normal error handling for other error types
      if (useDialog) {
        showErrorDialog(error: e, onRetry: onRetry);
      } else {
        showWarningSnackbar(e);
      }
    }
  }

  /// Executes an async task with loading state and standardized error handling.
  Future<T?> runWithLoading<T>(
    Future<T> Function() task, {
    bool showBusy = true,
    bool showError = true,
    bool useDialog = false,
    String? successMessage,
    VoidCallback? onRetry,
    bool silent401ForGuest =
        true, // By default, silent 401s for background tasks
  }) async {
    try {
      if (showBusy) setLoadingState(true);
      final result = await task();
      if (successMessage != null) {
        showSuccessMessage(message: successMessage);
      }
      return result;
    } catch (e) {
      if (showError) {
        final errorType = ErrorHandler.getErrorType(e);
        final isUnauthorized = errorType == ErrorType.unauthorized;
        final isGuest = LoginGuard.isGuest;

        if (isUnauthorized && isGuest && silent401ForGuest) {
          debugPrint('Silent 401 handled for guest user background task');
        } else {
          _handleErrorGlobally(e, useDialog: useDialog, onRetry: onRetry);
        }
      }
      return null;
    } finally {
      if (showBusy) setLoadingState(false);
    }
  }
}
