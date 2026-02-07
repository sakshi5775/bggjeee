import 'package:astrobharataiuser/screens/astrologer_registration/controller/astrologer_registration_controller.dart';
import 'package:get/get.dart';

class AstrologerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerRegistrationController>(
      () => AstrologerRegistrationController(),
    );
  }
}
