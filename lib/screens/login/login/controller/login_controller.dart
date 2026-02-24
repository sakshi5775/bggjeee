import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:astrobharataiuser/screens/login/login/service/login_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final LoginService _loginService = LoginService();
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  final RxBool isEmailMode = false.obs;
  final RxBool isTermsAccepted = false.obs;
  final Rx<CountryCode> selectedCountryCode = CountryCode.fromCountryCode(
    'IN',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // Listen to phone controller to detect if user is typing email
    phoneController.addListener(_checkInputType);
    emailController.addListener(_checkInputType);
  }

  @override
  void onClose() {
    phoneController.removeListener(_checkInputType);
    emailController.removeListener(_checkInputType);
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _checkInputType() {
    final phoneText = phoneController.text.trim();
    final emailText = emailController.text.trim();

    // Check if user is typing email in phone field or using email field
    if (emailText.isNotEmpty ||
        (phoneText.isNotEmpty && GetUtils.isEmail(phoneText))) {
      if (!isEmailMode.value) {
        isEmailMode.value = true;
      }
    } else if (phoneText.isNotEmpty && RegExp(r'^\d+$').hasMatch(phoneText)) {
      if (isEmailMode.value) {
        isEmailMode.value = false;
      }
    }
    // Removed automatic reset to phone mode when empty to allow toggle button to work reliably
  }

  void onCountryChanged(CountryCode countryCode) {
    selectedCountryCode.value = countryCode;
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!isTermsAccepted.value) {
      Get.snackbar(
        'Required',
        'Please accept Terms of Service and Privacy Policy to continue',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    String password = passwordController.text.trim();
    String identifier;

    if (isEmailMode.value) {
      identifier = emailController.text.trim();
      if (identifier.isEmpty) {
        identifier = phoneController.text.trim();
      }
    } else {
      final phoneNumber = phoneController.text.trim();
      final countryCode = selectedCountryCode.value.dialCode ?? '+91';
      identifier = '$countryCode$phoneNumber';
    }

    if (password.isEmpty) {
      showErrorMessage(
        title: "Error",
        message: "Password is required for login",
      );
      return;
    }

    CrashlyticsService.trackAction(
      "AUTH",
      "LOGIN_START",
      data: "mode:${isEmailMode.value ? 'email' : 'phone'}",
    );

    await runWithLoading(
      () async {
        // Password login for both phone and email
        final loginModel = await _loginService.login(identifier, password);
        if (loginModel != null) {
          CrashlyticsService.trackAction("AUTH", "LOGIN_SUCCESS");
          UserData().addLoginData(loginModel.toJson());

          // Set user ID for future crashes
          CrashlyticsService.setUser(loginModel.user?.userId ?? "unknown");

          // Link user to OneSignal for targeted notifications
          final userId = loginModel.user?.userId;
          if (userId != null && userId.isNotEmpty) {
            NotificationService.instance.setExternalUserId(userId);
          }

          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed(AppRoutes.userDashboard);
        } else {
          CrashlyticsService.trackAction("AUTH", "LOGIN_FAIL");
        }
      },
      showBusy: true,
      successMessage: "Login successful!",
    );
  }

  String? validatePhone(String? value) {
    if (isEmailMode.value) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Remove any non-digit characters
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.isEmpty) {
      return 'Please enter a valid phone number';
    }

    // Basic validation - at least 6 digits for international numbers
    if (cleanNumber.length < 6) {
      return 'Phone number is too short';
    }

    // For Indian numbers, validate format
    if (selectedCountryCode.value.code == 'IN') {
      if (cleanNumber.length != 10) {
        return 'Indian phone number must be 10 digits';
      }
      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber)) {
        return 'Please provide a valid 10-digit Indian phone number';
      }
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (!isEmailMode.value) {
      return null; // Skip validation if in phone mode
    }
    if (value == null || value.isEmpty) {
      // Check if email is in phone field
      final phoneText = phoneController.text.trim();
      if (phoneText.isNotEmpty && GetUtils.isEmail(phoneText)) {
        return null;
      }
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
