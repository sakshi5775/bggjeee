import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:get/get.dart';

import '../../../../apihelper/api_provider/end_points.dart';

class ForgotPasswordService {
  final ApiRepository _apiRepository = ApiRepository(apiClient: Get.find());

  Future<bool> sendOtp(String email) async {
    try {
      var body = {"identifier": email};
      final response = await _apiRepository.postApi(
        EndPoints.sendForgotPasswordOtp,
        useAuthHeader: false,
        body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Verify OTP and complete registration/login
  Future<bool> verifyOtp({
    required String identifier,
    required String otp,
  }) async {
    try {
      final response = await _apiRepository.postApi(EndPoints.verifyOtp, {
        'identifier': identifier,
        'otp': otp,
        'userType': "User",
      }, useAuthHeader: false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String password, String confirmPassword) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.resetPassword(UserData().getLoginData.accessToken ?? ''),
        {"password": password, "confirmPassword": confirmPassword},
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Resend OTP
  Future<bool> resendOtp({required String identifier}) async {
    try {
      final response = await _apiRepository.postApi(EndPoints.resendOtp, {
        'identifier': identifier,
      }, useAuthHeader: false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
