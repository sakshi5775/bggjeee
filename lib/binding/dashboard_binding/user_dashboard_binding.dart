import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:get/get.dart';

class UserDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Use putIfAbsent to avoid recreating if already exists
    if (!Get.isRegistered<UserDashboardController>()) {
      Get.put(UserDashboardController(), permanent: false);
    }
  }
}
