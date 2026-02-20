import 'package:astrobharataiuser/screens/numerology/controller/loshu_grid_result_controller.dart';
import 'package:get/get.dart';

class LoShuGridResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoShuGridResultController());
  }
}



