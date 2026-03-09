import 'dart:async';

import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/data_model/search_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class EcommerceSearchController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final query = ''.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingSuggestions = false.obs;
  final searchResults = <ProductModel>[].obs;
  final suggestions = Rx<SearchSuggestions>(SearchSuggestions());
  /// Categories from categories/search API (q, type, page, limit) – uses productCount & level
  final categorySearchResults = <CategoryModel>[].obs;
  final hasMoreResults = true.obs;

  SearchResponse? lastResponse;

  int _page = 1;
  final int _limit = 20;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['initialQuery'] is String) {
      final initial = (args['initialQuery'] as String).trim();
      if (initial.isNotEmpty) {
        searchController.text = initial;
        query.value = initial;
        performSearch(reset: true);
      }
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onQueryChanged(String value) {
    query.value = value;
    if (value.trim().isEmpty) {
      suggestions.value = SearchSuggestions();
      categorySearchResults.clear();
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _loadSuggestions);
  }

  Future<void> performSearch({bool reset = false}) async {
    final currentQuery = query.value.trim();
    if (currentQuery.isEmpty) {
      return;
    }

    if (reset) {
      _page = 1;
      hasMoreResults.value = true;
      searchResults.clear();
      lastResponse = null;
    } else if (!hasMoreResults.value || isLoadingMore.value) {
      return;
    }

    try {
      if (reset) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _service.searchProducts(
        query: currentQuery,
        page: _page,
        limit: _limit,
      );
      if (response != null) {
        lastResponse = response;
        final items = response.items;
        if (items.isNotEmpty) {
          searchResults.addAll(items);
        }
        final pagination = response.pagination;
        hasMoreResults.value = pagination?.hasNextPage ?? false;
        if (hasMoreResults.value) {
          _page = (pagination?.currentPage ?? _page) + 1;
        }
      } else {
        hasMoreResults.value = false;
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    await performSearch();
  }

  Future<void> _loadSuggestions() async {
    final currentQuery = query.value.trim();
    if (currentQuery.length < 2) {
      suggestions.value = SearchSuggestions();
      categorySearchResults.clear();
      return;
    }
    try {
      isLoadingSuggestions.value = true;
      final results = await Future.wait([
        _service.getSearchSuggestions(query: currentQuery, limit: 5),
        _service.searchCategories(q: currentQuery, type: 'all', limit: 5),
      ]);
      suggestions.value = results[0] as SearchSuggestions;
      final categoryData = results[1] as CategoryData?;
      categorySearchResults
        ..clear()
        ..addAll(categoryData?.items ?? []);
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  void onSuggestionCategorySelected(SearchSuggestionCategory category) {
    UserMainController.pushInCurrentTab(
      AppRoutes.productList,
      arguments: {
        if (category.slug != null) 'categorySlug': category.slug,
        if (category.id != null) 'categoryId': category.id,
      },
    );
  }

  /// When user taps a category from categories/search results (uses slug/id, productCount, level).
  void onCategorySearchResultSelected(CategoryModel category) {
    UserMainController.pushInCurrentTab(
      AppRoutes.productList,
      arguments: {
        if (category.slug != null && category.slug!.isNotEmpty)
          'categorySlug': category.slug
        else if (category.id != null)
          'categoryId': category.id
        else
          'category': category,
        'title': category.name,
      },
    );
  }

  void onSuggestionProductSelected(ProductModel product) {
    UserMainController.pushInCurrentTab(AppRoutes.productDetail, arguments: {'product': product});
  }

  String buildResultSummary() {
    final total = lastResponse?.pagination?.totalItems;
    if (total == null || total == 0) return 'No results';
    final currentCount = searchResults.length;
    return '$currentCount of $total results';
  }
}
