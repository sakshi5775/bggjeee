import 'package:astrobharataiuser/screens/e_mandir/passbook/controller/passbook_controller.dart';
import 'package:get/get.dart';

class PassbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassbookController>(() => PassbookController());
  }
}
