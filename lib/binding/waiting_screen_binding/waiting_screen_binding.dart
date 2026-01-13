import 'package:astrobharataiuser/screens/waiting_screen/controller/waiting_screen_controller.dart';
import 'package:get/get.dart';

class WaitingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put( WaitingScreenController());
  }
}
