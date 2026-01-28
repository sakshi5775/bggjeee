import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:get/get.dart';

class PalmReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PalmReadingController());
  }
}











