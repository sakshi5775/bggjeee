import 'package:get/get.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

class LyricsController extends BaseController {
  void navigateToPlayer() {
    Get.toNamed(AppRoutes.devotionalPlayer);
  }
}

