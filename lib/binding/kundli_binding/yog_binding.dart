import 'package:astrobharataiuser/screens/kundli/controller/yog_controller.dart';
import 'package:get/get.dart';

class YogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YogController>(() => YogController());
  }
}








