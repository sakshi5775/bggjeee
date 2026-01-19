import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

import 'common/app_bar_back_button.dart'; 

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final TextStyle? titleTextStyle;
  final List<Widget>? action;
  final bool? showLeading;
  final bool? centerTile;
  final Color? backgroundColor;
  final Gradient? gradient;
  const MyAppbar({
    super.key,
    required this.title,

    this.subTitle,
    this.titleTextStyle,
    this.backgroundColor,
    this.gradient,
    this.action,
    this.showLeading = true,
    this.centerTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null;
    final bgColor = hasGradient ? Colors.transparent : backgroundColor;
    
    return AppBar(
      leadingWidth: 56.w,
      centerTitle: centerTile,
      backgroundColor: bgColor,
      elevation: (bgColor == Colors.transparent || hasGradient) ? 0 : null,
      automaticallyImplyLeading: false,
      flexibleSpace: hasGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
            )
          : null,
      title: subTitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: titleTextStyle ?? MyTextTheme.veryLarge20.copyWith(
                    color: (bgColor == Colors.transparent || hasGradient)
                        ? (hasGradient ? Colors.white : const Color(0xFF8B1925))
                        : AppColors.lightBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AutoTranslateText(
                  subTitle ?? '', 
                  style: MyTextTheme.smallBCB.copyWith(
                    color: (bgColor == Colors.transparent || hasGradient)
                        ? (hasGradient ? Colors.white70 : AppColors.textSecondary)
                        : null,
                  ),
                ),
              ],
            )
          : AutoTranslateText(
              title,
              style: hasGradient
                  ? MyTextTheme.veryLarge20.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )
                  : null,
            ),
      titleTextStyle: titleTextStyle,
      actions: action,
      leading: showLeading == true ? AppBarBackButton() : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 56);
}
