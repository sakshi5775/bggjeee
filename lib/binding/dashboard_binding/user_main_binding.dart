import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import 'package:get/get.dart';

class UserMainBinding extends Bindings {
  @override
  void dependencies() {
    // Do not keep this controller permanent.
    // When `/user-dashboard` is triggered twice (login + delayed redirect),
    // a permanent controller reuses the same GlobalKeys for the tab Navigators
    // across two `UserMainView` widget instances, causing:
    // "Duplicate GlobalKeys detected in widget tree."
    // Also force a fresh controller instance so tab navigator GlobalKeys
    // are not reused across rapid re-mounts.
    if (Get.isRegistered<UserMainController>()) {
      Get.delete<UserMainController>();
    }
    Get.put<UserMainController>(UserMainController());
    if (!Get.isRegistered<UserDashboardController>()) {
      Get.lazyPut<UserDashboardController>(
        () => UserDashboardController(),
        fenix: true,
      );
    }
  }
}
