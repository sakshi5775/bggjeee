import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends BaseController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;
  final GetStorage _storage = GetStorage();

  final titles = ["Title for page 1", "Title for page 2", "Title for page 3"];

  final descriptions = [
    "Text for page 1",
    "Text for page 2",
    "Text for page 3",
  ];

  final pageButtons = [
    ["AI Astrologer Chat", "Live Video Consultation", "Expert Pandit"],
    ["AI Astrologer Chat", "Live Video Consultation", "Expert Pandit"],
    ["Kundli & Horoscope", "Virtual Temple & Pooja", "Remedies & shop"],
  ];

  @override
  void onInit() {
    super.onInit();
    // Check if user is logged in
    final isLoggedIn = UserData().getLoginData.accessToken != null;

    // Removed auto-advance functionality for non-logged-in users
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    // Manual next button
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  /// SKIP BUTTON
  void skip() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // Mark onboarding as completed when skipped
    _storage.write('onboarding_completed', true);
    pushAndRemoveUntil(AppRoutes.login);
  }

  void back() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    _storage.write('onboarding_completed', true);

    // Navigate to login screen (since this is only for non-logged-in users)
    pushAndRemoveUntil(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
