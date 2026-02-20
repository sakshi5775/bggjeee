import 'package:astrobharataiuser/screens/e_mandir/festivals/all_festival/controller/all_festival_controller.dart';
import 'package:get/get.dart';

class AllFestivalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllFestivalController());
  }
}
