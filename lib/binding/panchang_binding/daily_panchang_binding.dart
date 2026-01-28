import 'package:astrobharataiuser/screens/panchang/controller/daily_panchang_controller.dart';
import 'package:get/get.dart';

class DailyPanchangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DailyPanchangController());
  }
}



