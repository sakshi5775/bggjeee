import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemediesController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();

  final RxList<CategoryModel> storeCategories = <CategoryModel>[].obs;
  final RxList<RemedyCategoryModel> remedyCategories =
      <RemedyCategoryModel>[].obs;

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
  final RxList<String> bannerImages = <String>[
    // Placeholders, will be replaced or populated later
    'assets/images/banner1.png',
  ].obs;

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
      _fetchStoreCategories(),
      _fetchRemedyCategories(reset: true),
    ]);
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

    if (reset) {
      isLoadingRemedies.value = true;
      currentPage = 1;
      remedyCategories.clear();
    } else {
      isLoadingMore.value = true;
    }

    try {
      final data = await _remediesService.getRemedyCategories(
        page: currentPage,
        limit: _limit,
        searchQuery: currentQuery.isNotEmpty ? currentQuery : null,
      );

      // Concurrency check: If query changed while fetching, discard result
      if (searchQuery.value != currentQuery) {
        return;
      }

      // If reset was intended but another request cleared it?
      // Actually, if we are here, we matched the query.
      // But we should also check if we are still at page 1 if reset was true.
      // Simpler check: Just ensure we don't duplicate.
      // The race condition usually happens when a pending request returns AFTER a reset.
      // If we use 'reset', we cleared the list.
      // If 'currentQuery' matches 'searchQuery.value', it means user hasn't typed more.

      if (data != null) {
        if (data.items != null) {
          // Additional safety: if reset was true, ensure list is empty or we are just overwriting?
          // If we had a race, another request might have populated it.
          // But since we operate on the main isolate (mostly), the 'await' is the gap.
          // If a new search started, 'reset' would be called again, clearing the list.
          // So if we return here and query matches, we are 'current'.
          // But if a PREVIOUS request returns late?
          // E.g. Request A (Query "X"), Request B (Query "XY").
          // A starts. B starts (clears list). A returns. query "X" != "XY". A discards. Good.
          // B returns. query "XY" == "XY". B populates. Good.

          // What if Request A (Query "X"), Request B (Query "X") (User typed X, del, X)?
          // Unlikely to cause dupes unless we didn't clear.
          // The issue reported is "cancel all query" (Query "").
          // Request A ("X") returns. Request B ("") starts.
          // If B clears, A returns?
          // If A checks query, A sees "" (from B). "X" != "". A discards.

          remedyCategories.addAll(data.items!);
        }
        hasNextPage = data.pagination?.hasNextPage ?? false;
        if (hasNextPage) {
          currentPage++;
        }
      }
    } catch (e) {
      print("Error fetching remedies: $e");
    } finally {
      // Create a local check again?
      // Only turn off loading if this is the active request?
      // It's hard to know which request owns the loading state without a simplified ID.
      // But generally safe to turn off.
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

