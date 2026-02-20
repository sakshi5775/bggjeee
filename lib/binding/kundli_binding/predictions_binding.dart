import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:get/get.dart';

class PredictionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionsController>(() => PredictionsController());
  }
}

