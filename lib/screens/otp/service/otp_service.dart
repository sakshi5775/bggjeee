import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/login_model.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';
import 'package:get/get.dart';

class OtpService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

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

  /// Verify OTP and complete registration/login
  Future<LoginModel?> verifyOtp({
    required String identifier,
    required String otp,
    required String userType,
  }) async {
    final response = await _apiRepository.postApi(EndPoints.verifyOtp, {
      'identifier': identifier,
      'otp': otp,
      'userType': userType,
    }, useAuthHeader: false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null && response.body is Map) {
        final jsonData = response.body as Map<String, dynamic>;
        final data = jsonData['data'];
        if (data != null && data is Map) {
          return LoginModel.fromJson(data as Map<String, dynamic>);
        } else {
          return LoginModel.fromJson(jsonData); // Fallback
        }
      }
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'OTP verification failed',
    );
  }

  /// Resend OTP
  Future<bool> resendOtp({required String identifier}) async {
    final response = await _apiRepository.postApi(EndPoints.resendOtp, {
      'identifier': identifier,
    }, useAuthHeader: false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    throw UserFriendlyError.message(
      response.body?['message']?.toString(),
      fallback: 'Failed to resend OTP',
    );
  }

  /// Check if user exists (by email or phone)
  Future<Map<String, bool>?> checkExists({String? email, String? phone}) async {
    try {
      final Map<String, dynamic> body = {};
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      if (body.isEmpty) {
        showErrorMessage(
          title: "Error",
          message: "Please provide either phone number or email.",
        );
        return null;
      }

      final response = await _apiRepository.postApi(
        EndPoints.checkExists,
        body,
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body is Map) {
          final jsonData = response.body as Map<String, dynamic>;
          if (jsonData['data'] != null && jsonData['data'] is Map) {
            final data = jsonData['data'] as Map<String, dynamic>;
            return {
              'exists': data['exists'] == true,
              'emailExists': data['emailExists'] == true,
              'phoneExists': data['phoneExists'] == true,
            };
          }
        }
      }
      return null;
    } catch (e) {
      // Don't show error for check exists - it's just a validation check
      return null;
    }
  }
}
