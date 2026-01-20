import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:get/get.dart';

class PunyaMudraController extends BaseController {
  final RxInt selectedTab = 0.obs; // 0 = Earn, 1 = Bhakti, 2 = Passbook

  void selectTab(int index) {
    selectedTab.value = index;
  }
}
