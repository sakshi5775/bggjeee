import 'package:astrobharataiuser/screens/kundli/controller/shodashvarga_controller.dart';
import 'package:get/get.dart';

class ShodashvargaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShodashvargaController>(() => ShodashvargaController());
  }
}

