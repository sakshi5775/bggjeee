import 'package:astrobharataiuser/data_model/course_type_model.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/screens/courses/widgets/course_type_bottom_sheet.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Map a course-type slug to a Material icon.
/// Falls back to [Icons.school_outlined] for unknown slugs.
IconData _iconForSlug(String slug) {
  switch (slug) {
    case 'intro-course':
      return Icons.school_outlined;
    case 'diploma-program':
      return Icons.emoji_events_outlined;
    case 'bachelor':
      return Icons.workspace_premium_outlined;
    case 'master':
      return Icons.history_edu_outlined;
    case 'grand-master':
      return Icons.stars_outlined;
    default:
      return Icons.school_outlined;
  }
}

/// Whether the card should use the dark (maroon/gold) style.
bool _isDarkCard(String slug) => slug == 'grand-master';

// ══════════════════════════════════════════════════
// Section widget — fully stateless, reads API data
// ══════════════════════════════════════════════════
class LearningJourneySection extends StatelessWidget {
  const LearningJourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section heading ──
          Center(
            child: Column(
              children: [
                AutoTranslateText(
                  'Your Learning Journey',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                AutoTranslateText(
                  'Tap any level to explore available courses',
                  style: AppTypography.label.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // ── Horizontal scrollable steps (driven by API) ──
          Obx(() {
            if (ctrl.isCourseTypesLoading.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: SizedBox(
                    width: 32.w,
                    height: 32.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.deepOrange,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (ctrl.courseTypesList.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: AutoTranslateText(
                    'No course levels available',
                    style: AppTypography.body2.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            }

            final types = ctrl.courseTypesList;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < types.length; i++) ...[
                    _JourneyCard(courseType: types[i]),
                    if (i < types.length - 1) _buildArrow(),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14.w,
        color: const Color(0xFFD68D3C),
      ),
    );
  }
}

// ══════════════════════════════════════════════════
// Journey step card — fully stateless
// Bounce scale driven by CoursesController.bounceScaleMap via Obx.
// ══════════════════════════════════════════════════
class _JourneyCard extends StatelessWidget {
  final CourseTypeModel courseType;
  const _JourneyCard({required this.courseType});

  Future<void> _onTap(CoursesController ctrl) async {
    await ctrl.triggerBounce(courseType.id);
    await showCourseTypeSheet(
      courseType: courseType.id,
      courseLabel: courseType.name,
      icon: _iconForSlug(courseType.slug),
      isDark: _isDarkCard(courseType.slug),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();
    final icon = _iconForSlug(courseType.slug);
    final isDark = _isDarkCard(courseType.slug);

    return Obx(() {
      final scale = ctrl.bounceScaleMap[courseType.id] ?? 1.0;

      return Transform.scale(
        scale: scale,
        child: GestureDetector(
          onTap: () => _onTap(ctrl),
          child: Container(
            width: 148.w,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.primaryGradient : null,
              color: isDark ? null : Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isDark
                    ? const Color(0xFFD68D3C).withValues(alpha: 0.5)
                    : const Color(0xFFD68D3C).withValues(alpha: 0.25),
                width: isDark ? 1.5 : 1.0,
              ),
              boxShadow: [
                if (isDark)
                  BoxShadow(
                    color: const Color(0xFF3E1212).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon circle ──
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFFD68D3C), Color(0xFFFFCC80)],
                          )
                        : AppColors.orangeGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepOrange.withValues(alpha: 0.25),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22.w),
                ),
                SizedBox(height: 10.h),

                // ── Title ──
                SizedBox(
                  height: 38.h,
                  child: Center(
                    child: AutoTranslateText(
                      courseType.name,
                      textAlign: TextAlign.center,
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // ── Duration badge ──
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFFFCC80).withValues(alpha: 0.2)
                        : const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AutoTranslateText(
                    courseType.duration.toUpperCase(),
                    style: AppTypography.label.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFFFCC80)
                          : const Color(0xFF666666),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // ── Investment / Price ──
                AutoTranslateText(
                  '₹${courseType.investment}',
                  style: AppTypography.body2.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFFFCC80)
                        : const Color(0xFFD68D3C),
                  ),
                ),
                SizedBox(height: 10.h),

                // ── "Learn More" button ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFFFFCC80), Color(0xFFFFEEDD)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepOrange.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoTranslateText(
                        'Learn More',
                        textAlign: TextAlign.center,
                        style: AppTypography.body2.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                          color: isDark
                              ? const Color(0xFF3E1212)
                              : Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 12.w,
                        color: isDark ? const Color(0xFF3E1212) : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
