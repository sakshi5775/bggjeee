import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';

class PunyaMudraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PunyaMudraController());
  }
}
