import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/controllers/course_detail_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class CourseDetailView extends StatelessWidget {
  final String courseId;

  const CourseDetailView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseDetailController(courseId: courseId));

    return Scaffold(
      backgroundColor: Colors.white,
      // endDrawer: const CommonEndDrawer(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.courseDetail.value == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGradient.colors.first,
                ),
              ),
            );
          }

          if (controller.courseDetail.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: AppColors.primaryGradient.colors.first,
                  ),
                  SizedBox(height: 16.h),
                  AutoTranslateText(
                    'Failed to load course',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }

          final courseDetail = controller.courseDetail.value!;
          final course = courseDetail.course;
          final isEnrolled = controller.isEnrolled.value;

          return Column(
            children: [
              const CommonHeader(title: 'Course Detail'),
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Hero Section with Video Thumbnail
                      _buildHeroSection(course, controller),

                      // Course Info Section (Rating etc)
                      _buildRatingSection(course),

                      // Instructor Card
                      _buildInstructorCard(course),

                      // Course Meta Cards
                      _buildCourseMetaCards(courseDetail),

                      // Navigation Tabs
                      CommonTabSlider(
                        tabs: const ['Overview', 'Course Content'],
                        selectedIndex: controller.selectedTab.value,
                        onTabSelected: (index) =>
                            controller.selectedTab.value = index,
                      ),

                      // Tab Content
                      _buildTabContent(courseDetail, controller),

                      // Add bottom padding to account for fixed CTA button
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ),

              // Bottom CTA Button (Fixed at bottom)
              _buildBottomCTA(course, isEnrolled, controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeroSection(
    CourseModel course,
    CourseDetailController controller,
  ) {
    return Stack(
      children: [
        // Thumbnail/Video Background
        Container(
          height: 220.h,
          width: double.infinity,
          color: Colors.black,
          child: course.thumbnail != null && course.thumbnail!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: course.thumbnail!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.black,
                    child: Icon(
                      Icons.school,
                      color: Colors.white54,
                      size: 48.w,
                    ),
                  ),
                )
              : Container(
                  color: Colors.black,
                  child: Icon(Icons.school, color: Colors.white54, size: 48.w),
                ),
        ),

        // Gradient overlay
        Container(
          height: 220.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
            ),
          ),
        ),

        // Bestseller badge
        Positioned(
          bottom: 16.h,
          left: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 16.w,
                ),
                SizedBox(width: 4.w),
                AutoTranslateText(
                  'Bestseller',
                  style: AppTypography.label.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Play button overlay (center)
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: () {
                // TODO: Play preview video
              },
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.primaryGradient.colors.first,
                  size: 36.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(CourseModel course) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating and Student Count
          Row(
            children: [
              Icon(Icons.star, color: AppColors.templeGold, size: 18.w),
              SizedBox(width: 4.w),
              AutoTranslateText(
                '4.8',
                style: AppTypography.body1.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4.w),
              AutoTranslateText(
                '(543)',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              AutoTranslateText(
                '2,543 students',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorCard(CourseModel course) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Picture
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryGradient.colors.first.withValues(
                    alpha: 0.2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryGradient.colors.first,
                  size: 32.w,
                ),
              ),
              SizedBox(width: 12.w),

              // Instructor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      course.instructor,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    AutoTranslateText(
                      '15+ years of experience in Vedic Astrology. Helped 10,000+ students master the ancient science.',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Instructor Stats
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.templeGold, size: 16.w),
                  SizedBox(width: 4.w),
                  AutoTranslateText(
                    '4.9',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              AutoTranslateText(
                '25,430 students',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 16.w),
              AutoTranslateText(
                '12 courses',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseMetaCards(CourseDetailModel courseDetail) {
    final lectures = courseDetail.lectures;

    // Calculate total hours (estimate: 15 min per content item)
    int totalContent = 0;
    for (var lecture in lectures) {
      totalContent += lecture.content.length;
    }
    final totalHours = (totalContent * 15 / 60).toStringAsFixed(0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildMetaCard(
              icon: Icons.access_time,
              label: '$totalHours hours',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildMetaCard(
              icon: Icons.play_circle_outline,
              label: '${lectures.length} lessons',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildMetaCard(
              icon: Icons.school,
              label: 'Beginner to Advanced',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildMetaCard(icon: Icons.download, label: 'Lifetime'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCard({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.templeGold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.templeGold, size: 24.w),
          SizedBox(height: 8.h),
          AutoTranslateText(
            label,
            style: AppTypography.body2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    CourseDetailModel courseDetail,
    CourseDetailController controller,
  ) {
    return Obx(() {
      switch (controller.selectedTab.value) {
        case 0:
          return _buildOverviewTab(courseDetail);
        case 1:
          return _buildCurriculumTab(courseDetail, controller);
        default:
          return _buildOverviewTab(courseDetail);
      }
    });
  }

  Widget _buildOverviewTab(CourseDetailModel courseDetail) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'About This Course',
              style: AppTypography.h2.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              courseDetail.course.description,
              style: AppTypography.body1.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurriculumTab(
    CourseDetailModel courseDetail,
    CourseDetailController controller,
  ) {
    final lectures = courseDetail.lectures;
    final isEnrolled = controller.isEnrolled.value;

    // Sort lectures by order
    final sortedLectures = lectures.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: sortedLectures.map((lecture) {
          return _buildLectureAccordion(lecture, isEnrolled, controller);
        }).toList(),
      ),
    );
  }

  Widget _buildLectureAccordion(
    LectureModel lecture,
    bool isEnrolled,
    CourseDetailController controller,
  ) {
    final isExpanded = controller.lectureExpandedStates[lecture.id] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.templeGold.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Lecture Header
          GestureDetector(
            onTap: () => controller.toggleLecture(lecture.id),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          lecture.title,
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (lecture.description.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          AutoTranslateText(
                            lecture.description,
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primaryGradient.colors.first,
                  ),
                ],
              ),
            ),
          ),

          // Lecture Content (when expanded)
          if (isExpanded)
            ...lecture.content.map((content) {
              return _buildContentItem(
                content,
                isEnrolled,
                lecture,
                controller,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildContentItem(
    ContentModel content,
    bool isEnrolled,
    LectureModel lecture,
    CourseDetailController controller,
  ) {
    // 🔒 UDEMY PRINCIPLE: Content TITLES are always visible
    // Access Rules: Preview content bypasses enrollment, non-preview requires enrollment
    final canAccess = isEnrolled || content.isPreview;

    return GestureDetector(
      onTap: canAccess
          ? () async {
              // Step 4: Enrollment Check Flow (Security Layer) - Final confirmation before unlocking
              final verifiedEnrolled = await controller
                  .verifyEnrollmentBeforeAccess();

              // If not enrolled and not preview, block access
              if (!verifiedEnrolled && !content.isPreview) {
                // Show purchase CTA
                _showPurchaseDialog(controller);
                return;
              }

              controller.selectContent(lecture, content);
              UserMainController.pushInCurrentTab(
                AppRoutes.contentPlayer,
                arguments: {
                  'contentId': content.id,
                  'lectureId': lecture.id,
                  'content': content, // Pass full content object with URL
                  'isEnrolled': verifiedEnrolled,
                  'isPreview': content.isPreview,
                  'courseId': controller.courseId,
                },
              );
            }
          : () {
              // Show purchase CTA for locked content
              _showPurchaseDialog(controller);
            },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: canAccess ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: canAccess
                ? AppColors.templeGold.withValues(alpha: 0.3)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              content.type == 'video'
                  ? Icons.play_circle_outline
                  : Icons.picture_as_pdf,
              color: canAccess
                  ? AppColors.primaryGradient.colors.first
                  : Colors.grey,
              size: 24.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AutoTranslateText(
                content.title,
                style: AppTypography.body1.copyWith(
                  color: canAccess ? AppColors.textPrimary : Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (content.isPreview)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.templeGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: AutoTranslateText(
                  'Preview',
                  style: AppTypography.label.copyWith(
                    color: AppColors.templeGold,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (!canAccess) Icon(Icons.lock, color: Colors.grey, size: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCTA(
    CourseModel course,
    bool isEnrolled,
    CourseDetailController controller,
  ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ElevatedButton(
            onPressed: isEnrolled
                ? () {
                    // Continue Learning - Open Course Player (Udemy behavior)
                    UserMainController.pushInCurrentTab(
                      AppRoutes.coursePlayer,
                      arguments: controller.courseId,
                    );
                  }
                : () {
                    // Not enrolled - Start purchase flow
                    controller.initiatePurchase();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEnrolled ? Icons.play_arrow : Icons.shopping_cart,
                  color: Colors.white,
                  size: 24.w,
                ),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  isEnrolled
                      ? 'Continue Learning'
                      : 'Start Learning - ₹${course.price.toStringAsFixed(0)}',
                  style: AppTypography.h3.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show purchase dialog when content is locked
  void _showPurchaseDialog(CourseDetailController controller) {
    Get.dialog(
      AlertDialog(
        title: const AutoTranslateText('Content Locked'),
        content: const AutoTranslateText(
          'Please enroll in this course to access all content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const AutoTranslateText('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.initiatePurchase();
            },
            child: const AutoTranslateText('Enroll Now'),
          ),
        ],
      ),
    );
  }
}
