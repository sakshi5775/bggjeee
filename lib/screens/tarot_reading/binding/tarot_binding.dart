import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:get/get.dart';

class TarotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TarotController());
  }
}

