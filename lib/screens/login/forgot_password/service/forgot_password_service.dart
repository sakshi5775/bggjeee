import 'package:get/get.dart';

class ForgotPasswordService extends GetxService {
  Future<bool> sendOtp(String email) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // Return true for success
    return true;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // Mock OTP verification - treat '123456' as valid for testing
    return otp == '123456';
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> resendOtp(String email) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
