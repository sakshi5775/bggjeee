import 'package:astrobharataiuser/screens/panchang/controller/other_calendars_controller.dart';
import 'package:get/get.dart';

class OtherCalendarsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtherCalendarsController());
  }
}



