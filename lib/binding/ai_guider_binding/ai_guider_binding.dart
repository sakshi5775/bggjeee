import 'package:astrobharataiuser/screens/ai_guider/controller/ai_guider_controller.dart';
import 'package:astrobharataiuser/screens/ai_guider/service/ai_guider_service.dart';
import 'package:get/get.dart';

class AiGuiderBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure API client is initialized (should already be registered)
    // If not, it will be handled by the app's dependency injection

    // Register AI Guider Service
    if (!Get.isRegistered<AiGuiderService>()) {
      Get.put(AiGuiderService());
    }

    // Register AI Guider Controller
    Get.lazyPut(() => AiGuiderController());
  }
}

