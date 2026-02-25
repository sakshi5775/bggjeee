import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportsSectionWidget extends BasePage<UserDashboardController> {
  const ReportsSectionWidget({super.key});

  static const List<Map<String, String>> _reportItems = [
    {'title': 'Brihat Kundli', 'image': AppConstant.astrologyReportBrihatKudli},
    {'title': 'Raj Yoga', 'image': AppConstant.astrologyRajYogaReport},
    {'title': 'Year Book', 'image': AppConstant.astrologyYearBookReport},
    {'title': 'Horoscope', 'image': AppConstant.astrologyReportHoroscope2026},
    {
      'title': 'Shani Report',
      'image': AppConstant.astrologyYearBookReportShani,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Reports',
                style: AppTypography.h2.copyWith(
                  color: '#820B17'.toColor(),
                  letterSpacing: -0.05,
                ),
              ),
              GestureDetector(
                onTap: () => controller.selectedSliderIndex.value = 1,
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
          ),
          Spacing.h(4),
          SizedBox(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              separatorBuilder: (_, __) => Spacing.w(8),
              itemCount: _reportItems.length,
              itemBuilder: (context, index) {
                final item = _reportItems[index];
                return _buildReportCard(
                  title: item['title']!,
                  imagePath: item['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({required String title, required String imagePath}) {
    return GestureDetector(
      onTap: () => controller.selectedSliderIndex.value = 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 74.w,
            height: 74.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 74.w,
                  height: 74.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                ClipOval(
                  child: SizedBox(
                    width: 85.w,
                    height: 70.h,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: '#FCE5AA'.toColor(),
                        child: Icon(
                          Icons.menu_book,
                          color: AppColors.deepOrange,
                          size: 32.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(4),
          SizedBox(
            width: 74.w,
            child: AutoTranslateText(
              title,
              style: AppTypography.body2.copyWith(
                color: '#3D0C11'.toColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
