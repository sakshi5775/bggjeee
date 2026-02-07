import 'package:country_code_picker/country_code_picker.dart';
import 'package:astrobharataiuser/screens/astrologer_registration/service/astrologer_registration_service.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AstrologerRegistrationController extends GetxController {
  final AstrologerRegistrationService _service =
      AstrologerRegistrationService();

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final experienceController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  // OTP Controller
  final otpController = TextEditingController();

  // Selections
  final selectedKnowledge = <String>[].obs;
  final selectedLanguages = <String>[].obs;
  final selectedCountryCode = CountryCode(code: 'IN', dialCode: '+91').obs;

  // State
  final isLoading = false.obs;
  final requestId = ''.obs;
  final registeredPhone = ''.obs;

  void onCountryChanged(CountryCode countryCode) {
    selectedCountryCode.value = countryCode;
    countryController.text = countryCode.name ?? '';
  }

  // Knowledge Map
  final Map<String, String> knowledgeOptionsMap = {
    'Vedic': 'VEDIC',
    'Lal Kitab': 'LAL_KITAB',
    'Tarot Reading': 'TAROT_READING',
    'Numerology': 'NUMEROLOGY',
    'Palmistry': 'PALMISTRY',
    'Jaimini': 'JAIMINI',
    'Western': 'WESTERN',
    'Reiki': 'REIKI',
    'Face Reading': 'FACE_READING',
    'KP System': 'KP_SYSTEM',
    'Vastu': 'VASTU',
    'Nadi': 'NADI',
    'Ashtakvarga': 'ASHTAKVARGA',
    'Ramal': 'RAMAL',
    'Tajik': 'TAJIK',
    'Muhurta': 'MUHURTA',
  };

  List<String> get knowledgeDisplayOptions => knowledgeOptionsMap.keys.toList();

  // Language List
  final List<String> languageOptions = [
    'HINDI',
    'ENGLISH',
    'BENGALI',
    'MARATHI',
    'TELUGU',
    'TAMIL',
    'GUJARATI',
    'KANNADA',
    'MALAYALAM',
    'ASSAMESE',
    'ODIA',
    'PUNJABI',
    'URDU',
    'BHOJPURI',
    'NEPALI',
    'MAITHILI',
    'DOGRI',
    'KASHMIRI',
    'KONKANI',
    'SINDHI',
    'HARYANVI',
    'RAJASTHANI',
    'MANIPURI',
    'SANSKRIT',
    'KUMAONI',
    'TULU',
    'SANTALI',
    'SINDHI',
  ];

  void toggleKnowledge(String key) {
    if (selectedKnowledge.contains(key)) {
      selectedKnowledge.remove(key);
    } else {
      selectedKnowledge.add(key);
    }
  }

  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
  }

  Future<void> submitRegistration() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      // Convert display names to API values for knowledge
      final apiKnowledge = selectedKnowledge
          .map((k) => knowledgeOptionsMap[k]!)
          .toList();

      final formattedPhone =
          '${selectedCountryCode.value.dialCode}${phoneController.text.trim()}';

      final body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": formattedPhone,
        "yearsOfExperience":
            int.tryParse(experienceController.text.trim()) ?? 0,
        "knowledge": apiKnowledge,
        "languages": selectedLanguages.toList(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "country": countryController.text.trim(),
      };

      final response = await _service.registerAstrologer(body);

      if (response != null && response['success'] == true) {
        requestId.value = response['data']['requestId'] ?? '';
        registeredPhone.value = phoneController.text.trim();
        Get.snackbar(
          'Success',
          'Registration initiated. Please verify OTP.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(AppRoutes.astrologerRegistrationOtp);
      } else {
        Get.snackbar(
          'Error',
          response?['message'] ?? 'Registration failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final body = {
        "requestId": requestId.value,
        "otp": otpController.text.trim(),
      };

      final response = await _service.verifyOtp(body);

      if (response != null && response['success'] == true) {
        Get.snackbar(
          'Success',
          'Verification successful! Your request is under review.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoutes.userDashboard);
      } else {
        Get.snackbar(
          'Error',
          response?['message'] ?? 'OTP verification failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      final body = {"requestId": requestId.value};

      final response = await _service.resendOtp(body);

      if (response != null && response['success'] == true) {
        Get.snackbar(
          'Success',
          'OTP resent successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response?['message'] ?? 'Failed to resend OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (experienceController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter years of experience',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (selectedKnowledge.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one area of knowledge',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (selectedLanguages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one language',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
