import 'package:get/get.dart';
import '../../screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/controller/e_mandir_wallpaper_controller.dart';

class EMandirWallpaperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EMandirWallpaperController>(() => EMandirWallpaperController());
  }
}
