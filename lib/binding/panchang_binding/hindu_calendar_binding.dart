import 'package:astrobharataiuser/screens/panchang/controller/hindu_calendar_controller.dart';
import 'package:get/get.dart';

class HinduCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HinduCalendarController());
  }
}



