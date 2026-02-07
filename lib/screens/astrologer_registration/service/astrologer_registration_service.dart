import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:get/get.dart';

class AstrologerRegistrationService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Map<String, dynamic>?> registerAstrologer(
    Map<String, dynamic> body,
  ) async {
    final response = await _apiClient.postApi(
      EndPoints.astrologerRegistration,
      body,
    );
    return response.body as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>?> verifyOtp(Map<String, dynamic> body) async {
    final response = await _apiClient.postApi(
      EndPoints.astrologerRegistrationVerifyOtp,
      body,
    );
    return response.body as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>?> resendOtp(Map<String, dynamic> body) async {
    final response = await _apiClient.postApi(
      EndPoints.astrologerRegistrationResendOtp,
      body,
    );
    return response.body as Map<String, dynamic>?;
  }
}
