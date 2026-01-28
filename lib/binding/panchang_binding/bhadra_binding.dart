import 'package:astrobharataiuser/screens/panchang/controller/bhadra_controller.dart';
import 'package:get/get.dart';

class BhadraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BhadraController());
  }
}









