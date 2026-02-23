import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

/// Calibration hint widget with animated figure-8 motion
class CalibrationHint extends StatefulWidget {
  const CalibrationHint({Key? key}) : super(key: key);

  @override
  State<CalibrationHint> createState() => _CalibrationHintState();
}

class _CalibrationHintState extends State<CalibrationHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Slower, more spiritual
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // Full rotation
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.8), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 0.4), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: "#F38B3B".toColor().withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Icon(
                    Icons.rotate_right,
                    color: '#ffffff'.toColor(),
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: AutoTranslateText(
                    'Move device in figure-8 motion to calibrate',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: MyTextTheme.smallBCN
                        .copyWith(color: '#ffffff'.toColor())
                        .merge(AppTypography.body2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
