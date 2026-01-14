import 'dart:async';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/role_navigation_service.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:get_storage/get_storage.dart';

class WaitingScreenController extends BaseController {
  Timer? _splashTimer;
  var _navigationTriggered = false;
  final GetStorage _storage = GetStorage();
  Duration? _videoDuration;

  @override
  void onInit() {
    super.onInit();
    // Start with a minimum delay, will be updated when video loads
    _splashTimer = Timer(const Duration(seconds: 3), () {
      _navigateAfterSplash();
    });
  }

  void setVideoDuration(Duration duration) {
    if (_navigationTriggered) return;
    
    _videoDuration = duration;
    // Cancel existing timer
    _splashTimer?.cancel();
    
    // Wait for video duration + small buffer
    final waitTime = duration + const Duration(milliseconds: 500);
    _splashTimer = Timer(waitTime, () {
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

  void _navigateAfterSplash() {
    if (_navigationTriggered) return;
    _navigationTriggered = true;

    // Check if onboarding has been completed
    final bool hasCompletedOnboarding = checkOnboardingCompleted();
    if (!hasCompletedOnboarding) {
      // Navigate to onboarding for new users
      pushAndRemoveUntil(AppRoutes.onboarding);
    } else {
      // For users who have completed onboarding, navigate based on login status
      final isLoggedIn = LoginGuard.isLoggedIn;
      if (isLoggedIn) {
        final userType = UserData().getLoginData.user?.userType ?? 'USER';
        RoleNavigationService.navigateToDashboard(userType);
      } else {
        pushAndRemoveUntil(AppRoutes.login);
      }
    }
  }

  @override
  void onClose() {
    _splashTimer?.cancel();
    super.onClose();
  }
}
