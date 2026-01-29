import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/screens/courses/widgets/course_card.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/user_bottom_nav.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
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
    return WillPopScope(
      onWillPop: () async {
        try {
          final mainController = Get.find<UserMainController>();
          mainController.selectedIndex.value = 0;
        } catch (e) {
          // Controller not found, ignore
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: hideHeader ? null : _buildBottomNav(),
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
                if (!hideHeader) _buildHeader(),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!hideHeader) ...[
                          Obx(
                            () => controller.hasLiveWebinar.value
                                ? _buildLiveWebinarBanner()
                                : const SizedBox.shrink(),
                          ),
                          _buildCategoryTabs(),
                        ],
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

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Back Arrow (conditional)
          if (showBackButton) ...[
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.w,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: 12.w),
          ],

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Digital Learning',
                  style: AppTypography.h2.copyWith(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                AutoTranslateText(
                  'Expand Your Knowledge',
                  style: AppTypography.body2.copyWith(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          // My Learning Icon (Progress Report)
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.myLearning);
            },
            icon: Icon(Icons.school, color: Colors.white, size: 24.w),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'My Learning',
          ),

          // Filter Icon
          // IconButton(
          //   onPressed: () {

          //   },
          //   icon: Icon(Icons.filter_list, color: Colors.white, size: 24.w),
          //   padding: EdgeInsets.zero,
          //   constraints: const BoxConstraints(),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        ),
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            hintText: 'Search Courses & Book',
            hintStyle: AppTypography.body1.copyWith(
              color: const Color(0xFF999999),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.primaryGradient.colors.first,
              size: 20.w,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          style: AppTypography.body1.copyWith(color: AppColors.textPrimary),
          onSubmitted: (value) {
            controller.searchQuery.value = value;
            controller.loadCourses(refresh: true);
          },
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

      return Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
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
                          color: Colors.white.withOpacity(0.2),
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
                      GestureDetector(
                        onTap: () {
                          // Pass arguments if needed or just navigate
                          Get.toNamed(AppRoutes.liveWebinars);
                        },
                        child: Row(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _buildStatCard(
                icon: Icons.school,
                value: controller.courses.isEmpty && controller.isLoading.value
                    ? '0'
                    : '${controller.courses.length}',
                label: 'Courses',
              ),
            ),
          ),
          // SizedBox(width: 12.w),
          // Expanded(
          //   child: Obx(
          //     () => _buildStatCard(
          //       icon: Icons.menu_book,
          //       value: '${controller.eBooksCount.value}',
          //       label: 'E-Books',
          //     ),
          //   ),
          // ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(
              () => _buildStatCard(
                icon: Icons.emoji_events,
                value: '${controller.studentsCount.value}',
                label: 'Students',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAEAAF), // Cream
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.templeGold, size: 32.w),
          SizedBox(height: 8.h),
          AutoTranslateText(
            value,
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          AutoTranslateText(
            label,
            style: AppTypography.body2.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton('All', 0),
            SizedBox(width: 12.w),
            _buildTabButton('Courses', 1),
            SizedBox(width: 12.w),
            _buildTabButton('Webinars', 3), // Live Webinars
            // SizedBox(width: 12.w),
            // _buildTabButton('E-Books', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (index == 3) {
            Get.toNamed(AppRoutes.liveWebinars);
          } else {
            controller.selectedCategory.value = index;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: controller.selectedCategory.value == index
                ? AppColors.orangeGradient
                : null,
            color: controller.selectedCategory.value == index
                ? null
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: controller.selectedCategory.value == index
                  ? Colors.transparent
                  : Colors.grey.shade300,
            ),
          ),
          child: AutoTranslateText(
            label,
            style: AppTypography.body1.copyWith(
              color: controller.selectedCategory.value == index
                  ? Colors.white
                  : AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: controller.selectedCategory.value == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Obx(() {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64.w,
                  color: AppColors.primaryGradient.colors.first.withOpacity(
                    0.5,
                  ),
                ),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  'No courses found',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Filter courses based on selected category
      final filteredCourses = controller.getFilteredCourses();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hideHeader) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        color: AppColors.primaryGradient.colors.first,
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Courses',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to all courses
                    },
                    child: Row(
                      children: [
                        AutoTranslateText(
                          'View All',
                          style: AppTypography.body1.copyWith(
                            color: AppColors.primaryGradient.colors.first,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryGradient.colors.first,
                          size: 14.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 16.h,
                childAspectRatio: 2.5,
              ),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return CourseCard(
                  course: course,
                  onTap: () {
                    Get.toNamed(AppRoutes.courseDetail, arguments: course.id);
                  },
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      );
    });
  }

  Widget _buildBottomNav() {
    try {
      final mainController = Get.find<UserMainController>();
      return UserBottomNav(
        onTap: (index) {
          mainController.changePage(index);
        },
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
