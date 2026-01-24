import 'package:astrobharataiuser/screens/e_mandir/address_form/controller/address_form_controller.dart';
import 'package:get/get.dart';

class AddressFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressFormController>(() => AddressFormController());
  }
}
