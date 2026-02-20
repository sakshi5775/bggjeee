import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/controller/meaning_controller.dart';

class MeaningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeaningController());
  }
}
