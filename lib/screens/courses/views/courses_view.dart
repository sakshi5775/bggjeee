import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/screens/courses/widgets/digital_learning_banner_slider.dart';
import 'package:astrobharataiuser/screens/courses/widgets/key_course_modules_section.dart';
import 'package:astrobharataiuser/screens/courses/widgets/learning_features_section.dart';
import 'package:astrobharataiuser/screens/courses/widgets/learning_journey_section.dart';
import 'package:astrobharataiuser/screens/courses/widgets/mastery_bundles_section.dart';
import 'package:astrobharataiuser/screens/courses/widgets/premium_course_card.dart';
import 'package:astrobharataiuser/screens/courses/widgets/quick_connect_section.dart';
import 'package:astrobharataiuser/screens/courses/widgets/spiritual_pillars_grid.dart';
import 'package:astrobharataiuser/screens/courses/widgets/trusted_education_section.dart';
import 'package:astrobharataiuser/screens/courses/widgets/why_choose_us_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CoursesView extends BasePage<CoursesController> {
  final bool showBackButton;
  final bool hideHeader;

  const CoursesView({
    super.key,
    this.showBackButton = true,
    this.hideHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          try {
            final mainController = Get.find<UserMainController>();
            mainController.selectedIndex.value = 0;
          } catch (e) {
            // Controller not found, ignore
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // bottomNavigationBar: hideHeader ? null : _buildBottomNav(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: hideHeader
              ? null
              : BoxDecoration(gradient: AppColors.gradientBackground),
          color: hideHeader ? Colors.transparent : null,
          child: SafeArea(
            top: !hideHeader,
            child: Column(
              children: [
                if (!hideHeader)
                  CommonHeader(
                    title: 'Digital Learning',
                    showBackButton: showBackButton,
                    onMenuTap: showBackButton
                        ? null
                        : () {
                            final scaffoldState = context
                                .findAncestorStateOfType<ScaffoldState>();
                            scaffoldState?.openDrawer();
                          },
                    customActions: [
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.myLearning);
                        },
                        icon: Icon(
                          Icons.school,
                          color: const Color(0xFF6F221E),
                          size: 24.w,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'My Learning',
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.liveWebinars);
                        },
                        icon: Icon(
                          Icons.video_library,
                          color: const Color(0xFF6F221E),
                          size: 24.w,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Webinar',
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Add Common Slider
                        if (!hideHeader)
                          Obx(
                            () => CommonTabSlider(
                              tabs: const ['Courses', 'Webinars'],
                              selectedIndex: controller.selectedCategory.value,
                              onTabSelected: (index) {
                                if (index == 1) {
                                  Get.toNamed(AppRoutes.liveWebinars);
                                } else {
                                  controller.selectedCategory.value = index;
                                }
                              },
                            ),
                          ),

                        if (!hideHeader) ...[
                          Obx(
                            () => controller.hasLiveWebinar.value
                                ? _buildLiveWebinarBanner()
                                : const SizedBox.shrink(),
                          ),
                        ],
                        Spacing.h(20),
                        _buildCoursesSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveWebinarBanner() {
    return Obx(() {
      final webinar = controller.liveWebinar.value;
      if (webinar == null) return const SizedBox.shrink();

      // Calculate time difference
      String timeStatus = "Starting soon";
      int minutes = 0;

      if (webinar.scheduling?.scheduledStartTime != null) {
        final now = DateTime.now();
        final start = webinar.scheduling!.scheduledStartTime!;
        final difference = start.difference(now);
        minutes = difference.inMinutes;

        if (minutes > 0) {
          timeStatus = "Starting in $minutes min";
        } else {
          timeStatus = "Started ${minutes.abs()} min ago";
        }
      } else if (webinar.status == 'LIVE') {
        timeStatus = "Live Now";
      }

      return GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.liveWebinars);
        },
        child: Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Image Overlay (Optional)
              if (webinar.thumbnail != null && webinar.thumbnail!.isNotEmpty)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.network(
                        webinar.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LIVE badge
                    if (webinar.status == 'LIVE' ||
                        (minutes <= 10 && minutes >= -120))
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 8.w),
                            SizedBox(width: 4.w),
                            AutoTranslateText(
                              'LIVE NOW',
                              style: AppTypography.label.copyWith(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 12.h),

                    // Title
                    AutoTranslateText(
                      'Join Live Webinar',
                      style: AppTypography.h2.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Description
                    AutoTranslateText(
                      '"${webinar.title}" - $timeStatus',
                      style: AppTypography.body1.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16.h),

                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // FREE button (Assuming free for now, or check pricing)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: AutoTranslateText(
                            'FREE', // Or Check webinar.isFree
                            style: AppTypography.body2.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Watchers count with tap to navigate
                        Row(
                          children: [
                            Obx(
                              () => AutoTranslateText(
                                '${controller.liveWebinarViewers.value} watching',
                                style: AppTypography.body2.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 14.w,
                            ),
                          ],
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
    });
  }

  Widget _buildCoursesSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Digital Learning Banner Slider (Video/Image)
          Obx(() {
            if (controller.learningBanners.isNotEmpty) {
              return BannerCarouselWidget(banners: controller.learningBanners);
            }
            return const DigitalLearningBannerSlider();
          }),

          // 2. Learning Features Section
          const LearningFeaturesSection(),

          // 3. Spiritual Pillars Grid
          SpiritualPillarsGrid(),

          // 4. Learning Journey Section (Before Courses)
          const LearningJourneySection(),

          // 5. Mastery Bundles Section
          const MasteryBundlesSection(),

          // 6. Key Course Modules Section
          const KeyCourseModulesSection(),

          // 7. Why Choose Us Section
          const WhyChooseUsSection(),

          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Explore Our Premium Courses',
                  style: AppTypography.h2.copyWith(
                    color: const Color(0xFFD68D3C), // Orange/Gold
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // 6. Premium Courses List
          Obx(() {
            if (controller.isLoading.value && controller.courses.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(32.w),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGradient.colors.first,
                    ),
                  ),
                ),
              );
            }

            if (controller.courses.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(32.w),
                child: Center(
                  child: AutoTranslateText(
                    'No courses found',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }

            final filteredCourses = controller.getFilteredCourses();

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: filteredCourses.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return PremiumCourseCard(
                  course: course,
                  onTap: () {
                    Get.toNamed(AppRoutes.courseDetail, arguments: course.id);
                  },
                );
              },
            );
          }),

          // 7. Trusted Education Section
          const TrustedEducationSection(),
          const QuickConnectSection(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
