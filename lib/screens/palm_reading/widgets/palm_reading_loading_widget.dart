import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PalmReadingLoadingWidget extends StatefulWidget {
  final String? message;
  
  const PalmReadingLoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  State<PalmReadingLoadingWidget> createState() => _PalmReadingLoadingWidgetState();
}

class _PalmReadingLoadingWidgetState extends State<PalmReadingLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    
    // Rotation animation for the main circle
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Pulse animation for the center
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Wave animation for the text
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated loader
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer rotating circle
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: Size(120.w, 120.w),
                          painter: _PalmReadingLoaderPainter(),
                        ),
                      );
                    },
                  ),
                  // Pulsing center icon
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            color: AppColors.deepOrange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.pan_tool,
                            color: AppColors.deepOrange,
                            size: 30.w,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Animated text
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        AppColors.deepOrange,
                        AppColors.deepOrange.withOpacity(0.5),
                        AppColors.deepOrange,
                      ],
                      stops: [
                        (_waveAnimation.value - 0.3).clamp(0.0, 1.0),
                        _waveAnimation.value.clamp(0.0, 1.0),
                        (_waveAnimation.value + 0.3).clamp(0.0, 1.0),
                      ],
                    ).createShader(bounds);
                  },
                  child: AutoTranslateText(
                    widget.message ?? 'Analyzing Palm...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).merge(AppTypography.h2),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'This may take a few moments',
              style: TextStyle(
                color: '#666666'.toColor(),
              ).merge(AppTypography.body2),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            // Progress dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final animationValue = (_waveAnimation.value + delay) % 1.0;
                    final opacity = (math.sin(animationValue * math.pi * 2) + 1) / 2;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppColors.deepOrange.withOpacity(0.3 + opacity * 0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _PalmReadingLoaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 8.0;

    // Draw multiple arcs with different colors matching face reading theme
    final arcs = [
      {'color': '#F38B3B', 'start': 0.0, 'sweep': 0.4},
      {'color': '#FF8C5A', 'start': 0.4, 'sweep': 0.3},
      {'color': '#FFB08A', 'start': 0.7, 'sweep': 0.2},
      {'color': '#FFD4BA', 'start': 0.9, 'sweep': 0.1},
    ];

    for (var arc in arcs) {
      final paint = Paint()
        ..color = (arc['color'] as String).toColor()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (arc['start'] as double) * 2 * math.pi,
        (arc['sweep'] as double) * 2 * math.pi,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

