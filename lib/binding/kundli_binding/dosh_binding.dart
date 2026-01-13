import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:get/get.dart';

class DoshBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoshController>(() => DoshController());
  }
}

