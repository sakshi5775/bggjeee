import 'package:astrobharataiuser/screens/kundli/controller/gemstones_report_controller.dart';
import 'package:get/get.dart';

class GemstonesReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GemstonesReportController>(() => GemstonesReportController());
  }
}
