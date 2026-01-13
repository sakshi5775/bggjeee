import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends BaseController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;
  var isAutoAdvancing = false.obs;
  final GetStorage _storage = GetStorage();
  Timer? _autoAdvanceTimer;

  @override
  void onInit() {
    super.onInit();
    // Check if user is logged in
    final isLoggedIn = UserData().getLoginData.accessToken != null;
    
    if (!isLoggedIn) {
      // For non-logged-in users: auto-advance through all 3 pages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startAutoAdvance();
      });
    }
  }

  void startAutoAdvance() {
    isAutoAdvancing.value = true;
    _autoAdvanceToNextPage();
  }

  void _autoAdvanceToNextPage() {
    _autoAdvanceTimer?.cancel();
    
    // Wait 1 second on current page before advancing
    _autoAdvanceTimer = Timer(const Duration(seconds: 1), () {
      if (currentPage.value < 2) {
        // Move to next page
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) {
          // After animation completes, currentPage will be updated via onPageChanged
          // Then continue to next page after 1 second
          _autoAdvanceToNextPage();
        });
      } else {
        // Last page completed, wait 1 second then navigate to login
        _autoAdvanceTimer?.cancel();
        _autoAdvanceTimer = Timer(const Duration(seconds: 1), () {
          _completeOnboarding();
        });
      }
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    // Manual next button - only works if auto-advance is disabled
    if (!isAutoAdvancing.value) {
      if (currentPage.value < 2) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _completeOnboarding();
      }
    }
  }

  void _completeOnboarding() {
    _autoAdvanceTimer?.cancel();
    // Mark onboarding as completed
    _storage.write('onboarding_completed', true);
    
    // Navigate to login screen (since this is only for non-logged-in users)
    pushAndRemoveUntil(AppRoutes.login);
  }

  @override
  void onClose() {
    _autoAdvanceTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}

