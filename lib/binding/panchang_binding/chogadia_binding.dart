import 'package:astrobharataiuser/screens/panchang/controller/chogadia_controller.dart';
import 'package:get/get.dart';

class ChogadiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChogadiaController());
  }
}



