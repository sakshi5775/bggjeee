import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:get/get.dart';

class PoojaDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PujaDetailController>(() => PujaDetailController());
  }
}
