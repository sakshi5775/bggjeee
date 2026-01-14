import 'package:astrobharataiuser/screens/ecommerce/controller/payment_detail_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PaymentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentDetailController>(() => PaymentDetailController());
  }
}


