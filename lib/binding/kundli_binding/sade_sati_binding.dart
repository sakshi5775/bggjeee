import 'package:astrobharataiuser/screens/kundli/controller/sade_sati_controller.dart';
import 'package:get/get.dart';

class SadeSatiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SadeSatiController>(() => SadeSatiController());
  }
}
