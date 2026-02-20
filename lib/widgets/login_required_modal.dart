import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Login Required Modal Widget
/// Shows when guest user tries to access protected features
class LoginRequiredModal extends StatelessWidget {
  final String? message;
  final VoidCallback? onLoginSuccess;

  const LoginRequiredModal({
    super.key,
    this.message,
    this.onLoginSuccess,
  });

  void _navigateToLogin() {
    Get.back();
    Get.toNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.deepOrangemix.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                color: AppColors.deepOrangemix,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            AutoTranslateText(
              'Login Required',
              style: MyTextTheme.largeBCB.copyWith(
                color: AppColors.deepOrangemix,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Message
            AutoTranslateText(
              message ??
                  'Please login to continue using this feature.',
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.gray,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Login Button
            GestureDetector(
              onTap: _navigateToLogin,
              child: Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF38B3B), // light orange
                      Color(0xFFDD2914), // deep orange/red
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      AutoTranslateText(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cancel Button
            TextButton(
              onPressed: () => Get.back(),
              child: AutoTranslateText(
                'Maybe Later',
                style: MyTextTheme.smallBCB.copyWith(
                  color: AppColors.gray,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

