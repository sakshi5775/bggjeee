import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import 'package:get/get.dart';

class UserMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserMainController>(UserMainController(), permanent: true);
    if (!Get.isRegistered<UserDashboardController>()) {
      Get.lazyPut<UserDashboardController>(
        () => UserDashboardController(),
        fenix: true,
      );
    }
  }
}
