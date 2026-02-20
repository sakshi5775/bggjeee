import 'package:astrobharataiuser/screens/numerology/controller/numerology_reports_controller.dart';
import 'package:get/get.dart';

class NumerologyReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NumerologyReportsController());
  }
}


