import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';

/// Direction Confidence Meter Widget
/// Shows compass accuracy confidence to build trust
class ConfidenceMeter extends StatelessWidget {
  final double accuracy;
  final bool isCalibrated;

  const ConfidenceMeter({
    Key? key,
    required this.accuracy,
    required this.isCalibrated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final confidence = isCalibrated ? accuracy : accuracy * 0.5;
    final confidencePercent = (confidence * 100).toInt();

    Color meterColor;
    String statusText;

    if (confidence >= 0.8) {
      meterColor = Colors.green;
      statusText = 'High Accuracy';
    } else if (confidence >= 0.5) {
      meterColor = "#F38B3B".toColor();
      statusText = 'Moderate Accuracy';
    } else {
      meterColor = Colors.red;
      statusText = 'Low Accuracy';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: meterColor, size: 20.w),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      statusText,
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                    AutoTranslateText(
                      '$confidencePercent%',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: meterColor,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ],
                ),
                Spacing.h(6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: confidence,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(meterColor),
                    minHeight: 6.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
