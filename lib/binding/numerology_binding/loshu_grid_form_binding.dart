import 'package:astrobharataiuser/screens/numerology/controller/loshu_grid_form_controller.dart';
import 'package:get/get.dart';

class LoShuGridFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoShuGridFormController());
  }
}



