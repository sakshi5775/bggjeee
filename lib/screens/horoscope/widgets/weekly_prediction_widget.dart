import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeeklyPredictionWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const WeeklyPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingWeekly.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Weekly Prediction...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.weeklyPredictionData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Weekly Prediction data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>? ?? {};
      final horoscopeData = response['horoscope_data']?.toString() ?? '';
      final luckyColor = response['lucky_color']?.toString() ?? '';
      final luckyNumbers =
          (response['lucky_numbers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(16),
            if (horoscopeData.isNotEmpty) _buildPredictionCard(horoscopeData),
            Spacing.h(16),
            if (luckyColor.isNotEmpty || luckyNumbers.isNotEmpty)
              _buildLuckyElementsCard(luckyColor, luckyNumbers),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.calendar_view_week_rounded,
              color: AppColors.golden,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Weekly Prediction',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.golden,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Your weekly horoscope',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.golden.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(String prediction) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.golden,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Prediction',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            prediction,
            style: MyTextTheme.smallBCN.copyWith(
              color: AppColors.textPrimary.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyElementsCard(String luckyColor, List<String> luckyNumbers) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.stars_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Lucky Elements',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          if (luckyColor.isNotEmpty) ...[
            _buildInfoRow('Lucky Color', luckyColor),
            Spacing.h(12),
          ],
          if (luckyNumbers.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Lucky Numbers',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  flex: 3,
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: luckyNumbers.map((num) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AutoTranslateText(
                          num,
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacing.w(12),
        Expanded(
          flex: 3,
          child: AutoTranslateText(
            value,
            style: MyTextTheme.smallBCN.copyWith(
              color: AppColors.textPrimary.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
