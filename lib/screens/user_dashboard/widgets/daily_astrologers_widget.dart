import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class DailyAstrologersWidget extends BasePage<UserDashboardController> {
  const DailyAstrologersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Static data for Daily Astrologers cards
    final List<Map<String, dynamic>> dailyCards = [
      {'icon': AppConstant.horoscope, 'title': "Today's Horoscope"},
      {'icon': AppConstant.tarot, 'title': "Today's Tarot Reading"},
      // {'icon': AppConstant.service2025, 'title': 'All About 2026'},
      {'icon': AppConstant.servicePanchang, 'title': 'Todays Panchang'},
      {'icon': AppConstant.serviceNumerology, 'title': "Today's Numerology"},
    ];

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
                'Daily Astrology',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigate to view all daily astrologers
              //     // Get.toNamed(AppRoutes.dailyAstrologers);
              //   },
              //   child: AutoTranslateText(
              //     'View All',
              //     style: MyTextTheme.mediumBCN
              //         .copyWith(
              //           color: "#9D4807".toColor(),
              //           fontWeight: FontWeight.w400,
              //         )
              //         .merge(AppTypography.body1),
              //   ),
              // ),
            ],
          ),
          Spacing.h(16),
          // Horizontal Scrollable List
          SizedBox(
            height: 120.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dailyCards.length,
              separatorBuilder: (context, index) => Spacing.w(12),
              itemBuilder: (context, index) {
                final card = dailyCards[index];
                return _buildDailyCard(card);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCard(Map<String, dynamic> card) {
    final iconPath = card['icon'] as String;
    final title = card['title'] as String;

    return GestureDetector(
      onTap: () {
        switch (title) {
          case "Today's Horoscope":
            Get.toNamed(AppRoutes.horoscopeForm);
            break;
          case "Today's Tarot Reading":
            Get.toNamed(AppRoutes.tarotReading);
            break;
          case 'All About 2026':
            Get.toNamed(AppRoutes.comingSoon);
            break;
          case 'Todays Panchang':
            Get.toNamed(AppRoutes.panchang);
            break;
          case "Today's Numerology":
            Get.toNamed(AppRoutes.numerologyForm);
        }
      },
      child: Container(
        width: 110.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: AppPaddings.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with Orange Gradient Background
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                child: iconPath.endsWith('.svg')
                    ? SvgAssets(path: iconPath, width: 32.w, height: 32.h)
                    : Image.asset(
                        iconPath,
                        width: 28.w,
                        height: 28.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 32.w,
                          );
                        },
                      ),
              ),
              Spacing.h(12),
              // Title Text
              AutoTranslateText(
                title,
                style: MyTextTheme.smallBCN
                    .copyWith(
                      color: "#361515".toColor(),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    )
                    .merge(AppTypography.body2),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
