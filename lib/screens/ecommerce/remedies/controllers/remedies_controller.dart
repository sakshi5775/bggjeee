import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemediesController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();
  final BannerService _bannerService = BannerService();

  final RxList<CategoryModel> storeCategories = <CategoryModel>[].obs;
  final RxList<RemedyCategoryModel> remedyCategories =
      <RemedyCategoryModel>[].obs;
  final RxList<RemedyModel> featuredRemedyServices = <RemedyModel>[].obs;
  final RxBool isLoadingFeatured = true.obs;

  final RxBool isLoadingStore = true.obs;
  final RxBool isLoadingRemedies = true.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination
  int currentPage = 1;
  bool hasNextPage = false;
  final int _limit = 20;

  // Search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Banner (Static for now)
  final RxList<BannerItem> banners = <BannerItem>[].obs;
  final RxBool isLoadingBanners = true.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();

    // Search listener with debounce could be added here
    searchController.addListener(() {
      if (searchController.text != searchQuery.value) {
        // Simple debounce logic can be added if needed
      }
    });

    // Pagination listener
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _fetchBanners(),
      _fetchStoreCategories(),
      _fetchRemedyCategories(reset: true),
      _fetchFeaturedRemedyServices(),
    ]);
  }

  Future<void> _fetchFeaturedRemedyServices() async {
    try {
      isLoadingFeatured.value = true;
      final list = await _remediesService.getFeaturedRemedyServices(limit: 10);
      featuredRemedyServices.assignAll(list);
    } catch (e) {
      print("Error fetching featured remedies: $e");
      featuredRemedyServices.clear();
    } finally {
      isLoadingFeatured.value = false;
    }
  }

  Future<void> _fetchBanners() async {
    try {
      isLoadingBanners.value = true;
      final list = await _bannerService.getBannersWithFallback(['appgeneral', 'general']);
      banners.assignAll(list);
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<void> _fetchStoreCategories() async {
    try {
      isLoadingStore.value = true;
      final categories = await _remediesService.getStoreCategories();
      storeCategories.assignAll(categories);
    } finally {
      isLoadingStore.value = false;
    }
  }

  Future<void> _fetchRemedyCategories({bool reset = false}) async {
    final String currentQuery = searchQuery.value;
    final int fetchPage = reset ? 1 : currentPage;

    if (reset) {
      isLoadingRemedies.value = true;
      currentPage = 1;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final data = await _remediesService.getRemedyCategories(
        page: fetchPage,
        limit: _limit,
        search: currentQuery.isNotEmpty ? currentQuery : null,
      );

      // Concurrency guard: discard results if the query changed while fetching.
      if (searchQuery.value != currentQuery) return;

      if (data != null && data.items != null) {
        final newItems = List<RemedyCategoryModel>.from(data.items!);
        if (reset) {
          // Atomic replace to avoid ConcurrentModificationError
          remedyCategories.assignAll(newItems);
        } else {
          // For pagination, build a new list and assign atomically
          final merged = [...remedyCategories, ...newItems];
          remedyCategories.assignAll(merged);
        }
        hasNextPage = data.pagination?.hasNextPage ?? false;
        if (hasNextPage) {
          currentPage++;
        }
      }
    } catch (e) {
      debugPrint("Error fetching remedies: $e");
    } finally {
      if (searchQuery.value == currentQuery) {
        isLoadingRemedies.value = false;
        isLoadingMore.value = false;
      }
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _fetchRemedyCategories(reset: true);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (hasNextPage && !isLoadingMore.value && !isLoadingRemedies.value) {
        _fetchRemedyCategories();
      }
    }
  }
}
