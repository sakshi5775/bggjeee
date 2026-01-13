import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyPanchangButtonWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary; // true for orange gradient, false for white with orange border

  const DailyPanchangButtonWidget({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      // Orange gradient button (Get Panchang)
      return Container(
        width: double.infinity,
        height: 53.97.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              "#F38B3B".toColor(), // rgba(243, 139, 59, 1)
              "#DD2914".toColor(), // rgba(221, 41, 20, 1)
            ],
          ),
          borderRadius: BorderRadius.circular(10.98.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(10.98.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17.57.w),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : AutoTranslateText(
                        text,
                        style: MyTextTheme.mediumBCB.copyWith(
                          fontSize: 17.58.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    } else {
      // White button with orange border (Get Current Location)
      return Container(
        width: double.infinity,
        height: 53.97.h,
        decoration: BoxDecoration(
          color: "#FFFFFF".toColor(),
          borderRadius: BorderRadius.circular(10.98.r),
          border: Border.all(
            color: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                "#F38B3B".toColor(),
                "#DD2914".toColor(),
              ],
            ).colors.first,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(10.98.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17.57.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 21.96.w,
                      color: "#F15A24".toColor(),
                    ),
                    Spacing.w(12),
                  ],
                  isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              "#F15A24".toColor(),
                            ),
                          ),
                        )
                      : AutoTranslateText(
                          text,
                          style: MyTextTheme.mediumBCB.copyWith(
                            fontSize: 17.58.sp,
                            fontWeight: FontWeight.w500,
                            color: "#F15A24".toColor(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

