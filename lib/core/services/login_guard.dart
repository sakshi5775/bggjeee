import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Simple helper to gate features that require authentication.
/// Shows a login/signup prompt when the user is in guest mode.
class LoginGuard {
  static bool get isLoggedIn =>
      UserData().accessToken != null && UserData().accessToken!.isNotEmpty;

  static bool get isGuest => !isLoggedIn;

  /// Returns true when the user is logged in.
  /// When the user is a guest, a login dialog is shown and `false` is returned.
  static Future<bool> ensureLoggedIn({String? message}) async {
    if (isLoggedIn) return true;
    await showLoginRequiredDialog(message: message);
    return false;
  }

  /// Show a reusable login-required dialog with Login / Sign up actions.
  static Future<void> showLoginRequiredDialog({String? message}) async {
    // Avoid stacking multiple dialogs of the same kind.
    if (Get.isDialogOpen == true) {
      Get.back(closeOverlays: true);
    }

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8A00), Color(0xFFFF5F6D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const AutoTranslateText(
                'Login required',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              AutoTranslateText(
                message ?? 'Please login to continue using this feature.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.14),
                      ),
                      onPressed: () => Get.back(),
                      child: const AutoTranslateText('Maybe later'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF5F6D),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Get.back();
                        Get.toNamed(AppRoutes.login);
                      },
                      child: const AutoTranslateText('Login'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.signup);
                },
                child: const AutoTranslateText(
                  'New here? Create an account',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}

