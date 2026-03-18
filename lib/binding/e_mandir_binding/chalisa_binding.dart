import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/chalisa/controller/chalisa_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/chalisa/service/chalisa_service.dart';

class ChalisaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChalisaService>(() => ChalisaService(), fenix: true);
    Get.lazyPut<ChalisaController>(() => ChalisaController());
  }
}
