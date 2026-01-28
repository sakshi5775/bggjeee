import 'package:astrobharataiuser/screens/ecommerce/controller/payments_controller.dart';
import 'package:get/get.dart';

class PaymentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentsController>(() => PaymentsController(), fenix: true);
  }
}


