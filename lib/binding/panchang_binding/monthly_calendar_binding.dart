import 'package:astrobharataiuser/screens/panchang/controller/monthly_calendar_controller.dart';
import 'package:get/get.dart';

class MonthlyCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MonthlyCalendarController());
  }
}



