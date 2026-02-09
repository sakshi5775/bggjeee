import 'dart:async';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/call_initiation_helper.dart';

import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';

class AllAstrologersController extends GetxController {
  final AstrologerService _astrologerService = AstrologerService();
  final BannerService _bannerService = BannerService();

  // Reactive variables
  final RxList<AstrologerModel> astrologers = <AstrologerModel>[].obs;
  final RxList<BannerItem> astrologerBanners = <BannerItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingBanners = false.obs;
  final RxString errorMessage = ''.obs;

  // Follow/unfollow state tracking
  final RxMap<String, bool> followStatus = <String, bool>{}.obs;
  final RxMap<String, bool> followLoading = <String, bool>{}.obs;

  // Filter variables (specialization + category)
  final RxString selectedFilter =
      'All'.obs; // All, Vedic, Tarots, Vastu, Prashana, Celebrity, Kids
  final List<String> filterOptions = [
    'All',
    'Vedic',
    'Tarots',
    'Vastu',
    'Prashana',
    'Celebrity',
    'Kids',
  ];

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
    loadBanners();
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
      // Map filter to specialization or astrologer category
      String? specialization;
      String? astrologerCategory;
      if (selectedFilter.value != 'All') {
        if (selectedFilter.value == 'Celebrity') {
          astrologerCategory = 'CELEBRITY_ASTROLOGER';
        } else if (selectedFilter.value == 'Kids') {
          astrologerCategory = 'KID_ASTROLOGER';
        } else {
          if (selectedFilter.value == 'Tarots') {
            specialization = 'TAROT';
          } else if (selectedFilter.value == 'Prashana') {
            specialization = 'PRASHANA';
          } else {
            specialization = selectedFilter.value.toUpperCase();
          }
        }
      }

      final response = await _astrologerService.getAstrologers(
        page: currentPage.value,
        limit: limit.value,
        specialization: specialization,
        astrologerCategory: astrologerCategory,
      );

      if (response != null) {
        if (refresh) {
          astrologers.value = response.astrologers;
        } else {
          astrologers.addAll(response.astrologers);
        }
        // Initialize follow status for new astrologers
        _initializeFollowStatus();
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

  Future<void> loadBanners() async {
    isLoadingBanners.value = true;
    try {
      var list = await _bannerService.getBannersByCategory('appastrologer');
      if (list.isEmpty) {
        list = await _bannerService.getBannersByCategory('astrologer');
      }
      astrologerBanners.assignAll(list);
    } catch (e) {
      debugPrint('Error loading astrologer banners: $e');
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<void> refresh() async {
    loadBanners(); // Reload banners on refresh too
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
      prices.add(
        'Chat: ₹${astrologer.chatPricePerMin!.toStringAsFixed(0)}/min',
      );
    }
    if (astrologer.voicePricePerMin != null &&
        astrologer.voicePricePerMin! > 0) {
      prices.add(
        'Call: ₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min',
      );
    }
    if (astrologer.videoPricePerMin != null &&
        astrologer.videoPricePerMin! > 0) {
      prices.add(
        'Video: ₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min',
      );
    }

    if (prices.isEmpty) {
      return 'N/A';
    }
    return prices.join(' • ');
  }

  // Helper method to get individual prices for detailed display
  Map<String, String?> getDetailedPrices(AstrologerModel astrologer) {
    return {
      'chat':
          astrologer.chatPricePerMin != null && astrologer.chatPricePerMin! > 0
          ? '₹${astrologer.chatPricePerMin!.toStringAsFixed(0)}/min'
          : null,
      'voice':
          astrologer.voicePricePerMin != null &&
              astrologer.voicePricePerMin! > 0
          ? '₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min'
          : null,
      'video':
          astrologer.videoPricePerMin != null &&
              astrologer.videoPricePerMin! > 0
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

  /// Initiate voice call directly (bypasses booking screen)
  Future<void> initiateVoiceCall(AstrologerModel astrologer) async {
    await CallInitiationHelper.initiateVoiceCall(astrologer);
  }

  /// Initiate video call directly (bypasses booking screen)
  Future<void> initiateVideoCall(AstrologerModel astrologer) async {
    await CallInitiationHelper.initiateVideoCall(astrologer);
  }

  /// Initiate chat directly (bypasses booking screen)
  Future<void> initiateChat(AstrologerModel astrologer) async {
    await CallInitiationHelper.initiateChat(astrologer);
  }

  /// Toggle follow/unfollow for an astrologer
  Future<void> toggleFollow(AstrologerModel astrologer) async {
    final astrologerId = astrologer.astrologerId;

    // Prevent multiple simultaneous requests
    if (followLoading[astrologerId] == true) return;

    final currentState = followStatus[astrologerId] ?? false;

    try {
      followLoading[astrologerId] = true;

      final result = currentState
          ? await _astrologerService.unfollowAstrologer(astrologerId)
          : await _astrologerService.followAstrologer(
              astrologerId,
              source: 'PROFILE',
            );

      if (result['success'] == true) {
        // Update follow state - use proper reactive update
        final newState = !currentState;
        followStatus[astrologerId] = newState;
        followStatus.refresh(); // Force reactive update

        Get.snackbar(
          'Success',
          currentState
              ? 'Unfollowed ${astrologer.displayName}'
              : 'Following ${astrologer.displayName}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to ${currentState ? 'unfollow' : 'follow'} astrologer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${currentState ? 'unfollow' : 'follow'}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      followLoading[astrologerId] = false;
    }
  }

  /// Initialize follow status for loaded astrologers
  Future<void> _initializeFollowStatus() async {
    for (var astrologer in astrologers) {
      // Fetch actual follow status from API if not already loaded
      if (!followStatus.containsKey(astrologer.astrologerId)) {
        try {
          final status = await _astrologerService.getFollowStatus(
            astrologer.astrologerId,
          );
          if (status != null) {
            followStatus[astrologer.astrologerId] =
                status['isFollowing'] as bool? ?? false;
          } else {
            followStatus[astrologer.astrologerId] = false;
          }
        } catch (e) {
          // Default to false if API call fails
          followStatus[astrologer.astrologerId] = false;
        }
      }
    }
  }
}
