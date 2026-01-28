import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:get/get.dart';

class KpSystemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KpSystemController>(() => KpSystemController());
  }
}

