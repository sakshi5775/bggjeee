import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:get/get.dart';
import '../data_model/e_mandir_wallpaper_model.dart';
import '../service/e_mandir_wallpaper_service.dart';

class EMandirWallpaperController extends BaseController {
  final EMandirWallpaperService _wallpaperService = Get.put(
    EMandirWallpaperService(),
  );

  final List<String> filters = [
    'Astrology',
    'Rashifal',
    'Panchang',
    'Greetings',
    'Today',
  ];
  final RxString selectedFilter = 'Today'.obs;

  final RxList<WallpaperItem> wallpapers = <WallpaperItem>[].obs;
  GodCategory? currentCategory;

  @override
  void onInit() {
    super.onInit();
    fetchWallpapers();
  }

  void onChangeFilter(String filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    fetchWallpapers();
  }

  Future<void> fetchWallpapers() async {
    setLoadingState(true);
    wallpapers.clear();
    currentCategory = null;

    final response = await _wallpaperService.getDailyWallpapers(
      filter: selectedFilter.value.toLowerCase(),
      page: 1,
      limit: 30,
    );

    if (response != null && response.success && response.data != null) {
      wallpapers.assignAll(response.data!.wallpapers);
      currentCategory = response.data!.godCategory;
    }

    setLoadingState(false);
  }
}
