import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_history_controller.dart';
import 'package:get/get.dart';

class PalmReadingHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PalmReadingHistoryController());
  }
}











