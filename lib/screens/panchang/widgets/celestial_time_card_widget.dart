import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class CelestialTimeCardWidget extends StatelessWidget {
  final String iconPath;
  final String label;
  final RxString time;
  final Color iconColor;

  const CelestialTimeCardWidget({
    super.key,
    required this.iconPath,
    required this.label,
    required this.time,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.33.w),
      decoration: BoxDecoration(
        color: "#F38B3B".toColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(13.41.r),
        border: Border.all(
          color: "#F38B3B".toColor(), // Orange border
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container - orange icon on white circle
          SvgAssets(path: iconPath, width: 42.w, height: 42.h),
          Spacing.h(7.67),
          // Label - orange color
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#F38B3B".toColor(), // 3rd-orange
            ),
          ),
          Spacing.h(4),
          // Time - maroon color
          Obx(
            () => AutoTranslateText(
              time.value.isNotEmpty ? time.value : '--:-- --',
              style: MyTextTheme.largeBCB.copyWith(
                fontWeight: FontWeight.w400,
                color: "#8B1925".toColor(), // 1st-maroon
              ),
            ),
          ),
        ],
      ),
    );
  }
}

