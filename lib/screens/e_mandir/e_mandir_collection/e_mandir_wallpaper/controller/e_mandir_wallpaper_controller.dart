import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:flutter/material.dart';
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
  final ScrollController filterScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchWallpapers();
  }

  @override
  void onReady() {
    super.onReady();
    _scrollToSelectedFilter();
  }

  void _scrollToSelectedFilter() {
    final index = filters.indexOf(selectedFilter.value);
    if (index != -1 && filterScrollController.hasClients) {
      // Calculate approximate position. Each chip is roughly ~100 width.
      final offset = index * 100.0;
      filterScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
