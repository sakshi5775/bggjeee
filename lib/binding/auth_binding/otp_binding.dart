import 'package:astrobharataiuser/screens/otp/controller/otp_controller.dart';
import 'package:get/get.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OTPController());
  }
}
