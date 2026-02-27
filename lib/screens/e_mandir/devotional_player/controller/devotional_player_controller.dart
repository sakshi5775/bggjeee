import 'package:get/get.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/service/audio_player_service.dart';

class DevotionalPlayerController extends BaseController {
  late final AudioPlayerService audioService;

  @override
  void onInit() {
    super.onInit();
    audioService = Get.find<AudioPlayerService>();
  }

  void navigateToLyrics() {
    Get.toNamed(AppRoutes.lyrics);
  }

  void navigateToMeaning() {
    Get.toNamed(AppRoutes.meaning);
  }
}
