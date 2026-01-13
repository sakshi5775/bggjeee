import 'package:astrobharataiuser/screens/numerology/controller/numerology_controller.dart';
import 'package:get/get.dart';

class NumerologyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NumerologyController());
  }
}



