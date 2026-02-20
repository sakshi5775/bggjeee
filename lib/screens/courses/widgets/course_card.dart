import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const CourseCard({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Section
            Expanded(
              flex: 2,
              child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                  ),
                  child: Container(
                      height: 140.h,
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child: course.thumbnail != null && course.thumbnail!.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: course.thumbnail!,
                                width: double.infinity,
                                  height: 140.h,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: const Color(0xFFF5F5F5),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryGradient.colors.first,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => _buildPlaceholderImage(),
                              ),
                                // Gradient overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                        Colors.black.withOpacity(0.2),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _buildPlaceholderImage(),
                  ),
                ),
                  // Bestseller badge (top left)
                Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AutoTranslateText(
                        'Bestseller',
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Play button overlay (center)
                  Positioned.fill(
                    child: Center(
                  child: Container(
                        width: 56.w,
                        height: 56.w,
                    decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                        child: Icon(
                          Icons.play_arrow,
                          color: AppColors.primaryGradient.colors.first,
                          size: 32.w,
                        ),
                        ),
                    ),
                    ),
                ],
                ),
            ),
            
            // Content Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Course Title - Flexible to prevent overflow
                    Flexible(
                      child: AutoTranslateText(
                        course.title,
                        style: AppTypography.h3.copyWith(
                          color: AppColors.primaryGradient.colors.first,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    
                    // Instructor with profile picture
                    Row(
                      children: [
                        // Profile picture placeholder
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGradient.colors.first.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 14.w,
                            color: AppColors.primaryGradient.colors.first,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: AutoTranslateText(
                            course.instructor,
                            style: AppTypography.body2.copyWith(
                              color: const Color(0xFF666666),
                              fontSize: 11.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    
                    // Price
                    AutoTranslateText(
                      '₹${course.price.toStringAsFixed(0)}',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.primaryGradient.colors.first,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGradient.colors.first.withOpacity(0.15),
            AppColors.primaryGradient.colors.last.withOpacity(0.15),
          ],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.school_rounded,
              color: AppColors.primaryGradient.colors.first.withOpacity(0.4),
              size: 38.w,
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
