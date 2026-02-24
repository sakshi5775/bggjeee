import 'dart:async';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/live_stream_service.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AstrologyServicesController extends GetxController {
  final AstrologerService _astrologerService = AstrologerService();
  final LiveStreamService _liveStreamService = LiveStreamService();
  final EcommerceService _ecommerceService = EcommerceService();
  final BannerService _bannerService = BannerService();
  // Categories data - matching the image exactly
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Daily Horoscope',
      'icon':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/DailyHoroscope.png',
    },
    {
      'name': 'Kundli Analysis',
      'icon':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/kundali.jpeg',
    },
    {
      'name': 'Compatibility',
      'icon':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/Compatibility.png',
    },
    {
      'name': 'Tarot Reading',
      'icon':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/TarotReading.png',
    },
    {
      'name': 'Numerology',
      'icon':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/num.jpeg',
    },
    {
      'name': 'Remedies',
      'icon':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/Remediess.png',
    },
  ];
  // Reactive variables
  final RxList<AstrologerModel> allAstrologers = <AstrologerModel>[].obs;
  final RxList<BannerItem> serviceBanners = <BannerItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingBanners = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter variables
  final RxString selectedSpecialization = ''.obs;
  final RxString selectedLanguage = ''.obs;
  final RxDouble minRating = 0.0.obs;
  final RxDouble maxPrice = 0.0.obs;
  final RxString selectedAvailability = ''.obs;
  final RxInt minExperience = 0.obs;
  final RxString sortBy =
      'rating'.obs; // rating, experience, price_low, price_high, consultations
  final RxString searchQuery = ''.obs;
  final RxString selectedAstrologerCategory =
      ''.obs; // KID_ASTROLOGER, CELEBRITY_ASTROLOGER, NORMAL

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt limit = 20.obs;
  final RxBool hasMoreData = false.obs;

  // Search controller
  final TextEditingController searchController = TextEditingController();
  Timer? searchDebounceTimer;

  // Computed lists
  List<Map<String, dynamic>> get recommendedAstrologers {
    // Get top rated astrologers (sorted by rating, limit to 3)
    final sorted = List<AstrologerModel>.from(allAstrologers)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(3).map((a) => _astrologerToMap(a)).toList();
  }

  // Live streams
  final RxList<LiveStreamModel> liveStreams = <LiveStreamModel>[].obs;
  final RxBool isLoadingLiveStreams = false.obs;

  // Ecommerce Categories for Remedies
  final RxList<CategoryModel> remedyCategories = <CategoryModel>[].obs;
  final RxBool isLoadingRemedyCategories = false.obs;

  List<Map<String, dynamic>> get liveAstrologers {
    // Convert live streams to astrologer format for compatibility
    return liveStreams.map((stream) {
      // Try to find matching astrologer in allAstrologers list
      AstrologerModel? matchingAstrologer;
      try {
        matchingAstrologer = allAstrologers.firstWhere(
          (a) =>
              a.astrologerId == stream.astrologerId ||
              a.id == stream.astrologerId,
        );
      } catch (e) {
        // No matching astrologer found
        matchingAstrologer = null;
      }

      // Get specialization from matching astrologer or use default
      final specialization =
          matchingAstrologer != null &&
              matchingAstrologer.specializations.isNotEmpty
          ? matchingAstrologer.specializations.first
          : (stream.astrologerSpecializations != null &&
                    stream.astrologerSpecializations!.isNotEmpty
                ? stream.astrologerSpecializations!.first
                : 'Astrology');

      // Get rating from matching astrologer or use default
      final rating = matchingAstrologer != null
          ? matchingAstrologer.rating.toStringAsFixed(1)
          : '0.0';

      // Get all prices from matching astrologer
      String priceText = 'N/A';
      if (matchingAstrologer != null) {
        List<String> prices = [];
        if (matchingAstrologer.chatPricePerMin != null &&
            matchingAstrologer.chatPricePerMin! > 0) {
          prices.add(
            'Chat: ₹${matchingAstrologer.chatPricePerMin!.toStringAsFixed(0)}/min',
          );
        }
        if (matchingAstrologer.voicePricePerMin != null &&
            matchingAstrologer.voicePricePerMin! > 0) {
          prices.add(
            'Call: ₹${matchingAstrologer.voicePricePerMin!.toStringAsFixed(0)}/min',
          );
        }
        if (matchingAstrologer.videoPricePerMin != null &&
            matchingAstrologer.videoPricePerMin! > 0) {
          prices.add(
            'Video: ₹${matchingAstrologer.videoPricePerMin!.toStringAsFixed(0)}/min',
          );
        }
        if (prices.isNotEmpty) {
          priceText = prices.join(' • ');
        }
      }

      // Get profile picture from matching astrologer or use default
      final image =
          stream.astrologerPhoto ??
          matchingAstrologer?.profilePicture ??
          'assets/app/astrology.png';

      // Get name from matching astrologer or fall back to stream name
      final name = matchingAstrologer != null
          ? (matchingAstrologer.displayName.isNotEmpty
                ? matchingAstrologer.displayName
                : matchingAstrologer.name)
          : (stream.astrologerName != 'Unknown'
                ? stream.astrologerName
                : 'Astrologer');

      return {
        'streamId': stream.streamId,
        'astrologerId': stream.astrologerId,
        'name': name,
        'title': stream.title,
        'currentViewers': stream.currentViewers,
        'status': stream.status,
        'isLive': true,
        'image': image,
        'specialization': specialization,
        'rating': rating,
        'price': priceText,
        'astrologer': matchingAstrologer, // Store for navigation if available
      };
    }).toList();
  }

  List<Map<String, dynamic>> get vedicAstrologers {
    // Get astrologers with VEDIC specialization
    return allAstrologers
        .where((a) => a.specializations.contains('VEDIC'))
        .take(3)
        .map((a) => _astrologerToMap(a))
        .toList();
  }

  // Convert AstrologerModel to Map for view compatibility
  Map<String, dynamic> _astrologerToMap(
    AstrologerModel astrologer, {
    bool isLive = false,
  }) {
    // Get first specialization or join them
    final specialization = astrologer.specializations.isNotEmpty
        ? astrologer.specializations.first
        : 'Astrology';

    // Format price - prefer voice price, then video, then chat
    String priceText = 'N/A';
    if (astrologer.voicePricePerMin != null &&
        astrologer.voicePricePerMin! > 0) {
      priceText = '₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min';
    } else if (astrologer.videoPricePerMin != null &&
        astrologer.videoPricePerMin! > 0) {
      priceText = '₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min';
    } else if (astrologer.chatPrice != null && astrologer.chatPrice! > 0) {
      priceText = '₹${astrologer.chatPrice!.toStringAsFixed(0)}/msg';
    }

    return {
      'astrologer': astrologer, // Store original model for navigation
      'name': astrologer.displayName,
      'specialization': specialization,
      'rating': astrologer.rating.toStringAsFixed(1),
      'sessions': _formatNumber(astrologer.totalConsultations),
      'price': priceText,
      'experience': '${astrologer.experienceYears} years',
      'image': astrologer.profilePicture ?? 'assets/app/guru.png',
      'isLive': isLive,
      'isOnline': astrologer.isOnline, // Add online status from API
    };
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  @override
  void onInit() {
    super.onInit();
    loadAstrologers();
    loadLiveStreams();
    loadRemedyCategories();
    loadBanners();
  }

  /// Load remedy categories for Remedies section
  Future<void> loadRemedyCategories() async {
    try {
      isLoadingRemedyCategories.value = true;
      // Load featured categories for remedy section
      final categoryData = await _ecommerceService.getCategories(
        page: 1,
        limit: 20,
        isActive: true,
        isFeatured: true,
      );

      if (categoryData != null &&
          categoryData.items != null &&
          categoryData.items!.isNotEmpty) {
        // Filter to only top-level categories (no parent)
        remedyCategories.value = categoryData.items!
            .where((cat) => cat.parent == null)
            .toList();
      } else {
        // Fallback: try category tree
        final treeResult = await _ecommerceService.getCategoryTree();
        if (treeResult != null && treeResult.isNotEmpty) {
          remedyCategories.value = treeResult
              .where((cat) => cat.isFeatured == true && cat.parent == null)
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error loading remedy categories: $e');
    } finally {
      isLoadingRemedyCategories.value = false;
    }
  }

  Future<void> loadLiveStreams() async {
    isLoadingLiveStreams.value = true;
    try {
      final response = await _liveStreamService.getLiveStreams(limit: 20);
      if (response != null) {
        // Filter to only show LIVE streams
        liveStreams.value = response.streams
            .where((stream) => stream.status == 'LIVE')
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading live streams: $e');
      // Handle error silently or show message
    } finally {
      isLoadingLiveStreams.value = false;
    }
  }

  Future<void> loadBanners() async {
    isLoadingBanners.value = true;
    try {
      var list = await _bannerService.getBannersByCategory('appastrologer');
      if (list.isEmpty) {
        list = await _bannerService.getBannersByCategory('astrologer');
      }
      serviceBanners.assignAll(list);
    } catch (e) {
      debugPrint('Error loading service banners: $e');
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<void> loadAstrologers({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      allAstrologers.clear();
    }

    // Don't load if already loading
    if (isLoading.value && !refresh) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Build query parameters - only include non-empty values
      final response = await _astrologerService.getAstrologers(
        page: currentPage.value,
        limit: limit.value,
        specialization: selectedSpecialization.value.trim().isEmpty
            ? null
            : selectedSpecialization.value.trim(),
        language: selectedLanguage.value.trim().isEmpty
            ? null
            : selectedLanguage.value.trim(),
        minRating: minRating.value > 0 ? minRating.value : null,
        maxPrice: maxPrice.value > 0 ? maxPrice.value : null,
        availability: selectedAvailability.value.trim().isEmpty
            ? null
            : selectedAvailability.value.trim(),
        experience: minExperience.value > 0 ? minExperience.value : null,
        sortBy: sortBy.value.trim().isEmpty ? 'rating' : sortBy.value.trim(),
        search: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
        astrologerCategory: selectedAstrologerCategory.value.trim().isEmpty
            ? null
            : selectedAstrologerCategory.value.trim(),
      );

      if (response != null) {
        if (refresh) {
          allAstrologers.value = response.astrologers;
        } else {
          allAstrologers.addAll(response.astrologers);
        }
        hasMoreData.value = response.pagination.hasNextPage;
        currentPage.value = response.pagination.currentPage;
        errorMessage.value = ''; // Clear any previous errors
      } else {
        errorMessage.value = 'Failed to load astrologers. Please try again.';
      }
    } catch (e) {
      debugPrint('Error loading astrologers: $e');
      errorMessage.value = 'Error loading astrologers: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh handler for the Astrology & Guidance screen
  Future<void> refresh() async {
    searchDebounceTimer?.cancel();
    await Future.wait([loadAstrologers(refresh: true), loadLiveStreams()]);
  }

  Future<void> loadMore() async {
    if (!isLoading.value && hasMoreData.value) {
      currentPage.value++;
      await loadAstrologers();
    }
  }

  // Filter methods - with debouncing to prevent too many API calls
  Timer? _filterDebounceTimer;

  void _applyFilters() {
    _filterDebounceTimer?.cancel();
    _filterDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      loadAstrologers(refresh: true);
    });
  }

  /// Apply filters immediately (used when Apply button is pressed)
  void applyFiltersNow() {
    _filterDebounceTimer?.cancel();
    loadAstrologers(refresh: true);
  }

  void setSpecialization(String? specialization) {
    selectedSpecialization.value = specialization ?? '';
    _applyFilters();
  }

  void setLanguage(String? language) {
    selectedLanguage.value = language ?? '';
    _applyFilters();
  }

  void setMinRating(double rating) {
    minRating.value = rating;
    _applyFilters();
  }

  void setMaxPrice(double price) {
    maxPrice.value = price;
    _applyFilters();
  }

  void setAvailability(String? availability) {
    selectedAvailability.value = availability ?? '';
    _applyFilters();
  }

  void setMinExperience(int experience) {
    minExperience.value = experience;
    _applyFilters();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    // Cancel any pending debounce timer
    searchDebounceTimer?.cancel();
    searchQuery.value = query;
    // Sync controller text if different
    if (searchController.text != query) {
      searchController.text = query;
    }
    loadAstrologers(refresh: true);
  }

  void setAstrologerCategory(String? category) {
    selectedAstrologerCategory.value = category ?? '';
    _applyFilters();
  }

  void clearFilters() {
    selectedSpecialization.value = '';
    selectedLanguage.value = '';
    minRating.value = 0.0;
    maxPrice.value = 0.0;
    selectedAvailability.value = '';
    minExperience.value = 0;
    sortBy.value = 'rating';
    searchQuery.value = '';
    selectedAstrologerCategory.value = '';
    searchController.clear();
    loadAstrologers(refresh: true);
  }

  @override
  void onClose() {
    searchDebounceTimer?.cancel();
    _filterDebounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
