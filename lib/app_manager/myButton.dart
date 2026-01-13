import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import '../core/value/dimension.dart';

class MyButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? elevation;
  final double? borderWidth;
  final double? width;
  final Function? onPress;
  final Color? color;
  final TextStyle? textStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? borderColor;
  final Color? textColor;
  final bool useGradient; // 👈 new parameter to toggle gradient

  const MyButton({
    super.key,
    required this.title,
    this.onPress,
    this.color,
    this.height,
    this.textStyle,
    this.elevation,
    this.suffixIcon,
    this.prefixIcon,
    this.width,
    this.borderColor,
    this.borderWidth,
    this.textColor,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: borderColor != null
            ? Border.all(
                color: borderColor ?? AppColors.saffron,
                width: borderWidth ?? 1,
              )
            : null,
        borderRadius: AppRadius.all(12),
        gradient: useGradient
            ? LinearGradient(
                colors: [AppColors.saffron, const Color(0xFF310400)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: useGradient ? null : color ?? AppColors.saffron,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          shadowColor: AppColors.saffron,
          elevation: elevation ?? 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.all(5)),
        ),
        onPressed: () {
          if (onPress != null) onPress!();
        },
        child: Padding(
          padding: AppPaddings.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (suffixIcon != null) ...[
                suffixIcon!,
                const SizedBox(width: 5),
              ],
              Flexible(
                child: AutoTranslateText(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style:
                      textStyle ??
                      MyTextTheme.mediumWCB.copyWith(
                        color: textColor ?? AppColors.lightBackground,
                      ),
                ),
              ),
              if (prefixIcon != null) ...[
                const SizedBox(width: 5),
                prefixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
