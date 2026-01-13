import 'dart:async';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/enums/user_role.dart';
import 'package:astrobharataiuser/core/services/role_navigation_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OTPController extends BaseController {
  final int otpLength = 4;
  late final TextEditingController otpTextController;
  final RxBool isSubmitting = false.obs;
  final RxInt secondsRemaining = 60.obs;
  Timer? _timer;

  RxString get maskedDestination =>
      (Get.arguments?['destination'] ?? '').toString().obs;

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
    // TODO: integrate API to resend OTP
    showSuccessMessage(title: 'OTP Sent', message: 'A new code has been sent.');
    _startTimer();
  }

  Future<void> submitOtp(String code) async {
    if (code.length != otpLength) return;
    isSubmitting.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // TODO: Verify OTP via API
      showSuccessMessage(
        title: 'Verified',
        message: 'Verification successful.',
      );

      // Navigate based on user role
      final userData = UserData().getLoginData.user?.userType;
      final userType = UserRole.fromString(userData ?? 'USER').value.toString();
      RoleNavigationService.navigateToDashboard(userType);
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Verification failed.');
    } finally {
      isSubmitting.value = false;
    }
  }

  void changeNumber() {
    onBack();
  }
}
