import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:get/get.dart';

class NamasteHomeBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put with permanent: false to ensure proper disposal when route is removed
    Get.put(NamasteHomeController(), permanent: false);
  }
}
