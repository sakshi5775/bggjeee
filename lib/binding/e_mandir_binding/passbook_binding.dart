import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/controller/passbook_controller.dart';

class PassbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PassbookController());
  }
}
