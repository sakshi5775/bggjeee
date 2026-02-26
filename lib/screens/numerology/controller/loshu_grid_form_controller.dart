import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/numerology/service/numerology_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';

class LoShuGridFormController extends BaseController {
  final NumerologyService _numerologyService = NumerologyService();

  // Form fields
  final selectedDate = Rx<DateTime?>(null);
  final selectedGender = RxString('');
  final selectedLanguage = RxString('en');

  // Loading state
  final isLoading = false.obs;

  // Language options
  final Map<String, String> languages = {
    'en': 'English',
    'hi': 'Hindi',
    'te': 'Telugu',
    'ka': 'Kannada',
    'ml': 'Malayalam',
    'be': 'Bengali',
    'gr': 'Gujarati',
    'mr': 'Marathi',
  };

  // Gender options
  final List<String> genders = ['male', 'female'];

  final UserProfileService _userProfileService = UserProfileService();

  @override
  void onInit() {
    super.onInit();
    _loadUserProfileData();
  }

  Future<void> _loadUserProfileData() async {
    try {
      final userId = UserData().getLoginData.user?.userId;
      if (userId == null) return;
      final profile = await _userProfileService.getProfile(userId);
      if (profile == null) return;

      if (profile.personalInfo != null) {
        final gender = profile.personalInfo!.gender;
        if (gender != null &&
            gender.isNotEmpty &&
            selectedGender.value.isEmpty) {
          if (gender.toUpperCase() == 'MALE') {
            selectedGender.value = 'male';
          } else if (gender.toUpperCase() == 'FEMALE') {
            selectedGender.value = 'female';
          } else {
            selectedGender.value = gender.toLowerCase();
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> generateLoShuGrid() async {
    // Validation
    if (selectedDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select your date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select your gender',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final dateStr = formatDate(selectedDate.value!);
      final gender = selectedGender.value;
      final lang = selectedLanguage.value;

      final response = await _numerologyService.getLoShuGrid(
        date: dateStr,
        gender: gender,
        lang: lang,
      );

      isLoading.value = false;

      if (response != null && response['response'] != null) {
        // Navigate to result page with data and form inputs
        UserMainController.pushInCurrentTab(
          AppRoutes.loshuGridResult,
          arguments: {
            ...response['response'],
            '_formData': {'date': dateStr, 'gender': gender, 'lang': lang},
          },
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to generate Lo Shu Grid. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }
}
