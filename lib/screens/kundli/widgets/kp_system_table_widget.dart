import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// KP System table â€“ same design as predictions_table_widget / lal_kitab_table_widget.
class KpSystemTableWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpSystemTableWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('KP System', Icons.grid_view),
          Spacing.h(8),
          ...controller.kpSystemTableData.map((row) => _buildRow(row)),
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
            color: AppColors.deepOrange.withValues(alpha: 0.2),
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
              color: Colors.white.withValues(alpha: 0.25),
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
          if (hasApiLeft)
            Expanded(
              child: _buildCard(
                leftText,
                hasApiLeft,
                leftText.isNotEmpty
                    ? () => controller.navigateToTab(leftText)
                    : null,
              ),
            ),
          if (hasApiLeft && hasApiRight && rightText.isNotEmpty) Spacing.w(8),
          if (rightText.isNotEmpty && hasApiRight)
            Expanded(
              child: _buildCard(
                  rightText, hasApiRight, () => controller.navigateToTab(rightText)),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, bool hasApi, VoidCallback? onTap) {
    return GestureDetector(
      onTap: hasApi && onTap != null ? onTap : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.deepOrange.withValues(alpha: 0.35), width: 1),
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
                gradient: hasApi ? AppColors.orangeGradient : null,
                color: hasApi ? null : Colors.grey.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                boxShadow: hasApi
                    ? [
                        BoxShadow(
                          color: AppColors.deepOrange.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.grid_view,
                color: Colors.white,
                size: 14.w,
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                  if (!hasApi) ...[
                    Spacing.h(2),
                    AutoTranslateText(
                      'Coming Soon',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasApi)
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.deepOrange, size: 12.w),
          ],
        ),
      ),
    );
  }
}

