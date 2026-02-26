import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/chalisa/controller/chalisa_detail_controller.dart';

class ChalisaDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChalisaDetailController>(() => ChalisaDetailController());
  }
}
