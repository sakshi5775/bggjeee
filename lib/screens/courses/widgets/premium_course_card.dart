import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const PremiumCourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E7), // Beige background
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFD68D3C).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: course.thumbnail ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    course.title,
                    style: AppTypography.h3.copyWith(
                      color: const Color(0xFF3E1212),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  AutoTranslateText(
                    course.description,
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF5D4037),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16.w,
                        color: const Color(0xFF5D4037),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: AutoTranslateText(
                          course.instructor,
                          style: AppTypography.label.copyWith(
                            color: const Color(0xFF5D4037),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.menu_book_outlined,
                        size: 16.w,
                        color: const Color(0xFF5D4037),
                      ),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        '${course.lectureIds.length} Lec',
                        style: AppTypography.label.copyWith(
                          color: const Color(0xFF5D4037),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Container(
                    height: 1,
                    color: const Color(0xFFD68D3C).withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'PRICE',
                            style: AppTypography.label.copyWith(
                              color: Colors.grey[600],
                              fontSize: 10,
                              letterSpacing: 1.0,
                            ),
                          ),
                          AutoTranslateText(
                            '₹${course.price.toStringAsFixed(0)}',
                            style: AppTypography.h3.copyWith(
                              color: const Color(0xFF3E1212),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: AutoTranslateText(
                          'ENROLL NOW',
                          style: AppTypography.body2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 10,
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
      ),
    );
  }
}
