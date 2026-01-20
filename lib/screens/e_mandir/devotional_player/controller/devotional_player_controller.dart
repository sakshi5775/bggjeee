import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:get/get.dart';

class DevotionalPlayerController extends BaseController {
  final RxDouble currentPosition = 112.0.obs;
  final RxDouble maxPosition = 323.0.obs;
  final RxBool isPlaying = false.obs;

  void onPositionChanged(double value) {
    currentPosition.value = value;
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
  }
}
