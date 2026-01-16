import 'package:astrobharataiuser/screens/ecommerce/controller/address_controller.dart';
import 'package:get/get.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AddressController>()) {
      Get.lazyPut<AddressController>(() => AddressController());
    }
  }
}


