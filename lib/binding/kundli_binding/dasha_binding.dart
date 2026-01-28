import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:get/get.dart';

class DashaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashaController>(() => DashaController());
  }
}

