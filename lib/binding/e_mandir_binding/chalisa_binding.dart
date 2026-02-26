import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/chalisa/controller/chalisa_controller.dart';

class ChalisaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChalisaController>(() => ChalisaController());
  }
}
