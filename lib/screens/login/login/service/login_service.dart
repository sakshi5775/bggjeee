import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/login_model.dart';
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

    throw response.body?['message']?.toString() ??
        'Invalid credentials. Please try again.';
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

    throw response.body?['message']?.toString() ?? 'Failed to send OTP';
  }
}
