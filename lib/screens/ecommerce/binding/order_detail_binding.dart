import 'package:astrobharataiuser/screens/ecommerce/controller/order_detail_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailController>(() => OrderDetailController());
  }
}


