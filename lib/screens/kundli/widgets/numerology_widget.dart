import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/prediction_style.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumerologyWidget extends StatelessWidget {
  final PredictionsController controller;

  const NumerologyWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingNumerology.value) {
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.numerologyData.value;

      if (data == null || data.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Please select Numerology from the table to view your prediction',
        );
      }

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return PredictionStyle.buildEmptyState(message: 'No data available');
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...response.entries.map((entry) {
              final categoryData = entry.value as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildCategoryCard(categoryData),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final title = category['title'] as String? ?? '';
    final number = category['number'] as String? ?? '';
    final master = category['master'] as bool? ?? false;
    final meaning = category['meaning'] as String? ?? '';
    final description = category['description'] as String? ?? '';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.w(12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.deepOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoTranslateText(
                      'Number: ',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AutoTranslateText(
                      number,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (master) ...[
                Spacing.w(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AutoTranslateText(
                    'Master',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Spacing.h(10),
          
          // Description
          if (description.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.deepOrange.withValues(alpha: 0.06),
                border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.3), width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Spacing.h(12),
          ],
          
          // Meaning
          if (meaning.isNotEmpty) ...[
            AutoTranslateText(
              'Meaning:',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(6),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.deepOrange.withValues(alpha: 0.08),
                border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.3), width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                meaning,
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


