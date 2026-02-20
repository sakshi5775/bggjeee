import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared styling for prediction widgets - matches kundli_result_view.
class PredictionStyle {
  static Widget buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: 32.w,
        height: 32.w,
        child: CircularProgressIndicator(
          color: AppColors.deepOrange,
          strokeWidth: 2,
        ),
      ),
    );
  }

  static Widget buildEmptyState({
    required String message,
    String? submessage,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.info_outline, color: Colors.white, size: 32.w),
            ),
            Spacing.h(16),
            AutoTranslateText(
              message,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            if (submessage != null && submessage.isNotEmpty) ...[
              Spacing.h(8),
              AutoTranslateText(
                submessage,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Card container - white bg, orange border, shadow (kundli_result_view style)
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: AppColors.cardLight,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Header bar - orange gradient (birth_details_widget style)
  static BoxDecoration headerBarDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: ['#FF8A3D'.toColor(), '#ed6f30'.toColor()],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    );
  }

  /// Icon badge - orange gradient circle
  static Widget iconBadge(IconData icon, {double size = 18}) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size.w),
    );
  }
}

