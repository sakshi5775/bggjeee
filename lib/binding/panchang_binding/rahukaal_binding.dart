import 'package:astrobharataiuser/screens/panchang/controller/rahukaal_controller.dart';
import 'package:get/get.dart';

class RahukaalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RahukaalController());
  }
}









