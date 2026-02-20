import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/prediction_style.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AscendantPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const AscendantPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAscendant.value) {
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.ascendantPredictionData.value;

      if (data == null || data.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Please select Ascendant Prediction from the table',
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return PredictionStyle.buildEmptyState(message: 'No data available');
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
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 24.w),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      'Ascendant: $zodiac',
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
                decoration: PredictionStyle.cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PredictionStyle.iconBadge(Icons.info_outline, size: 18),
                        Spacing.w(8),
                        AutoTranslateText(
                          'About Ascendant',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(12),
                    AutoTranslateText(
                      explanation,
                      style: AppTypography.body1.copyWith(
                        color: AppColors.textPrimary,
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
              Spacing.h(10),
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
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(icon, size: 18),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          Spacing.h(10),
          AutoTranslateText(
            content,
            style: AppTypography.body1.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

