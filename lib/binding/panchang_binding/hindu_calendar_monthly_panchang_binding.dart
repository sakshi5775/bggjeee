import 'package:astrobharataiuser/screens/panchang/controller/hindu_calendar_monthly_panchang_controller.dart';
import 'package:get/get.dart';

class HinduCalendarMonthlyPanchangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HinduCalendarMonthlyPanchangController());
  }
}

