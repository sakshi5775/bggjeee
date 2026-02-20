import 'package:astrobharataiuser/screens/panchang/controller/yearly_vrat_controller.dart';
import 'package:get/get.dart';

class YearlyVratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YearlyVratController());
  }
}



