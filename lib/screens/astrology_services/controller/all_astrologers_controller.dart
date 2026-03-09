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
  String? initialAvailability;

  // Full API filters (from Consult "View all" or Get.arguments map)
  final RxnString languageFilter = RxnString();
  final RxDouble minRatingFilter = 0.0.obs;
  final RxDouble maxPriceFilter = 0.0.obs;
  final RxInt experienceFilter = 0.obs;
  final RxString sortByFilter = 'rating'.obs;
  final RxString searchFilter = ''.obs;

  AllAstrologersController({this.initialFilter, this.initialAvailability});

  final RxnString selectedAvailability = RxnString();

  @override
  void onInit() {
    super.onInit();

    // Check constructor params
    if (initialFilter != null) {
      selectedFilter.value = initialFilter!;
    }
    if (initialAvailability != null) {
      selectedAvailability.value = initialAvailability;
    }

    // Check Get.arguments (from navigation e.g. Consult "View all")
    if (Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('availability')) {
        selectedAvailability.value = args['availability'] as String?;
      }
      if (args.containsKey('filter')) {
        selectedFilter.value = args['filter'] as String;
      }
      if (args.containsKey('specialization')) {
        final s = args['specialization']?.toString();
        if (s != null && s.isNotEmpty) _mapSpecializationToFilter(s);
      }
      if (args.containsKey('astrologerCategory')) {
        final c = args['astrologerCategory']?.toString();
        if (c == 'CELEBRITY_ASTROLOGER') selectedFilter.value = 'Celebrity';
        else if (c == 'KID_ASTROLOGER') selectedFilter.value = 'Kids';
      }
      if (args.containsKey('language')) {
        languageFilter.value = args['language']?.toString();
      }
      if (args.containsKey('minRating')) {
        final v = args['minRating'];
        if (v != null) minRatingFilter.value = (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0;
      }
      if (args.containsKey('maxPrice')) {
        final v = args['maxPrice'];
        if (v != null) maxPriceFilter.value = (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0;
      }
      if (args.containsKey('experience')) {
        final v = args['experience'];
        if (v != null) experienceFilter.value = (v is num) ? v.toInt() : int.tryParse(v.toString()) ?? 0;
      }
      if (args.containsKey('sortBy')) {
        sortByFilter.value = args['sortBy']?.toString() ?? 'rating';
      }
      if (args.containsKey('search')) {
        searchFilter.value = args['search']?.toString() ?? '';
      }
    }

    loadAstrologers();
    loadBanners();
  }

  void _mapSpecializationToFilter(String spec) {
    final upper = spec.toUpperCase();
    if (upper == 'TAROT') selectedFilter.value = 'Tarots';
    else if (upper == 'PRASHNA') selectedFilter.value = 'Prashana';
    else if (upper == 'VEDIC') selectedFilter.value = 'Vedic';
    else if (upper == 'VASTU') selectedFilter.value = 'Vastu';
    else selectedFilter.value = spec.length > 1 ? '${spec[0].toUpperCase()}${spec.substring(1).toLowerCase()}' : spec;
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
        availability:
            (selectedAvailability.value == 'CHAT' ||
                selectedAvailability.value == 'VOICE_CALL' ||
                selectedAvailability.value == 'VIDEO_CALL')
            ? 'ONLINE'
            : selectedAvailability.value,
        language: languageFilter.value,
        minRating: minRatingFilter.value > 0 ? minRatingFilter.value : null,
        maxPrice: maxPriceFilter.value > 0 ? maxPriceFilter.value : null,
        experience: experienceFilter.value > 0 ? experienceFilter.value : null,
        sortBy: sortByFilter.value.isNotEmpty ? sortByFilter.value : null,
        search: searchFilter.value.isNotEmpty ? searchFilter.value : null,
        useCache: false,
      );

      if (response != null) {
        List<AstrologerModel> filteredList = response.astrologers;

        // CLIENT-SIDE FILTERING for specific services
        if (selectedAvailability.value == 'CHAT') {
          filteredList = filteredList
              .where((a) => a.services.chat.enabled)
              .toList();
        } else if (selectedAvailability.value == 'VOICE_CALL') {
          filteredList = filteredList
              .where((a) => a.services.voice.enabled)
              .toList();
        } else if (selectedAvailability.value == 'VIDEO_CALL') {
          filteredList = filteredList
              .where((a) => a.services.video.enabled)
              .toList();
        }

        if (refresh) {
          astrologers.value = filteredList;
        } else {
          astrologers.addAll(filteredList);
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
