import 'package:get/get.dart';

mixin NavigationService {
  Future<void> replaceRoute(String route, {dynamic arguments}) async {
    return await Get.offNamed(route, arguments: arguments);
  }

  Future<void>  pushRoute(String route, {dynamic arguments}) async {
    return await Get.toNamed(route, arguments: arguments);
  }

  Future<void> pushAndRemoveUntil(String route, {dynamic arguments}) async {
    return await Get.offAllNamed(route, arguments: arguments);
  }

  void onBack() {
    Get.back();
  }
}
