import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/analytics_service.dart';
import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:astrobharataiuser/screens/login/login/service/login_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';

class LoginController extends BaseController {
  final LoginService _loginService = LoginService();
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  final RxBool isEmailMode = false.obs;
  final RxBool isTermsAccepted = false.obs;
  /// true = login with OTP (phone + OTP), false = login with password (phone/email + password).
  final RxBool isOtpMode = false.obs;
  /// After sending OTP, we show OTP input and resend timer.
  final RxBool otpSent = false.obs;
  final RxInt resendSecondsRemaining = 0.obs;
  final TextEditingController otpController = TextEditingController();
  Timer? _resendTimer;

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
    _resendTimer?.cancel();
    phoneController.removeListener(_checkInputType);
    emailController.removeListener(_checkInputType);
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.onClose();
  }

  String get _fullPhoneNumber {
    final phone = phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
    final countryCode = selectedCountryCode.value.dialCode ?? '+91';
    return '$countryCode$phone';
  }

  /// Send OTP for phone (OTP login). Starts 60s resend timer.
  Future<void> sendOtpLogin() async {
    if (!formKey.currentState!.validate()) return;
    if (isEmailMode.value) {
      showErrorMessage(title: 'Error', message: 'Use phone number for OTP login');
      return;
    }
    final phone = _fullPhoneNumber;
    final countryCode = selectedCountryCode.value.dialCode ?? '+91';

    await runWithLoading(
      () async {
        await _loginService.sendOtpLogin(phone: phone, countryCode: countryCode);
        otpSent.value = true;
        _startResendTimer();
      },
      showBusy: true,
      successMessage: 'OTP sent successfully',
    );
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    resendSecondsRemaining.value = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSecondsRemaining.value <= 1) {
        t.cancel();
        resendSecondsRemaining.value = 0;
        return;
      }
      resendSecondsRemaining.value = resendSecondsRemaining.value - 1;
    });
  }

  Future<void> resendOtpLogin() async {
    if (resendSecondsRemaining.value > 0) return;
    await sendOtpLogin();
  }

  Future<void> verifyOtpLogin() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      showErrorMessage(title: 'Invalid OTP', message: 'Please enter 6-digit OTP');
      return;
    }
    final phone = _fullPhoneNumber;
    final countryCode = selectedCountryCode.value.dialCode ?? '+91';

    await runWithLoading(
      () async {
        final loginModel = await _loginService.verifyOtpLogin(
          phone: phone,
          countryCode: countryCode,
          otp: otp,
        );
        if (loginModel != null) {
          UserData().addLoginData(loginModel.toJson());
          CrashlyticsService.trackAction('AUTH', 'LOGIN_SUCCESS');
          AnalyticsService().setUserId(loginModel.user?.userId ?? 'unknown');
          AnalyticsService().logLogin('Phone OTP');
          CrashlyticsService.setUser(loginModel.user?.userId ?? 'unknown');
          final userId = loginModel.user?.userId;
          if (userId != null && userId.isNotEmpty) {
            NotificationService.instance.setExternalUserId(userId);
          }
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed(AppRoutes.userDashboard);
        }
      },
      showBusy: true,
      successMessage: 'Login successful!',
    );
  }

  void _checkInputType() {
    // OTP login is phone-only; don't auto-toggle to email mode while OTP is enabled.
    if (isOtpMode.value) return;

    final phoneText = phoneController.text.trim();
    final emailText = emailController.text.trim();

    // Decide whether we should be in email mode.
    bool shouldBeEmailMode = false;
    if (emailText.isNotEmpty ||
        (phoneText.isNotEmpty && GetUtils.isEmail(phoneText))) {
      shouldBeEmailMode = true;
    } else if (phoneText.isNotEmpty && RegExp(r'^\d+$').hasMatch(phoneText)) {
      shouldBeEmailMode = false;
    }

    // Check if user is typing email in phone field or using email field
    if (shouldBeEmailMode == isEmailMode.value) return;

    // Avoid scheduling rebuilds while Flutter is in the middle of a frame
    // (prevents "Build scheduled during frame" assertions).
    final inBuildFrame =
        SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle;
    if (inBuildFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isClosed) return;
        isEmailMode.value = shouldBeEmailMode;
      });
    } else {
      isEmailMode.value = shouldBeEmailMode;
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
          AnalyticsService().setUserId(loginModel.user?.userId ?? "unknown");
          AnalyticsService().logLogin(isEmailMode.value ? 'Email' : 'Phone');

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
