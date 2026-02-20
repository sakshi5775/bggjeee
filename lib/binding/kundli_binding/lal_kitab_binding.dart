import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:get/get.dart';

class LalKitabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LalKitabController>(() => LalKitabController());
  }
}

