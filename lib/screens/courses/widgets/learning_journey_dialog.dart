import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class LearningJourneyDialog extends StatelessWidget {
  final String title;
  final String duration;
  final String description;
  final String whoItIsFor;
  final String objective;
  final List<String> whatYouWillLearn;
  final List<String> learningOutcomes;
  final IconData icon;
  final String buttonText;

  const LearningJourneyDialog({
    super.key,
    required this.title,
    required this.duration,
    required this.description,
    required this.whoItIsFor,
    required this.objective,
    required this.whatYouWillLearn,
    required this.learningOutcomes,
    required this.icon,
    this.buttonText = 'Start Your Learning Journey',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0), // Cream background for header
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 24.w),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          title,
                          style: AppTypography.h3.copyWith(
                            color: const Color(0xFF3E1212),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14.w,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4.w),
                            AutoTranslateText(
                              duration,
                              style: AppTypography.body2.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      description, // "Foundations & Awareness"
                      style: AppTypography.h3.copyWith(
                        color: const Color(0xFF3E1212),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildSectionTitle('WHO IT IS FOR'),
                    SizedBox(height: 4.h),
                    AutoTranslateText(
                      whoItIsFor,
                      style: AppTypography.body1.copyWith(
                        color: const Color(0xFF666666),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildSectionTitle('OBJECTIVE'),
                    SizedBox(height: 4.h),
                    AutoTranslateText(
                      objective,
                      style: AppTypography.body1.copyWith(
                        color: const Color(0xFF666666),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // What You Will Learn Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                color: const Color(0xFF3E1212),
                                size: 20.w,
                              ),
                              SizedBox(width: 8.w),
                              AutoTranslateText(
                                'What You Will Learn',
                                style: AppTypography.h3.copyWith(
                                  color: const Color(0xFF3E1212),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ...whatYouWillLearn.map((item) {
                            if (item.startsWith('HEADER:')) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  bottom: 8.h,
                                ),
                                child: AutoTranslateText(
                                  item.replaceAll('HEADER:', '').trim(),
                                  style: AppTypography.body1.copyWith(
                                    color: const Color(0xFF3E1212),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }
                            return _buildCheckItem(item, isRed: true);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Learning Outcome Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9), // Light Green
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                color: const Color(0xFF2E7D32),
                                size: 20.w,
                              ),
                              SizedBox(width: 8.w),
                              AutoTranslateText(
                                'Learning Outcome',
                                style: AppTypography.h3.copyWith(
                                  color: const Color(0xFF2E7D32),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ...learningOutcomes.map(
                            (item) => _buildCheckItem(item, isGreen: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Button
            // Padding(
            //   padding: EdgeInsets.all(20.w),
            //   child: Container(
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       gradient: AppColors.orangeGradient,
            //       borderRadius: BorderRadius.circular(12.r),
            //     ),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Get.back();
            //         // Navigate to course detail or start journey
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.transparent,
            //         padding: EdgeInsets.symmetric(vertical: 16.h),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12.r),
            //         ),
            //       ),
            //       child: AutoTranslateText(
            //         'Start Your Learning Journey',
            //         style: AppTypography.body1.copyWith(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AutoTranslateText(
      title,
      style: AppTypography.label.copyWith(
        color: const Color(0xFF999999),
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildCheckItem(
    String text, {
    bool isRed = false,
    bool isGreen = false,
  }) {
    Color iconColor = const Color(0xFF3E1212);
    if (isGreen) iconColor = const Color(0xFF2E7D32);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: iconColor, size: 18.w),
          SizedBox(width: 8.w),
          Expanded(
            child: AutoTranslateText(
              text,
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF444444),
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
