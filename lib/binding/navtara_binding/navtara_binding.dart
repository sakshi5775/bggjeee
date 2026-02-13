import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:get/get.dart';

class NavtaraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavtaraController>(() => NavtaraController());
  }
}
