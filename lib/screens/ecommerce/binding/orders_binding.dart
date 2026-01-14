import 'package:astrobharataiuser/screens/ecommerce/controller/orders_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OrdersController>()) {
      Get.lazyPut<OrdersController>(() => OrdersController());
    }
  }
}


