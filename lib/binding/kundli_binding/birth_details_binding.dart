import 'package:astrobharataiuser/screens/kundli/controller/birth_details_controller.dart';
import 'package:get/get.dart';

class BirthDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthDetailsController>(() => BirthDetailsController());
  }
}










