import 'package:astrobharataiuser/screens/e_mandir/meaning/controller/meaning_controller.dart';
import 'package:get/get.dart';

class MeaningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeaningController>(() => MeaningController());
  }
}
