import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/controller/namaste_home_controller.dart';
import 'package:get/get.dart';

class NamasteHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NamasteHomeController());
  }
}
