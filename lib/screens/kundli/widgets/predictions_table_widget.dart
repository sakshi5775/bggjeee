import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Predictions table - matches kundli_result_view feature list style.
class PredictionsTableWidget extends StatelessWidget {
  final PredictionsController controller;

  const PredictionsTableWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Life Predictions', Icons.auto_awesome),
          Spacing.h(8),
          ...controller.predictionsTableData.take(6).map((row) => _buildRow(row)),
          Spacing.h(14),
          _buildSectionHeader('Monthly Predictions', Icons.calendar_month),
          Spacing.h(8),
          ...controller.predictionsTableData.skip(6).map((row) => _buildRow(row)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18.w),
          ),
          Spacing.w(10),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> row) {
    final leftText = row['left'] as String;
    final rightText = row['right'] as String? ?? '';
    final hasApiLeft = row['hasApi'] as bool? ?? false;
    final hasApiRight = row['hasApiRight'] as bool? ?? false;

    if (!hasApiLeft && !hasApiRight) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          if (hasApiLeft) Expanded(child: _buildCard(leftText, () => controller.navigateToTab(leftText))),
          if (hasApiLeft && hasApiRight && rightText.isNotEmpty) Spacing.w(8),
          if (rightText.isNotEmpty && hasApiRight)
            Expanded(child: _buildCard(rightText, () => controller.navigateToTab(rightText))),
        ],
      ),
    );
  }

  Widget _buildCard(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.deepOrange.withOpacity(0.35), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 14.w),
            ),
            Spacing.w(12),
            Expanded(
              child: AutoTranslateText(
                title,
                style: MyTextTheme.smallBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.deepOrange, size: 12.w),
          ],
        ),
      ),
    );
  }
}
