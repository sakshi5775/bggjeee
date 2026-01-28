import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:get/get.dart';

/// Language binding - initializes the global language controller
class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize language controller (single source of truth)
    Get.put(LanguageControllerV2(), permanent: true);
  }
}
