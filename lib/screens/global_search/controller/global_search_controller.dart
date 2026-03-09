import 'dart:async';

import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/data_model/global_search_model.dart';
import 'package:astrobharataiuser/screens/global_search/service/global_search_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for global search: runs search across all modules and handles
/// navigation with optional login check before opening protected routes.
/// Triggers search as user types (debounced) and shows suggestions below.
/// When [closeBeforeNavigate] is set (e.g. for overlay), it is called before navigating.
class GlobalSearchController extends BaseController {
  GlobalSearchController({this.closeBeforeNavigate});

  final VoidCallback? closeBeforeNavigate;

  final GlobalSearchService _service = GlobalSearchService();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final Rx<String> query = ''.obs;
  final RxBool isLoading = false.obs;
  final Rx<GlobalSearchResponse?> searchResponse = Rx<GlobalSearchResponse?>(null);

  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 350);

  List<GlobalSearchSection> get nonEmptySections =>
      searchResponse.value?.nonEmptySections ?? [];

  bool get hasResults => searchResponse.value?.hasResults ?? false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['initialQuery'] is String) {
      final initial = (args['initialQuery'] as String).trim();
      if (initial.isNotEmpty) {
        searchController.text = initial;
        query.value = initial;
        performSearch();
      }
    } else if (args is String && args.trim().isNotEmpty) {
      searchController.text = args.trim();
      query.value = args.trim();
      performSearch();
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onQueryChanged(String value) {
    query.value = value;
    _debounceTimer?.cancel();
    if (value.trim().isEmpty) {
      searchResponse.value = null;
      return;
    }
    _debounceTimer = Timer(_debounceDuration, () {
      performSearch();
    });
  }

  Future<void> performSearch() async {
    final q = query.value.trim();
    if (q.isEmpty) {
      searchResponse.value = GlobalSearchResponse(sections: [], query: '');
      return;
    }

    try {
      isLoading.value = true;
      searchResponse.value = null;
      final response = await _service.search(q);
      searchResponse.value = response;
    } catch (e) {
      searchResponse.value = GlobalSearchResponse(sections: [], query: q);
      showErrorMessage(
        title: 'Search failed',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to the result: close search (or call [closeBeforeNavigate]), then
  /// if [item.requiresAuth] and user is not logged in, show login modal; then navigate.
  Future<void> onResultTap(GlobalSearchResultItem item) async {
    if (closeBeforeNavigate != null) {
      closeBeforeNavigate!();
    } else if (Get.context != null && Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
    }
    if (item.requiresAuth && LoginGuard.isGuest) {
      final didLogin = await LoginGuard.ensureLoggedIn(
        message: 'Please login to view this.',
        onLoginSuccess: () => _navigateToResult(item),
      );
      if (didLogin) {
        _navigateToResult(item);
      }
      return;
    }
    _navigateToResult(item);
  }

  void _navigateToResult(GlobalSearchResultItem item) {
    UserMainController.pushInCurrentTab(item.route, arguments: item.arguments);
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    searchController.clear();
    query.value = '';
    searchResponse.value = null;
  }
}
