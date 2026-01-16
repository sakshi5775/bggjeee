import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

/// Direction overlay widget with smooth animations
class DirectionOverlay extends StatefulWidget {
  final String direction;
  final double heading;
  
  const DirectionOverlay({
    Key? key,
    required this.direction,
    required this.heading,
  }) : super(key: key);

  @override
  State<DirectionOverlay> createState() => _DirectionOverlayState();
}

class _DirectionOverlayState extends State<DirectionOverlay> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 120),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: AutoTranslateText(
          widget.direction,
          key: ValueKey(widget.direction),
          style: MyTextTheme.veryLargeBCB.copyWith(
            color: '#ffffff'.toColor(),
            fontWeight: FontWeight.bold,
            fontSize: 32.sp,
          ).merge(AppTypography.h1),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

