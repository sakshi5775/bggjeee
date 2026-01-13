import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable header widget for astrology services screens
/// Accepts custom content while maintaining the same design
class AstrologyHeaderWidget extends StatelessWidget {
  final Widget content;
  final EdgeInsets? padding;
  final bool showRotatingCircle;

  const AstrologyHeaderWidget({
    Key? key,
    required this.content,
    this.padding,
    this.showRotatingCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF3D0C11), // Starting point
            const Color(0xFF5D1C21), // End point
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Large rotating circle positioned like sunrise (only top arcs visible)
          if (showRotatingCircle)
            Positioned(
              top: -80.h, // Position circle center below to show only top arcs
              left: 0,
              right: 0,
              child: Center(
                child: _RotatingCircle(),
              ),
            ),
          // Content on top
          content,
        ],
      ),
    );
  }
}

// Rotating Circle Widget - Covers complete center part (like rising sun)
class _RotatingCircle extends StatefulWidget {
  @override
  State<_RotatingCircle> createState() => _RotatingCircleState();
}

class _RotatingCircleState extends State<_RotatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    // Explicitly start the animation after a frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.repeat();
      }
    });
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
        return Transform.rotate(
          angle: -_controller.value * 2 * math.pi, // Clockwise rotation
          alignment: Alignment.center,
          child: Opacity(
            opacity: 0.3, // Decreased opacity for subtle effect
            child: SvgAssets(
              path: 'assets/app/appbar_circle.svg',
              width: 450.w, // Increased size to cover complete center part
              height: 380.h,
            ),
          ),
        );
      },
    );
  }
}




