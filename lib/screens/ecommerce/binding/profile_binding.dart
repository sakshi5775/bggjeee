import 'package:astrobharataiuser/screens/ecommerce/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    }
  }
}


