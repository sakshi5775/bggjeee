import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Explore Our Courses',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: AppColors.orangeGradient.colors.first,
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  AutoTranslateText(
                    'View all',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: AppColors.orangeGradient.colors.last,
                          fontWeight: FontWeight.w400,
                        )
                        .merge(AppTypography.body1),
                  ),
                ],
              ),
              Spacing.h(16),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.orangeGradient.colors.first,
                    ),
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
        padding: AppPaddings.symmetric(h: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Explore Our Courses',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: AppColors.orangeGradient.colors.first,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.courses);
                  },
                  child: AutoTranslateText(
                    'View all',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: AppColors.orangeGradient.colors.last,
                          fontWeight: FontWeight.w400,
                        )
                        .merge(AppTypography.body1),
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            // Horizontal Scrollable List
            SizedBox(
              height: 290.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.courses.length >= 5
                    ? 5
                    : controller.courses.length,
                separatorBuilder: (context, index) => Spacing.w(12),
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

  Widget _buildCourseCard(CourseModel course) {
    // Map course data to display
    final courseTitle = course.title;
    final description = course.description;
    final price = course.price > 0 ? '₹${course.price.toInt()}' : 'Free';
    final thumbnail = course.thumbnail ?? '';
    // Extract diploma title from course title or use a default
    final diplomaTitle = courseTitle.contains('Diploma')
        ? courseTitle
        : 'Diploma in ${courseTitle}';
    final tag = 'Foundation Programs';

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.courseDetail, arguments: course.id);
      },
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section - Image with Overlay Text
            Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    child: thumbnail.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnail,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.orangeGradient.colors.first.withOpacity(0.3),
                                    AppColors.orangeGradient.colors.first.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.orangeGradient.colors.first,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.orangeGradient.colors.first.withOpacity(0.3),
                                    AppColors.orangeGradient.colors.first.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.school,
                                  size: 60.w,
                                  color: AppColors.orangeGradient.colors.first.withOpacity(0.5),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.deepOrange.withOpacity(0.3),
                                  AppColors.deepOrange.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.school,
                                size: 60.w,
                                color: AppColors.deepOrange.withOpacity(0.5),
                              ),
                            ),
                          ),
                  ),

                  // Diploma Title Overlay
                  Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    right: 16.w,
                    child: AutoTranslateText(
                      diplomaTitle,
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          )
                          .merge(AppTypography.h2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Section - Text Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Foundation Programs Tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: "#008236".toColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: AutoTranslateText(
                        tag,
                        style: MyTextTheme.smallBCB
                            .copyWith(
                              color: "#008236".toColor(),
                              fontWeight: FontWeight.w900,
                            )
                            .merge(AppTypography.label),
                      ),
                    ),
                    Spacing.h(8),
                    // Course Title
                    AutoTranslateText(
                      courseTitle,
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: AppColors.primaryGradient.colors[1],
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(6),
                    // Description
                    AutoTranslateText(
                      description,
                      style: MyTextTheme.smallBCN
                          .copyWith(color: AppColors.primaryGradient.colors.first.withOpacity(0.6))
                          .merge(AppTypography.body2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Price and Arrow Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoTranslateText(
                          price,
                          style: MyTextTheme.mediumBCB
                              .copyWith(
                                color: AppColors.primaryGradient.colors[1],
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.h3),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryGradient.colors.first,
                          size: 16.w,
                        ),
                      ],
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
}
