import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MonthlyPredictionWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const MonthlyPredictionWidget({
    super.key,
    required this.controller,
  });

  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMonthly.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orangeGradient.colors.first),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Monthly Prediction...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: primaryGradient.colors.first.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.monthlyPredictionData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Monthly Prediction data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.7),
            ),
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>? ?? {};
      final horoscopeData = response['horoscope_data']?.toString() ?? '';
      final luckyColor = response['lucky_color']?.toString() ?? '';
      final luckyNumbers = (response['lucky_numbers'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      
      return Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(10),
            if (horoscopeData.isNotEmpty) _buildPredictionCard(horoscopeData),
            Spacing.h(10),
            if (luckyColor.isNotEmpty || luckyNumbers.isNotEmpty) _buildLuckyElementsCard(luckyColor, luckyNumbers),
          ],
        ),
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryGradient.colors.first.withOpacity(0.3),
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
              Icons.calendar_month_rounded,
              color: const Color(0xFFDFB343),
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Monthly Prediction',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Your monthly horoscope',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFFDFB343).withOpacity(0.9),
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: const Color(0xFFDFB343),
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Prediction',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            prediction,
            style: MyTextTheme.smallBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyElementsCard(String luckyColor, List<String> luckyNumbers) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                  gradient: orangeGradient,
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
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          if (luckyColor.isNotEmpty) ...[
            _buildInfoRow('Lucky Color', luckyColor),
            if (luckyNumbers.isNotEmpty) _buildDivider(),
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
                      color: primaryGradient.colors.first.withOpacity(0.7),
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
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          gradient: orangeGradient,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: primaryGradient.colors.first.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: primaryGradient.colors.first,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: primaryGradient.colors.first.withOpacity(0.1),
    );
  }
}










