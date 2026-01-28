import 'package:get/get.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

class PunyaMudraController extends BaseController {
  final selectedTab = 0.obs; // 0 = Earn, 1 = Bhakti, 2 = Passbook

  void onTabChanged(int index) {
    selectedTab.value = index;
  }

  void navigateToBhaktiChakra() {
    Get.toNamed(AppRoutes.bhaktiChakra);
  }

  void navigateToPassbook() {
    Get.toNamed(AppRoutes.passbook);
  }
}
