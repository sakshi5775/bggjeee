import 'package:astrobharataiuser/screens/panchang/controller/festival_filtered_controller.dart';
import 'package:get/get.dart';

class FestivalFilteredBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FestivalFilteredController());
  }
}



