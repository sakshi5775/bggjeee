import 'package:astrobharataiuser/screens/kundli/controller/kundli_form_controller.dart';
import 'package:get/get.dart';

class KundliFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KundliFormController());
  }
}

