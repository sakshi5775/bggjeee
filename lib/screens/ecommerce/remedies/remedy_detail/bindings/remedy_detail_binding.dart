import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_detail/controller/remedy_detail_controller.dart';
import 'package:get/get.dart';

class RemedyDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemedyDetailController>(() => RemedyDetailController());
  }
}
