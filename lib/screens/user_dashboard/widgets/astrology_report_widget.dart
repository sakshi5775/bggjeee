import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../utils/app_constant.dart';
import '../../../widgets/auto_translate_text.dart';
import 'ComingSoonPage.dart';

class AstrologyReportWidget extends StatelessWidget {
  const AstrologyReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ComingSoonPage());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Astrology Report',
                  style: AppTypography.h2.copyWith(color: "#820B17".toColor()),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ComingSoonPage());
                  },
                  child: AutoTranslateText(
                    'View All',
                    style: AppTypography.body1.copyWith(color: "#9D4807".toColor()),
                  ),
                ),
              ],
            ),
            Spacing.h(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  _buildAstrologyReportCard(
                    image: AppConstant.astrologyReportBrihatKudli,
                    title: 'Brihat Kundli',
                  ),
                  _buildAstrologyReportCard(
                    image: AppConstant.astrologyReportHoroscope2026,
                    title: 'Horoscope 2026',
                  ),
                  _buildAstrologyReportCard(
                    image: AppConstant.astrologyYearBookReport,
                    title: 'Year Book',
                  ),
                  _buildAstrologyReportCard(
                    image: AppConstant.astrologyYearBookReportShani,
                    title: 'Year Book',
                  ),
                  _buildAstrologyReportCard(
                    image: AppConstant.astrologyRajYogaReport,
                    title: 'Raj Yoga',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstrologyReportCard({
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ComingSoonPage());
      },
      child: Container(
        // height: 82,
        width: 82,
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: AppRadius.only(
            topLeft: 13,
            topRight: 13,
            bottomRight: 13,
          ),
        ),
        child: Padding(
          padding: AppPaddings.all(1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.only(
                topLeft: 13,
                topRight: 13,
                bottomRight: 13,
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    image,
                    // fit: BoxFit.cover,
                    height: 70,
                    width: 70,
                  ),
                ),
                Padding(
                  padding: AppPaddings.symmetric(h: 5),
                  child: AutoTranslateText(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTypography.body2.copyWith(
                      color: '#8B1925'.toColor(),
                    ),
                  ),
                ),
                Spacing.h(5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
