import 'package:get/get.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

class DevotionalPlayerController extends BaseController {
  final currentPosition = 112.0.obs;
  final maxPosition = 323.0.obs;
  final isPlaying = false.obs;

  void onSliderChanged(double value) {
    currentPosition.value = value;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void navigateToLyrics() {
    Get.toNamed(AppRoutes.lyrics);
  }

  void navigateToMeaning() {
    Get.toNamed(AppRoutes.meaning);
  }
}
