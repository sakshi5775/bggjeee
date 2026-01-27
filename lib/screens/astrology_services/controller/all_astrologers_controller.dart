import 'dart:async';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllAstrologersController extends GetxController {
  final AstrologerService _astrologerService = AstrologerService();

  // Reactive variables
  final RxList<AstrologerModel> astrologers = <AstrologerModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter variables
  final RxString selectedFilter = 'All'.obs; // All, Vedic, Tarots, Vastu, Prashana
  final List<String> filterOptions = ['All', 'Vedic', 'Tarots', 'Vastu', 'Prashana'];

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt limit = 20.obs;
  final RxBool hasMoreData = false.obs;

  // Initial filter (can be passed from previous screen)
  String? initialFilter;

  AllAstrologersController({this.initialFilter});

  @override
  void onInit() {
    super.onInit();
    if (initialFilter != null) {
      selectedFilter.value = initialFilter!;
    }
    loadAstrologers();
  }

  /// Call from view when user scrolls near bottom (NotificationListener).
  /// Avoids ScrollController on ListView to prevent "attached to multiple scroll views".
  void onScrollMetrics(ScrollMetrics metrics) {
    if (isLoading.value || !hasMoreData.value) return;
    if (metrics.pixels >= metrics.maxScrollExtent * 0.8) {
      loadMore();
    }
  }

  Future<void> loadAstrologers({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      astrologers.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Map filter to specialization
      String? specialization;
      if (selectedFilter.value != 'All') {
        // Handle special cases first
        if (selectedFilter.value == 'Tarots') {
          specialization = 'TAROT';
        } else if (selectedFilter.value == 'Prashana') {
          specialization = 'PRASHANA';
        } else {
          // For Vedic, Vastu, etc., just uppercase
          specialization = selectedFilter.value.toUpperCase();
        }
      }

      final response = await _astrologerService.getAstrologers(
        page: currentPage.value,
        limit: limit.value,
        specialization: specialization,
      );

      if (response != null) {
        if (refresh) {
          astrologers.value = response.astrologers;
        } else {
          astrologers.addAll(response.astrologers);
        }
        hasMoreData.value = response.pagination.hasNextPage;
        currentPage.value = response.pagination.currentPage;
      } else {
        errorMessage.value = 'Failed to load astrologers';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadAstrologers(refresh: true);
  }

  Future<void> loadMore() async {
    if (!isLoading.value && hasMoreData.value) {
      currentPage.value++;
      await loadAstrologers();
    }
  }

  void setFilter(String filter) {
    if (selectedFilter.value != filter) {
      selectedFilter.value = filter;
      loadAstrologers(refresh: true);
    }
  }

  // Helper method to format price (returns all three prices)
  String getPrice(AstrologerModel astrologer) {
    List<String> prices = [];
    
    if (astrologer.chatPricePerMin != null && astrologer.chatPricePerMin! > 0) {
      prices.add('Chat: ₹${astrologer.chatPricePerMin!.toStringAsFixed(0)}/min');
    }
    if (astrologer.voicePricePerMin != null && astrologer.voicePricePerMin! > 0) {
      prices.add('Call: ₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min');
    }
    if (astrologer.videoPricePerMin != null && astrologer.videoPricePerMin! > 0) {
      prices.add('Video: ₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min');
    }
    
    if (prices.isEmpty) {
      return 'N/A';
    }
    return prices.join(' • ');
  }
  
  // Helper method to get individual prices for detailed display
  Map<String, String?> getDetailedPrices(AstrologerModel astrologer) {
    return {
      'chat': astrologer.chatPricePerMin != null && astrologer.chatPricePerMin! > 0
          ? '₹${astrologer.chatPricePerMin!.toStringAsFixed(0)}/min'
          : null,
      'voice': astrologer.voicePricePerMin != null && astrologer.voicePricePerMin! > 0
          ? '₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min'
          : null,
      'video': astrologer.videoPricePerMin != null && astrologer.videoPricePerMin! > 0
          ? '₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min'
          : null,
    };
  }

  // Helper method to format specializations
  String getSpecializations(AstrologerModel astrologer) {
    if (astrologer.specializations.isEmpty) {
      return 'Astrology';
    }
    return astrologer.specializations.join(', ');
  }

  // Helper method to format languages
  String getLanguages(AstrologerModel astrologer) {
    if (astrologer.languages.isEmpty) {
      return 'Hindi';
    }
    return astrologer.languages.join(', ');
  }

  @override
  void onClose() {
    super.onClose();
  }
}

