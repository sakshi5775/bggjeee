import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/otp/service/otp_service.dart';
import 'package:astrobharataiuser/screens/sign_up/service/signup_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends BaseController {
  final SignUpService _signUpService = SignUpService();
  final OtpService _otpService = OtpService();

  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final GlobalKey<FormState> formKey;

  final Rx<CountryCode> selectedCountryCode = CountryCode.fromCountryCode(
    'IN',
  ).obs;

  // User type is always 'USER' for this app
  static const String userType = 'USER';

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  void onCountryChanged(CountryCode countryCode) {
    selectedCountryCode.value = countryCode;
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final phoneNumber = phoneController.text.trim();
    final countryCode = selectedCountryCode.value.dialCode ?? '+91';
    final phone = '$countryCode$phoneNumber';
    final email = emailController.text.trim();

    await runWithLoading(() async {
      // Check if user exists
      final existsResult = await _otpService.checkExists(
        email: email,
        phone: phone,
      );
      if (existsResult != null) {
        if (existsResult['emailExists'] == true &&
            existsResult['phoneExists'] == true) {
          throw "An account with this email and phone number already exists. Please try logging in.";
        } else if (existsResult['emailExists'] == true) {
          throw "This email is already registered. Please use a different email or try logging in.";
        } else if (existsResult['phoneExists'] == true) {
          throw "This phone number is already registered. Please use a different phone number or try logging in.";
        }
      }

      final signUpModel = await _signUpService.register(
        phone: phone,
        email: email,
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        userType: SignUpController.userType,
      );

      if (signUpModel != null) {
        String identifier = phone;
        if (signUpModel.otpSentTo?.email == true &&
            signUpModel.otpSentTo?.phone != true) {
          identifier = email;
        }

        showSuccessMessage(
          title: "Registration Successful",
          message:
              signUpModel.message ??
              "Registration successful! Please verify OTP.",
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offNamed(
          AppRoutes.otp,
          arguments: {
            'destination': identifier,
            'userType': signUpModel.user?.userType ?? 'USER',
            'isRegistration': true,
          },
        );
      }
    }, showBusy: true);
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    if (selectedCountryCode.value.code == 'IN') {
      if (cleanNumber.length != 10) {
        return 'Indian phone number must be 10 digits';
      }
      // Validate Indian mobile number format (must start with 6, 7, 8, or 9)
      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber)) {
        return 'Please provide a valid 10-digit Indian phone number';
      }
    } else {
      // For other countries, basic validation
      if (cleanNumber.length < 6) {
        return 'Phone number is too short';
      }
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
    ).hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void goToLogin() {
    onBack();
  }
}

