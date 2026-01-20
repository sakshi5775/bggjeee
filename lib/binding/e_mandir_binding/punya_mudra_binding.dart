import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';
import 'package:get/get.dart';

class PunyaMudraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PunyaMudraController());
  }
}
