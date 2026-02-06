import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/live_stream/view/live_stream_view.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/AnimatedChakra.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/astrology_tool_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/media_hub_preview_widget.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/orders_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/controller/my_bookings_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/screens/courses/widgets/video_player_widget.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../utils/app_colors.dart';
import '../widgets/astrology_report_widget.dart';
import '../widgets/chat_video_live_astrologer_widget.dart';
import '../widgets/our_services_section.dart';
import '../widgets/book_pooja_carousel_widget.dart';
import '../widgets/courses_section_widget.dart';
import '../widgets/kids_specialist_astrologers_widget.dart';
import '../widgets/celebrity_astrologer_widget.dart';

import '../widgets/what_else_widget.dart';
import '../widgets/year_tab_widget.dart';
import '../widgets/banner_carousel_widget.dart';
import '../widgets/our_services_carousel_widget.dart';
import '../widgets/floating_astrologer_button.dart';
// import '../widgets/reports_tab_widget.dart';
import '../widgets/horoscope_tab_widget.dart';
import '../widgets/daily_astrologers_widget.dart';
// import '../widgets/quote_of_the_day_widget.dart';
import '../widgets/history_section_widget.dart';
import '../../e_mandir/e_mandir_home/view/namaste_home_view.dart';
import '../../e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import '../../courses/views/courses_view.dart';
import '../../courses/controllers/courses_controller.dart';
import 'all_videos_view.dart';
import '../controller/all_videos_controller.dart';
import '../../panchang/view/panchang_view.dart';
import '../../panchang/controller/panchang_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/ecommerce_home_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';
import '../widgets/reports_section_widget.dart';
import '../widgets/digital_services_animated_widget.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';

class UserDashboardView extends BasePage<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: buildDrawer(context),
      body: Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(gradient: AppColors.gradientBackground),
          child: SafeArea(
            top: false,
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: controller.refreshDashboard,
                  color: "#6F221E".toColor(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Safe area padding for the specific top content if strictly needed,
                        // but CommonHeader handles its own SafeArea.
                        // However, since we are inside a ScrollView, CommonHeader's SafeArea
                        // might behave interestingly if scrolled.
                        // But standard behavior is acceptable.
                        _buildHeaderAndSliderWithChakra(context),
                        Obx(() {
                          final i = controller.selectedSliderIndex.value;
                          final tabs = controller.sliderTabs;
                          final noGap =
                              (i == 2 &&
                                  tabs.length > 2 &&
                                  tabs[2] == 'Astrologers') ||
                              (i == 3 &&
                                  tabs.length > 3 &&
                                  tabs[3] == 'AI Astrologers') ||
                              (i == 4 &&
                                  tabs.length > 4 &&
                                  tabs[4] == 'Digital Mart') ||
                              (i == 5 &&
                                  tabs.length > 5 &&
                                  tabs[5] == 'Digital Mandir') ||
                              (i == 6 &&
                                  tabs.length > 6 &&
                                  tabs[6] == 'Digital Learning') ||
                              (i == 7 &&
                                  tabs.length > 7 &&
                                  tabs[7] == 'Video') ||
                              (i == 8 &&
                                  tabs.length > 8 &&
                                  tabs[8] == 'Panchang') ||
                              (i == 9 &&
                                  tabs.length > 9 &&
                                  tabs[9] == 'Horoscope');
                          return Spacing.h(noGap ? 0 : 8);
                        }),
                        _buildSliderBodyWithSwipe(context),
                        Spacing.h(60),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => controller.isHeaderSearchOpen.value
                      ? _buildHeaderSearchOverlay(context)
                      : const SizedBox.shrink(),
                ),
                Positioned(
                  right: 1.w,
                  bottom: 10.h,
                  child: _buildCircularChatButton(),
                ),
                Positioned(
                  left: 20.w,
                  bottom: 10.h,
                  child: const FloatingAstrologerButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAndSliderWithChakra(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Fullchakra as background behind both header and slider
        Positioned(
          right: -20.w,
          //    top: -20.h,
          child: AnimatedChakra(
            child: SvgAssets(
              colorFilter: ColorFilter.mode(
                "6F221E".toColor(),
                BlendMode.srcIn,
              ),
              path: 'assets/app/fullchakra.svg',
              width: 150.w,
              height: 150.h,
            ),
          ),
        ),
        // Header content + slider on top (transparent)
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHeader(
              showHome: false,
              showDrawer: false,
              onSearchTap: controller.openHeaderSearch,
            ),
            _buildSlider(context),
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 44.h,
      padding: EdgeInsets.only(left: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, size: 24.w, color: "#6F221E".toColor()),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(36.w, 36.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          Spacing.w(4),
          // Use CommonTabSlider for the tabs
          Expanded(
            child: Obx(
              () => CommonTabSlider(
                tabs: controller.sliderTabs,
                selectedIndex: controller.selectedSliderIndex.value,
                onTabSelected: (index) {
                  controller.selectedSliderIndex.value = index;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const double _kSwipeVelocityThreshold = 200.0;

  Widget _buildSliderBodyWithSwipe(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        final n = controller.sliderTabs.length;
        if (n == 0) return;
        final v = details.velocity.pixelsPerSecond.dx;
        final cur = controller.selectedSliderIndex.value;
        if (v < -_kSwipeVelocityThreshold) {
          final newIndex = (cur + 1).clamp(0, n - 1);
          debugPrint(
            "SLIDER: Swipe left detected, changing index from $cur to $newIndex",
          );
          controller.selectedSliderIndex.value = newIndex;
        } else if (v > _kSwipeVelocityThreshold) {
          final newIndex = (cur - 1).clamp(0, n - 1);
          debugPrint(
            "SLIDER: Swipe right detected, changing index from $cur to $newIndex",
          );
          controller.selectedSliderIndex.value = newIndex;
        }
      },
      child: _buildSliderBody(context),
    );
  }

  Widget _buildSliderBody(BuildContext context) {
    return Obx(() {
      final index = controller.selectedSliderIndex.value;
      final n = controller.sliderTabs.length;
      final i = n == 0 ? 0 : index.clamp(0, n - 1);

      if (i == 0) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKundliTabs(context),
            Spacing.h(8),
            // Banner removed as per request to fix layout issue and UI requirement
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: _buildBodyWithCurve(context),
                ),
                Positioned(
                  top: 0,
                  left: 20.w,
                  right: 20.w,
                  child: _buildSearchBar(context),
                ),
              ],
            ),
          ],
        );
      }
      if (i == 1) {
        return const YearTabWidget();
      }
      if (i == 2 && controller.sliderTabs[i] == 'Astrologers') {
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const AllAstrologersView(hideHeader: true),
        );
      }
      if (i == 3 && controller.sliderTabs[i] == 'AI Astrologers') {
        // AI Chat (aichat) embedded below slider like other tabs, without header
        if (!Get.isRegistered<AiChatController>()) {
          Get.put(AiChatController(), permanent: false);
        }
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const AiChatView(hideHeader: true, showBackButton: false),
        );
      }
      if (i == 4 && controller.sliderTabs[i] == 'Digital Mart') {
        if (!Get.isRegistered<EcommerceHomeController>()) {
          Get.put(EcommerceHomeController(), permanent: false);
        }
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const EcommerceHomeView(hideHeader: true),
        );
      }
      if (i == 5 && controller.sliderTabs[i] == 'Digital Mandir') {
        if (!Get.isRegistered<NamasteHomeController>()) {
          Get.put(NamasteHomeController(), permanent: false);
        }
        final h = MediaQuery.sizeOf(context).height;
        return Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: SizedBox(
            height: (h - 252).clamp(388.0, h * 0.85),
            child: const NamasteHomeView(hideHeader: true),
          ),
        );
      }
      if (i == 6 && controller.sliderTabs[i] == 'Digital Learning') {
        if (!Get.isRegistered<CoursesController>()) {
          Get.put(CoursesController(), permanent: false);
        }
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const CoursesView(hideHeader: true),
        );
      }
      if (i == 7 && controller.sliderTabs[i] == 'Video') {
        if (!Get.isRegistered<AllVideosController>()) {
          Get.put(AllVideosController(), permanent: false);
        }
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const AllVideosView(hideHeader: true),
        );
      }
      if (i == 8 && controller.sliderTabs[i] == 'Panchang') {
        if (!Get.isRegistered<PanchangController>()) {
          Get.put(PanchangController(), permanent: false);
        }
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const PanchangView(hideHeader: true),
        );
      }
      if (i == 9 && controller.sliderTabs[i] == 'Horoscope') {
        final h = MediaQuery.sizeOf(context).height;
        return SizedBox(
          height: (h - 240).clamp(400.0, h * 0.85),
          child: const HoroscopeTabWidget(),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
        child: Center(
          child: AutoTranslateText(
            'Coming Soon',
            style: AppTypography.h2.copyWith(color: "#6F221E".toColor()),
          ),
        ),
      );
    });
  }

  static final List<Map<String, dynamic>> _kundliTabs = [
    {
      'label': 'Kundli',
      'route': AppRoutes.kundliForm,
      'icon': AppConstant.serviceGenerateKundali,
    },
    {
      'label': 'kundli Matching',
      'route': AppRoutes.matchMakingForm,
      'icon': AppConstant.serviceMatchMaking,
    },
    {
      'label': 'Horoscope',
      'route': AppRoutes.horoscopeForm,
      'icon': AppConstant.horoscope,
    },
    {
      'label': 'Predictions',
      'route': AppRoutes.predictions,
      'icon': AppConstant.lifePredictions,
    },
    {'label': 'Dasha', 'route': AppRoutes.dasha, 'icon': AppConstant.dasha},
    {'label': 'Dosh', 'route': AppRoutes.dosh, 'icon': AppConstant.dosh},
    {
      'label': 'Lal Kitab',
      'route': AppRoutes.lalKitab,
      'icon': AppConstant.lalKitab,
    },
    {
      'label': 'KP Astrology',
      'route': AppRoutes.kpSystem,
      'icon': AppConstant.kpN,
    },
    {
      'label': 'Numerology',
      'route': AppRoutes.numerologyForm,
      'icon': AppConstant.serviceNumerology,
    },
    {
      'label': 'Panchang',
      'route': AppRoutes.panchang,
      'icon': AppConstant.servicePanchang,
    },
  ];

  static bool _isNetworkUrl(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  Widget _buildKundliTabs(BuildContext context) {
    const maroon = Color(0xFF6F221E);
    final double iconSize = 52.w;

    return SizedBox(
      height: 92.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _kundliTabs.length,
        separatorBuilder: (_, __) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final tab = _kundliTabs[index];
          final label = tab['label'] as String;
          final route = tab['route'] as String;
          final iconPath = tab['icon'] as String;
          return GestureDetector(
            onTap: () => Get.toNamed(route),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 78.w,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: "#DBCCA8".toColor().withOpacity(0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: "#6F221E".toColor().withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: iconPath.endsWith('.svg')
                        ? SvgAssets(
                            path: iconPath,
                            width: iconSize,
                            height: iconSize,
                          )
                        : _isNetworkUrl(iconPath)
                        ? Image.network(
                            iconPath,
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.star_outline,
                              size: 40.w,
                              color: maroon,
                            ),
                          )
                        : Image.asset(
                            iconPath,
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.star_outline,
                              size: 40.w,
                              color: maroon,
                            ),
                          ),
                  ),
                  SizedBox(height: 4.h),
                  AutoTranslateText(
                    label,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: maroon,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdsSection(BuildContext context) {
    return Obx(() {
      final banners = controller.adsBanners;
      if (controller.isLoadingBanners.value && banners.isEmpty) {
        return SizedBox(
          height: 110.h,
          child: Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                color: "#6F221E".toColor(),
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }
      if (banners.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        children: [
          BannerCarouselWidget(
            key: ValueKey(banners.length),
            banners: banners.toList(),
          ),
          Spacing.h(5),
        ],
      );
    });
  }

  Widget _buildSearchBar(BuildContext context) {
    return Obx(() {
      final controller = Get.find<UserDashboardController>();
      final hasQuery = controller.searchQuery.value.isNotEmpty;

      return Container(
        padding: AppPaddings.symmetric(h: 20, v: 6),
        decoration: BoxDecoration(
          color: "#FFFFFF".toColor(),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: controller.isListening.value
                ? "#F38B3B".toColor()
                : "#FFFFFF".toColor().withOpacity(0.2),
            width: controller.isListening.value ? 2.0 : 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SvgAssets(
                path: 'assets/app/search.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  "#3D0C11".toColor(),
                  BlendMode.srcIn,
                ),
              ),
            ),
            Spacing.w(10),
            Expanded(
              child: controller.isListening.value && hasQuery
                  ? AutoTranslateText(
                      controller.searchQuery.value,
                      style: AppTypography.body1.copyWith(
                        color: "#3D0C11".toColor(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Obx(() {
                      final showAnimatedText =
                          controller.searchController.text.isEmpty &&
                          !controller.isListening.value &&
                          controller.animatedSearchText.value.isNotEmpty;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Actual TextField (always present for input)
                          TextField(
                            controller: controller.searchController,
                            style: MyTextTheme.mediumBCN
                                .copyWith(
                                  color: "#3D0C11".toColor(),
                                  fontWeight: FontWeight.w500,
                                )
                                .merge(AppTypography.body1),
                            decoration: InputDecoration(
                              hintText: controller.isListening.value
                                  ? 'Listening...'
                                  : showAnimatedText
                                  ? controller.animatedSearchText.value
                                  : (controller
                                            .translatedSearchHint
                                            .value
                                            .isNotEmpty
                                        ? controller.translatedSearchHint.value
                                        : 'Search horoscope, kundli, tarot...'),
                              hintStyle: MyTextTheme.mediumBCN
                                  .copyWith(
                                    color: "#3D0C11".toColor().withOpacity(0.5),

                                    fontWeight: FontWeight.w500,
                                  )
                                  .merge(AppTypography.body1),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            enabled: !controller.isListening.value,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                controller.stopTypewriterAnimation();
                              } else {
                                controller.resumeTypewriterAnimation();
                              }
                            },
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                controller.processTextSearch(value);
                              }
                            },
                            onTap: () {
                              controller.stopTypewriterAnimation();
                            },
                          ),
                        ],
                      );
                    }),
            ),
            Spacing.w(8),
            Row(
              children: [
                Container(height: 20.h, width: 1.w, color: "#3D0C11".toColor()),
                GestureDetector(
                  onTap: () => controller.toggleVoiceSearch(),
                  child: Obx(
                    () => Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: controller.isListening.value
                            ? "#F38B3B".toColor().withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: SvgAssets(
                        path: 'assets/app/mic.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          controller.isListening.value
                              ? "#F38B3B".toColor()
                              : "#3D0C11".toColor(),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderSearchOverlay(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: controller.closeHeaderSearch,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black54),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: AppPaddings.symmetric(h: 16, v: 10),
                  decoration: BoxDecoration(
                    color: "#FFFFFF".toColor(),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(color: "#DBCCA8".toColor(), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: controller.closeHeaderSearch,
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20.w,
                          color: "#6F221E".toColor(),
                        ),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(36.w, 36.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: TextField(
                          controller: controller.headerSearchController,
                          focusNode: controller.headerSearchFocusNode,
                          autofocus: true,
                          style: MyTextTheme.mediumBCN
                              .copyWith(
                                color: "#3D0C11".toColor(),
                                fontWeight: FontWeight.w500,
                              )
                              .merge(AppTypography.body1),
                          decoration: InputDecoration(
                            hintText:
                                'Search horoscope, kundli, tarot, palm reading...',
                            hintStyle: MyTextTheme.mediumBCN
                                .copyWith(
                                  color: "#3D0C11".toColor().withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                )
                                .merge(AppTypography.body1),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              controller.processTextSearch(
                                value,
                                fromHeaderSearch: true,
                              );
                            }
                          },
                        ),
                      ),
                      Spacing.w(8),
                      IconButton(
                        onPressed: () {
                          final q = controller.headerSearchController.text
                              .trim();
                          if (q.isNotEmpty) {
                            controller.processTextSearch(
                              q,
                              fromHeaderSearch: true,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          size: 22.w,
                          color: "#6F221E".toColor(),
                        ),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(36.w, 36.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyWithCurve(context) {
    return Container(
      decoration: BoxDecoration(
        color: "#fff8e7".toColor(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(61.r),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        border: Border(top: BorderSide(color: "#DBCCA8".toColor(), width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(40),
          AstrologyToolWidget(),
          Spacing.h(10),
          _buildAdsSection(context),
          Spacing.h(10),
          //   OurServicesSection(),
          // Live Astrologers Section
          Obx(() {
            final hasLiveStreams = controller.liveStreams.isNotEmpty;

            // Pick a random, non-mutating subset from allAstrologer for offline display
            final randomAstrologers = () {
              final copy = List<AstrologerModel>.from(controller.allAstrologer);
              copy.shuffle();
              return copy.take(5).toList();
            }();

            final showSection = hasLiveStreams || randomAstrologers.isNotEmpty;
            if (!showSection) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(left: 16.w, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return AppColors.orangeGradient.createShader(
                                    Rect.fromLTWH(
                                      0,
                                      0,
                                      bounds.width,
                                      bounds.height,
                                    ),
                                  );
                                },
                                child: AutoTranslateText(
                                  'Astro Live Streaming Hub',
                                  style: AppTypography.h2.copyWith(
                                    color: '#820B17'.toColor(),
                                    letterSpacing: -0.05,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Spacing.w(8),
                            if (hasLiveStreams)
                              FadeTransition(
                                opacity: controller.liveVideoIconOpacity,
                                child: ScaleTransition(
                                  scale: controller.liveVideoIconScale,
                                  child: SvgAssets(
                                    path: 'assets/icons/video_icon_live.svg',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.liveAstrologers);
                          },
                          child: AutoTranslateText(
                            'View All',
                            style: AppTypography.body1.copyWith(
                              color: "#9D4807".toColor(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // if (!hasLiveStreams) ...[
                  //   Spacing.h(8),
                  //   Container(
                  //     padding: AppPaddings.symmetric(h: 12.w, v: 8.h),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red.withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(8.r),
                  //       border: Border.all(color: Colors.red.withOpacity(0.3)),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.info_outline, color: Colors.red, size: 18.w),
                  //         Spacing.w(8),
                  //         Expanded(
                  //           child: AutoTranslateText(
                  //             'No astrologer is live',
                  //             style: AppTypography.body2.copyWith(
                  //               color: Colors.red.shade700,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                  Spacing.h(2),
                  SizedBox(
                    height: 120.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: hasLiveStreams
                          ? controller.liveStreams.length
                          : randomAstrologers.length,
                      separatorBuilder: (context, index) => Spacing.w(8),
                      itemBuilder: (context, index) {
                        if (hasLiveStreams) {
                          return _buildLiveAstrologerProfile(
                            index,
                            controller.liveStreams[index],
                          );
                        } else {
                          return _buildOfflineAstrologerProfile(
                            index,
                            randomAstrologers[index],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }),

          // Chat/Call Section (same data as All Astrologers, reversed order)
          const ChatCallAstrologerWidget(),
          Spacing.h(2),

          // All Astrologers Section
          AllAstrologerWidget(),
          Spacing.h(2),

          // AI Astrologers Section
          _buildAIAstrologersSection(context),
          Spacing.h(2),

          // History Section
          const HistorySectionWidget(),
          Spacing.h(4),

          // Reports Section
          // const ReportsSectionWidget(),

          // Spacing.h(2),
          // AstrologyReportWidget(),
          Spacing.h(2),

          // Astro Remedy Section
          _buildAstroRemedySection(),
          Spacing.h(2),
          // Book Pooja Section
          const BookPoojaCarouselWidget(),
          Spacing.h(2),
          // Courses Section
          CoursesSectionWidget(),
          Spacing.h(2),
          _buildBlogSection(),

          Spacing.h(2),
          _buildVedicKundliAstrologersSection(),
          Spacing.h(4),

          // Our Services Carousel
          const OurServicesCarouselWidget(),
          Spacing.h(2),

          // kids specialist astrologers
          const KidsSpecialistAstrologersWidget(),

          // Spacing.h(24),

          // // Live Pooja in Temples Section
          // _buildLivePoojaSection(),
          // Spacing.h(24),

          // // Sacred Mandirs of Bharat Section
          // _buildSacredMandirsSection(),
          Spacing.h(2),

          // Celebrity Astrologer Section
          CelebrityAstrologerWidget(),

          Spacing.h(2),

          // Join Live Webinar Section (only if user has enrolled course with live webinar)
          Obx(
            () => controller.hasLiveWebinarForEnrolledCourse.value
                ? _buildJoinLiveWebinarSection()
                : const SizedBox.shrink(),
          ),

          // Spacing.h(24),

          // // Prashna Kundli Astrologers Section
          // _buildPrashnaKundliSection(),
          Spacing.h(2),

          // Blog Section

          // Media Hub Section
          const MediaHubPreviewWidget(),
          Spacing.h(5),
          WhatElseWidget(),

          Spacing.h(60),

          // // Features Section (scrollable with close button)
          // _buildFeaturesSection(),

          // Spacing.h(24),
        ],
      ),
    );
  }

  // Widget _buildOurServicesPillSection() {
  //   return Padding(
  //     padding: AppPaddings.symmetric(h: 16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: _buildPillServiceCard(
  //                 'Mart',
  //                 'assets/app/pill_digital_mart.png',
  //                 onTap: () {
  //                   Get.toNamed(
  //                     AppRoutes.ecommerceHome,
  //                     arguments: {'showBackButton': true},
  //                   );
  //                 },
  //               ),
  //             ),
  //             Spacing.w(10),
  //             Expanded(
  //               child: _buildPillServiceCard(
  //                 'Mandir',
  //                 'assets/app/pill_digital_mandir.png',
  //                 onTap: () {
  //                   Get.toNamed(AppRoutes.namasteHome);
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //         Spacing.h(10),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: _buildPillServiceCard(
  //                 'Consultation',
  //                 'assets/app/pill_consult.png',
  //                 onTap: () {
  //                   Get.toNamed(AppRoutes.astrologyServices);
  //                 },
  //               ),
  //             ),
  //             Spacing.w(10),
  //             Expanded(
  //               child: _buildPillServiceCard(
  //                 'Education',
  //                 'assets/app/pill_digital_education.png',
  //                 onTap: () {
  //                   Get.toNamed(AppRoutes.courses);
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTalkToAIAstrologerCard() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : 388.w;
          final double cardWidth = availableWidth.clamp(0.0, 388.w).toDouble();
          final double scale = (cardWidth / 388.w).clamp(0.78, 1.0);
          final double cardHeight = 205.h;
          final double imageWidth = 135.w * scale;
          final double imageHeight = 150.h * scale;
          final double desiredImageLeft = 228.w * scale;
          final double desiredImageTop = 40.h * scale;
          final double safeImageLeft = math.max(
            0,
            cardWidth - imageWidth - 12.w * scale,
          );
          final double imageLeft = math.min(desiredImageLeft, safeImageLeft);
          final double safeImageTop = math.max(0, cardHeight - imageHeight);
          final double imageTop = math.min(desiredImageTop, safeImageTop);
          final double rightPadding = math.max(
            22.w * scale,
            cardWidth - imageLeft + 12.w * scale,
          );

          return Center(
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF211339), Color(0xFF0C0C2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.all(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Floating glyphs overlay for subtle depth
                  Positioned(
                    left: 90.w * scale,
                    top: 62.h * scale,
                    child: Opacity(
                      opacity: 0.25,
                      child: Icon(
                        Icons.hexagon_outlined,
                        color: const Color(0xFFA38BD7),
                        size: 26.w * scale,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140.w * scale,
                    top: 28.h * scale,
                    child: Opacity(
                      opacity: 0.22,
                      child: Icon(
                        Icons.change_history,
                        color: const Color(0xFF7D60C3),
                        size: 20.w * scale,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40.w * scale,
                    bottom: 36.h * scale,
                    child: Opacity(
                      opacity: 0.18,
                      child: Icon(
                        Icons.all_inclusive,
                        color: const Color(0xFF9A84D8),
                        size: 24.w * scale,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 22.w * scale,
                      right: rightPadding,
                      top: 18.h * scale,
                      bottom: 13.5.h * scale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: cardWidth - rightPadding - 4.w,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w * scale,
                                vertical: 6.h * scale,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x2600BC7D),
                                borderRadius: AppRadius.all(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8.w * scale,
                                    height: 8.w * scale,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00BC7D),
                                    ),
                                  ),
                                  Spacing.w(6 * scale),
                                  AutoTranslateText(
                                    '50+ AI Astrologers LIVE',
                                    style: AppTypography.body2.copyWith(
                                      color: const Color(0xFF5EE9B5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacing.h(12 * scale),
                        AutoTranslateText(
                          'Talk to AI \nAstrologer',
                          style: AppTypography.h1.copyWith(
                            color: Colors.white,
                            height: 1.08,
                          ),
                        ),
                        Spacing.h(12 * scale),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AutoTranslateText(
                                'Instant answers',
                                style: MyTextTheme.mediumBCN
                                    .copyWith(
                                      color: const Color(0xFFD7D0E6),
                                      fontFamily: 'Poppins',
                                    )
                                    .merge(AppTypography.body2),
                              ),
                              Spacing.w(8 * scale),
                              Container(
                                width: 5.w * scale,
                                height: 5.w * scale,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF7D60C3),
                                ),
                              ),
                              Spacing.w(8 * scale),
                              AutoTranslateText(
                                'Accurate predictions',
                                style: MyTextTheme.mediumBCN
                                    .copyWith(
                                      color: const Color(0xFFD7D0E6),
                                      fontFamily: 'Poppins',
                                    )
                                    .merge(AppTypography.body2),
                              ),
                            ],
                          ),
                        ),
                        Spacing.h(11.5 * scale),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/ai-guider');
                          },
                          child: Container(
                            height: 44.h * scale,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w * scale,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD33D), Color(0xFFF7C443)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppRadius.all(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFD33D,
                                  ).withOpacity(0.45),
                                  blurRadius: 22,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 12,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoTranslateText(
                                  'Start Free Chat',
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(
                                        color: "#222222".toColor(),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      )
                                      .merge(AppTypography.body1),
                                ),
                                Spacing.w(10 * scale),
                                Icon(
                                  Icons.arrow_forward,
                                  color: "#222222".toColor(),
                                  size: 18.w * scale,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: imageLeft,
                    top: imageTop,
                    child: Container(
                      padding: EdgeInsets.all(2.w * scale),
                      child: ClipRRect(
                        borderRadius: AppRadius.all(12),
                        child: Image.asset(
                          'assets/app/talktoaiastrologer.png',
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: imageWidth,
                              height: imageHeight,
                              color: Colors.white.withOpacity(0.06),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.white.withOpacity(0.6),
                                size: 28.w,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHoroscopeCard(Map<String, dynamic> card, int index) {
    // Responsive dimensions - all using .w, .h, .r for proper scaling
    final double cardHeight = 155.h; // Reduced card height
    final double guruImageWidth = 160.w; // Responsive width
    final double guruImageHeight = 280.h; // Reduced for better proportion
    // Bottom flush with card: offset = cardHeight - guruHeight (negative -> head overlaps)
    final double guruTopOffset = cardHeight - guruImageHeight;

    return Container(
      key: ValueKey('horoscope_$index'),
      width: double.infinity, // Full width minus parent padding - responsive
      height: cardHeight, // Reduced card height (155.h)
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#FFEDB4".toColor(), // Light cream from reference
            "#FFFFFF".toColor(), // White from reference
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r), // Responsive border radius
        boxShadow: [
          BoxShadow(
            color: "#E75426".toColor().withOpacity(0.2),
            blurRadius: 38.1,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: "#DC3E3E".toColor().withOpacity(0.2),
            blurRadius: 10.9,
            offset: const Offset(-6, -2),
          ),
          BoxShadow(
            color: "#E03419".toColor().withOpacity(0.1),
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allow image to extend above card
        children: [
          // Guru image on the left, overlapping at the top - head extends above card
          Positioned(
            left: 0,
            top: guruTopOffset, // Head overlaps above card - responsive
            child: SizedBox(
              width: guruImageWidth, // Responsive width
              height: guruImageHeight, // Responsive height
              child: Image.asset(
                card['asset'] as String,
                fit: BoxFit.cover, // Maintain aspect ratio and fill
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: Icon(Icons.person, color: Colors.white, size: 60.w),
                  );
                },
              ),
            ),
          ),
          // AutoTranslateText content on the right - positioned to fit within card
          Positioned(
            left: guruImageWidth + 10.w, // Image width + small gap - responsive
            right: 16.w, // Right padding - responsive
            top: 12.h, // Top padding - responsive
            bottom: 12.h, // Bottom padding - responsive
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  card['title'] as String,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Baloo',
                      )
                      .merge(AppTypography.h2),
                ),
                SizedBox(height: 8.h), // Responsive spacing
                Expanded(
                  child: AutoTranslateText(
                    card['desc'] as String,
                    style: MyTextTheme.smallBCN
                        .copyWith(
                          color: "#6F6F6F".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          height: 1.4, // Line height
                        )
                        .merge(AppTypography.label),
                    textAlign: TextAlign.left,
                    maxLines: 6, // More lines now that card is taller
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(Map<String, dynamic> card, int index) {
    final bgColor = (card['bgColor'] as String?) ?? '#FFF5E6';
    final buttonText = card['buttonText'] as String;
    final isLetsSearch = buttonText == 'LETS SEARCH';
    final title = card['title'] as String;
    final isKundliCard = title.toLowerCase().contains('kundli');

    return GestureDetector(
      onTap: () {
        if (isKundliCard) {
          Get.toNamed(AppRoutes.kundliForm);
        } else if (isLetsSearch) {
          // Handle LETS SEARCH action
        } else {
          // Handle other consultation cards
        }
      },
      child: Container(
        key: ValueKey('${card['title']}_$index'),
        height: 155.h,
        decoration: BoxDecoration(
          color: bgColor.toColor(),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Left side - AutoTranslateText and Button
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  top: 14.h,
                  bottom: 14.h,
                  right: 8.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      card['title'] as String,
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Baloo',
                            height: 1.2,
                          )
                          .merge(AppTypography.h2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 11.h,
                      ),
                      decoration: BoxDecoration(
                        color: "#FFFFFF".toColor(),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: "#F38B3B".toColor().withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: isLetsSearch
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoTranslateText(
                                  'LETS',
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(
                                        color: "#9B2D87"
                                            .toColor(), // Reddish-purple
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Baloo',
                                      )
                                      .merge(AppTypography.body1),
                                ),
                                AutoTranslateText(
                                  ' SEARCH',
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(
                                        color: "#F38B3B".toColor(), // Orange
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Baloo',
                                      )
                                      .merge(AppTypography.body1),
                                ),
                              ],
                            )
                          : AutoTranslateText(
                              buttonText,
                              style: MyTextTheme.mediumBCB
                                  .copyWith(
                                    color: "#6F221E".toColor(),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Baloo',
                                  )
                                  .merge(AppTypography.body1),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            // Right side - Image
            Container(
              width: 140.w,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  card['asset'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(Icons.image, color: Colors.white, size: 60.w),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPillServiceCard(
  //   String label,
  //   String iconPath, {
  //   VoidCallback? onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       constraints: BoxConstraints(minHeight: 60.h),
  //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
  //       decoration: BoxDecoration(
  //         gradient: AppColors.orangeGradient,
  //         borderRadius: BorderRadius.circular(80.r),
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 52.w,
  //             height: 52.h,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               border: Border.all(color: Colors.white, width: 1.5),
  //             ),
  //             child: ClipOval(child: GifView.asset(iconPath, fit: BoxFit.fill)),
  //           ),
  //           SizedBox(width: 8.w),
  //           Expanded(
  //             child: Text(
  //               label,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13.sp,
  //                 fontWeight: FontWeight.w500,
  //                 height: 1.2,
  //               ),
  //               maxLines: 2,
  //               overflow: TextOverflow.clip,
  //               textAlign: TextAlign.left,
  //               softWrap: true,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLiveAstrologersSection() {
  //   return Obx(() {
  //     if (controller.isLoadingLiveStreams.value &&
  //         controller.liveStreams.isEmpty) {
  //       return Padding(
  //         padding: AppPaddings.symmetric(h: 16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 AutoTranslateText(
  //                   'LIVE ASTROLOGERS',
  //                   style: MyTextTheme.largeBCB
  //                       .copyWith(
  //                         color: "#6F221E".toColor(),
  //                         fontWeight: FontWeight.w400,
  //                         fontFamily: 'Baloo',
  //                         letterSpacing: -0.05,
  //                         height: 1.2999999788072374,
  //                       )
  //                       .merge(AppTypography.h2),
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     debugPrint(
  //                       'View All button tapped - navigating to live astrologers',
  //                     );
  //                     Get.toNamed(AppRoutes.liveAstrologers);
  //                   },
  //                   borderRadius: BorderRadius.circular(4.r),
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 8.w,
  //                       vertical: 4.h,
  //                     ),
  //                     child: AutoTranslateText(
  //                       'View All',
  //                       style: MyTextTheme.mediumBCN
  //                           .copyWith(
  //                             color: "#6F221E".toColor(),
  //                             fontWeight: FontWeight.w400,
  //                             fontFamily: 'Poppins',
  //                             height: 1.5,
  //                           )
  //                           .merge(AppTypography.body1),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Spacing.h(16),
  //             SizedBox(
  //               height: 85.h,
  //               child: Center(
  //                 child: CircularProgressIndicator(color: "#6F221E".toColor()),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }

  //     if (controller.liveStreams.isEmpty) {
  //       return const SizedBox.shrink();
  //     }

  //     return Padding(
  //       padding: AppPaddings.symmetric(h: 16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               AutoTranslateText(
  //                 'LIVE ASTROLOGERS',
  //                 style: MyTextTheme.largeBCB
  //                     .copyWith(
  //                       color: "#6F221E".toColor(),
  //                       fontWeight: FontWeight.w400,
  //                       fontFamily: 'Baloo',
  //                       letterSpacing: -0.05,
  //                       height: 1.2999999788072374,
  //                     )
  //                     .merge(AppTypography.h2),
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   debugPrint(
  //                     'View All button tapped - navigating to live astrologers',
  //                   );
  //                   Get.toNamed(AppRoutes.liveAstrologers);
  //                 },
  //                 borderRadius: BorderRadius.circular(4.r),
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 8.w,
  //                     vertical: 4.h,
  //                   ),
  //                   child: AutoTranslateText(
  //                     'View All',
  //                     style: MyTextTheme.mediumBCN
  //                         .copyWith(
  //                           color: "#6F221E".toColor(),
  //                           fontWeight: FontWeight.w400,
  //                           fontFamily: 'Poppins',
  //                           height: 1.5,
  //                         )
  //                         .merge(AppTypography.body1),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Spacing.h(16),
  //           SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Row(
  //               children: controller.liveStreams.asMap().entries.map((entry) {
  //                 final index = entry.key;
  //                 final stream = entry.value;
  //                 return Padding(
  //                   padding: EdgeInsets.only(
  //                     right: index < controller.liveStreams.length - 1
  //                         ? 12.w
  //                         : 0,
  //                   ),
  //                   child: _buildAstrologerAvatar(stream),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // Widget _buildAstrologerAvatar(LiveStreamModel stream) {
  //   final controller = Get.find<UserDashboardController>();
  //   final profilePicture = controller.getProfilePictureForAstrologer(
  //     stream.astrologerId,
  //   );
  //   final astrologerName = controller.getAstrologerName(stream.astrologerId);

  //   return GestureDetector(
  //     onTap: () {
  //       Get.to(
  //         () => LiveStreamView(
  //           stream: stream,
  //           astrologerName: astrologerName,
  //           astrologerProfilePicture: profilePicture,
  //         ),
  //       );
  //     },
  //     child: Container(
  //       width: 85.w,
  //       height: 85.h,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         border: Border.all(
  //           color: "#08A44F".toColor(), // Green
  //           width: 3,
  //         ),
  //       ),
  //       child: Stack(
  //         children: [
  //           ClipOval(
  //             child: profilePicture != null && profilePicture.isNotEmpty
  //                 ? NetworkImageWithLoader(
  //                     url: profilePicture,
  //                     width: 85.w,
  //                     height: 85.h,
  //                     isCircular: true,
  //                   )
  //                 : Image.asset(
  //                     'assets/app/astrology.png',
  //                     width: 85.w,
  //                     height: 85.h,
  //                     fit: BoxFit.cover,
  //                     errorBuilder: (context, error, stackTrace) {
  //                       return Container(
  //                         decoration: const BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: Color(0xFFE0E0E0),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //           ),
  //           // Online indicator
  //           Positioned(
  //             bottom: 0,
  //             right: 0,
  //             child: Container(
  //               width: 16.w,
  //               height: 16.h,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: "#08A44F".toColor(),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBulletPoint(
    String text, {
    Color color = Colors.white,
    double? size,
  }) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Spacing.w(8),
        AutoTranslateText(
          text,
          style: MyTextTheme.smallBCN.copyWith(
            color: color,
            fontSize: size ?? 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLivePoojaSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'LIVE POOJA IN TEMPLES',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Baloo',
                      letterSpacing: -0.05,
                    )
                    .merge(AppTypography.h2),
              ),
              AutoTranslateText(
                'View All',
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    )
                    .merge(AppTypography.body1),
              ),
            ],
          ),
          Spacing.h(16),
          SizedBox(
            height: 320.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildPoojaCard(
                    'Anuj Kumar',
                    'Hawan Puja • Birthday Puja',
                    '10:25 AM, 15th Sep',
                    AppConstant.poojaAnuj,
                    235.w,
                  );
                }
                return _buildPoojaCard(
                  'Abhishek Singh',
                  'Wedding Puja • Rituals',
                  '10:25 AM, 15th Sep',
                  AppConstant.poojaAbhishek,
                  207.19.w,
                );
              },
              separatorBuilder: (_, __) => Spacing.w(24),
              itemCount: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoojaCard(
    String name,
    String type,
    String time,
    String imagePath,
    double width,
  ) {
    final List<String> parts = type.split(' • ');
    final String primaryType = parts.isNotEmpty ? parts[0] : '';
    final String secondaryType = parts.length > 1 ? parts[1] : '';
    final Color titleColor = "#5B2A2A".toColor();
    final Color subtitleColor = const Color(0xFF6E6E6E);
    final double cardRadius = 6.r;
    final double imageRadius = 10.r;
    final double imageHeight = 190.h;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(imageRadius),
                  child: Image.asset(
                    imagePath,
                    width: width - 24.w,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: width - 24.w,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(imageRadius),
                          color: "#CCCCCC".toColor(),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7D7D7),
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: AutoTranslateText(
                      time,
                      style: MyTextTheme.mediumBCN
                          .copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                AutoTranslateText(
                  name,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Baloo',
                        height: 1.3,
                      )
                      .merge(AppTypography.h2),
                ),
                Spacing.h(8),
                // Pooja types
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AutoTranslateText(
                        primaryType,
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (secondaryType.isNotEmpty) ...[
                      Container(
                        width: 5.w,
                        height: 5.h,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: subtitleColor,
                        ),
                      ),
                      Flexible(
                        child: AutoTranslateText(
                          secondaryType,
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstroRemedySection() {
    return Obx(() {
      return Padding(
        padding: AppPaddings.symmetric(h: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Astro Remedy',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Baloo',
                        letterSpacing: -0.05,
                      )
                      .merge(AppTypography.h2),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.remedies);
                  },
                  child: AutoTranslateText(
                    'View All',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        )
                        .merge(AppTypography.body1),
                  ),
                ),
              ],
            ),
            Spacing.h(6),
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => Spacing.w(8),
                itemCount: controller.remedyCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.remedyCategories[index];
                  return _buildRemedyCard(category);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBlogSection() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Blogs and News',
                style: AppTypography.h2.copyWith(
                  color: '#820B17'.toColor(),
                  letterSpacing: -0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.allBlogs),
                child: Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: AutoTranslateText(
                    'View All',
                    style: AppTypography.body1.copyWith(
                      color: '#9D4807'.toColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(4),
          Obx(() {
            if (controller.isLoadingBlogs.value && controller.blogs.isEmpty) {
              return SizedBox(
                height: 140.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.deepOrange,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            if (controller.blogs.isEmpty) {
              return const SizedBox.shrink();
            }
            final list = controller.blogs;
            final count = list.length >= 8 ? 8 : list.length;
            return SizedBox(
              height: 140.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => Spacing.w(10),
                itemCount: count,
                itemBuilder: (context, index) {
                  return _buildBlogCardFromModel(list[index]);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
    String title,
    String duration,
    String imagePath,
    double width,
  ) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor().withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#E3B341".toColor().withOpacity(0.1),
          width: 0.53,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Image.asset(
              imagePath,
              width: width,
              height: 96.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: width,
                  height: 96.h,
                  color: Colors.grey.withOpacity(0.3),
                  child: Icon(Icons.image, size: 40.w),
                );
              },
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(11.99.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#DFB343".toColor(),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Baloo Bhai 2',
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacing.h(3.99),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 11.99.w,
                      color: "#F38B3B".toColor(),
                    ),
                    Spacing.w(3.99),
                    AutoTranslateText(
                      duration,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCardFromModel(Blog blog) {
    const double cardWidth = 150;
    const double thumbHeight = 94;
    final img = blog.featuredImage ?? '';
    final useImage = img.isNotEmpty && !_isVideoUrl(img);

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.blogDetail, arguments: blog),
      child: SizedBox(
        width: cardWidth.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: cardWidth.w,
              height: thumbHeight.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: useImage
                        ? CachedNetworkImage(
                            imageUrl: img,
                            width: cardWidth.w,
                            height: thumbHeight.h,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _blogThumbnailPlaceholder(
                              cardWidth.w,
                              thumbHeight.h,
                            ),
                            errorWidget: (_, __, ___) =>
                                _blogThumbnailPlaceholder(
                                  cardWidth.w,
                                  thumbHeight.h,
                                ),
                          )
                        : _blogThumbnailPlaceholder(cardWidth.w, thumbHeight.h),
                  ),
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26.w,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(6),
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: AutoTranslateText(
                blog.title ?? 'Untitled',
                style: AppTypography.body2.copyWith(
                  color: '#3D0C11'.toColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blogThumbnailPlaceholder(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(
          colors: [
            '#FCE5AA'.toColor(),
            AppColors.deepOrange.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.article_outlined,
          size: 36.w,
          color: AppColors.deepOrange.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  bool _isVideoUrl(String url) {
    if (url.isEmpty) return false;
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.mp4') ||
        lowerUrl.endsWith('.mov') ||
        lowerUrl.endsWith('.avi') ||
        lowerUrl.endsWith('.mkv') ||
        lowerUrl.endsWith('.webm') ||
        lowerUrl.contains('/video/') ||
        lowerUrl.contains('video');
  }

  Widget _buildRemedyCard(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        if (category.id != null) {
          Get.toNamed('/product-list', arguments: {'category': category});
        } else if (category.slug != null) {
          Get.toNamed(
            '/product-list',
            arguments: {'categorySlug': category.slug},
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 74.w,
            height: 74.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 74.w,
                  height: 74.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                ClipOval(
                  child: SizedBox(
                    width: 70.w,
                    height: 70.h,
                    child: category.image != null && category.image!.isNotEmpty
                        ? NetworkImageWithLoader(
                            url: category.image!,
                            width: 70.w,
                            height: 70.h,
                            isCircular: true,
                          )
                        : Container(
                            width: 70.w,
                            height: 70.h,
                            color: '#FCE5AA'.toColor(),
                            child: Icon(
                              Icons.category,
                              size: 32.w,
                              color: AppColors.deepOrange,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(4),
          SizedBox(
            width: 74.w,
            child: AutoTranslateText(
              category.name ?? 'Category',
              style: AppTypography.body2.copyWith(
                color: '#3D0C11'.toColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrashnaKundliSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoTranslateText(
                  'PRASHNA KUNDLI ASTROLOGERS',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Baloo',
                        letterSpacing: -0.05,
                        height: 1.5740000406901042,
                      )
                      .merge(AppTypography.h2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'View All',
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    )
                    .merge(AppTypography.body1),
              ),
            ],
          ),
          Spacing.h(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAstrologerCard(
                  'Anuj Kumar',
                  'Experience: 5 years',
                  'Hindi/English',
                  '₹ 30/Min',
                  AppConstant.astrologerAnuj,
                ),
                Spacing.w(12),
                _buildAstrologerCard(
                  'Shashi Sharma',
                  'Experience: 15 years',
                  'Hindi/English',
                  '₹ 100/Min',
                  AppConstant.astrologerShashi,
                ),
                Spacing.w(12),
                _buildAstrologerCard(
                  'Prakhar Singh',
                  'Experience: 7 years',
                  'Hindi/English',
                  '₹ 45/Min',
                  AppConstant.astrologerPrakhar,
                ),
                Spacing.w(12),
                _buildAstrologerCard(
                  'Ritik Yadav',
                  'Experience: 4 years',
                  'Hindi/English',
                  '₹ 25/Min',
                  AppConstant.astrologerRitik,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologerCard(
    String name,
    String experience,
    String languages,
    String price,
    String imagePath,
  ) {
    return Container(
      width: 163.25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.31.r),
        color: "#FFFFFF".toColor(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 18.93,
            offset: const Offset(3.15, 3.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Padding(
            padding: EdgeInsets.all(9.08.w),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.73.r),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 145.24.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: const Color(0xFFCCCCCC),
                        ),
                      );
                    },
                  ),
                ),
                // Available badge overlay in top-left
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: "#08A44F".toColor(),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: AutoTranslateText(
                      'Available',
                      style: MyTextTheme.smallBCN
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )
                          .merge(AppTypography.label),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details section with white background
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name in dark brown, bold
                AutoTranslateText(
                  name,
                  style: MyTextTheme.smallBCB
                      .copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.body1),
                ),
                Spacing.h(4),
                // Experience in lighter gray
                AutoTranslateText(
                  experience,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                  ),
                ),
                Spacing.h(2),
                // Languages in lighter gray
                AutoTranslateText(
                  languages,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                  ),
                ),
                Spacing.h(4),
                // Price in dark brown
                AutoTranslateText(
                  price,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.body2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVedicKundliAstrologersSection() {
    return Obx(() {
      if (controller.isLoadingVedicAstrologers.value) {
        return Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Vedic Kundli Astrologers',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: "#8B1925".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Baloo',
                          letterSpacing: -0.05,
                          height: 1.5740000406901042,
                        )
                        .merge(AppTypography.h2),
                  ),
                  AutoTranslateText(
                    'View all',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#9D4807".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          height: 1.5,
                        )
                        .merge(AppTypography.body1),
                  ),
                ],
              ),
              Spacing.h(4),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CircularProgressIndicator(color: AppColors.deepOrange),
                ),
              ),
            ],
          ),
        );
      }

      if (controller.vedicAstrologers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: AppPaddings.symmetric(h: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Vedic Kundli Astrologers',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: "#8B1925".toColor(),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Baloo',
                        letterSpacing: -0.05,
                        height: 1.5740000406901042,
                      )
                      .merge(AppTypography.h2),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to view all Vedic astrologers
                    Get.toNamed(
                      AppRoutes.allAstrologers,
                      arguments: {'filter': 'VEDIC'},
                    );
                  },
                  child: AutoTranslateText(
                    'View all',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#9D4807".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          height: 1.5,
                        )
                        .merge(AppTypography.body1),
                  ),
                ),
              ],
            ),
            Spacing.h(4),
            // Horizontal Scrollable List
            SizedBox(
              height: 210.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.vedicAstrologers.length >= 5
                    ? 5
                    : controller.vedicAstrologers.length,
                separatorBuilder: (context, index) => Spacing.w(12),
                itemBuilder: (context, index) {
                  final astrologer = controller.vedicAstrologers[index];
                  return _buildVedicAstrologerCard(astrologer);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildVedicAstrologerCard(AstrologerModel astrologer) {
    // Map astrologer data to display
    final name = astrologer.displayName;
    final experienceYears = astrologer.experienceYears;
    final experienceText = '$experienceYears Years';
    final voicePricePerMin = astrologer.services.voice.pricePerMinute ?? 0;
    final videoPricePerMin = astrologer.services.video.pricePerMinute ?? 0;
    final chatPrice = astrologer.services.chat.pricePerMinute ?? 0;
    final voicePrice = voicePricePerMin > 0
        ? '₹${voicePricePerMin.toInt()}/Min'
        : '₹0/Min';
    final videoPrice = videoPricePerMin > 0
        ? '₹${videoPricePerMin.toInt()}/Min'
        : '₹0/Min';
    final chatPriceText = chatPrice > 0
        ? '₹${chatPrice.toInt()}/Msg'
        : '₹0/Msg';
    final imagePath = astrologer.profilePicture ?? '';

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.astrologerDetail,
          arguments: {'astrologer': astrologer},
        );
      },
      child: Container(
        width: 170.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          border: Border.all(color: "#F38B3B".toColor(), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image with Decorative Border and Experience Badge
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background decorative border image
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/app/vedic_astrologer_background.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Profile Image
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.deepOrange, width: 1),
                    ),
                    child: ClipOval(
                      child: imagePath.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imagePath,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.withOpacity(0.3),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.deepOrange,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.withOpacity(0.3),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 40.w,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey.withOpacity(0.3),
                              child: Icon(
                                Icons.person,
                                color: Colors.white.withOpacity(0.5),
                                size: 40.w,
                              ),
                            ),
                    ),
                  ),
                  // Green dot indicator for online astrologers
                  if (astrologer.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 22.w,
                      child: Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50), // Green
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  // Experience Badge at bottom-center
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ["#FF6B35".toColor(), "#F38B3B".toColor()],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: AutoTranslateText(
                        experienceText,
                        style: MyTextTheme.smallBCB
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                            )
                            .merge(AppTypography.body2),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.h(3),
              // Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: AutoTranslateText(
                  name,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: "#361515".toColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      )
                      .merge(AppTypography.h3),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacing.h(1),
              // Designation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: AutoTranslateText(
                  'Vedic Astrologer',
                  style: MyTextTheme.smallBCN
                      .copyWith(color: "#909090".toColor(), fontSize: 10.sp)
                      .merge(AppTypography.body2),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacing.h(3),
              // Service Pricing Section (Horizontal with Icons)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Video Service
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.videocam,
                            size: 14.w,
                            color: AppColors.deepOrange,
                          ),
                          Spacing.h(2),
                          AutoTranslateText(
                            videoPrice,
                            style: MyTextTheme.smallBCB
                                .copyWith(
                                  color: AppColors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 5.sp,
                                )
                                .merge(AppTypography.label),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    // Voice Service
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14.w,
                            color: AppColors.deepOrange,
                          ),
                          Spacing.h(2),
                          AutoTranslateText(
                            voicePrice,
                            style: MyTextTheme.smallBCB
                                .copyWith(
                                  color: AppColors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 5.sp,
                                )
                                .merge(AppTypography.label),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    // Chat Service
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 14.w,
                            color: AppColors.deepOrange,
                          ),
                          Spacing.h(2),
                          AutoTranslateText(
                            chatPriceText,
                            style: MyTextTheme.smallBCB
                                .copyWith(
                                  color: AppColors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 5.sp,
                                )
                                .merge(AppTypography.label),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ],
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

  Widget _buildFeaturesSection() {
    return Obx(() {
      final showBanner = controller.showConsultationBanner.value;
      if (!showBanner) return const SizedBox.shrink();

      return Padding(
        padding: AppPaddings.symmetric(h: 16),
        child: Container(
          padding: AppPaddings.all(20),
          decoration: BoxDecoration(
            color: "#FFF8F0".toColor(), // Light yellow/cream
            borderRadius: AppRadius.all(12),
          ),
          child: Stack(
            children: [
              // Features Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFeatureItem(
                    icon: Icons.lock,
                    label: 'Private & Confidential',
                  ),
                  _buildFeatureItem(
                    icon: Icons.verified_user,
                    label: 'Verified Astrologers',
                  ),
                  _buildFeatureItem(
                    icon: Icons.payment,
                    label: 'Secure Payments',
                  ),
                ],
              ),
              // Close button positioned at top right
              Positioned(
                top: -20,
                // right: -20,
                child: IconButton(
                  onPressed: () {
                    controller.showConsultationBanner.value = false;
                  },
                  icon: Icon(
                    Icons.close,
                    color: "#6F221E".toColor(),
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFeatureItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: "#6F221E".toColor(), // Dark red
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 24.w),
        ),
        Spacing.h(8),
        SizedBox(
          width: 80.w,
          child: AutoTranslateText(
            label,
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCN
                .copyWith(color: "#6F221E".toColor())
                .merge(AppTypography.label),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularChatButton() {
    return GestureDetector(
      onTap: () => Get.toNamed('/ai-guider'),
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.r,
          ), // Rounded corners instead of circle
        ),
        child: Image.asset(
          'assets/app/ai_astro_icon.png',
          fit: BoxFit.contain,
          width: 70.w,
          height: 70.h,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28.w),
        ),
      ),
    );
  }

  Widget _buildSacredMandirsSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'SACRED MANDIRS OF BHARAT',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Baloo',
                      letterSpacing: -0.05,
                      height: 1.5740000406901042,
                    )
                    .merge(AppTypography.h2),
              ),
              AutoTranslateText(
                'View All',
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    )
                    .merge(AppTypography.body1),
              ),
            ],
          ),
          Spacing.h(16),
          SizedBox(
            height: 360.h,
            child: StreamBuilder<int>(
              stream: Stream.periodic(const Duration(seconds: 5), (x) => x),
              initialData: 0,
              builder: (context, snapshot) {
                final mandirs = [
                  {
                    'title': 'Mahakaleshwar Jyotirlinga',
                    'location': 'Ujjain, Madhya Pradesh',
                    'desc':
                        'It is the only Jyotirlinga facing south, symbolizing Mahadev\'s role as the destroyer of evil forces. The temple stands on the banks of the holy Shipra River, where the Kumbh Mela is held.',
                    'image': AppConstant.templeMahakaleshwar,
                  },
                  {
                    'title': 'Shore Temple',
                    'location': 'Mahabalipuram, Tamil Nadu',
                    'desc':
                        'An 8th-century seaside temple built by the Pallavas; a UNESCO World Heritage Site. Dedicated to Shiva and Vishnu, carved entirely from granite. Stands strong against sea waves and salty winds for over a thousand years.',
                    'image': 'assets/app/shore_temple.jpg',
                  },
                  {
                    'title': 'Brahma Temple',
                    'location': 'Pushkar, Rajasthan',
                    'desc':
                        'Around 2,000 years old and one of the very few temples of Lord Brahma. Believed to be the site where Brahma performed a sacred yajna. Built with red stone and marble, housing a four-faced idol of Brahma.',
                    'image': 'assets/app/brahma_temple.jpg',
                  },
                ];
                final idx = (snapshot.data ?? 0) % mandirs.length;
                final card = mandirs[idx];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: _buildMandirCard(
                    key: ValueKey(idx),
                    title: card['title'] as String,
                    location: card['location'] as String,
                    desc: card['desc'] as String,
                    image: card['image'] as String,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMandirCard({
    Key? key,
    required String title,
    required String location,
    required String desc,
    required String image,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            '#F7C443'.toColor().withOpacity(0.2),
            "#FFFCF3".toColor(),
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 210.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 210.h,
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(Icons.temple_hindu, size: 60.w),
                    );
                  },
                ),
              ),
              Spacing.h(12),
              AutoTranslateText(
                title,
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#E46E2E".toColor(),
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Baloo',
                    )
                    .merge(AppTypography.h1),
              ),
              Spacing.h(10),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18.w,
                    color: "#6F221E".toColor(),
                  ),
                  Spacing.w(6),
                  Flexible(
                    child: AutoTranslateText(
                      location,
                      style: MyTextTheme.mediumBCN
                          .copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          )
                          .merge(AppTypography.body1),
                    ),
                  ),
                ],
              ),
              Spacing.h(12),
              AutoTranslateText(
                desc,
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      height: 1.55,
                    )
                    .merge(AppTypography.body1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIAstrologersSection(context) {
    return Obx(() {
      if (controller.aiAstrologersPersonas.isEmpty &&
          !controller.isLoadingAiAstrologers.value) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(left: 16.w, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'AI Astrologers',
                  style: AppTypography.h2.copyWith(
                    color: '#820B17'.toColor(),
                    letterSpacing: -0.05,
                  ),
                ),
                Spacing.w(16),
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.aichat,
                        arguments: {'showBackButton': true},
                      );
                    },
                    child: AutoTranslateText(
                      'View All',
                      style: AppTypography.body1.copyWith(
                        color: '#9D4807'.toColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacing.h(2),
            if (controller.isLoadingAiAstrologers.value)
              SizedBox(
                height: 100.h,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.deepOrange),
                ),
              )
            else
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) => Spacing.w(8),
                  itemCount: controller.aiAstrologersPersonas.length,
                  itemBuilder: (context, index) {
                    final persona = controller.aiAstrologersPersonas[index];
                    return _buildAIAstrologerAvatarProfile(persona, context);
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildAIAstrologerAvatarProfile(
    PersonaModel persona,
    BuildContext context,
  ) {
    final imageUrl = persona.image ?? '';
    final displayName = persona.displayName.isNotEmpty
        ? persona.displayName
        : persona.name;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.personaDetail,
          arguments: {'personaId': persona.id, 'persona': persona},
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 74.w,
            height: 74.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 74.w,
                  height: 74.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.orangeGradient,
                  ),
                ),
                ClipOval(
                  child: SizedBox(
                    width: 70.w,
                    height: 70.h,
                    child: imageUrl.isNotEmpty
                        ? NetworkImageWithLoader(
                            url: imageUrl,
                            width: 70.w,
                            height: 70.h,
                            isCircular: true,
                          )
                        : Container(
                            width: 70.w,
                            height: 70.h,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 35.w,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(4),
          SizedBox(
            width: 70.w,
            child: AutoTranslateText(
              displayName,
              style: AppTypography.body2.copyWith(
                color: '#3D0C11'.toColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAstrologerCard(PersonaModel persona, index, context) {
    // Map persona data to card display
    final title = persona.displayName;
    final subtitle = persona.category.isNotEmpty
        ? persona.category
        : (persona.specializations.isNotEmpty
              ? persona.specializations.first
              : 'AI Astrologer');
    // final tags = persona.tags.isNotEmpty
    //     ? persona.tags.take(3).toList()
    //     : (persona.specializations.isNotEmpty
    //           ? persona.specializations.take(3).toList()
    //           : ['Astrology', 'Consultation', 'Guidance']);
    final imagePath = persona.image ?? '';
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.personaDetail,
          arguments: {'personaId': persona.id, 'persona': persona},
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 255.99.w, maxHeight: 220.h),
        child: Container(
          width: 255.99.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                "#3D0C11".toColor(),
                "#5D1C21".toColor(),
                "#3D0C11".toColor(),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              SvgAssets(
                path: 'assets/icons/ai_astrologer_circle.svg',
                width: 255.99.w,
                height: 265.h,
                colorFilter: ColorFilter.mode(
                  "#FFF6C2".toColor().withOpacity(0.1),
                  BlendMode.srcIn,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 220.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image with emoji overlay - moved to top
                    SizedBox(
                      width: 255.99.w,
                      height: 120.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: imagePath.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imagePath,
                                    width: 255.99.w,
                                    height: 120.h,
                                    fit: BoxFit.contain,

                                    errorWidget: (context, url, error) {
                                      return Container(
                                        width: 255.99.w,
                                        height: 120.h,
                                        color: Colors.grey.withOpacity(0.3),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 40.w,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 255.99.w,
                                    height: 120.h,
                                    color: Colors.grey.withOpacity(0.3),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 40.w,
                                    ),
                                  ),
                          ),
                          // Gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Emoji badge
                          // Positioned(
                          //   top: 72.h,
                          //   right: 50.w,
                          //   left: 50.w,
                          //   child: Container(
                          //     width: 48.w,
                          //     height: 48.h,
                          //     decoration: BoxDecoration(
                          //       gradient: LinearGradient(
                          //         colors: [
                          //           "#E3B341".toColor(),
                          //           "#C9A033".toColor(),
                          //         ],
                          //         begin: Alignment.topCenter,
                          //         end: Alignment.bottomCenter,
                          //       ),
                          //       shape: BoxShape.circle,
                          //       border: Border.all(
                          //         color: Colors.white.withOpacity(0.2),
                          //         width: 1.58,
                          //       ),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.black.withOpacity(0.1),
                          //           blurRadius: 4,
                          //           offset: const Offset(0, 2),
                          //         ),
                          //       ],
                          //     ),
                          //     child: Center(
                          //       child: AutoTranslateText(
                          //         emoji,
                          //         style: TextStyle().merge(AppTypography.h1),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Spacing.h(1),
                    // Title and subtitle
                    Padding(
                      padding: AppPaddings.symmetric(h: 10),
                      child: AutoTranslateText(
                        title,
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              color: "#DFB343".toColor(),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Baloo Bhai 2',
                              height: 1.0,
                              fontSize: 14.sp,
                            )
                            .merge(AppTypography.h3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacing.h(4),
                    Padding(
                      padding: AppPaddings.symmetric(h: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoTranslateText(
                              subtitle,
                              style: MyTextTheme.smallBCN.copyWith(
                                color: "#FFF6C2".toColor().withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                height: 1.0,
                                fontSize: 9.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacing.w(3),
                          Row(
                            children: [
                              Container(
                                width: 3.5.w,
                                height: 3.5.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: "#05DF72".toColor().withOpacity(0.91),
                                ),
                              ),
                              Spacing.w(2),
                              AutoTranslateText(
                                'Online',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#E3B341".toColor(),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  height: 1.0,
                                  fontSize: 8.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Spacing.h(1),
                    // // Tags
                    // Padding(
                    //   padding: AppPaddings.symmetric(h: 10),
                    //   child: Wrap(
                    //     spacing: 4.w,
                    //     runSpacing: 4.h,
                    //     children: tags
                    //         .map(
                    //           (tag) => Container(
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: 6.w,
                    //               vertical: 3.h,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               color: "#E3B341".toColor().withOpacity(0.2),
                    //               borderRadius: BorderRadius.circular(
                    //                 17722700.r,
                    //               ),
                    //               border: Border.all(
                    //                 color: "#E3B341".toColor().withOpacity(0.3),
                    //                 width: 0.53,
                    //               ),
                    //             ),
                    //             child: AutoTranslateText(
                    //               tag,
                    //               style: MyTextTheme.smallBCN.copyWith(
                    //                 color: "#FFF6C2".toColor(),
                    //                 fontWeight: FontWeight.w400,
                    //                 fontFamily: 'Poppins',
                    //                 height: 1.33,
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //         .toList(),
                    //   ),
                    // ),
                    Spacing.h(8),
                    // Chat Now button
                    Padding(
                      padding: AppPaddings.symmetric(h: 10),
                      child: Row(
                        spacing: 6.w,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgAssets(
                                      path: AppConstant.chatIcon,
                                      width: 14.w,
                                      height: 14.h,
                                    ),
                                    Spacing.w(4),
                                    Flexible(
                                      child: AutoTranslateText(
                                        'Chat Now',
                                        style: MyTextTheme.smallBCN.copyWith(
                                          color: "#FFFFFF".toColor(),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          height: 1.2,
                                          fontSize: 11.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgAssets(
                                      path: AppConstant.callIcon,
                                      width: 14.w,
                                      height: 14.h,
                                      colorFilter: ColorFilter.mode(
                                        "#FFFFFF".toColor(),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Spacing.w(4),
                                    Flexible(
                                      child: AutoTranslateText(
                                        'Call Now',
                                        style: MyTextTheme.smallBCN.copyWith(
                                          color: "#FFFFFF".toColor(),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          height: 1.2,
                                          fontSize: 11.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
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
              // FREE badge - positioned in top right of card
              Positioned(
                right: 12.w,
                top: 12.h,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 7.99.w,
                    right: 7.99.w,
                    top: 5.h,
                    bottom: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: "#05DF72".toColor(),
                    borderRadius: BorderRadius.circular(17722700.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        size: 12.w,
                        color: "#3D0C11".toColor(),
                      ),
                      Spacing.w(3.99),
                      AutoTranslateText(
                        'FREE',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: "#3D0C11".toColor(),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmojiForPersona(PersonaModel persona) {
    // Map category or name to emoji
    final category = persona.category.toLowerCase();
    final name = persona.displayName.toLowerCase();

    if (category.contains('vedic') || name.contains('vedic')) {
      return '♈';
    } else if (category.contains('tarot') || name.contains('tarot')) {
      return '🔮';
    } else if (category.contains('numerology') || name.contains('numero')) {
      return '🔢';
    } else if (category.contains('palm') || name.contains('palm')) {
      return '🤚';
    } else if (category.contains('astrology') || name.contains('astrolog')) {
      return '⭐';
    } else {
      return '✨';
    }
  }

  Widget _buildJoinLiveWebinarSection() {
    return Obx(() {
      final webinar = controller.liveWebinarForEnrolledCourse.value;
      if (webinar == null) return const SizedBox.shrink();

      // Calculate time status
      String timeStatus = "Live Now";
      if (webinar.scheduling?.scheduledStartTime != null) {
        final now = DateTime.now();
        final start = webinar.scheduling!.scheduledStartTime!;
        final difference = start.difference(now);
        final minutes = difference.inMinutes;

        if (minutes > 0) {
          timeStatus = "Starting in $minutes min";
        } else if (minutes < 0) {
          timeStatus = "Started ${minutes.abs()} min ago";
        } else {
          timeStatus = "Live Now";
        }
      } else if (webinar.status == 'LIVE') {
        timeStatus = "Live Now";
      }

      // Get viewer count
      final viewerCount = webinar.viewerStats?.currentViewers ?? 0;
      final viewerText = viewerCount > 0
          ? '${viewerCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} watching'
          : 'Live Now';

      // Get webinar title
      final webinarTitle = webinar.title ?? 'Live Webinar';
      final courseTitle = webinar.courseId?.title ?? '';
      final displayTitle = courseTitle.isNotEmpty
          ? '"$courseTitle" - $timeStatus'
          : '"$webinarTitle" - $timeStatus';

      return GestureDetector(
        onTap: () async {
          // Navigate to live webinar session
          if (webinar.webinarId != null && webinar.webinarId!.isNotEmpty) {
            try {
              final webinarService = WebinarService();
              final response = await webinarService.joinWebinar(
                webinar.webinarId!,
              );
              if (response != null) {
                Get.toNamed(
                  '/live-webinar-session',
                  arguments: {
                    'webinarId': webinar.webinarId!,
                    'courseId': webinar.courseId?.id ?? '',
                    'joinResponse': response,
                    'webinar': webinar,
                  },
                );
              } else {
                // If join fails, still try to navigate (user might already be in session)
                Get.toNamed(
                  '/live-webinar-session',
                  arguments: {
                    'webinarId': webinar.webinarId!,
                    'courseId': webinar.courseId?.id ?? '',
                    'webinar': webinar,
                  },
                );
              }
            } catch (e) {
              debugPrint('Error joining webinar: $e');
              // On error, still try to navigate
              Get.toNamed(
                '/live-webinar-session',
                arguments: {
                  'webinarId': webinar.webinarId!,
                  'courseId': webinar.courseId?.id ?? '',
                  'webinar': webinar,
                },
              );
            }
          }
        },
        child: Stack(
          children: [
            Container(
              margin: AppPaddings.symmetric(h: 16),
              padding: AppPaddings.all(20),
              decoration: BoxDecoration(
                color: "#BD5E14".toColor(),
                borderRadius: AppRadius.all(22.56),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: "#FFFFFF".toColor(),
                                    width: 2,
                                  ),
                                  color: "#05DF72".toColor().withOpacity(0.91),
                                ),
                              ),
                              Spacing.w(6),
                              AutoTranslateText(
                                'LIVE NOW',
                                style: MyTextTheme.smallBCN
                                    .copyWith(
                                      color: "#05DF72".toColor(),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                    )
                                    .merge(AppTypography.body2),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoTranslateText(
                            'Join Live Webinar',
                            style: MyTextTheme.largeBCB
                                .copyWith(
                                  color: "#FFFFFF".toColor(),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  height: 1.56,
                                )
                                .merge(AppTypography.h3),
                          ),
                          AutoTranslateText(
                            viewerText,
                            style: MyTextTheme.mediumBCN
                                .copyWith(
                                  color: "#FFFFFF".toColor(),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                )
                                .merge(AppTypography.body1),
                          ),
                        ],
                      ),
                      Spacing.h(8),
                      AutoTranslateText(
                        displayTitle,
                        style: MyTextTheme.mediumBCN
                            .copyWith(
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                            )
                            .merge(AppTypography.body2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.h(22.56),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: AppPaddings.symmetric(h: 11.28, v: 4.23),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.all(22.56),
                            ),
                            child: AutoTranslateText(
                              'FREE',
                              style: MyTextTheme.smallBCN
                                  .copyWith(
                                    color: "#F38B3B".toColor(),
                                    fontWeight: FontWeight.w400,
                                  )
                                  .merge(AppTypography.body2),
                            ),
                          ),
                          Container(
                            padding: AppPaddings.symmetric(h: 11.28, v: 4.23),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.all(22.56),
                            ),
                            child: AutoTranslateText(
                              'Join Now',
                              style: MyTextTheme.smallBCN
                                  .copyWith(
                                    color: "#F38B3B".toColor(),
                                    fontWeight: FontWeight.w400,
                                  )
                                  .merge(AppTypography.body2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: -40,
              right: -25,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: "#FFFFFF".toColor().withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -25,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: "#FFFFFF".toColor().withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildVideosSection() {
    return Obx(() {
      // Filter blogs that have video featured images
      final videoBlogs = controller.blogs
          .where(
            (blog) =>
                _isVideoUrl(blog.featuredImage ?? '') &&
                blog.featuredImage != null &&
                blog.featuredImage!.isNotEmpty,
          )
          .take(5)
          .toList();

      if (controller.isLoadingBlogs.value && videoBlogs.isEmpty) {
        return Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(17801400.r),
                        ),
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Videos',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Baloo Bhai 2',
                              height: 1.5,
                            )
                            .merge(AppTypography.h3),
                      ),
                    ],
                  ),
                  AutoTranslateText(
                    'View All',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          height: 1.5,
                        )
                        .merge(AppTypography.body1),
                  ),
                ],
              ),
              Spacing.h(16),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        );
      }

      if (videoBlogs.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: AppPaddings.symmetric(h: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ["#E63946".toColor(), "#FF8C42".toColor()],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(17801400.r),
                      ),
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Videos',
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Baloo Bhai 2',
                            height: 1.5,
                          )
                          .merge(AppTypography.h3),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.allBlogs),
                  child: AutoTranslateText(
                    'View All',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          height: 1.5,
                        )
                        .merge(AppTypography.body1),
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: videoBlogs.asMap().entries.map((entry) {
                  final blog = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: entry.key < videoBlogs.length - 1 ? 10.w : 0,
                    ),
                    child: _buildVideoCardFromBlog(blog, 168.42.w),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildVideoCardFromBlog(Blog blog, double width) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.blogDetail, arguments: blog),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: AppRadius.all(16),
          border: Border.all(
            color: "#E3B341".toColor().withOpacity(0.1),
            width: 0.53,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Container(
                    width: width,
                    height: 96.h,
                    color: Colors.black,
                    child:
                        blog.featuredImage != null &&
                            blog.featuredImage!.isNotEmpty
                        ? SizedBox(
                            width: width,
                            height: 96.h,
                            child: ClipRect(
                              child: OverflowBox(
                                maxWidth: width,
                                maxHeight: 96.h,
                                alignment: Alignment.center,
                                child: VideoPlayerWidget(
                                  videoUrl: blog.featuredImage!,
                                  autoPlay: false,
                                  showControls: false,
                                ),
                              ),
                            ),
                          )
                        : Icon(
                            Icons.video_library,
                            size: 40.w,
                            color: Colors.grey,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: AppPaddings.symmetric(h: 6, v: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: AppRadius.all(4),
                    ),
                    child: AutoTranslateText(
                      _formatDuration(blog.readingTime ?? 0),
                      style: MyTextTheme.smallBCN
                          .copyWith(color: Colors.white)
                          .merge(AppTypography.label),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    blog.title ?? 'Untitled',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: "#DFB343".toColor(),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Baloo Bhai 2',
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(8),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 12.w,
                        color: "#F38B3B".toColor(),
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        '${_formatViews(blog.viewsCount ?? 0)} views',
                        style: MyTextTheme.smallBCN
                            .copyWith(color: "#F38B3B".toColor())
                            .merge(AppTypography.label),
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

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes:00';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}:${mins.toString().padLeft(2, '0')}';
  }

  String _formatViews(int views) {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}K';
    return views.toString();
  }

  Widget _buildVideoCard({
    required String thumbnail,
    required String title,
    required String author,
    required String views,
    required String duration,
  }) {
    return Container(
      width: 168.42.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: AppRadius.all(16),
        border: Border.all(
          color: "#E3B341".toColor().withOpacity(0.1),
          width: 0.53,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: Image.asset(
                  thumbnail,
                  width: double.infinity,
                  height: 96.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 96.h,
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(Icons.video_library, size: 40.w),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Container(
                  padding: AppPaddings.symmetric(h: 8, v: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: AppRadius.all(4),
                  ),
                  child: AutoTranslateText(
                    duration,
                    style: MyTextTheme.smallBCN.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: AppPaddings.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB
                      .copyWith(
                        color: "#DFB343".toColor(),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Baloo Bhai 2',
                        height: 1.25,
                      )
                      .merge(AppTypography.h3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacing.h(4),
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 12.w,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    Spacing.w(4),
                    AutoTranslateText(
                      views,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDrawer(BuildContext context) {
    final controller = Get.isRegistered<UserDashboardController>()
        ? Get.find<UserDashboardController>()
        : null;
    return Drawer(
      backgroundColor: const Color(
        0xFFFEF5DF,
      ), // Light beige/yellowish background
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with logo and close button
              Padding(
                padding: AppPaddings.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: "#6F221E".toColor(), // Dark maroon
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: AppPaddings.all(3),
                                child: Image.asset(
                                  'assets/app/app_icon.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.star,
                                      color: const Color(0xFFFFD700), // Gold
                                      size: 24.w,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Spacing.w(12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.network(
                                  'https://astrobharatai.s3.ap-south-1.amazonaws.com/homepageVideos/Frame+1321314931.svg',
                                  height: 32.h,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerLeft,
                                ),
                                AutoTranslateText(
                                  'Stars Align, Destiny Divine',
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: const Color(
                                      0xFF5F2221,
                                    ).withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  translate: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: "#6F221E".toColor(), // Dark maroon
                        size: 24.w,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Card
              // Container(
              //   margin: AppPaddings.symmetric(h: 16),
              //   padding: AppPaddings.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white, // White card background
              //     borderRadius: AppRadius.all(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.05),
              //         blurRadius: 10,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Obx(() {
              //             final profilePic = controller
              //                 ?.userProfile.value?.personalInfo?.profilePicture;
              //             final url = profilePic ?? '';
              //             if (url.isEmpty) {
              //               return Container(
              //                 width: 48.w,
              //                 height: 48.w,
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: "#6F221E".toColor().withOpacity(0.2),
              //                 ),
              //                 child: Icon(
              //                   Icons.person,
              //                   color: "#6F221E".toColor(),
              //                   size: 28.w,
              //                 ),
              //               );
              //             }
              //             return SizedBox(
              //               width: 48.w,
              //               height: 48.w,
              //               child: NetworkImageWithLoader(
              //                 url: url,
              //                 width: 48.w,
              //                 height: 48.w,
              //                 isCircular: true,
              //               ),
              //             );
              //           }),
              //           Spacing.w(12),
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Obx(() {
              //                   final name = controller
              //                           ?.userProfile.value?.personalInfo?.fullName ??
              //                       controller?.userName.value ??
              //                       'User';
              //                   return AutoTranslateText(
              //                     name.isNotEmpty ? name : 'User',
              //                     style: MyTextTheme.mediumBCB
              //                         .copyWith(
              //                           color: "#6F221E".toColor(),
              //                           fontWeight: FontWeight.bold,
              //                         )
              //                         .merge(AppTypography.h3),
              //                   );
              //                 }),
              //                 Spacing.h(4),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //       Spacing.h(16),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           // _buildStatItemStatic('12', 'Consults'),
              //           // _buildStatItemStatic('4', 'Orders'),
              //           Obx(() {
              //             final walletController =
              //                 Get.isRegistered<WalletController>()
              //                 ? Get.find<WalletController>()
              //                 : null;
              //             final balance =
              //                 walletController?.walletBalance.value ?? 0.0;
              //             final formattedBalance = balance >= 1000
              //                 ? '₹${(balance / 1000).toStringAsFixed(1)}K'
              //                 : '₹${balance.toStringAsFixed(0)}';
              //             return _buildStatItemStatic(
              //               formattedBalance,
              //               'Wallet',
              //             );
              //           }),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // Spacing.h(24),
              // EXPLORE Section
              _buildDrawerSection(
                context: context,
                title: 'EXPLORE',
                children: [
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.offNamed('/user-home', id: 1);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.star,
                    label: 'AI Astrologer',
                    hasBadge: true,
                    badgeText: 'New',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.aichat);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.video_call,
                    label: 'Digital Consultation',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.astrologyServices);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.shopping_bag,
                    label: 'Digital Mart',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.ecommerceHome);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.temple_hindu,
                    label: 'Digital Mandir',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.namasteHome);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.school,
                    label: 'Digital Learning',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.courses);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.live_tv,
                    label: 'Live',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.liveAstrologers);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.people,
                    label: 'Consult',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.astrologyServices);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.history,
                    label: 'History',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.consultationHistory);
                    },
                  ),
                ],
              ),
              Spacing.h(24),
              Divider(
                color: const Color(0xFF5F2221).withOpacity(0.2),
                thickness: 1,
              ),
              Spacing.h(12),
              // SERVICES Section
              _buildDrawerSection(
                context: context,
                title: 'SERVICES',
                children: [
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.book,
                    label: 'Kundli',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.kundliForm);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.menu_book,
                    label: 'Lal Kitab',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.lalKitab);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.analytics,
                    label: 'KP Astrology',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.kpSystem);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.auto_awesome,
                    label: 'Predictions',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.predictions);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.favorite,
                    label: 'Kundli Matching',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.matchMakingForm);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.calendar_today,
                    label: 'Horoscope',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.horoscope);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.calendar_month,
                    label: 'Panchang',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.panchang);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.assignment,
                    label: 'Reports',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.allReports);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.timeline,
                    label: 'Dasha',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.dasha);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.warning_amber,
                    label: 'Dosh',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.dosh);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.numbers,
                    label: 'Numerology',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.numerologyForm);
                    },
                  ),
                ],
              ),
              Spacing.h(24),
              Divider(
                color: const Color(0xFF5F2221).withOpacity(0.2),
                thickness: 1,
              ),
              Spacing.h(12),
              // READINGS Section
              _buildDrawerSection(
                context: context,
                title: 'READINGS',
                children: [
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.face,
                    label: 'Face Reading',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.faceReading);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.back_hand,
                    label: 'Palm Reading',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.palmReading);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.home_work,
                    label: 'Vastu',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.vastuDashboard);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.casino,
                    label: 'Ramal',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.ramalShastra);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.edit_note,
                    label: 'Writing',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.handwritingAstrology);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.help_outline,
                    label: 'Prashna',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.prashnaKundali);
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.style,
                    label: 'Tarot',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.tarotReading);
                    },
                  ),
                ],
              ),
              Spacing.h(24),
              Divider(
                color: const Color(0xFF5F2221).withOpacity(0.2),
                thickness: 1,
              ),
              Spacing.h(12),
              // ASTROLOGER BY CATEGORY Section
              _buildDrawerSection(
                context: context,
                title: 'ASTROLOGER BY CATEGORY',
                children: [
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.auto_awesome,
                    label: 'Vedic',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.allAstrologers, arguments: 'Vedic');
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.style,
                    label: 'Tarot',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(
                        AppRoutes.allAstrologers,
                        arguments: 'Tarots',
                      );
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.home_work,
                    label: 'Vastu',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.allAstrologers, arguments: 'Vastu');
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.help_outline,
                    label: 'Prashna',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(
                        AppRoutes.allAstrologers,
                        arguments: 'Prashana',
                      );
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.verified_user,
                    label: 'Celebrity',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(
                        AppRoutes.allAstrologers,
                        arguments: 'Celebrity',
                      );
                    },
                  ),
                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.child_care,
                    label: 'Kids',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.allAstrologers, arguments: 'Kids');
                    },
                  ),
                ],
              ),
              Spacing.h(24),
              Divider(
                color: const Color(0xFF5F2221).withOpacity(0.2),
                thickness: 1,
              ),
              Spacing.h(12),
              // ACCOUNT Section
              _buildDrawerSection(
                context: context,
                title: 'ACCOUNT',
                children: [
                  _buildDrawerWalletItem(context),
                  _buildDrawerOrdersItem(context),

                  _buildDrawerItemStatic(
                    context: context,
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.profile);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildStatItemStatic(String value, String label) {
    return Column(
      children: [
        AutoTranslateText(
          value,
          style: MyTextTheme.mediumBCB
              .copyWith(
                color: "#6F221E".toColor(), // Dark maroon
                fontWeight: FontWeight.bold,
              )
              .merge(AppTypography.body1),
        ),
        SizedBox(height: 4.h),
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN
              .copyWith(
                color: const Color(
                  0xFF5F2221,
                ).withOpacity(0.7), // Dark maroon with opacity
              )
              .merge(AppTypography.label),
        ),
      ],
    );
  }

  static Widget _buildDrawerWalletItem(BuildContext context) {
    if (!Get.isRegistered<WalletController>()) {
      return _buildDrawerItemStatic(
        context: context,
        icon: Icons.account_balance_wallet,
        label: 'Wallet',
        trailing: AutoTranslateText(
          '₹0',
          style: MyTextTheme.smallBCN.copyWith(color: "#F38B3B".toColor()),
        ),
        onTap: () {
          Navigator.of(context).pop();
          Get.toNamed(AppRoutes.wallet);
        },
      );
    }
    return Obx(() {
      final walletController = Get.find<WalletController>();
      final balance = walletController.walletBalance.value;
      return _buildDrawerItemStatic(
        context: context,
        icon: Icons.account_balance_wallet,
        label: 'Wallet',
        trailing: AutoTranslateText(
          walletController.formatCurrency(balance),
          style: MyTextTheme.smallBCN.copyWith(color: "#F38B3B".toColor()),
        ),
        onTap: () {
          Navigator.of(context).pop();
          Get.toNamed(AppRoutes.wallet);
        },
      );
    });
  }

  static Widget _buildDrawerOrdersItem(BuildContext context) {
    if (!Get.isRegistered<OrdersController>()) {
      return _buildDrawerItemStatic(
        context: context,
        icon: Icons.shopping_cart,
        label: 'My Orders',
        onTap: () {
          Navigator.of(context).pop();
          Get.toNamed(AppRoutes.orders);
        },
      );
    }
    return Obx(() {
      final ordersController = Get.find<OrdersController>();
      final count = ordersController.orders.length;
      return _buildDrawerItemStatic(
        context: context,
        icon: Icons.shopping_cart,
        label: 'My Orders',
        trailing: count > 0
            ? AutoTranslateText(
                '$count',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        onTap: () {
          Navigator.of(context).pop();
          Get.toNamed(AppRoutes.orders);
        },
      );
    });
  }

  static Widget _buildDrawerSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.smallBCN.copyWith(
              color: const Color(0xFF5F2221).withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacing.h(12),
          ...children,
        ],
      ),
    );
  }

  static Widget _buildDrawerItemStatic({
    required BuildContext context,
    required IconData icon,
    required String label,
    bool isSelected = false,
    bool hasBadge = false,
    String? badgeText,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5F2221)
              : Colors.transparent, // Dark maroon for selected
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : const Color(
                      0xFF5F2221,
                    ), // White for selected, dark maroon for unselected
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AutoTranslateText(
                label,
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: isSelected
                          ? Colors.white
                          : const Color(
                              0xFF5F2221,
                            ), // White for selected, dark maroon for unselected
                    )
                    .merge(AppTypography.body1),
              ),
            ),
            if (hasBadge && badgeText != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35), // Orange
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  badgeText,
                  style: MyTextTheme.smallBCN
                      .copyWith(color: Colors.white)
                      .merge(AppTypography.label),
                ),
              ),
            if (trailing != null) ...[SizedBox(width: 8.w), trailing],
          ],
        ),
      ),
    );
  }

  Widget _buildLiveAstrologerProfile(int index, LiveStreamModel stream) {
    final profilePicture = controller.getProfilePictureForAstrologer(
      stream.astrologerId,
    );
    final isLive = stream.status == 'LIVE';
    final borderColor = isLive ? "#00C853".toColor() : Colors.red;
    final badgeColor = isLive ? "#00C853".toColor() : Colors.red;

    return GestureDetector(
      onTap: () async {
        // Check if user is logged in before accessing live stream
        final isLoggedIn = await LoginGuard.ensureLoggedIn(
          message: 'Please login to watch live streams.',
        );

        if (isLoggedIn) {
          if (isLive) {
            // Navigate to live stream if it's actually live
            Get.to(
              () => LiveStreamView(
                stream: stream,
                astrologerName: stream.astrologerName,
                astrologerProfilePicture: profilePicture,
              ),
            );
          } else {
            // Show "live stream has ended" message
            Get.snackbar(
              'Stream Ended',
              'Live stream has ended',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2.w),
            ),
            child: ClipOval(
              child: Image.network(
                profilePicture ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 35.w,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: badgeColor,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  AutoTranslateText(
                    isLive ? 'Live' : 'Offline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacing.h(4),
          SizedBox(
            width: 70.w,
            child: AutoTranslateText(
              stream.astrologerName,
              style: AppTypography.body2.copyWith(
                color: "#3D0C11".toColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineAstrologerProfile(int index, AstrologerModel astrologer) {
    final profilePicture = astrologer.profilePicture ?? '';
    final astrologerName = astrologer.displayName.isNotEmpty
        ? astrologer.displayName
        : astrologer.name;

    return GestureDetector(
      onTap: () async {
        // Check if user is logged in
        final isLoggedIn = await LoginGuard.ensureLoggedIn(
          message: 'Please login to view astrologer profiles.',
        );

        if (isLoggedIn) {
          // Show "live stream has ended" message
          Get.snackbar(
            'Stream Ended',
            'Live stream has ended',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2.w),
            ),
            child: ClipOval(
              child: profilePicture.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profilePicture,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.deepOrange,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 35.w,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 35.w,
                        color: Colors.grey[600],
                      ),
                    ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  AutoTranslateText(
                    'Offline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacing.h(4),
          SizedBox(
            width: 70.w,
            child: AutoTranslateText(
              astrologerName,
              style: AppTypography.body2.copyWith(
                color: "#3D0C11".toColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
