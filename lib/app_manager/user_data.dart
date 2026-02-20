import 'package:astrobharataiuser/data_model/login_model.dart';
import 'package:get_storage/get_storage.dart';

import '../core/base/baseController.dart';
import '../core/routes/app_routes.dart';

class UserData extends BaseController {
  GetStorage get loginData => GetStorage('loginData');
  GetStorage get setOnboardingVal => GetStorage('onboardingVal');
  GetStorage get baseUrl => GetStorage('baseUrl');

  LoginModel get getLoginData =>
      LoginModel.fromJson(loginData.read('loginData') ?? {});

  String? get accessToken => getLoginData.accessToken;
  String? get refreshToken => getLoginData.refreshToken;

  String? get getBaseUrl => baseUrl.read('baseUrl');

  void addLoginData(dynamic val) async {
    print('addLoginData: $val');
    await loginData.write('loginData', val);
    update();
  }

  void updateTokens({required String accessToken, String? refreshToken}) async {
    final current = getLoginData.toJson();
    current['accessToken'] = accessToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      current['refreshToken'] = refreshToken;
    }
    await loginData.write('loginData', current);
    update();
  }

  void setBaseUrl(dynamic val) async {
    await baseUrl.write('baseUrl', val);
    update();
  }

  setOnboardingScreen(dynamic val) async {
    await setOnboardingVal.write('onboardingVal', val);
    update();
  }

  int? get getOnboardingVal => setOnboardingVal.read('onboardingVal') ?? 0;

  void removeUserData() async {
    await loginData.remove('loginData');
    await baseUrl.remove('baseUrl');
    pushAndRemoveUntil(AppRoutes.login);
    update();
  }

  // Map<String, dynamic>? getUserData() {
  //   return loginData.read('loginData');
  // }

  // void clearUserData() async {
  //   await loginData.remove('loginData');
  //   await baseUrl.remove('baseUrl');
  //   update();
  // }
}
