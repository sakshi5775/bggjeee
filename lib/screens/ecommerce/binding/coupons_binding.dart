import 'package:astrobharataiuser/screens/ecommerce/controller/coupons_controller.dart';
import 'package:get/get.dart';

class CouponsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CouponsController>()) {
      Get.lazyPut<CouponsController>(() => CouponsController());
    }
  }
}


