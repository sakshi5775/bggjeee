import 'package:astrobharataiuser/screens/panchang/controller/festival_yearly_controller.dart';
import 'package:get/get.dart';

class FestivalYearlyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FestivalYearlyController());
  }
}



