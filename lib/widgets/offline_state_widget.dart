import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class OfflineStateWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? title;
  final String? subtitle;

  const OfflineStateWidget({
    super.key,
    required this.onRetry,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 80.w,
                color: AppColors.saffron,
              ),
            ),
            SizedBox(height: 24.h),
            AutoTranslateText(
              title ?? 'No Internet Connection',
              style: MyTextTheme.mediumBCB.copyWith(
                fontSize: 20.sp,
                color: AppColors.saffron,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              subtitle ??
                  'Please check your connection and try again to access real-time data.',
              style: MyTextTheme.mediumBCN.copyWith(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffron,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                elevation: 2,
              ),
              child: const AutoTranslateText(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

