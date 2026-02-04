import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/signup_model.dart';
import 'package:get/get.dart';
import '../../../apihelper/api_provider/end_points.dart';

class SignUpService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  Future<SignUpModel?> register({
    required String phone,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String userType,
  }) async {
    final response = await _apiRepository.postApi(EndPoints.register, {
      'phone': phone,
      'email': email,
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'userType': userType,
    }, useAuthHeader: false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null) {
        final signUpModel = SignUpModel.fromJson(response.body);
        if (signUpModel.success == true && signUpModel.user != null) {
          return signUpModel;
        }
      }
    }

    throw response.body?['message']?.toString() ??
        'Registration failed. Please try again.';
  }
}
