import 'dart:async';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/role_navigation_service.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/services/deeplink_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WaitingScreenController extends BaseController {
  Timer? _splashTimer;
  var _navigationTriggered = false;
  GetStorage get _storage => GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Minimum splash time, then wait for deeplink check so we don't show dashboard when opening from "Open Kundli"
    _splashTimer = Timer(const Duration(milliseconds: 500), () {
      _navigateAfterSplash();
    });
  }

  bool checkOnboardingCompleted() {
    return _storage.read('onboarding_completed') == true;
  }

  void navigateToOnboarding() {
    pushAndRemoveUntil(AppRoutes.onboarding);
  }

  void navigateToBasedOnLoginStatus() {
    final isLoggedIn = LoginGuard.isLoggedIn;
    if (isLoggedIn) {
      final userType = UserData().getLoginData.user?.userType ?? 'USER';
      RoleNavigationService.navigateToDashboard(userType);
    } else {
      pushAndRemoveUntil(AppRoutes.login);
    }
  }

  void _navigateAfterSplash() async {
    if (_navigationTriggered) return;

    // When opened from Astrologer "Open Kundli" deeplink, wait for initial link check then stay on splash
    // (DeepLinkHandler will replace with Kundli result when ready — no dashboard flash).
    if (Get.isRegistered<DeepLinkHandler>()) {
      final handler = Get.find<DeepLinkHandler>();
      await handler.initialLinkChecked
          .timeout(const Duration(milliseconds: 2000), onTimeout: () {});
      if (handler.wasLaunchedByKundliDeeplink) {
        return; // Stay on splash; handler will call Get.offNamed(kundliResult)
      }
    }

    if (_navigationTriggered) return;
    _navigationTriggered = true;

    // Check if onboarding has been completed
    final bool hasCompletedOnboarding = checkOnboardingCompleted();
    if (!hasCompletedOnboarding) {
      // Navigate to onboarding for new users
      pushAndRemoveUntil(AppRoutes.onboarding);
    } else {
      // For users who have completed onboarding, navigate to dashboard
      // Allow guest access - users can browse without login
      final isLoggedIn = LoginGuard.isLoggedIn;
      if (isLoggedIn) {
        // User is logged in, navigate to dashboard
        final userType = UserData().getLoginData.user?.userType ?? 'USER';
        RoleNavigationService.navigateToDashboard(userType);
      } else {
        // User is not logged in - allow guest access to dashboard
        // Guest mode will be set when user explicitly clicks "Continue as Guest"
        // For now, navigate directly to dashboard (no login required)
        pushAndRemoveUntil(AppRoutes.userDashboard);
      }
    }
  }

  @override
  void onClose() {
    _splashTimer?.cancel();
    super.onClose();
  }
}
