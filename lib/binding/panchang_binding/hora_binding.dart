import 'package:astrobharataiuser/screens/panchang/controller/hora_controller.dart';
import 'package:get/get.dart';

class HoraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HoraController());
  }
}



