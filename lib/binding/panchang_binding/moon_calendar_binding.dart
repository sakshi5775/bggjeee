import 'package:astrobharataiuser/screens/panchang/controller/moon_calendar_controller.dart';
import 'package:get/get.dart';

class MoonCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoonCalendarController());
  }
}



