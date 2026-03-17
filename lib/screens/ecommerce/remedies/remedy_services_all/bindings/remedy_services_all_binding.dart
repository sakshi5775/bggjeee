import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_services_all/controller/remedy_services_all_controller.dart';
import 'package:get/get.dart';

class RemedyServicesAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemedyServicesAllController>(
      () => RemedyServicesAllController(),
    );
  }
}
