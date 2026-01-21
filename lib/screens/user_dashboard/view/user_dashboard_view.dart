import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/live_stream/view/live_stream_view.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/AnimatedChakra.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/astrology_tool_widget.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
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
import 'package:astrobharataiuser/widgets/language_selector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
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
import '../widgets/features_and_videos_widget.dart';
import '../widgets/daily_astrologers_widget.dart';
import '../widgets/quote_of_the_day_widget.dart';
import '../widgets/digital_services_animated_widget.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';

class UserDashboardView extends BasePage<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              "#FCE5AA".toColor(), // Light yellow/cream at top (3%)
              "#FFFCF3".toColor(), // Light cream in middle (52%)
              "#FFFFFF".toColor(), // White at bottom (100%)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Scrollable content with pull-to-refresh
              RefreshIndicator(
                onRefresh: controller.refreshDashboard,
                color: "#6F221E".toColor(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller.scrollController,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with menu, logo, icons and search bar
                          _buildHeader(context),
                          Spacing.h(10),

                          // Body with curve, gradient and all content sections
                          _buildBodyWithCurve(context),

                          // Bottom padding to prevent content from being hidden behind sticky banner
                          // Spacing.h(100),
                        ],
                      ),
                      Positioned(
                        top: 110,
                        left: 25,
                        right: 25,
                        child: _buildSearchBar(context),
                      ),
                    ],
                  ),
                ),
              ),
              // 🔥 Search bar overlay (FIX)

              // Circular button for AI Chat navigation at bottom - just above bottom nav
              Positioned(
                right: 1.w,
                bottom: 60
                    .h, // Position just above bottom nav (60h nav + 20h spacing)
                child: _buildCircularChatButton(),
              ),
              // Floating action buttons row
              // Option 3: Container with full width white background
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  child: _buildAstrologerActionsRow(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Animated fullchakra background - positioned in header background
        Positioned(
          right: -20.w,
          top: -15.h,
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
        // Header content
        Column(
          children: [
            // Top section with menu, logo and icons
            Container(
              height: 120.h,
              padding: AppPaddings.symmetric(h: 16, v: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Menu icon
                      IconButton(
                        onPressed: () {
                          final scaffoldState = context
                              .findAncestorStateOfType<ScaffoldState>();
                          scaffoldState?.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 24.w,
                          color: "#6F221E".toColor(),
                        ),
                      ),
                      Spacing.w(8),
                      // Logo placed near drawer
                      SvgAssets(
                        path: 'assets/app/AstrobharatAi .svg',
                        width: 120.w,
                        height: 30.h,
                      ),
                    ],
                  ),
                  // Wallet, Language and Cart icons
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.wallet);
                        },
                        icon: Icon(
                          Icons.account_balance_wallet,
                          size: 24.w,
                          color: "#6F221E".toColor(),
                        ),
                      ),
                      // Language selector
                      LanguageSelector(
                        iconColor: "#6F221E".toColor(),
                        iconSize: 24.w,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.cart);
                        },
                        icon: SvgAssets(
                          path: 'assets/app/cart.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                            "#6F221E".toColor(),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
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
                                  : 'Search horoscope, kundli, tarot...',
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
          Spacing.h(50),

          // Live Astrologers Section
          Obx(() {
            final hasLiveStreams = controller.liveStreams.isNotEmpty;
            final randomAstrologers = controller.allAstrologer.take(5).toList();
            
            // Always show section - with live streams or random astrologers
            final showSection = hasLiveStreams || randomAstrologers.isNotEmpty;
            
            if (!showSection) {
              return SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ShaderMask(
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
                              'Live Astrologers',
                              style: AppTypography.h2.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.05,
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
                      GestureDetector(
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
                    ],
                  ),
                  if (!hasLiveStreams) ...[
                    Spacing.h(8),
                    Container(
                      padding: AppPaddings.symmetric(h: 12.w, v: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red, size: 18.w),
                          Spacing.w(8),
                          Expanded(
                            child: AutoTranslateText(
                              'No astrologer live at the moment',
                              style: AppTypography.body2.copyWith(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Spacing.h(16),
                  SizedBox(
                    height: 110.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: hasLiveStreams 
                          ? controller.liveStreams.length 
                          : randomAstrologers.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
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

          // Digital Services Animated Widget
          const DigitalServicesAnimatedWidget(),

          Spacing.h(15),

          // Our Services Pill Section
          _buildOurServicesPillSection(),
          Spacing.h(24),

          // Daily Astrologers Section
          DailyAstrologersWidget(),

          AllAstrologerWidget(),
          Spacing.h(12),
          OurServicesSection(title: 'Our Services'),
          Spacing.h(12),
          AstrologyToolWidget(),
          Spacing.h(12),
          // // Talk to AI Astrologer Card
          // _buildTalkToAIAstrologerCard(),

          // Spacing.h(24),

          // Quote of the Day Section
          const QuoteOfTheDayWidget(),
          Spacing.h(12),
          AstrologyReportWidget(),

          Spacing.h(24),

          // AI Astrologers Section
          _buildAIAstrologersSection(context),
          Spacing.h(24),
          // Astro Remedy Section
          _buildAstroRemedySection(),
          Spacing.h(24),
          // Book Pooja Section
          const BookPoojaCarouselWidget(),
          Spacing.h(24),
          _buildVedicKundliAstrologersSection(),
          Spacing.h(24),

          // Our Services Carousel
          _buildOurServicesCarousel(),
          Spacing.h(24),
          // Courses Section
          CoursesSectionWidget(),
          Spacing.h(24),
          // kids specialist astrologers
          const KidsSpecialistAstrologersWidget(),

          // Spacing.h(24),

          // // Live Pooja in Temples Section
          // _buildLivePoojaSection(),
          Spacing.h(24),

          // Sacred Mandirs of Bharat Section
          _buildSacredMandirsSection(),

          Spacing.h(12),

          // Celebrity Astrologer Section
          CelebrityAstrologerWidget(),

          Spacing.h(24),

          // Join Live Webinar Section (only if user has enrolled course with live webinar)
          Obx(
            () => controller.hasLiveWebinarForEnrolledCourse.value
                ? _buildJoinLiveWebinarSection()
                : const SizedBox.shrink(),
          ),

          // Spacing.h(24),

          // // Prashna Kundli Astrologers Section
          // _buildPrashnaKundliSection(),
          Spacing.h(24),

          // Blog Section
          _buildBlogSection(),

          Spacing.h(24),

          // Features and Videos Section
          FeaturesAndVideosWidget(),

          Spacing.h(60),

          // // Features Section (scrollable with close button)
          // _buildFeaturesSection(),

          // Spacing.h(24),
        ],
      ),
    );
  }

  Widget _buildOurServicesPillSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildPillServiceCard(
                  'Digital Mart',
                  'assets/app/digital_shop_video_icon.gif',
                  onTap: () {
                    Get.offNamed(
                      '/user-shop',
                      id: 1,
                      arguments: {'showBackButton': true},
                    );
                  },
                ),
              ),
              Spacing.w(10),
              Expanded(
                child: _buildPillServiceCard(
                  'Digital Pooja',
                  'assets/app/digital_pooja_video_icon.gif',
                  onTap: () {
                    Get.toNamed(AppRoutes.namasteHome);
                  },
                ),
              ),
            ],
          ),
          Spacing.h(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildPillServiceCard(
                  'Consultation',
                  'assets/app/consultation_video_icon.gif',
                  onTap: () {
                    Get.toNamed(AppRoutes.astrologyServices);
                  },
                ),
              ),
              Spacing.w(10),
              Expanded(
                child: _buildPillServiceCard(
                  'Digital Education',
                  'assets/app/digital_education_video_icon.gif',
                  onTap: () {
                    Get.toNamed(AppRoutes.courses);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
    final double guruImageHeight =
        280.h; // Reduced for better proportion
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

  Widget _buildPillServiceCard(
    String label,
    String iconPath, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 60.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(80.r),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: ClipOval(child: GifView.asset(iconPath, fit: BoxFit.fill)),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildOurServicesCarousel() {
    final services = [
      {
        'title': 'Kundli Matching',
        'description': 'Find your perfect match with 36 Gun Milan analysis and AI-powered compatibility insights.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.matchMakingForm,
      },
      {
        'title': 'Generate Kundli',
        'description': 'Get your personalized birth chart with detailed planetary positions and analysis.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
      },
      {
        'title': 'Life Predictions',
        'description': 'Discover your future with comprehensive life predictions based on your birth chart.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
        'args': {'targetRoute': AppRoutes.predictions},
      },
      {
        'title': 'Dosh Analysis',
        'description': 'Check for malefic planetary combinations and get remedies for dosh in your chart.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
        'args': {'targetRoute': AppRoutes.dosh},
      },
      {
        'title': 'Dasha Prediction',
        'description': 'Understand your current planetary periods and their effects on your life.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
        'args': {'targetRoute': AppRoutes.dasha},
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Our Services',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#68171E".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
            ],
          ),
        ),
        Spacing.h(16),
        SizedBox(
          height: 110.h,
          child: PageView.builder(
            controller: controller.ourServicesPageController.value,
            onPageChanged: (index) {
              controller.ourServicesCurrentPage.value = index;
            },
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(service);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        final args = service['args'] as Map<String, dynamic>?;
        if (args != null) {
          Get.toNamed(service['route'] as String, arguments: args);
        } else {
          Get.toNamed(service['route'] as String);
        }
      },
      child: Container(
        margin: AppPaddings.symmetric(h: 8),
        padding: AppPaddings.symmetric(h: 16, v: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: "#F38B3B".toColor(), width: 1),
        ),
        child: Row(
          children: [
            // Left Side - Square Icon Container with Gradient
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Image.asset(
                service['icon'] as String,
                height: 40.h,
                width: 40.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 24.w,
                  );
                },
              ),
            ),
            Spacing.w(16),
            // Middle Section - Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  AutoTranslateText(
                    service['title'] as String,
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: "#68171E".toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(6),
                  // Description
                  AutoTranslateText(
                    service['description'] as String,
                    style: MyTextTheme.mediumBCN
                        .copyWith(color: "#F38B3B".toColor())
                        .merge(AppTypography.body2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Spacing.w(12),
            // Right Side - Navigation Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.deepOrange,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }

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
                  'ASTRO REMEDY',
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
                    Get.toNamed(
                      AppRoutes.ecommerceHome,
                      arguments: {'showBackButton': true},
                    );
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
            Spacing.h(16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.remedyCategories.asMap().entries.map((
                  entry,
                ) {
                  final index = entry.key;
                  final category = entry.value;
                  return Row(
                    children: [
                      _buildRemedyCard(category, 150.w),
                      if (index < controller.remedyCategories.length - 1)
                        Spacing.w(12),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBlogSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'BLOGS AND NEWS',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Baloo',
                      letterSpacing: -0.05,
                    )
                    .merge(AppTypography.h2),
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
          Obx(() {
            if (controller.isLoadingBlogs.value && controller.blogs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.blogs.isEmpty) {
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.blogs.asMap().entries.map((entry) {
                  final blog = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: entry.key < controller.blogs.length - 1 ? 0.w : 0,
                    ),
                    child: _buildBlogCardFromModel(blog, 168.42.w),
                  );
                }).toList(),
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

  Widget _buildBlogCardFromModel(Blog blog, double width) {
    final isVideo = _isVideoUrl(blog.featuredImage ?? '');
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.blogDetail, arguments: blog),
      child: SizedBox(
        width: width,
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
              bottom: Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Video
              Container(
                width: width,
                height: 96.h,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child:
                    isVideo &&
                        blog.featuredImage != null &&
                        blog.featuredImage!.isNotEmpty
                    ? Stack(
                        children: [
                          VideoPlayerWidget(
                            videoUrl: blog.featuredImage!,
                            autoPlay: false,
                            showControls: false,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 32.w,
                              ),
                            ),
                          ),
                        ],
                      )
                    : blog.featuredImage != null &&
                          blog.featuredImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: blog.featuredImage!,
                        width: width,
                        height: 96.h,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Icon(
                            Icons.image,
                            size: 40.w,
                            color: Colors.grey,
                          );
                        },
                      )
                    : Icon(Icons.image, size: 40.w, color: Colors.grey),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(11.99.w),
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
                          '${blog.readingTime ?? 0} min',
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

  Widget _buildRemedyCard(CategoryModel category, double width) {
    return GestureDetector(
      onTap: () {
        // Navigate to product list with category filter
        if (category.id != null) {
          Get.toNamed('/product-list', arguments: {'category': category});
        } else if (category.slug != null) {
          Get.toNamed(
            '/product-list',
            arguments: {'categorySlug': category.slug},
          );
        }
      },
      child: Container(
        width: width,
        height: 150.h,
        decoration: BoxDecoration(
          color: "#E9F6FE".toColor(),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 18.93,
              offset: const Offset(3.15, 3.15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image - Network image from category
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: category.image != null && category.image!.isNotEmpty
                  ? NetworkImageWithLoader(
                      url: category.image!,
                      width: width,
                      height: 150.h,
                    )
                  : Container(
                      width: width,
                      height: 150.h,
                      color: "#E9F6FE".toColor(),
                      child: Icon(
                        Icons.category,
                        size: 40.w,
                        color: Colors.grey,
                      ),
                    ),
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      "#6F221E".toColor().withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Label at bottom
            Positioned(
              bottom: 4.h,
              left: 10.w,
              right: 4.w,
              child: AutoTranslateText(
                category.name ?? 'Category',
                style: MyTextTheme.smallBCN
                    .copyWith(
                      color: "#FFFFFF".toColor(),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.04,
                      height: 1.5,
                    )
                    .merge(AppTypography.body2),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
              Spacing.h(16),
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
            Spacing.h(16),
            // Horizontal Scrollable List
            SizedBox(
              height: 295.h,
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
    final experience = 'Experience: ${astrologer.experienceYears} years';
    final languages = astrologer.languages.isNotEmpty
        ? astrologer.languages.join('/')
        : 'Hindi/English';
    final voicePricePerMin = astrologer.services.voice.pricePerMinute ?? 0;
    final videoPricePerMin = astrologer.services.video.pricePerMinute ?? 0;
    final chatPrice = astrologer.services.chat.pricePerMinute ?? 0;
    final voicePrice = voicePricePerMin > 0
        ? '${voicePricePerMin.toInt()}/Min'
        : '0';
    final videoPrice = videoPricePerMin > 0
        ? '${videoPricePerMin.toInt()}/Min'
        : '0';
    final chatPriceText = chatPrice > 0 ? '${chatPrice.toInt()}/Msg' : '0';

    final videoPriceHighlight = videoPrice;
    final voicePriceHighlight = voicePrice;
    final chatPriceHighlight = chatPriceText;
    final imagePath = astrologer.profilePicture ?? '';
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.astrologerDetail,
          arguments: {'astrologer': astrologer},
        );
      },
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          border: Border.all(color: "#F38B3B".toColor(), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.h(16),
            // Profile Image with Decorative Border
            Stack(
              alignment: Alignment.center,
              children: [
                // Background image
                Container(
                  width: 135.w,
                  height: 135.w,
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
                // Decorative border with Sanskrit text (simulated with circular border)

                // Profile Image
                Container(
                  width: 90.w,
                  height: 90.w,
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
              ],
            ),
            Spacing.h(12),
            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AutoTranslateText(
                name,
                style: MyTextTheme.mediumBCB
                    .copyWith(
                      color: "#361515".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.body1),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(4),
            // Experience
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AutoTranslateText(
                experience,
                style: MyTextTheme.smallBCN
                    .copyWith(color: "#909090".toColor(), fontSize: 11.sp)
                    .merge(AppTypography.body2),
                textAlign: TextAlign.center,
              ),
            ),
            Spacing.h(8),
            // Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '₹  Video: $videoPriceHighlight ',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                  Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '₹  Voice: $voicePriceHighlight ',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                  Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '₹  Chat: $chatPriceHighlight ',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                ],
              ),
            ),

            Spacing.h(8),
            // Languages with icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language, size: 14.w, color: "#909090".toColor()),
                  Spacing.w(4),
                  Expanded(
                    child: AutoTranslateText(
                      ': $languages',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyTextTheme.smallBCN
                          .copyWith(color: "#909090".toColor(), fontSize: 11.sp)
                          .merge(AppTypography.body2),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(16),
          ],
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
      onTap: () {
        Get.toNamed('/ai-guider');
      },
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

  Widget _buildAstrologerActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _goldPillButton(
            icon: 'assets/icons/chat_with_astro.png',
            label: 'Chat with Astrologer',
            onTap: () => Get.to(() => const AstrologyServicesView()),
          ),
        ),
        Spacing.w(12),
        Expanded(
          child: _goldPillButton(
            icon: 'assets/icons/call_with_astro.png',
            label: 'Call with Astrologer',
            onTap: () => Get.to(() => const AstrologyServicesView()),
          ),
        ),
      ],
    );
  }

  Widget _goldPillButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 52.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: "#F7C443".toColor().withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, width: 20.w, height: 20.h),
            Spacing.w(8),
            Flexible(
              child: AutoTranslateText(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: MyTextTheme.mediumBCB
                    .copyWith(
                      color: "#820B17".toColor(),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      height: 1.2,
                    )
                    .merge(
                      AppTypography.body2.copyWith(fontWeight: FontWeight.w900),
                    ),
              ),
            ),
          ],
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
              height: 450.h,
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
      if (controller.isLoadingAiAstrologers.value) {
        return Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'AI ASTROLOGERS',
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

      if (controller.aiAstrologersPersonas.isEmpty) {
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
                AutoTranslateText(
                  'AI ASTROLOGERS',
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
                    Get.toNamed(
                      AppRoutes.aichat,
                      arguments: {'showBackButton': true},
                    );
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
            Spacing.h(16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.aiAstrologersPersonas.asMap().entries.map((
                  entry,
                ) {
                  final index = entry.key;
                  final persona = entry.value;
                  return Row(
                    children: [
                      _buildAIAstrologerCard(persona, index, context),
                      if (index < controller.aiAstrologersPersonas.length - 1)
                        Spacing.w(15.99),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAIAstrologerCard(PersonaModel persona, index, context) {
    // Map persona data to card display
    final title = persona.displayName;
    final subtitle = persona.category.isNotEmpty
        ? persona.category
        : (persona.specializations.isNotEmpty
              ? persona.specializations.first
              : 'AI Astrologer');
    final tags = persona.tags.isNotEmpty
        ? persona.tags.take(3).toList()
        : (persona.specializations.isNotEmpty
              ? persona.specializations.take(3).toList()
              : ['Astrology', 'Consultation', 'Guidance']);
    final imagePath = persona.image ?? '';
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.personaDetail,
          arguments: {'personaId': persona.id, 'persona': persona},
        );
      },
      child: Container(
        width: 255.99.w,
        height: 265.h,
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
            SingleChildScrollView(
              child: SizedBox(
                height: 265.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image with emoji overlay - moved to top
                    SizedBox(
                      // width: 224.w,
                      height: 130.h,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: imagePath.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imagePath,
                                    width: double.infinity,
                                    // height: 127.99.h,
                                    fit: BoxFit.cover,

                                    errorWidget: (context, url, error) {
                                      return Container(
                                        width: 224.w,
                                        height: 127.99.h,
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
                                    width: 224.w,
                                    height: 127.99.h,
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
                    Spacing.h(8),
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
                              height: 1.2,
                              fontSize: 16.sp,
                            )
                            .merge(AppTypography.h2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacing.h(3),
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
                                height: 1.2,
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacing.w(4),
                          Row(
                            children: [
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: "#05DF72".toColor().withOpacity(0.91),
                                ),
                              ),
                              Spacing.w(4),
                              AutoTranslateText(
                                'Online',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#E3B341".toColor(),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  height: 1.2,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacing.h(8),
                    // Tags
                    Padding(
                      padding: AppPaddings.symmetric(h: 10),
                      child: Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: tags
                            .map(
                              (tag) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 7.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: "#E3B341".toColor().withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    17722700.r,
                                  ),
                                  border: Border.all(
                                    color: "#E3B341".toColor().withOpacity(0.3),
                                    width: 0.53,
                                  ),
                                ),
                                child: AutoTranslateText(
                                  tag,
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: "#FFF6C2".toColor(),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    height: 1.33,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Spacer(),
                    // Chat Now button
                    Padding(
                      padding: AppPaddings.symmetric(h: 10),
                      child: Row(
                        spacing: 10.w,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 5.h,
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
                                    Spacing.w(3),
                                    Flexible(
                                      child: AutoTranslateText(
                                        'Chat Now',
                                        style: MyTextTheme.smallBCN.copyWith(
                                          color: "#FFFFFF".toColor(),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                          height: 1.2,
                                          fontSize: 10.sp,
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
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
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
                                    Spacing.w(3),
                                    Flexible(
                                      child: AutoTranslateText(
                                        'Call Now',
                                        style: MyTextTheme.smallBCN.copyWith(
                                          color: "#FFFFFF".toColor(),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                          height: 1.2,
                                          fontSize: 10.sp,
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
                    Spacing.h(12),
                  ],
                ),
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
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
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
                    Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: "#6F221E".toColor(), // Dark maroon
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/app/logo1.png',
                              width: 40.w,
                              height: 40.h,
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
                        Spacing.w(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoTranslateText(
                              'AstroBharat AI',
                              style: MyTextTheme.mediumBCB
                                  .copyWith(
                                    color: "#6F221E".toColor(), // Dark maroon
                                    fontWeight: FontWeight.bold,
                                  )
                                  .merge(AppTypography.h2),
                            ),
                            AutoTranslateText(
                              'Divine Guidance',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF5F2221).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
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
              Container(
                margin: AppPaddings.symmetric(h: 16),
                padding: AppPaddings.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // White card background
                  borderRadius: AppRadius.all(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: "#F38B3B".toColor(), // Orange
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30.w,
                          ),
                        ),
                        Spacing.w(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller != null
                                  ? Obx(
                                      () => AutoTranslateText(
                                        controller.userName.value.isNotEmpty
                                            ? controller.userName.value
                                            : 'Rajesh Kumar',
                                        style: MyTextTheme.mediumBCB
                                            .copyWith(
                                              color: "#6F221E"
                                                  .toColor(), // Dark maroon
                                              fontWeight: FontWeight.bold,
                                            )
                                            .merge(AppTypography.h3),
                                      ),
                                    )
                                  : AutoTranslateText(
                                      'Rajesh Kumar',
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(
                                            color: "#6F221E"
                                                .toColor(), // Dark maroon
                                            fontWeight: FontWeight.bold,
                                          )
                                          .merge(AppTypography.h3),
                                    ),
                              Spacing.h(4),
                              Row(
                                children: [
                                  Container(
                                    padding: AppPaddings.symmetric(h: 6, v: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9C27B0), // Purple
                                      borderRadius: AppRadius.all(8),
                                    ),
                                    child: AutoTranslateText(
                                      'Virgo',
                                      style: MyTextTheme.smallBCN
                                          .copyWith(color: Colors.white)
                                          .merge(AppTypography.label),
                                    ),
                                  ),
                                  Spacing.w(6),
                                  Icon(
                                    Icons.star,
                                    color: const Color(0xFFFFD700), // Gold
                                    size: 14.w,
                                  ),
                                  Spacing.w(4),
                                  AutoTranslateText(
                                    'Premium',
                                    style: MyTextTheme.smallBCN
                                        .copyWith(
                                          color: const Color(
                                            0xFFFFD700,
                                          ), // Gold
                                        )
                                        .merge(AppTypography.label),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItemStatic('12', 'Consults'),
                        _buildStatItemStatic('4', 'Orders'),
                        Obx(() {
                          final walletController =
                              Get.isRegistered<WalletController>()
                              ? Get.find<WalletController>()
                              : null;
                          final balance =
                              walletController?.walletBalance.value ?? 0.0;
                          final formattedBalance = balance >= 1000
                              ? '₹${(balance / 1000).toStringAsFixed(1)}K'
                              : '₹${balance.toStringAsFixed(0)}';
                          return _buildStatItemStatic(
                            formattedBalance,
                            'Wallet',
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.h(24),
              // EXPLORE Section
              Padding(
                padding: AppPaddings.symmetric(h: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'EXPLORE',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(
                          0xFF5F2221,
                        ).withOpacity(0.6), // Dark maroon with opacity
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacing.h(12),
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
                        Get.toNamed('/ai-guider');
                      },
                    ),
                    _buildDrawerItemStatic(
                      context: context,
                      icon: Icons.people,
                      label: 'Consult Expert',
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.toNamed(AppRoutes.astrologyServices);
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
                      icon: Icons.book,
                      label: 'Kundli',
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.toNamed(AppRoutes.kundliForm);
                      },
                    ),
                    _buildDrawerItemStatic(
                      context: context,
                      icon: Icons.favorite,
                      label: 'Virtual Temple',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    _buildDrawerItemStatic(
                      context: context,
                      icon: Icons.shopping_bag,
                      label: 'DigitalShop',
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.offNamed(
                          '/user-shop',
                          id: 1,
                          arguments: {'showBackButton': true},
                        );
                      },
                    ),
                  ],
                ),
              ),
              Spacing.h(24),
              Divider(
                color: const Color(
                  0xFF5F2221,
                ).withOpacity(0.2), // Dark maroon with opacity
                thickness: 1,
              ),
              Spacing.h(12),
              // ACCOUNT Section
              Padding(
                padding: AppPaddings.symmetric(h: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'ACCOUNT',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(
                          0xFF5F2221,
                        ).withOpacity(0.6), // Dark maroon with opacity
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacing.h(12),
                    Obx(() {
                      final walletController =
                          Get.isRegistered<WalletController>()
                          ? Get.find<WalletController>()
                          : null;
                      final balance =
                          walletController?.walletBalance.value ?? 0.0;
                      return _buildDrawerItemStatic(
                        context: context,
                        icon: Icons.account_balance_wallet,
                        label: 'Wallet',
                        trailing: AutoTranslateText(
                          walletController?.formatCurrency(balance) ?? '₹0',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#F38B3B".toColor(), // Orange
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Get.toNamed(AppRoutes.wallet);
                        },
                      );
                    }),
                    _buildDrawerItemStatic(
                      context: context,
                      icon: Icons.shopping_bag_outlined,
                      label: 'My Orders',
                      trailing: Container(
                        padding: AppPaddings.symmetric(h: 8, v: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF38B3B), // Orange
                          shape: BoxShape.circle,
                        ),
                        child: AutoTranslateText(
                          '4',
                          style: MyTextTheme.smallBCN
                              .copyWith(color: Colors.white)
                              .merge(AppTypography.label),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.toNamed(AppRoutes.orders);
                      },
                    ),
                    _buildDrawerItemStatic(
                      context: context,
                      icon: Icons.phone,
                      label: 'My Bookings',
                      trailing: Container(
                        padding: AppPaddings.symmetric(h: 8, v: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF38B3B), // Orange
                          shape: BoxShape.circle,
                        ),
                        child: AutoTranslateText(
                          '4',
                          style: MyTextTheme.smallBCN
                              .copyWith(color: Colors.white)
                              .merge(AppTypography.label),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
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
            // Show "live stream is ended" message
            Get.snackbar(
              'Stream Ended',
              'Live stream is ended',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        }
      },
      child: Stack(
        children: [
          Column(
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
              Spacing.h(6),
              SizedBox(
                width: 70.w,
                child: AutoTranslateText(
                  stream.astrologerName,
                  style: AppTypography.body2.copyWith(
                    color: "#3D0C11".toColor(),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 37,
            left: 0,
            right: 0,
            child: Center(
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
                    Text(
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
          // Show "live stream is ended" message
          Get.snackbar(
            'Stream Ended',
            'Live stream is ended',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Stack(
        children: [
          Column(
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
              Spacing.h(6),
              SizedBox(
                width: 70.w,
                child: AutoTranslateText(
                  astrologerName,
                  style: AppTypography.body2.copyWith(
                    color: "#3D0C11".toColor(),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 37,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.red,
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
                    Text(
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
          ),
        ],
      ),
    );
  }
}
