import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:get/get.dart';

class EcommerceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => EcommerceHomeController());
  }
}

