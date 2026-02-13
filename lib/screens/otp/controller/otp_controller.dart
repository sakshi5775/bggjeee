import 'dart:async';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:astrobharataiuser/screens/otp/service/otp_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OTPController extends BaseController {
  final int otpLength = 6; // Updated to 6 digits as per backend
  late final TextEditingController otpTextController;
  final RxBool isSubmitting = false.obs;
  final RxInt secondsRemaining = 60.obs;
  Timer? _timer;
  final OtpService _otpService = OtpService();

  RxString get maskedDestination =>
      (Get.arguments?['destination'] ?? '').toString().obs;

  RxString get userType =>
      (Get.arguments?['userType'] ?? 'USER').toString().obs;

  RxBool get isRegistration => (Get.arguments?['isRegistration'] ?? false).obs;

  @override
  void onInit() {
    super.onInit();
    otpTextController = TextEditingController();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpTextController.dispose();
    super.onClose();
  }

  void _startTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 0) {
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    try {
      setLoadingState(true);
      final identifier = maskedDestination.value;

      if (identifier.isEmpty) {
        showErrorMessage(
          title: 'Error',
          message: 'Unable to resend OTP. Please try again.',
        );
        setLoadingState(false);
        return;
      }

      final success = await _otpService.resendOtp(identifier: identifier);

      if (success) {
        showSuccessMessage(
          title: 'OTP Sent',
          message: 'A new code has been sent.',
        );
        _startTimer();
      } else {
        // Check if registration is already completed
        // If user is already logged in, navigate to dashboard
        final userData = UserData();
        if (userData.accessToken != null && userData.accessToken!.isNotEmpty) {
          showSuccessMessage(
            title: 'Already Verified',
            message: 'Your registration is already complete. Redirecting...',
          );
          await Future.delayed(const Duration(milliseconds: 500));
          if (Get.nestedKey(1)?.currentState != null) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.userDashboard);
          }
        }
      }
    } catch (e) {
      print('Resend OTP error: $e');
      // Check if user is already logged in
      final userData = UserData();
      if (userData.accessToken != null && userData.accessToken!.isNotEmpty) {
        showSuccessMessage(
          title: 'Already Verified',
          message: 'Your registration is already complete. Redirecting...',
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (Get.nestedKey(1)?.currentState != null) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.userDashboard);
        }
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to resend OTP. Please try again.',
        );
      }
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> submitOtp(String code) async {
    if (code.length != otpLength) {
      showErrorMessage(
        title: 'Invalid OTP',
        message: 'Please enter a valid $otpLength-digit OTP.',
      );
      return;
    }

    isSubmitting.value = true;
    setLoadingState(true);

    try {
      final identifier = maskedDestination.value;
      final userTypeValue = userType.value;

      if (identifier.isEmpty) {
        showErrorMessage(
          title: 'Error',
          message: 'Unable to verify OTP. Please try again.',
        );
        isSubmitting.value = false;
        setLoadingState(false);
        return;
      }

      final loginModel = await _otpService.verifyOtp(
        identifier: identifier,
        otp: code,
        userType: userTypeValue,
      );

      if (loginModel != null) {
        try {
          // Save user data and tokens
          UserData().addLoginData(loginModel.toJson());

          // Link user to OneSignal for targeted notifications
          final userId = loginModel.user?.userId;
          if (userId != null && userId.isNotEmpty) {
            NotificationService.instance.setExternalUserId(userId);
          }

          // Show success message (don't await to avoid blocking)
          showSuccessMessage(
            title: 'Verified',
            message: isRegistration.value
                ? 'Registration completed successfully!'
                : 'Verification successful.',
          );

          // Navigate: if already on dashboard (e.g. opened login from Profile), just pop
          await Future.delayed(const Duration(milliseconds: 300));
          if (Get.nestedKey(1)?.currentState != null) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.userDashboard);
          }
        } catch (navError) {
          print('Navigation error: $navError');
          if (Get.nestedKey(1)?.currentState != null) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.userDashboard);
          }
        }
      } else {
        // Error message is already shown by the service
        isSubmitting.value = false;
      }
    } catch (e) {
      print('OTP verification error: $e');
      // Only show error if we haven't already saved user data
      final userData = UserData();
      if (userData.accessToken == null || userData.accessToken!.isEmpty) {
        showErrorMessage(
          title: 'Error',
          message: 'Verification failed. Please try again.',
        );
      } else {
        // User data is saved, just navigate
        if (Get.nestedKey(1)?.currentState != null) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.userDashboard);
        }
      }
      isSubmitting.value = false;
    } finally {
      setLoadingState(false);
    }
  }

  void changeNumber() {
    Get.offNamed(AppRoutes.login);
  }

  void goBack() {
    Get.offNamed(AppRoutes.login);
  }
}
