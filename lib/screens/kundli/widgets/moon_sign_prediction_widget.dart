import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoonSignPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const MoonSignPredictionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMoonSign.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.moonSignPredictionData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 48.w,
                color: "#6F221E".toColor().withOpacity(0.5),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'No data available',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                ),
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Please select Moon Sign from the table',
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final zodiac = response['zodiac'] as String? ?? '';
      final explanation = response['explanation'] as String? ?? '';
      final health = response['health'] as String? ?? '';
      final temp = response['temp'] as String? ?? '';
      final physical = response['physical'] as String? ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zodiac Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(color: AppColors.deepOrange.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.nightlight_round,
                    color: Colors.white,
                    size: 24.w,
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      'Moon Sign: $zodiac',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),
            
            // Explanation
            if (explanation.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: "#ed6f30".toColor(),
                          size: 20.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          'About Moon Sign',
                          style: AppTypography.h2.copyWith(
                            color: "#6F221E".toColor(),
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(12),
                    AutoTranslateText(
                      explanation,
                      style: AppTypography.body1.copyWith(
                        color: "#6F221E".toColor(),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(10),
            ],
            
            // Health
            if (health.isNotEmpty) ...[
              _buildSectionCard('Health', health, Icons.favorite),
              Spacing.h(16),
            ],
            
            // Temperament
            if (temp.isNotEmpty) ...[
              _buildSectionCard('Temperament', temp, Icons.psychology),
              Spacing.h(10),
            ],

            // Physical
            if (physical.isNotEmpty) ...[
              _buildSectionCard('Physical Appearance', physical, Icons.person),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildSectionCard(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#ed6f30".toColor().withOpacity(0.1),
            "#ed6f30".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: "#ed6f30".toColor(),
                size: 20.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: AppTypography.h2.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
            ],
          ),
          Spacing.h(10),
          AutoTranslateText(
            content,
            style: AppTypography.body1.copyWith(
              color: "#6F221E".toColor(),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

