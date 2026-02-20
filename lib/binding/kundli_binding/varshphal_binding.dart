import 'package:astrobharataiuser/screens/kundli/controller/varshphal_controller.dart';
import 'package:get/get.dart';

class VarshphalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VarshphalController>(() => VarshphalController());
  }
}
