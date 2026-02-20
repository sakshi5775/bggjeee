import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/courses/controllers/my_learning_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/data_model/my_learning_model.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyLearningView extends BasePage<MyLearningController> {
  const MyLearningView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    if (!Get.isRegistered<MyLearningController>()) {
      Get.put(MyLearningController());
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // bottomNavigationBar: _buildBottomNav(),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Obx(
                () => CommonHeader(
                  title: 'My Learning',
                  subtitle: AutoTranslateText(
                    '${controller.enrolledCourses.length} courses enrolled',
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF5F2221).withValues(alpha: 0.7),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),

              // Progress Overview
              _buildProgressOverview(),

              // Enrolled Courses
              Expanded(child: _buildEnrolledCourses()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Obx(
      () => Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Overall Progress',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Enrolled',
                    value: '${controller.totalEnrollments}',
                    icon: Icons.school,
                  ),
                ),
                Container(
                  height: 40.h,
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'Completed',
                    value: '${controller.completedCourses}',
                    icon: Icons.check_circle,
                  ),
                ),
                Container(
                  height: 40.h,
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'In Progress',
                    value: '${controller.inProgressCourses}',
                    icon: Icons.play_circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Overall completion percentage
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: controller.overallCompletionPercentage / 100,
                    backgroundColor: AppColors.textSecondary.withValues(
                      alpha: 0.1,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.saffron,
                    ),
                    minHeight: 8.h,
                  ),
                ),
                SizedBox(width: 12.w),
                AutoTranslateText(
                  '${controller.overallCompletionPercentage.toStringAsFixed(0)}%',
                  style: AppTypography.body1.copyWith(
                    color: AppColors.saffron,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.saffron, size: 24.w),
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
    );
  }

  Widget _buildEnrolledCourses() {
    return Obx(() {
      if (controller.isLoading.value && controller.enrolledCourses.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.saffron),
        );
      }

      if (controller.enrolledCourses.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64.w,
                  color: AppColors.saffron.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  'No enrolled courses',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                AutoTranslateText(
                  'Start learning by enrolling in a course',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.saffron,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.enrolledCourses.length,
          itemBuilder: (context, index) {
            final enrollment = controller.enrolledCourses[index];
            return _buildEnrolledCourseCard(enrollment);
          },
        ),
      );
    });
  }

  Widget _buildEnrolledCourseCard(EnrollmentData enrollment) {
    final course = enrollment.course;
    final progress = enrollment.progress;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Container(
                  height: 160.h,
                  width: double.infinity,
                  color: Colors.black,
                  child:
                      course.thumbnail != null && course.thumbnail!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
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
                          child: Icon(
                            Icons.school,
                            color: Colors.white54,
                            size: 48.w,
                          ),
                        ),
                ),
              ),

              // Progress badge
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AutoTranslateText(
                    '${progress.completionPercentage.toStringAsFixed(0)}%',
                    style: AppTypography.label.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Title
                AutoTranslateText(
                  course.title,
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // Instructor
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: AutoTranslateText(
                        course.instructor,
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoTranslateText(
                          'Progress',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                        AutoTranslateText(
                          '${progress.completionPercentage.toStringAsFixed(0)}%',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.saffron,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    LinearProgressIndicator(
                      value: progress.completionPercentage / 100,
                      backgroundColor: AppColors.textSecondary.withValues(
                        alpha: 0.1,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.saffron,
                      ),
                      minHeight: 6.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Open Course Player directly (Udemy behavior)
                      Get.toNamed(AppRoutes.coursePlayer, arguments: course.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: AutoTranslateText(
                      'Continue Learning',
                      style: AppTypography.body1.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

