import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
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
    'Festivals',
  ];
  final RxString selectedFilter = 'Today'.obs;

  /// Tracks route-provided filter so we only apply once per navigation.
  String? _routeRequestedFilter;

  final List<String> greetingFilters = ['Today', 'Morning', 'Evening', 'Night'];
  final RxString selectedGreetingFilter = 'Today'.obs;

  final RxList<WallpaperItem> wallpapers = <WallpaperItem>[].obs;
  final RxList<DailyThoughtItem> dailyThoughts = <DailyThoughtItem>[].obs;
  final RxList<FestivalModel> festivals = <FestivalModel>[].obs;
  final RxList<BannerItem> banners = <BannerItem>[].obs;
  GodCategory? currentCategory;

  final EMandirHomeService _homeService = Get.put(EMandirHomeService());
  final BannerService _bannerService = BannerService();

  @override
  void onInit() {
    super.onInit();
    // Accept initial filter from route arguments (e.g. when controller is first created)
    final args = Get.arguments ?? Get.routing.args;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['initialFilter'] != null) {
      final initial = args['initialFilter'] as String;
      if (filters.contains(initial)) {
        selectedFilter.value = initial;
        _routeRequestedFilter = initial;
      }
    }
    fetchContent();
    loadBanners();
  }

  /// Apply filter from route (e.g. collection bottom sheet). Idempotent per value.
  void applyRouteFilter(String? filter) {
    if (filter == null || !filters.contains(filter)) return;
    if (filter == _routeRequestedFilter) return;
    _routeRequestedFilter = filter;
    selectedFilter.value = filter;
    fetchContent();
    // Scrolling is handled by the view (local ScrollController)
  }

  Future<void> loadBanners() async {
    final list = await _bannerService.getBannersWithFallback(['appsrimandir']);
    banners.assignAll(list);
  }

  @override
  void onReady() {
    super.onReady();
    // Scrolling is handled by the view (local ScrollController)
  }

  /// Scroll so the selected filter chip is centered in the viewport.
  void scrollToSelectedFilter(ScrollController filterScrollController) {
    final index = filters.indexOf(selectedFilter.value);
    if (index == -1 || !filterScrollController.hasClients) return;
    final position = filterScrollController.position;
    final viewportWidth = position.viewportDimension;
    // Approximate chip width (padding + text + margin)
    const double chipWidth = 100.0;
    final maxExtent = position.maxScrollExtent;
    // Center the selected chip: chip center at viewport center
    double offset = (index * chipWidth) - (viewportWidth / 2) + (chipWidth / 2);
    offset = offset.clamp(0.0, maxExtent);
    filterScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onChangeFilter(String filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    fetchContent();
    // Center the selected tab in the horizontal list
    // Scrolling is handled by the view (local ScrollController)
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
    } else if (selectedFilter.value == 'Festivals') {
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
