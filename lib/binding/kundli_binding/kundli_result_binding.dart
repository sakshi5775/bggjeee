import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:get/get.dart';

class KundliResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KundliResultController());
    Get.lazyPut(() => NavtaraController());
  }
}
