import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';

/// Correction Step Card
/// Shows step-by-step Vastu correction guidance
class CorrectionStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;

  const CorrectionStepCard({
    Key? key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCompleted 
            ? '#E8F5E9'.toColor()
            : '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isCompleted
              ? '#4CAF50'.toColor()
              : '#F5D7B8'.toColor(),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isCompleted
                  ? '#4CAF50'.toColor()
                  : "#F38B3B".toColor(),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20.w,
                    )
                  : AutoTranslateText(
                      stepNumber.toString(),
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h3),
                    ),
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: "#F38B3B".toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    Expanded(
                      child: AutoTranslateText(
                        title,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.h3),
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
                AutoTranslateText(
                  description,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#666666'.toColor(),
                  ).merge(AppTypography.body1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}










