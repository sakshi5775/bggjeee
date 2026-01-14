import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/login_model.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LoginService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  Future<LoginModel?> login(String identifier, String password) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.login,
        {
          'identifier': identifier,
          'password': password,
        },
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginModel = LoginModel.fromJson(response.body['data']);
        return loginModel;
      } else {
        showErrorMessage(
          title: "Login Failed",
          message: "Invalid credentials. Please try again.",
        );
        return null;
      }
    } catch (e) {
      showErrorMessage(
        title: "Error",
        message: "An error occurred during login. Please try again.",
      );
      return null;
    }
  }
}
