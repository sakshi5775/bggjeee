import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CelestialInfoCardWidget extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const CelestialInfoCardWidget({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.33.w, vertical: 15.33.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(13.41.r),
          border: Border.all(color: "#F38B3B".toColor(), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Icon and label
            Row(
              children: [
                Container(
                  width: 34.49.w,
                  height: 34.49.h,
                  padding: EdgeInsets.all(6.39.w),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(9.58.r),
                  ),
                  child: SvgAssets(
                    path: iconPath,
                    width: 20.w,
                    height: 20.h,
                    colorFilter: ColorFilter.mode(
                      iconBgColor == "#FFA602".toColor().withValues(alpha: 0.2)
                          ? "#FFA602"
                                .toColor() // Solar Noon - yellow
                          : "#7F00BB".toColor(), // Moon Phase - purple
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Spacing.w(11.5),
                AutoTranslateText(
                  label,
                  style: MyTextTheme.smallBCB.copyWith(
                    fontSize: 13.41.sp,
                    color: "#8B1925".toColor(), // 1st-maroon
                  ),
                ),
              ],
            ),
            // Right side: Value
            AutoTranslateText(
              value,
              style: MyTextTheme.mediumBCB.copyWith(
                fontSize: 15.33.sp,
                fontWeight: FontWeight.w400,
                color: "#8B1925".toColor(), // 1st-maroon
              ),
            ),
          ],
        ),
      ),
    );
  }
}
