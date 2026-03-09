import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import '../../../app_manager/network_image.dart';

// ══════════════════════════════════════════════════
// Entry point — triggers fetch then opens sheet
// ══════════════════════════════════════════════════
Future<void> showCourseTypeSheet({
  required String courseType,
  required String courseLabel,
  required IconData icon,
  required bool isDark,
}) {
  final controller = Get.find<CoursesController>();
  controller.fetchCoursesByType(courseType);

  return Get.bottomSheet(
    _CourseTypeSheet(courseLabel: courseLabel, icon: icon, isDark: isDark),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    ignoreSafeArea: false,
  );
}

// ══════════════════════════════════════════════════
// Bottom sheet — pure StatelessWidget
// All state lives in CoursesController (Obx-driven)
// ══════════════════════════════════════════════════
class _CourseTypeSheet extends StatelessWidget {
  final String courseLabel;
  final IconData icon;
  final bool isDark;

  const _CourseTypeSheet({
    required this.courseLabel,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();
    final sheetMaxH = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: sheetMaxH,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Drag handle ──
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 4.h),

          // ── Header card ──
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        const Color(0xFF3E1212),
                        AppColors.textColorMaroon,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24.w),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        courseLabel,
                        style: AppTypography.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Obx(
                        () => AutoTranslateText(
                          ctrl.isCourseTypeLoading.value
                              ? 'Loading courses...'
                              : '${ctrl.courseTypeCourses.length} course${ctrl.courseTypeCourses.length == 1 ? '' : 's'} available',
                          style: AppTypography.label.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18.w),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // ── Body ──
          Expanded(
            child: Obx(() {
              // Loading
              if (ctrl.isCourseTypeLoading.value) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 48.w,
                        height: 48.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.deepOrange,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AutoTranslateText(
                        'Fetching courses...',
                        style: AppTypography.body2.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Error
              if (ctrl.courseTypeError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 48.w,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 12.h),
                      AutoTranslateText(
                        'Failed to load courses',
                        style: AppTypography.body1.copyWith(
                          color: AppColors.textColorMaroon,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Empty
              if (ctrl.courseTypeCourses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 56.w,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 12.h),
                      AutoTranslateText(
                        'No courses available yet',
                        style: AppTypography.body1.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        'Check back soon!',
                        style: AppTypography.label.copyWith(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Course list
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                itemCount: ctrl.courseTypeCourses.length,
                separatorBuilder: (_, __) => SizedBox(height: 14.h),
                itemBuilder: (_, index) => _CourseCard(
                  course: ctrl.courseTypeCourses[index],
                  isDark: isDark,
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
// Course card — pure StatelessWidget
// Description expanded state → CoursesController.descExpandedMap
// ══════════════════════════════════════════════════
class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isDark;

  const _CourseCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();
    final priceText = course.price == 0
        ? 'FREE'
        : '₹${course.price.toStringAsFixed(0)}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD68D3C).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: NetworkImageWithLoader(
                url: course.thumbnail!,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── Body ──
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Row(
                  children: [
                    if (course.pillar != null && course.pillar!.isNotEmpty)
                      _buildTag(
                        course.pillar!.toUpperCase(),
                        AppColors.deepOrange,
                      ),
                    if (course.pillar != null && course.pillar!.isNotEmpty)
                      SizedBox(width: 6.w),
                    _buildTag(
                      '${course.lectureIds.length} lectures',
                      Colors.grey.shade500,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Title
                AutoTranslateText(
                  course.title,
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorMaroon,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                // ── Description + Read More (Obx-scoped to description only) ──
                Obx(() {
                  final expanded = ctrl.descExpandedMap[course.id] ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: expanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: AutoTranslateText(
                          course.description,
                          style: AppTypography.label.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: AutoTranslateText(
                          course.description,
                          style: AppTypography.label.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (course.description.length > 120)
                        GestureDetector(
                          onTap: () => ctrl.toggleDescExpanded(course.id),
                          child: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoTranslateText(
                                  expanded ? 'Show less' : 'Read more',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.deepOrange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  expanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 16.w,
                                  color: AppColors.deepOrange,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                SizedBox(height: 10.h),

                // Instructor
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14.w,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AutoTranslateText(
                        course.instructor,
                        style: AppTypography.label.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // Price + Buttons
                Row(
                  children: [
                    // Price chip
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: course.price == 0
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFF6E5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AutoTranslateText(
                        priceText,
                        style: AppTypography.body2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: course.price == 0
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFD68D3C),
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Cancel
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: AutoTranslateText(
                          'Cancel',
                          style: AppTypography.label.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // Enroll Now
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        // TODO: replace with navigation when courseDetail route is ready
                        // UserMainController.pushInCurrentTab(AppRoutes.courseDetail, arguments: course.id);
                        Get.snackbar(
                          'Coming Soon',
                          'Enrollment for "${course.title}" will be available shortly.',
                          backgroundColor: AppColors.textColorMaroon,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16.w),
                          borderRadius: 12.r,
                          duration: const Duration(seconds: 3),
                          icon: Icon(Icons.school, color: AppColors.templeGold),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF3E1212),
                                    AppColors.textColorMaroon,
                                  ],
                                )
                              : AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.deepOrange.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AutoTranslateText(
                          'Enroll Now',
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}

// ── File-level helpers ──────────────────────────

Widget _buildTag(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: AutoTranslateText(
      text,
      style: AppTypography.label.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 10,
      ),
    ),
  );
}
