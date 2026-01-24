import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TempleHighlightsWidget extends StatelessWidget {
  const TempleHighlightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoTranslateText(
              'Temple Highlights',
              style: AppTypography.h3.copyWith(
                color: AppColors.textColorMaroon,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  AutoTranslateText(
                    'View All',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.orange,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _TempleItem(
          title: 'Golden Temple',
          subtitle: 'Sri Harmandir Sahib',
          assetPath: AppConstant.eMandirGoldenTemple,
        ),
        SizedBox(height: 12.h),
        _TempleItem(
          title: 'Meenakshi Temple',
          subtitle: 'Madurai, Tamil Nadu',
          assetPath: AppConstant.eMandirMeenakshiTemple,
        ),
        SizedBox(height: 12.h),
        _TempleItem(
          title: 'Tirupati Balaji',
          subtitle: 'Tirumala, Andhra Pradesh',
          assetPath: AppConstant.eMandirTirupatiBalaji,
        ),
      ],
    );
  }
}

class _TempleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;

  const _TempleItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              assetPath,
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: AppTypography.h2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoTranslateText(
                  subtitle,
                  style: AppTypography.body2.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.orange),
        ],
      ),
    );
  }
}
