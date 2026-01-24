import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Quick Actions',
          style: AppTypography.h3.copyWith(
            color: AppColors.textColorMaroon,
          ),
        ),
        SizedBox(height: 8.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          children: [
            _QuickActionCard(
              icon: Image.asset(AppConstant.eMandirPlayIcon, height: 50.h),
              title: 'Live Darshan',
              subtitle: 'Just now',
            ),
            _QuickActionCard(
              icon: Image.asset(AppConstant.eMandirEPuja, height: 50.h),
              title: 'E-Puja Booking',
              subtitle: 'Book online',
            ),
            _QuickActionCard(
              icon: Image.asset(AppConstant.eMandirLibraryAarti, height: 50.h),
              title: 'Aarti Library',
              subtitle: '10+ devotional',
            ),
            _QuickActionCard(
              icon: Image.asset(AppConstant.eMandirLibraryAarti, height: 50.h),
              title: 'Wallpaper',
              subtitle: '30+ devotional',
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 8.h),
          AutoTranslateText(
            title,
            style: AppTypography.body1.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          AutoTranslateText(
            subtitle,
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
