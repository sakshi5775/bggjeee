import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PanchangToolButtonWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const PanchangToolButtonWidget({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPaddings.all(5),
        decoration: BoxDecoration(
          color: "#FFFFFF".toColor(),
          borderRadius: BorderRadius.circular(13.41.r),
          border: Border.all(color: "#F38B3B".toColor(), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            SvgAssets(path: iconPath, width: 42.w, height: 42.h),
            // Title
            AutoTranslateText(
              title,
              style: MyTextTheme.smallBCB.copyWith(
                fontWeight: FontWeight.w500,
                color: "#4C2B2A".toColor(),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
