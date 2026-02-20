import 'package:astrobharataiuser/screens/kundli/controller/transit_today_controller.dart';
import 'package:get/get.dart';

class TransitTodayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransitTodayController>(() => TransitTodayController());
  }
}
