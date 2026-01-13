import 'package:astrobharataiuser/screens/handwriting_astrology/controller/handwriting_astrology_controller.dart';
import 'package:get/get.dart';

class HandwritingAstrologyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HandwritingAstrologyController());
  }
}



