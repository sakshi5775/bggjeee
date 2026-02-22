import 'dart:async';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/puja_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookPujaController extends BaseController {
  final PujaService _pujaService = PujaService();

  // Filter types
  final RxString selectedFilter = 'All'.obs;
  final List<Map<String, dynamic>> filters = [
    {'name': 'All', 'featured': null, 'popular': null},
    {'name': 'Featured', 'featured': true, 'popular': null},
    {'name': 'Popular', 'featured': null, 'popular': true},
  ];

  // Search
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _searchDebounce;

  // Pooja list
  final RxList<PujaModel> pujas = <PujaModel>[].obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  final int limit = 10;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPujas();

    // Listen to search text changes with debounce
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;

    // Cancel previous timer
    _searchDebounce?.cancel();

    // Create new timer for debounce (500ms delay)
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      loadPujas(refresh: true);
    });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> loadPujas({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore.value = true;
      pujas.clear();
    }

    if (!hasMore.value || isLoading.value) return;

    setLoadingState(true);
    errorMessage.value = '';

    try {
      // Get current filter
      final currentFilter = filters.firstWhere(
        (f) => f['name'] == selectedFilter.value,
        orElse: () => filters[0],
      );

      final response = await _pujaService.getPujas(
        page: currentPage,
        limit: limit,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        featured: currentFilter['featured'] as bool?,
        popular: currentFilter['popular'] as bool?,
      );

      if (response != null && response.success == true) {
        final newPujas = response.data?.items ?? [];

        if (refresh) {
          pujas.value = newPujas;
        } else {
          pujas.addAll(newPujas);
        }

        // Check if there are more pages
        final pagination = response.data?.pagination;
        if (pagination != null) {
          hasMore.value = pagination.hasNextPage ?? false;
        } else {
          hasMore.value = newPujas.length >= limit;
        }

        // Increment page for next load if there are more pages
        if (hasMore.value) {
          currentPage++;
        }
      } else {
        errorMessage.value = 'Failed to load pujas';
      }
    } catch (e) {
      errorMessage.value = 'Error loading pujas: ${e.toString()}';
    } finally {
      setLoadingState(false);
    }
  }

  void onFilterChanged(String filterName) {
    if (selectedFilter.value != filterName) {
      selectedFilter.value = filterName;
      loadPujas(refresh: true);
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    loadPujas(refresh: true);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    loadPujas(refresh: true);
  }

  void onBookNow(PujaModel puja) {
    // TODO: Navigate to booking page or show booking dialog
    Get.snackbar(
      'Book Puja',
      'Booking functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Get icon color based on puja index
  Color getIconColor(int index) {
    final colors = [
      const Color(0xFFE8D5FF), // Light purple
      const Color(0xFFFFF4E0), // Light yellow
      const Color(0xFFFFE5D9), // Light orange
      const Color(0xFFFFF4E0), // Light yellow
    ];
    return colors[index % colors.length];
  }

  // Get icon based on puja title
  String getPujaIcon(PujaModel puja) {
    final title = puja.title?.toLowerCase() ?? '';
    if (title.contains('ganesh') || title.contains('ganesha')) {
      return 'à¥';
    } else if (title.contains('rudra') || title.contains('shiva')) {
      return '🕉️';
    } else if (title.contains('lakshmi')) {
      return '🪔';
    } else if (title.contains('navgrah') || title.contains('navgraha')) {
      return '⭐';
    }
    return 'à¥';
  }

  // Get minimum price from packages
  double? getMinPrice(PujaModel puja) {
    if (puja.packages == null || puja.packages!.isEmpty) {
      return null;
    }
    final prices = puja.packages!
        .map((p) => p.price ?? 0.0)
        .where((p) => p > 0)
        .toList();
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  // Get duration from timing
  String getDuration(PujaModel puja) {
    if (puja.timing != null && puja.timing!.isNotEmpty) {
      return puja.timing!;
    }
    return '30 mins'; // Default
  }
}
