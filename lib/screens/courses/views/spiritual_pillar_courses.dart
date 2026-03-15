import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Screen that lists courses filtered by **Course Type** and **Pillar**.
///
/// The pillar ID is pre-set from the previous screen (SpiritualPillarsGrid).
/// Only the Course Type filter is shown — the first one is auto-selected
/// on load and courses are fetched immediately.
class SpiritualPillarCoursesView extends StatelessWidget {
  const SpiritualPillarCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();

    // Auto-select defaults if nothing selected & data is ready
    _initDefaults(ctrl);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      // endDrawer: const CommonEndDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonHeader(title: 'Explore Courses'),
          // ── Filter section ──
          _FilterSection(),

          // ── Course list ──
          Expanded(child: _CoursesList()),
        ],
      ),
    );
  }

  void _initDefaults(CoursesController ctrl) {
    // Pillar ID is already set from the previous screen.
    // Auto-select the first courseType if not yet set.
    if (ctrl.selectedCourseTypeId.value.isEmpty &&
        ctrl.courseTypesList.isNotEmpty) {
      ctrl.selectedCourseTypeId.value = ctrl.courseTypesList.first.id;
      ctrl.fetchPillarCourses();
    } else if (ctrl.selectedCourseTypeId.value.isEmpty) {
      // courseTypes not loaded yet — listen for it
      ever<dynamic>(ctrl.courseTypesList, (_) {
        if (ctrl.selectedCourseTypeId.value.isEmpty &&
            ctrl.courseTypesList.isNotEmpty) {
          ctrl.selectedCourseTypeId.value = ctrl.courseTypesList.first.id;
          ctrl.fetchPillarCourses();
        }
      });
    } else {
      // Both IDs are already set — fetch immediately
      ctrl.fetchPillarCourses();
    }
  }
}

// ══════════════════════════════════════════════════
// Filter chips — only Course Type (pillar is pre-set)
// ══════════════════════════════════════════════════
class _FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Course Type filter ──
          AutoTranslateText(
            'Course Type',
            style: AppTypography.body2.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textColorMaroon,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(() {
            if (ctrl.isCourseTypesLoading.value) {
              return _filterShimmer();
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ctrl.courseTypesList.map((ct) {
                  final selected = ctrl.selectedCourseTypeId.value == ct.id;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _FilterChip(
                      label: ct.name,
                      selected: selected,
                      onTap: () {
                        ctrl.selectedCourseTypeId.value = ct.id;
                        ctrl.fetchPillarCourses();
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _filterShimmer() {
    return SizedBox(
      height: 34.h,
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════
// Styled filter chip
// ══════════════════════════════════════════════════
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.orangeGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : const Color(0xFFD68D3C).withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AutoTranslateText(
          label,
          style: AppTypography.label.copyWith(
            color: selected ? Colors.white : AppColors.textColorMaroon,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════
// Courses list — loading / error / empty / data
// ══════════════════════════════════════════════════
class _CoursesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();

    return Obx(() {
      // Loading
      if (ctrl.isPillarCoursesLoading.value) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 44.w,
                height: 44.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.deepOrange,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
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
      if (ctrl.pillarCoursesError.value.isNotEmpty) {
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
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => ctrl.fetchPillarCourses(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: AutoTranslateText(
                    'Retry',
                    style: AppTypography.label.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Empty
      if (ctrl.pillarCourses.isEmpty) {
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
                'No courses found',
                style: AppTypography.body1.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 4.h),
              AutoTranslateText(
                'Try a different filter combination',
                style: AppTypography.label.copyWith(
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      }

      // Course cards
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        itemCount: ctrl.pillarCourses.length,
        separatorBuilder: (_, __) => SizedBox(height: 14.h),
        itemBuilder: (_, index) =>
            _PillarCourseCard(course: ctrl.pillarCourses[index]),
      );
    });
  }
}

// ══════════════════════════════════════════════════
// Course card — same look as _CourseCard in course_type_bottom_sheet
// ══════════════════════════════════════════════════
class _PillarCourseCard extends StatelessWidget {
  final CourseModel course;

  const _PillarCourseCard({required this.course});

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

                // ── Description + Read More (Obx-scoped) ──
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

                // Price + Enroll
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

                    // Enroll Now
                    GestureDetector(
                      onTap: () {
                        // TODO: replace with navigation when courseDetail route is ready
                        // Get.toNamed(AppRoutes.courseDetail, arguments: course.id);
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
                          gradient: AppColors.orangeGradient,
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

// ── Helpers ──────────────────────────────────────

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
