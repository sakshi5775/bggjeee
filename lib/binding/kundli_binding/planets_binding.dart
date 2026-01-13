import 'package:astrobharataiuser/screens/kundli/controller/planets_controller.dart';
import 'package:get/get.dart';

class PlanetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanetsController>(() => PlanetsController());
  }
}










