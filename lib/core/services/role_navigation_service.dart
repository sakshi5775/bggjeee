import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleNavigationService {
  // This is a user-only app, so always navigate to user dashboard
  static void navigateToDashboard(String userType, {BuildContext? context}) {
    // Wait for GetMaterialApp to be ready
    Future.delayed(Duration(milliseconds: 300), () {
      try {
        // Check if GetMaterialApp context is available
        if (Get.key.currentContext != null) {
          // Avoid redundant navigation calls during login/splash races.
          if (Get.currentRoute == AppRoutes.userDashboard) return;
          // Use GetX navigation
          Get.offAllNamed(AppRoutes.userDashboard);
        } else if (context != null) {
          // Fallback to Navigator
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.userDashboard,
            (route) => false,
          );
        } else {
          // Try again after a delay
          Future.delayed(Duration(milliseconds: 500), () {
            if (Get.key.currentContext != null) {
              if (Get.currentRoute == AppRoutes.userDashboard) return;
              Get.offAllNamed(AppRoutes.userDashboard);
            }
          });
        }
      } catch (e) {
        // If GetX navigation fails, use Navigator fallback
        if (context != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.userDashboard,
            (route) => false,
          );
        }
      }
    });
  }

  static void navigateToUserDashboard({BuildContext? context}) {
    // Wait for GetMaterialApp to be ready
    Future.delayed(Duration(milliseconds: 300), () {
      try {
        // Check if GetMaterialApp context is available
        if (Get.key.currentContext != null) {
          if (Get.currentRoute == AppRoutes.userDashboard) return;
          // Use GetX navigation
          Get.offAllNamed(AppRoutes.userDashboard);
        } else if (context != null) {
          // Fallback to Navigator
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.userDashboard,
            (route) => false,
          );
        } else {
          // Try again after a delay
          Future.delayed(Duration(milliseconds: 500), () {
            if (Get.key.currentContext != null) {
              if (Get.currentRoute == AppRoutes.userDashboard) return;
              Get.offAllNamed(AppRoutes.userDashboard);
            }
          });
        }
      } catch (e) {
        // If GetX navigation fails, use Navigator fallback
        if (context != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.userDashboard,
            (route) => false,
          );
        }
      }
    });
  }
}
