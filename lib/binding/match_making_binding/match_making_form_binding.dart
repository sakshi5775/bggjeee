import 'package:astrobharataiuser/screens/match_making/controller/match_making_form_controller.dart';
import 'package:get/get.dart';

class MatchMakingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MatchMakingFormController());
  }
}








