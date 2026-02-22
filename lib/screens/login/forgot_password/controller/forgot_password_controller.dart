import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/login/forgot_password/service/forgot_password_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends BaseController {
  final ForgotPasswordService _service = Get.put(ForgotPasswordService());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> sendOtp() async {
    if (!emailFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final success = await _service.sendOtp(emailController.text.trim());
      if (success) {
        Get.toNamed(AppRoutes.forgotPasswordOtp);
        Get.snackbar(
          'OTP Sent',
          'We have sent an OTP to your email: ${emailController.text}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final success = await _service.verifyOtp(
        identifier: emailController.text.trim(),
        otp: otpController.text.trim(),
      );
      if (success) {
        Get.toNamed(AppRoutes.resetPassword);
      } else {
        Get.snackbar(
          'Invalid OTP',
          'Please enter correct OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;
    try {
      final success = await _service.resendOtp(
        identifier: emailController.text.trim(),
      );
      if (success) {
        Get.snackbar(
          'OTP Resent',
          'We have resent the OTP to your email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend OTP');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final success = await _service.resetPassword(
        passwordController.text.trim(),
        confirmPasswordController.text.trim(),
      );
      if (success) {
        Get.snackbar(
          'Success 🎉',
          'Password changed successfully. Please login with new password. ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppRoutes.login);
      } else {
        showErrorMessage(message: 'Failed to reset password');
      }
    } catch (e) {
      showErrorMessage(message: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
