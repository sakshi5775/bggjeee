import 'package:astrobharataiuser/screens/panchang/controller/jain_calendar_controller.dart';
import 'package:get/get.dart';

class JainCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JainCalendarController());
  }
}



