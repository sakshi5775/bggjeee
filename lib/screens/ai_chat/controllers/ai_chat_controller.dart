import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatController extends BaseController {
  final AiChatService _aiChatService = AiChatService();

  // Personas list
  final RxList<PersonaModel> personas = <PersonaModel>[].obs;

  // Categories
  final RxList<PersonaCategory> categories = <PersonaCategory>[].obs;
  final Rx<PersonaCategory?> selectedCategory = Rx<PersonaCategory?>(null);

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxBool isLoadingMore = false.obs;

  // Search
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // View Mode: true for grid, false for list
  final RxBool isGridView = true.obs;

  // Toggle view mode
  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadPersonas(refresh: true);
    searchController.addListener(_performSearch);
  }

  @override
  void onClose() {
    searchController.removeListener(_performSearch);
    searchController.dispose();
    super.onClose();
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final categoriesList = await _aiChatService.getCategories();
      categories.value = categoriesList;
    } catch (e) {
      // Handle error silently - categories are optional
      // If categories fail to load, the filter will just show "All"
    }
  }

  // Load personas
  Future<void> loadPersonas({bool refresh = false}) async {
    if (!refresh && (!hasMoreData.value || isLoadingMore.value)) {
      return;
    }

    await runWithLoading(
      () async {
        if (refresh) {
          currentPage.value = 1;
          personas.clear();
          hasMoreData.value = true;
        } else {
          isLoadingMore.value = true;
        }

        final categoryValue = selectedCategory.value?.value;

        final response = await _aiChatService.getPersonas(
          page: refresh ? 1 : currentPage.value,
          limit: 20,
          category: categoryValue,
          sortBy: 'rating',
        );

        if (response != null) {
          if (refresh) {
            personas.value = response.personas;
          } else {
            personas.addAll(response.personas);
          }

          hasMoreData.value = response.pagination.hasNextPage;
          if (response.pagination.nextPage != null) {
            currentPage.value = response.pagination.nextPage!;
          } else {
            currentPage.value = response.pagination.page + 1;
          }

          _performSearch();
        }
      },
      showBusy: refresh,
      showError: true,
      useDialog:
          refresh, // Use dialog for initial load failures, snackbar for pagination
      onRetry: () => loadPersonas(refresh: refresh),
    );

    if (!refresh) {
      isLoadingMore.value = false;
    }
  }

  // Load more personas
  Future<void> loadMore() async {
    if (hasMoreData.value && !isLoadingMore.value) {
      await loadPersonas(refresh: false);
    }
  }

  // Filter by category
  void filterByCategory(PersonaCategory? category) {
    if (selectedCategory.value?.value == category?.value) {
      // If same category is clicked, deselect it (show all)
      selectedCategory.value = null;
    } else {
      // Select the new category
      selectedCategory.value = category;
    }
    // Reload personas with the selected category filter
    loadPersonas(refresh: true);
  }

  // Clear filter
  void clearFilter() {
    selectedCategory.value = null;
    // Reload all personas without category filter
    loadPersonas(refresh: true);
  }

  // Get filtered personas (for search)
  List<PersonaModel> get filteredPersonas {
    if (searchQuery.value.isEmpty) {
      return List.from(personas);
    }

    final query = searchQuery.value.toLowerCase();
    return personas
        .where(
          (persona) =>
              persona.displayName.toLowerCase().contains(query) ||
              persona.description.toLowerCase().contains(query) ||
              persona.tags.any((tag) => tag.toLowerCase().contains(query)) ||
              persona.specializations.any(
                (spec) => spec.toLowerCase().contains(query),
              ),
        )
        .toList();
  }

  // Perform search
  void _performSearch() {
    // Search is handled by filteredPersonas getter
    // This listener is for future enhancements
  }

  // Refresh
  Future<void> refresh() async {
    await loadPersonas(refresh: true);
  }
}

