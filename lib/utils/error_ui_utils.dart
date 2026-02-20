import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorUiUtils {
  /// Shows a professional error dialog for critical failures.
  static void showErrorDialog({
    String? title,
    required String message,
    VoidCallback? onRetry,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title ?? 'Something went wrong',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Get.back();
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Shows a toast or snackbar for minor warnings or informational errors.
  static void showWarningSnackbar(String message) {
    Get.snackbar(
      'Notice',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber[100],
      colorText: Colors.black87,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
      duration: const Duration(seconds: 3),
    );
  }

  /// Shows a success snackbar.
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.black87,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      duration: const Duration(seconds: 3),
    );
  }
}
