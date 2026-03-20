import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/login_model.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';
import 'package:get/get.dart';

class LoginService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  Future<LoginModel?> login(String identifier, String password) async {
    final response = await _apiRepository.postApi(EndPoints.login, {
      'identifier': identifier,
      'password': password,
    }, useAuthHeader: false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null && response.body['data'] != null) {
        return LoginModel.fromJson(response.body['data']);
      }
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Invalid credentials. Please try again.',
    );
  }

  /// Send OTP to phone or email
  Future<bool> sendOtp({String? phone, String? email}) async {
    final Map<String, dynamic> body = {};
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }
    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    }

    if (body.isEmpty) {
      throw "Please provide either phone number or email.";
    }

    final response = await _apiRepository.postApi(
      EndPoints.sendOtp,
      body,
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Failed to send OTP',
    );
  }

  /// Send OTP for phone login (POST auth/otp-login/send).
  /// Returns data with otpExpiresIn (seconds) and optional devOnly.otp.
  Future<Map<String, dynamic>> sendOtpLogin({
    required String phone,
    required String countryCode,
  }) async {
    final response = await _apiRepository.postApi(
      EndPoints.otpLoginSend,
      {'phone': phone, 'countryCode': countryCode},
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body != null && body['success'] == true) {
        return body['data'] is Map<String, dynamic>
            ? body['data'] as Map<String, dynamic>
            : <String, dynamic>{};
      }
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Failed to send OTP',
    );
  }

  /// Verify OTP and login (POST auth/otp-login/verify).
  /// Returns LoginModel (user, accessToken, refreshToken) on success.
  Future<LoginModel?> verifyOtpLogin({
    required String phone,
    required String countryCode,
    required String otp,
  }) async {
    final response = await _apiRepository.postApi(
      EndPoints.otpLoginVerify,
      {'phone': phone, 'countryCode': countryCode, 'otp': otp},
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body != null && body['data'] != null) {
        final data = body['data'] is Map<String, dynamic>
            ? body['data'] as Map<String, dynamic>
            : null;
        if (data != null) return LoginModel.fromJson(data);
      }
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Invalid OTP',
    );
  }
}
