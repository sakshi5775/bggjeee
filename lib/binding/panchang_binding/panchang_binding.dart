import 'package:astrobharataiuser/screens/panchang/controller/panchang_controller.dart';
import 'package:get/get.dart';

class PanchangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PanchangController());
  }
}



