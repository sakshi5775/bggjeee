import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

import '../../../../data_model/e_mandir_dataModels/e_mandir_home_model.dart';

class PunyaMudraController extends BaseController {
  final selectedTab = 0.obs; // 0 = Earn, 1 = Bhakti, 2 = Passbook

  void onTabChanged(int index) {
    selectedTab.value = index;
  }

  void navigateToBhaktiChakra() {
    UserMainController.pushInCurrentTab(AppRoutes.bhaktiChakra);
  }

  void navigateToPassbook() {
    UserMainController.pushInCurrentTab(AppRoutes.passbook);
  }

  Rxn<EMandirHomeDataModel> punyaWallet = Rxn<EMandirHomeDataModel>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    punyaWallet.value = Get.arguments['punyaWallet'];
  }
}
