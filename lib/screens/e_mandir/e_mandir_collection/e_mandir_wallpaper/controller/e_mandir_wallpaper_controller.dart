import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data_model/e_mandir_wallpaper_model.dart';
import '../service/e_mandir_wallpaper_service.dart';

import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/data_model/daily_thought_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/service/e_mandir_home_service.dart';

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
    'Library',
  ];
  final RxString selectedFilter = 'Today'.obs;

  final List<String> greetingFilters = ['Today', 'Morning', 'Evening', 'Night'];
  final RxString selectedGreetingFilter = 'Today'.obs;

  final RxList<WallpaperItem> wallpapers = <WallpaperItem>[].obs;
  final RxList<DailyThoughtItem> dailyThoughts = <DailyThoughtItem>[].obs;
  final RxList<FestivalModel> festivals = <FestivalModel>[].obs;
  GodCategory? currentCategory;
  final ScrollController filterScrollController = ScrollController();

  final EMandirHomeService _homeService = Get.put(EMandirHomeService());

  @override
  void onInit() {
    super.onInit();
    // Accept initial filter from route arguments
    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['initialFilter'] != null) {
      final initial = args['initialFilter'] as String;
      if (filters.contains(initial)) {
        selectedFilter.value = initial;
      }
    }
    fetchContent();
  }

  @override
  void onReady() {
    super.onReady();
    scrollToSelectedFilter();
  }

  void scrollToSelectedFilter() {
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
    fetchContent();
  }

  void onChangeGreetingFilter(String filter) {
    if (selectedGreetingFilter.value == filter) return;
    selectedGreetingFilter.value = filter;
    fetchDailyThoughts();
  }

  void fetchContent() {
    if (selectedFilter.value == 'Greetings') {
      fetchDailyThoughts();
    } else if (selectedFilter.value == 'Today') {
      fetchWallpapers();
    } else if (selectedFilter.value == 'Library') {
      fetchFestivals();
    }
  }

  Future<void> fetchDailyThoughts() async {
    setLoadingState(true);
    dailyThoughts.clear();
    currentCategory = null;

    final response = await _wallpaperService.getDailyThoughts(
      selectedGreetingFilter.value.toLowerCase(),
    );

    if (response != null && response.success && response.data != null) {
      dailyThoughts.assignAll(response.data!.items);
    }

    setLoadingState(false);
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

  Future<void> fetchFestivals() async {
    setLoadingState(true);
    festivals.clear();

    final response = await _homeService.getFestivals();
    if (response != null && response.success) {
      festivals.assignAll(response.items);
    }

    setLoadingState(false);
  }
}
