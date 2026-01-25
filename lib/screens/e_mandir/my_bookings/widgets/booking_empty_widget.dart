import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingEmptyWidget extends StatelessWidget {
  final VoidCallback? onBookNow;

  const BookingEmptyWidget({super.key, this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.orangeGradient.colors.first.withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.temple_hindu_rounded,
                size: 64.sp,
                color: AppColors.orangeGradient.colors.first,
              ),
            ),
            SizedBox(height: 24.h),
            AutoTranslateText(
              'No Bookings Yet',
              style: AppTypography.h2.copyWith(color: const Color(0xFF424242)),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              'Start your spiritual journey by booking a puja',
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF9E9E9E),
              ),
              textAlign: TextAlign.center,
            ),
            if (onBookNow != null) ...[
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: onBookNow,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orangeGradient.colors.first.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AutoTranslateText(
                    'Book a Puja',
                    style: AppTypography.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
