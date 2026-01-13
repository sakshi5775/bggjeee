import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:get/get.dart';

class RamalShastraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RamalShastraController>(() => RamalShastraController());
  }
}


