import 'package:get/get.dart';
import '../../screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/controller/e_mandir_wallpaper_story_controller.dart';

class EMandirWallpaperStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EMandirWallpaperStoryController>(
      () => EMandirWallpaperStoryController(),
    );
  }
}
