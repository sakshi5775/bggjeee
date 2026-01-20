import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/services/guest_session_manager.dart';
import 'package:astrobharataiuser/widgets/login_required_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Simple helper to gate features that require authentication.
/// Shows a login/signup prompt when the user is in guest mode.
class LoginGuard {
  static bool get isLoggedIn =>
      UserData().accessToken != null && UserData().accessToken!.isNotEmpty;

  static bool get isGuest => !isLoggedIn;

  /// Returns true when the user is logged in.
  /// When the user is a guest, a login modal is shown and `false` is returned.
  /// 
  /// [message] - Optional custom message to display in the modal
  /// [onLoginSuccess] - Optional callback to execute after successful login
  static Future<bool> ensureLoggedIn({
    String? message,
    VoidCallback? onLoginSuccess,
  }) async {
    if (isLoggedIn) return true;
    
    // Show login modal for guest users or non-logged-in users
    await showLoginRequiredModal(
      message: message,
      onLoginSuccess: onLoginSuccess,
    );
    return false;
  }

  /// Show a reusable login-required modal with email/password fields.
  /// This modal allows users to login directly without navigating away.
  static Future<void> showLoginRequiredModal({
    String? message,
    VoidCallback? onLoginSuccess,
  }) async {
    // Avoid stacking multiple dialogs of the same kind.
    if (Get.isDialogOpen == true) {
      Get.back(closeOverlays: true);
    }

    await Get.dialog(
      LoginRequiredModal(
        message: message,
        onLoginSuccess: onLoginSuccess,
      ),
      barrierDismissible: true,
    );
  }
}

