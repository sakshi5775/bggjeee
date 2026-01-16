import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color? titleColor;
  final TextStyle? titleTextStyle;

  const CommonHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
    this.titleColor,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 15.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE ROW (never moves)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBackPressed ?? () => Get.back(),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.templeGold,
                      size: 24.w,
                    ),
                  ),
                ),

              if (showBackButton) SizedBox(width: 8.w),

              Expanded(
                child: AutoTranslateText(
                  title,
                  style: titleTextStyle ?? MyTextTheme.veryLarge20.copyWith(
                    color: titleColor ?? Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              if (actions != null) ...[SizedBox(width: 8.w), ...actions!],
            ],
          ),

          /// 🔹 SUBTITLE (always below)
          if (subtitle != null) ...[SizedBox(height: 6.h), subtitle!],
        ],
      ),
    );
  }
}