import 'package:astrobharataiuser/screens/numerology/controller/numerology_form_controller.dart';
import 'package:get/get.dart';

class NumerologyFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NumerologyFormController());
  }
}


