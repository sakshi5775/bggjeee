import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_form_controller.dart';
import 'package:get/get.dart';

class HoroscopeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HoroscopeFormController());
  }
}










