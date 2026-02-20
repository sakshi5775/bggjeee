import 'package:astrobharataiuser/screens/panchang/controller/muhurat_controller.dart';
import 'package:get/get.dart';

class MuhuratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MuhuratController());
  }
}









