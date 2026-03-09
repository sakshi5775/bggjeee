import 'dart:async';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrology_services_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/remedies_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/screens/live_stream/view/live_stream_view.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import '../../../app_manager/network_image.dart';
import '../../../utils/app_colors.dart';

class AstrologyServicesView extends StatelessWidget {
  final bool showBackButton;

  const AstrologyServicesView({Key? key, this.showBackButton = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologyServicesController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header with Common Header
              const CommonHeader(title: 'Astrology Services'),

              // Custom Search Bar (extracted from old header)
              _buildSearchBar(context, controller),

              // Main Scrollable Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.allAstrologers.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFDFB343),
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty &&
                      controller.allAstrologers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoTranslateText(
                            controller.errorMessage.value,
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: const Color(0xFF5F2221),
                            ),
                          ),
                          Spacing.h(16),
                          ElevatedButton(
                            onPressed: () =>
                                controller.loadAstrologers(refresh: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDFB343),
                            ),
                            child: const AutoTranslateText('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    color: const Color(0xFFDFB343),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacing.h(16),

                          // Explore Categories Section
                          _buildExploreCategoriesSection(context, controller),

                          Spacing.h(16),

                          // Banners
                          Obx(() {
                            if (controller.serviceBanners.isNotEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: BannerCarouselWidget(
                                  banners: controller.serviceBanners,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          Spacing.h(10),

                          // Show filtered results if any filter is active
                          Obx(() {
                            final hasActiveFilters =
                                controller
                                    .selectedSpecialization
                                    .value
                                    .isNotEmpty ||
                                controller.selectedLanguage.value.isNotEmpty ||
                                controller
                                    .selectedAvailability
                                    .value
                                    .isNotEmpty ||
                                controller.searchQuery.value.isNotEmpty ||
                                controller.minRating.value > 0 ||
                                controller.maxPrice.value > 0 ||
                                controller.minExperience.value > 0 ||
                                controller
                                    .selectedAstrologerCategory
                                    .value
                                    .isNotEmpty;

                            if (hasActiveFilters) {
                              return _buildFilteredResultsSection(
                                context,
                                controller,
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          Spacing.h(12),

                          // Recommended for You Section (only show when no filters)
                          Obx(() {
                            final hasActiveFilters =
                                controller
                                    .selectedSpecialization
                                    .value
                                    .isNotEmpty ||
                                controller.selectedLanguage.value.isNotEmpty ||
                                controller
                                    .selectedAvailability
                                    .value
                                    .isNotEmpty ||
                                controller.searchQuery.value.isNotEmpty ||
                                controller.minRating.value > 0 ||
                                controller.maxPrice.value > 0 ||
                                controller.minExperience.value > 0 ||
                                controller
                                    .selectedAstrologerCategory
                                    .value
                                    .isNotEmpty;

                            if (!hasActiveFilters) {
                              return _buildRecommendedSection(
                                context,
                                controller,
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          Spacing.h(24),

                          // Live Now Section
                          _buildLiveNowSection(context, controller),

                          Spacing.h(24),

                          // Vedic Astrologer Section (only show when no filters)
                          Obx(() {
                            final hasActiveFilters =
                                controller
                                    .selectedSpecialization
                                    .value
                                    .isNotEmpty ||
                                controller.selectedLanguage.value.isNotEmpty ||
                                controller
                                    .selectedAvailability
                                    .value
                                    .isNotEmpty ||
                                controller.searchQuery.value.isNotEmpty ||
                                controller.minRating.value > 0 ||
                                controller.maxPrice.value > 0 ||
                                controller.minExperience.value > 0 ||
                                controller
                                    .selectedAstrologerCategory
                                    .value
                                    .isNotEmpty;

                            if (!hasActiveFilters) {
                              return _buildVedicAstrologerSection(
                                context,
                                controller,
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          Spacing.h(24),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF5D1C21), Colors.transparent],
          stops: [0.0, 1.0],
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(
            0xFFFFFFFF,
          ).withValues(alpha: 0.95), // White with slight opacity
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFDFB343), // #DFB343 border
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: const Color(0xFFDFB343), // #DFB343 color
              size: 20.w,
            ),
            Spacing.w(12),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: const Color(0xFF3D0C11),
                ),
                decoration: InputDecoration(
                  hintText: 'Search by Zodiac, Category...',
                  hintStyle: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFF3D0C11).withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  // Update reactive variable immediately for UI feedback
                  controller.searchQuery.value = value;
                  // Debounce search API call - wait 500ms after user stops typing
                  controller.searchDebounceTimer?.cancel();
                  controller.searchDebounceTimer = Timer(
                    const Duration(milliseconds: 500),
                    () {
                      if (controller.searchController.text == value) {
                        controller.loadAstrologers(refresh: true);
                      }
                    },
                  );
                },
              ),
            ),
            Obx(
              () => controller.searchQuery.value.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.searchDebounceTimer?.cancel();
                        controller.searchController.clear();
                        controller.searchQuery.value = '';
                        controller.loadAstrologers(refresh: true);
                      },
                      child: Icon(
                        Icons.clear,
                        color: const Color(0xFFDFB343),
                        size: 18.w,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Spacing.w(8),
            // Filter Icon
            GestureDetector(
              onTap: () => _showFilterBottomSheet(context, controller),
              child: Icon(
                Icons.tune,
                color: const Color(0xFFDFB343),
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreCategoriesSection(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFF3D0C11), const Color(0xFF5D1C21)],
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Explore Categories',
                style: MyTextTheme.largeBCB.copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Spacing.h(16),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _buildCategoryCard(category, context, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> category,
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _navigateToCategory(category['name'] as String, context, controller);
      },
      child: Container(
        width: 80.w,
        // margin: EdgeInsets.only(right: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCategoryIcon(category['icon'] as String),
            Spacing.h(6),
            Flexible(
              child: AutoTranslateText(
                category['name'] as String,
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF5F2221),
                  fontSize: 11.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String iconUrl) {
    // Check if it's a network URL or asset path
    if (iconUrl.startsWith('http://') || iconUrl.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: CachedNetworkImage(
          imageUrl: iconUrl,
          height: 60.h,
          width: 60.w,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            height: 60.h,
            width: 60.w,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.deepOrange,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 60.h,
            width: 60.w,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(
              Icons.image_not_supported,
              size: 30.w,
              color: Colors.grey,
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Image.asset(
          iconUrl,
          height: 60.h,
          width: 60.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 60.h,
            width: 60.w,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(
              Icons.image_not_supported,
              size: 30.w,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
  }

  void _navigateToCategory(
    String categoryName,
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    switch (categoryName.toLowerCase()) {
      case 'daily horoscope':
        UserMainController.pushInCurrentTab(AppRoutes.horoscopeForm);
        break;
      case 'kundli analysis':
        UserMainController.pushInCurrentTab(AppRoutes.kundliForm);
        break;
      case 'compatibility':
        UserMainController.pushInCurrentTab(AppRoutes.matchMakingGif);
        break;
      case 'tarot reading':
        UserMainController.pushInCurrentTab(AppRoutes.tarotReading);
        break;
      case 'numerology':
        UserMainController.pushInCurrentTab(AppRoutes.numerologyForm);
        break;
      case 'remedies':
        // Show remedies bottom sheet with ecommerce categories
        _showRemediesBottomSheet(context, controller);
        break;
      default:
        // Default: stay on the same page or show all astrologers
        break;
    }
  }

  Widget _buildFilteredResultsSection(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return Obx(() {
      if (controller.isLoading.value && controller.allAstrologers.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(color: Color(0xFFDFB343)),
          ),
        );
      }

      if (controller.allAstrologers.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64.w,
                  color: const Color(0xFF999999),
                ),
                Spacing.h(16),
                AutoTranslateText(
                  'No astrologers found',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFF5F2221),
                  ),
                ),
                Spacing.h(8),
                AutoTranslateText(
                  'Try adjusting your filters',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF3D0C11),
                            const Color(0xFF5D1C21),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Search Results (${controller.allAstrologers.length})',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: const Color(0xFF5F2221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () =>
                      UserMainController.pushInCurrentTab('/all-astrologers'),
                  child: AutoTranslateText(
                    'View All →',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(16),
          SizedBox(
            height: 130.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.allAstrologers.length,
              itemBuilder: (context, index) {
                final astrologerModel = controller.allAstrologers[index];
                final sessions = astrologerModel.totalConsultations >= 1000
                    ? '${(astrologerModel.totalConsultations / 1000).toStringAsFixed(1)}k'
                    : astrologerModel.totalConsultations.toString();
                final astrologer = {
                  'astrologer': astrologerModel,
                  'name': astrologerModel.displayName,
                  'specialization': astrologerModel.specializations.isNotEmpty
                      ? astrologerModel.specializations.first
                      : 'Astrology',
                  'rating': astrologerModel.rating.toStringAsFixed(1),
                  'sessions': sessions,
                  'price': _getPriceText(astrologerModel),
                  'experience': '${astrologerModel.experienceYears} years',
                  'image':
                      astrologerModel.profilePicture ?? 'assets/app/guru.png',
                  'isLive': false,
                  'isOnline': astrologerModel.isOnline,
                };
                return _buildAstrologerCard(astrologer, isLive: false);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRecommendedSection(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF3D0C11),
                            const Color(0xFF5D1C21),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Recommended for You',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: const Color(0xFF5F2221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => UserMainController.pushInCurrentTab(
                    '/all-astrologers',
                    arguments: null,
                  ),
                  child: AutoTranslateText(
                    'View All →',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(16),
          SizedBox(
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.recommendedAstrologers.length,
              itemBuilder: (context, index) {
                final astrologer = controller.recommendedAstrologers[index];
                return _buildAstrologerCard(astrologer, isLive: false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveNowSection(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return Obx(() {
      // Hide section if loading and no data, or if no live streams
      if (controller.isLoadingLiveStreams.value &&
          controller.liveStreams.isEmpty) {
        return const SizedBox.shrink();
      }

      if (controller.liveAstrologers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF3D0C11),
                            const Color(0xFF5D1C21),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Spacing.w(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50), // Green
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Spacing.w(4),
                          AutoTranslateText(
                            'LIVE',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Live Now',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: const Color(0xFF5F2221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => UserMainController.pushInCurrentTab(
                    AppRoutes.liveAstrologers,
                  ),
                  child: AutoTranslateText(
                    'View All →',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(16),
          SizedBox(
            height: 270
                .h, // Extra room for live cards to avoid overflow on small screens
            child: controller.isLoadingLiveStreams.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF5F2221),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: controller.liveAstrologers.length,
                    itemBuilder: (context, index) {
                      final astrologer = controller.liveAstrologers[index];
                      return _buildAstrologerCard(astrologer, isLive: true);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildVedicAstrologerSection(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF3D0C11),
                            const Color(0xFF5D1C21),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Vedic Astrologer',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: const Color(0xFF5F2221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => UserMainController.pushInCurrentTab(
                    '/all-astrologers',
                    arguments: 'Vedic',
                  ),
                  child: AutoTranslateText(
                    'View All →',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(16),
          SizedBox(
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.vedicAstrologers.length,
              itemBuilder: (context, index) {
                final astrologer = controller.vedicAstrologers[index];
                return _buildAstrologerCard(astrologer, isLive: false);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Card for Recommended and Vedic sections (First image style)
  Widget _buildAstrologerCard(
    Map<String, dynamic> astrologer, {
    required bool isLive,
  }) {
    if (isLive) {
      // Live Now card style (Second image)
      return _buildLiveCard(astrologer);
    } else {
      // Recommended/Vedic card style (First image)
      return _buildRecommendedCard(astrologer);
    }
  }

  // Recommended/Vedic card - Profile on left, info on right
  Widget _buildRecommendedCard(Map<String, dynamic> astrologer) {
    final isOnline = astrologer['isOnline'] as bool? ?? false;
    final astrologerModel = astrologer['astrologer'] as AstrologerModel?;

    return GestureDetector(
      onTap: () {
        if (astrologerModel != null) {
          UserMainController.pushInCurrentTab(
            '/astrologer-detail',
            arguments: astrologerModel,
          );
        }
      },
      child: Container(
        width: 250.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.deepOrange, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture on Left
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDFB343), // Gold border
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildImage(
                      astrologer['image'] as String?,
                      size: 65,
                    ),
                  ),
                ),
                // Green dot only when online
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50), // Green
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            Spacing.w(10),
            // Info on Right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Name
                  AutoTranslateText(
                    astrologer['name'] as String,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF5F2221),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(4),
                  // Specialization
                  AutoTranslateText(
                    astrologer['specialization'] as String,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF666666),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(4),
                  // Rating and Sessions Row
                  Row(
                    children: [
                      // Rating Badge
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDFB343).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: const Color(0xFFDFB343),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: const Color(0xFFDFB343),
                                size: 11.w,
                              ),
                              Spacing.w(2),
                              Flexible(
                                child: AutoTranslateText(
                                  astrologer['rating'] as String,
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: const Color(0xFF5F2221),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacing.w(4),
                      // Sessions
                      Flexible(
                        child: AutoTranslateText(
                          '${astrologer['sessions']} sessions',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF999999),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(4),
                  // Price and Experience Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Flexible(
                        child: AutoTranslateText(
                          astrologer['price'] as String,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFFDFB343),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacing.w(6),
                      // Experience
                      Flexible(
                        child: AutoTranslateText(
                          astrologer['experience'] as String,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF999999),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Live Now card - Centered profile with LIVE badge (Second image style)
  Widget _buildLiveCard(Map<String, dynamic> astrologer) {
    final streamId = astrologer['streamId'] as String?;
    final astrologerName = astrologer['name'] as String?;
    final image = astrologer['image'] as String?;

    return GestureDetector(
      onTap: () async {
        if (streamId != null) {
          // Get the stream from controller
          final controller = Get.find<AstrologyServicesController>();
          // Check if user is logged in before accessing live stream
          final isLoggedIn = await LoginGuard.ensureLoggedIn(
            message: 'Please login to watch live streams.',
            onLoginSuccess: () async {
              // Navigate to live stream after successful login
              LiveStreamModel? stream;
              try {
                stream = controller.liveStreams.firstWhere(
                  (s) => s.streamId == streamId,
                );
              } catch (e) {
                // Stream not found
              }
              if (stream != null) {
                Get.to(
                  () => LiveStreamView(
                    stream: stream!,
                    astrologerName: astrologerName,
                    astrologerProfilePicture: image,
                  ),
                );
              }
            },
          );

          if (isLoggedIn) {
            LiveStreamModel? stream;
            try {
              stream = controller.liveStreams.firstWhere(
                (s) => s.streamId == streamId,
              );
            } catch (e) {
              // Stream not found
            }
            if (stream != null) {
              Get.to(
                () => LiveStreamView(
                  stream: stream!,
                  astrologerName: astrologerName,
                  astrologerProfilePicture: image,
                ),
              );
            }
          }
        }
      },
      child: Container(
        width: 180.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0), // Light cream background
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFDFB343), // Gold border
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with LIVE Badge
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 82.w,
                  height: 82.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDFB343), // Gold border
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildImage(
                      astrologer['image'] as String?,
                      size: 90,
                    ),
                  ),
                ),
                // LIVE Badge
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50), // Green
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 9.w),
                        Spacing.w(2),
                        AutoTranslateText(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            // Name
            AutoTranslateText(
              (astrologer['name'] as String?) ?? 'Astrologer',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5F2221),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Spacing.h(2),
            // Specialization
            AutoTranslateText(
              (astrologer['specialization'] as String?) ?? 'Astrology',
              style: MyTextTheme.smallBCN.copyWith(
                color: const Color(0xFF666666),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Spacing.h(8),
            // Rating Badge and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rating Badge
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFB343).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: const Color(0xFFDFB343),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFDFB343),
                          size: 11.w,
                        ),
                        Spacing.w(2),
                        Flexible(
                          child: AutoTranslateText(
                            (astrologer['rating'] as String?) ?? '0.0',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: const Color(0xFF5F2221),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacing.w(6),
                // Price
                Flexible(
                  child: AutoTranslateText(
                    (astrologer['price'] as String?) ?? 'N/A',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFFDFB343),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 80}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: size.w,
        height: size.h,
        color: Colors.grey.withValues(alpha: 0.3),
        child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
      );
    }

    // Check if it's a network URL or asset path
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImageWithLoader(
        url: imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
      );
    } else {
      // Asset image
      return Image.asset(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }

  void _showFilterBottomSheet(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Filters',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: const Color(0xFF5F2221),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.clearFilters();
                          },
                          child: AutoTranslateText(
                            'Clear All',
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: const Color(0xFFFF6B35),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close,
                            color: const Color(0xFF5F2221),
                            size: 24.w,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Filter Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    // Specialization Filter
                    _buildFilterSection(
                      title: 'Specialization',
                      child: Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children:
                              [
                                'VEDIC',
                                'KP',
                                'NADI',
                                'NUMEROLOGY',
                                'TAROT',
                                'PALMISTRY',
                                'VASTU',
                                'GEMOLOGY',
                                'HORARY',
                                'PRASHNA',
                              ].map((spec) {
                                final isSelected =
                                    controller.selectedSpecialization.value ==
                                    spec;
                                return FilterChip(
                                  label: AutoTranslateText(spec),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.setSpecialization(
                                      selected ? spec : null,
                                    );
                                  },
                                  selectedColor: const Color(
                                    0xFFDFB343,
                                  ).withValues(alpha: 0.3),
                                  checkmarkColor: const Color(0xFF5F2221),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF5F2221)
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Language Filter
                    _buildFilterSection(
                      title: 'Language',
                      child: Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children:
                              [
                                'Hindi',
                                'English',
                                'Punjabi',
                                'Bengali',
                                'Tamil',
                                'Telugu',
                              ].map((lang) {
                                final isSelected =
                                    controller.selectedLanguage.value == lang;
                                return FilterChip(
                                  label: AutoTranslateText(lang),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.setLanguage(
                                      selected ? lang : null,
                                    );
                                  },
                                  selectedColor: const Color(
                                    0xFFDFB343,
                                  ).withValues(alpha: 0.3),
                                  checkmarkColor: const Color(0xFF5F2221),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF5F2221)
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Availability Filter
                    _buildFilterSection(
                      title: 'Availability',
                      child: Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: ['ONLINE', 'OFFLINE', 'BUSY', 'ON_BREAK']
                              .map((avail) {
                                final isSelected =
                                    controller.selectedAvailability.value ==
                                    avail;
                                return FilterChip(
                                  label: AutoTranslateText(
                                    avail.replaceAll('_', ' '),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.setAvailability(
                                      selected ? avail : null,
                                    );
                                  },
                                  selectedColor: const Color(
                                    0xFFDFB343,
                                  ).withValues(alpha: 0.3),
                                  checkmarkColor: const Color(0xFF5F2221),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF5F2221)
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Astrologer Category Filter
                    _buildFilterSection(
                      title: 'Astrologer Category',
                      child: Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children:
                              [
                                'KID_ASTROLOGER',
                                'CELEBRITY_ASTROLOGER',
                                'NORMAL',
                              ].map((category) {
                                final isSelected =
                                    controller
                                        .selectedAstrologerCategory
                                        .value ==
                                    category;
                                return FilterChip(
                                  label: AutoTranslateText(
                                    category.replaceAll('_', ' '),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.setAstrologerCategory(
                                      selected ? category : null,
                                    );
                                  },
                                  selectedColor: const Color(
                                    0xFFDFB343,
                                  ).withValues(alpha: 0.3),
                                  checkmarkColor: const Color(0xFF5F2221),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF5F2221)
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Min Rating Filter
                    _buildFilterSection(
                      title: 'Minimum Rating',
                      child: Obx(
                        () => Slider(
                          value: controller.minRating.value,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          label: controller.minRating.value > 0
                              ? controller.minRating.value.toStringAsFixed(1)
                              : 'Any',
                          onChanged: (value) {
                            controller.setMinRating(value);
                          },
                          activeColor: const Color(0xFFDFB343),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: AutoTranslateText(
                          controller.minRating.value > 0
                              ? 'Rating: ${controller.minRating.value.toStringAsFixed(1)}+'
                              : 'Any rating',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Max Price Filter
                    _buildFilterSection(
                      title: 'Maximum Price (₹/min)',
                      child: Obx(
                        () => Slider(
                          value: controller.maxPrice.value > 0
                              ? controller.maxPrice.value
                              : 500,
                          min: 0,
                          max: 1000,
                          divisions: 20,
                          label: controller.maxPrice.value > 0
                              ? '₹${controller.maxPrice.value.toStringAsFixed(0)}'
                              : 'Any',
                          onChanged: (value) {
                            controller.setMaxPrice(value > 0 ? value : 0);
                          },
                          activeColor: const Color(0xFFDFB343),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: AutoTranslateText(
                          controller.maxPrice.value > 0
                              ? 'Max Price: ₹${controller.maxPrice.value.toStringAsFixed(0)}/min'
                              : 'Any price',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Min Experience Filter
                    _buildFilterSection(
                      title: 'Minimum Experience (Years)',
                      child: Obx(
                        () => Slider(
                          value: controller.minExperience.value > 0
                              ? controller.minExperience.value.toDouble()
                              : 10,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: controller.minExperience.value > 0
                              ? '${controller.minExperience.value} years'
                              : 'Any',
                          onChanged: (value) {
                            controller.setMinExperience(value.toInt());
                          },
                          activeColor: const Color(0xFFDFB343),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: AutoTranslateText(
                          controller.minExperience.value > 0
                              ? 'Experience: ${controller.minExperience.value}+ years'
                              : 'Any experience',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Sort By Filter
                    _buildFilterSection(
                      title: 'Sort By',
                      child: Obx(
                        () => Column(
                          children:
                              [
                                'rating',
                                'experience',
                                'price_low',
                                'price_high',
                                'consultations',
                              ].map((sort) {
                                return RadioListTile<String>(
                                  title: AutoTranslateText(
                                    _getSortLabel(sort),
                                    style: MyTextTheme.mediumBCN.copyWith(
                                      color: const Color(0xFF5F2221),
                                    ),
                                  ),
                                  value: sort,
                                  groupValue: controller.sortBy.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.setSortBy(value);
                                    }
                                  },
                                  activeColor: const Color(0xFFDFB343),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    Spacing.h(24),
                    // Apply Button
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: ElevatedButton(
                        onPressed: () {
                          // Apply filters immediately when button is pressed
                          controller.applyFiltersNow();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDFB343),
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: AutoTranslateText(
                          'Apply Filters',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF5F2221),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        child,
      ],
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'rating':
        return 'Highest Rated First (Default)';
      case 'experience':
        return 'Most Experienced First';
      case 'price_low':
        return 'Lowest Price First';
      case 'price_high':
        return 'Highest Price First';
      case 'consultations':
        return 'Most Consultations First';
      default:
        return sort;
    }
  }

  String _getPriceText(dynamic astrologerModel) {
    if (astrologerModel.voicePricePerMin != null &&
        astrologerModel.voicePricePerMin! > 0) {
      return '₹${astrologerModel.voicePricePerMin!.toStringAsFixed(0)}/min';
    } else if (astrologerModel.videoPricePerMin != null &&
        astrologerModel.videoPricePerMin! > 0) {
      return '₹${astrologerModel.videoPricePerMin!.toStringAsFixed(0)}/min';
    } else if (astrologerModel.chatPrice != null &&
        astrologerModel.chatPrice! > 0) {
      return '₹${astrologerModel.chatPrice!.toStringAsFixed(0)}/msg';
    }
    return 'N/A';
  }

  void _showRemediesBottomSheet(
    BuildContext context,
    AstrologyServicesController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RemediesBottomSheetWidget(controller: controller),
    );
  }
}
