import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/screens/courses/widgets/course_type_bottom_sheet.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Static metadata for each course level (labels / API key / display info).
class _CourseStep {
  final String label;
  final String courseType;
  final String duration;
  final String price;
  final IconData icon;
  final bool isDark;

  const _CourseStep({
    required this.label,
    required this.courseType,
    required this.duration,
    required this.price,
    required this.icon,
    this.isDark = false,
  });
}

const _steps = <_CourseStep>[
  _CourseStep(
    label: 'Intro Course',
    courseType: 'introcourse',
    duration: '4 WEEKS',
    price: '₹1,200+',
    icon: Icons.school_outlined,
  ),
  _CourseStep(
    label: 'Diploma Program',
    courseType: 'diplomacourse',
    duration: '8 WEEKS',
    price: '₹4,999+',
    icon: Icons.emoji_events_outlined,
  ),
  _CourseStep(
    label: 'Bachelor Program',
    courseType: 'bachelorcourse',
    duration: '12 WEEKS',
    price: '₹9,999+',
    icon: Icons.workspace_premium_outlined,
  ),
  _CourseStep(
    label: 'Master Program',
    courseType: 'mastercourse',
    duration: '16 WEEKS',
    price: '₹19,999+',
    icon: Icons.history_edu_outlined,
  ),
  _CourseStep(
    label: 'Grand Master',
    courseType: 'grandmaster',
    duration: '24 WEEKS',
    price: '₹39,999+',
    icon: Icons.stars_outlined,
    isDark: true,
  ),
];

// ══════════════════════════════════════════════════
// Section widget — fully stateless
// ══════════════════════════════════════════════════
class LearningJourneySection extends StatelessWidget {
  const LearningJourneySection({super.key});

  @override
  Widget build(BuildContext context) {
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

          // ── Horizontal scrollable steps ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < _steps.length; i++) ...[
                  _JourneyCard(step: _steps[i]),
                  if (i < _steps.length - 1) _buildArrow(),
                ],
              ],
            ),
          ),
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
// Bounce scale is driven by CoursesController.bounceScaleMap via Obx.
// ══════════════════════════════════════════════════
class _JourneyCard extends StatelessWidget {
  final _CourseStep step;
  const _JourneyCard({required this.step});

  Future<void> _onTap(CoursesController ctrl) async {
    await ctrl.triggerBounce(step.courseType);
    await showCourseTypeSheet(
      courseType: step.courseType,
      courseLabel: step.label,
      icon: step.icon,
      isDark: step.isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();

    return Obx(() {
      final scale = ctrl.bounceScaleMap[step.courseType] ?? 1.0;

      return Transform.scale(
        scale: scale,
        child: GestureDetector(
          onTap: () => _onTap(ctrl),
          child: Container(
            width: 148.w,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: step.isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF4A1515), Color(0xFF2E0D0D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: step.isDark ? null : Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: step.isDark
                    ? const Color(0xFFD68D3C).withValues(alpha: 0.5)
                    : const Color(0xFFD68D3C).withValues(alpha: 0.25),
                width: step.isDark ? 1.5 : 1.0,
              ),
              boxShadow: [
                if (step.isDark)
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
                    gradient: step.isDark
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
                  child: Icon(step.icon, color: Colors.white, size: 22.w),
                ),
                SizedBox(height: 10.h),

                // ── Title ──
                SizedBox(
                  height: 38.h,
                  child: Center(
                    child: AutoTranslateText(
                      step.label,
                      textAlign: TextAlign.center,
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: step.isDark
                            ? Colors.white
                            : AppColors.textPrimary,
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
                    color: step.isDark
                        ? const Color(0xFFFFCC80).withValues(alpha: 0.2)
                        : const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AutoTranslateText(
                    step.duration,
                    style: AppTypography.label.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: step.isDark
                          ? const Color(0xFFFFCC80)
                          : const Color(0xFF666666),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // ── Price ──
                AutoTranslateText(
                  step.price,
                  style: AppTypography.body2.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: step.isDark
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
                    gradient: step.isDark
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
                          color: step.isDark
                              ? const Color(0xFF3E1212)
                              : Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 12.w,
                        color: step.isDark
                            ? const Color(0xFF3E1212)
                            : Colors.white,
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
