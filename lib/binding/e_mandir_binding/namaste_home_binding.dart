import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:get/get.dart';

class NamasteHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NamasteHomeController());
  }
}
