import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CoursesSectionWidget extends BasePage<UserDashboardController> {
  const CoursesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCourses.value) {
        return Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Spacing.h(4),
              SizedBox(
                height: 140.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.deepOrange,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (controller.courses.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Spacing.h(4),
            SizedBox(
              height: 140.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => Spacing.w(10),
                itemCount: controller.courses.length >= 8
                    ? 8
                    : controller.courses.length,
                itemBuilder: (context, index) {
                  final course = controller.courses[index];
                  return _buildCourseCard(course);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoTranslateText(
          'Explore Our Courses',
          style: AppTypography.h2.copyWith(
            color: '#820B17'.toColor(),
            letterSpacing: -0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            try {
              final dashboardController = Get.find<UserDashboardController>();
              dashboardController.selectedSliderIndex.value = 6;
              dashboardController.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } catch (e) {
              Get.toNamed(AppRoutes.courses);
            }
          },
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
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    final title = course.title;
    final thumbnail = course.thumbnail ?? '';
    const double cardWidth = 150;
    const double thumbHeight = 94;

    return GestureDetector(
      onTap: () {
        // Switch to Digital Learning tab (index 6) instead of navigating
        try {
          final dashboardController = Get.find<UserDashboardController>();
          dashboardController.selectedSliderIndex.value = 6;
          dashboardController.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } catch (e) {
          // Fallback if controller not found
          Get.toNamed(AppRoutes.courseDetail, arguments: course.id);
        }
      },
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
                    child: thumbnail.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnail,
                            width: cardWidth.w,
                            height: thumbHeight.h,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _thumbnailPlaceholder(
                              cardWidth.w,
                              thumbHeight.h,
                            ),
                            errorWidget: (_, __, ___) => _thumbnailPlaceholder(
                              cardWidth.w,
                              thumbHeight.h,
                            ),
                          )
                        : _thumbnailPlaceholder(cardWidth.w, thumbHeight.h),
                  ),
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
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
                title,
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

  Widget _thumbnailPlaceholder(double w, double h) {
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
          Icons.school_rounded,
          size: 36.w,
          color: AppColors.deepOrange.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
