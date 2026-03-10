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

  /// Returns map: { success: bool, message: String?, errors: List<{field, message}>? }
  Future<Map<String, dynamic>> resetPassword(
    String identifier,
    String otp,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await _apiRepository.postApi(EndPoints.resetPassword, {
        "otp": otp,
        "identifier": identifier,
        "password": password,
        "confirmPassword": confirmPassword,
      }, useAuthHeader: false);

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        return {'success': false, 'message': 'Invalid response from server'};
      }

      final success = body['success'] as bool? ?? false;
      final message = body['message'] as String? ?? '';
      final errors = body['errors'] as List<dynamic>?;
      final errorsList = errors
          ?.map((e) => e is Map<String, dynamic>
              ? {'field': e['field'] as String?, 'message': e['message'] as String?}
              : null)
          .whereType<Map<String, dynamic>>()
          .toList();

      return {
        'success': success,
        'message': message,
        'errors': errorsList ?? [],
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
        'errors': [],
      };
    }
  }

  /// Resend OTP
  Future<bool> resendOtp({required String identifier}) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.resendPasswordOtp,
        {'identifier': identifier},
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
}
