import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/role_navigation_service.dart';
import 'package:astrobharataiuser/screens/sign_up/service/signup_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends BaseController {
  final SignUpService _signUpService = SignUpService();

  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final GlobalKey<FormState> formKey;
  
  final Rx<CountryCode> selectedCountryCode = CountryCode.fromCountryCode('IN').obs;

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
    try {
      setLoadingState(true);
      if (formKey.currentState!.validate()) {
        // Get phone number with country code
        final phoneNumber = phoneController.text.trim();
        final countryCode = selectedCountryCode.value.dialCode ?? '+91';
        final phone = '$countryCode$phoneNumber';
        
        // Additional validation check before API call (defensive programming)
        final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
        if (selectedCountryCode.value.code == 'IN') {
          if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber)) {
            showErrorMessage(
              title: "Invalid Phone Number",
              message: "Please provide a valid 10-digit Indian phone number (must start with 6, 7, 8, or 9).",
            );
            setLoadingState(false);
            return;
          }
        } else if (cleanNumber.length < 6) {
          showErrorMessage(
            title: "Invalid Phone Number",
            message: "Please provide a valid phone number.",
          );
          setLoadingState(false);
          return;
        }
        
        final signUpModel = await _signUpService.register(
          phone: phone,
          email: emailController.text.trim(),
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
          userType: SignUpController.userType, // Always 'USER' for this app
        );

        if (signUpModel != null) {
          // Store tokens and user data for auto-login
          if (signUpModel.accessToken != null && signUpModel.refreshToken != null) {
            try {
              // Create login data structure matching LoginModel format
              final loginData = {
                'accessToken': signUpModel.accessToken,
                'refreshToken': signUpModel.refreshToken,
                'user': signUpModel.user?.toJson(),
              };
              UserData().addLoginData(loginData);
              
              if (kDebugMode) {
                print('User data stored successfully after registration');
              }
            } catch (e) {
              // If storing fails, show error but continue
              if (kDebugMode) {
                print('Error storing tokens: $e');
              }
              showErrorMessage(
                title: "Warning",
                message: "Account created but failed to save login data. Please login manually.",
              );
              await Future.delayed(const Duration(milliseconds: 500));
              onBack(); // Navigate to login screen
              return;
            }
          }

          // Show success message
          showSuccessMessage(
            title: "Success",
            message: "Account created successfully! Welcome to the app.",
          );
          
          // Navigate to home page (user dashboard) after a short delay
          await Future.delayed(const Duration(milliseconds: 800));
          
          // Navigate to user dashboard using RoleNavigationService
          try {
            RoleNavigationService.navigateToDashboard(
              signUpModel.user?.userType ?? 'USER',
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error navigating to dashboard: $e');
            }
            // Fallback to direct navigation
            Get.offAllNamed(AppRoutes.userDashboard);
          }
        }
      }
    } catch (e) {
      setLoadingState(false);
      showErrorMessage(title: "Error", message: "Registration failed! $e");
    } finally {
      setLoadingState(false);
    }
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
