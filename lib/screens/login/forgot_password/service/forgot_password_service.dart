import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:get/get.dart';

import '../../../../apihelper/api_provider/end_points.dart';

/// Response shape: { success: bool, message: String, data?: { message?, expiresIn?, otpExpiresIn? } }
Map<String, dynamic> _parseAuthResponse(dynamic body) {
  if (body is! Map<String, dynamic>) {
    return {'success': false, 'message': 'Invalid response from server'};
  }
  final success = body['success'] as bool? ?? false;
  String message = body['message'] as String? ?? '';
  final data = body['data'] as Map<String, dynamic>?;
  if (message.isEmpty && data != null && data['message'] != null) {
    message = data['message'] as String? ?? message;
  }
  return {'success': success, 'message': message};
}

class ForgotPasswordService {
  final ApiRepository _apiRepository = ApiRepository(apiClient: Get.find());

  /// POST /api/auth/forgot-password with { "identifier": "email" }
  /// Returns { success: bool, message: String }
  Future<Map<String, dynamic>> sendForgotPasswordOtp(String identifier) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.sendForgotPasswordOtp,
        {'identifier': identifier},
        useAuthHeader: false,
      );
      return _parseAuthResponse(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst(RegExp(r'^Exception:?\s*'), '')};
    }
  }

  /// POST /api/auth/resend-password-otp with { "identifier": "email" }
  /// Returns { success: bool, message: String }
  Future<Map<String, dynamic>> resendPasswordOtp(String identifier) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.resendPasswordOtp,
        {'identifier': identifier},
        useAuthHeader: false,
      );
      return _parseAuthResponse(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst(RegExp(r'^Exception:?\s*'), '')};
    }
  }

  /// POST /api/auth/reset-password with { otp, identifier, password, confirmPassword }
  /// Returns { success: bool, message: String?, errors: List? }
  Future<Map<String, dynamic>> resetPassword(
    String identifier,
    String otp,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.resetPassword,
        {
          'otp': otp,
          'identifier': identifier,
          'password': password,
          'confirmPassword': confirmPassword,
        },
        useAuthHeader: false,
      );

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        return {'success': false, 'message': 'Invalid response from server', 'errors': <Map<String, dynamic>>[]};
      }

      final success = body['success'] as bool? ?? false;
      String message = body['message'] as String? ?? '';
      final data = body['data'] as Map<String, dynamic>?;
      if (message.isEmpty && data != null && data['message'] != null) {
        message = data['message'] as String? ?? message;
      }
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
        'message': e.toString().replaceFirst(RegExp(r'^Exception:?\s*'), ''),
        'errors': <Map<String, dynamic>>[],
      };
    }
  }
}
