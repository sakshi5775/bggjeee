import 'package:astrobharataiuser/screens/e_mandir/address_selection/controller/address_selection_controller.dart';
import 'package:get/get.dart';

class AddressSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressSelectionController>(() => AddressSelectionController());
  }
}
