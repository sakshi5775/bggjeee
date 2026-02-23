import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'dart:math' as math;

/// Advanced AR Direction Overlay
/// Shows all 8 directions with smooth rotation, room-aware indicators, and distance-based opacity
class ARDirectionOverlay extends StatefulWidget {
  final double heading;
  final double? gyroRotation;
  final VastuRoomConfig? roomConfig;
  final List<String> directions;

  const ARDirectionOverlay({
    Key? key,
    required this.heading,
    this.gyroRotation,
    this.roomConfig,
    this.directions = const ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'],
  }) : super(key: key);

  @override
  State<ARDirectionOverlay> createState() => _ARDirectionOverlayState();
}

class _ARDirectionOverlayState extends State<ARDirectionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final Map<String, double> _directionAngles = {
    'N': -90.0,
    'NE': -45.0,
    'E': 0.0,
    'SE': 45.0,
    'S': 90.0,
    'SW': 135.0,
    'W': 180.0,
    'NW': -135.0,
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        final center = Offset(screenSize.width / 2, screenSize.height / 2);
        final radius = math.min(screenSize.width, screenSize.height) * 0.38;

        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Stack(
              children: widget.directions.map((direction) {
                final position = _calculateDirectionPosition(
                  direction,
                  screenSize,
                  center,
                  radius,
                );

                final opacity = _calculateOpacity(position, center, screenSize);
                final isVisible = opacity > 0.1;

                if (!isVisible) return const SizedBox.shrink();

                final isIdeal =
                    widget.roomConfig?.isIdealDirection(direction) ?? false;
                final isAvoid =
                    widget.roomConfig?.isAvoidDirection(direction) ?? false;

                return Positioned(
                  left: position.dx - 35.w,
                  top: position.dy - 20.h,
                  child: Opacity(
                    opacity: opacity,
                    child: _buildDirectionLabel(direction, isIdeal, isAvoid),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Offset _calculateDirectionPosition(
    String direction,
    Size screenSize,
    Offset center,
    double radius,
  ) {
    final baseAngle = _directionAngles[direction] ?? 0.0;

    // Adjust for current heading (compass rotates opposite to heading)
    final adjustedAngle = (baseAngle - widget.heading) * math.pi / 180.0;

    // Add gyroscope rotation for smooth movement
    final gyroAdjustment = (widget.gyroRotation ?? 0.0) * 0.1;
    final finalAngle = adjustedAngle + gyroAdjustment;

    // Calculate position
    final x = center.dx + radius * math.cos(finalAngle);
    final y = center.dy + radius * math.sin(finalAngle);

    return Offset(x, y);
  }

  double _calculateOpacity(Offset position, Offset center, Size screenSize) {
    // Calculate distance from center
    final distance = math.sqrt(
      math.pow(position.dx - center.dx, 2) +
          math.pow(position.dy - center.dy, 2),
    );

    final maxDistance = math.min(screenSize.width, screenSize.height) / 2;
    final normalizedDistance = (distance / maxDistance).clamp(0.0, 1.0);

    // Fade out as distance increases (more visible near edges)
    // But also fade if too close to center
    if (normalizedDistance < 0.2) {
      return normalizedDistance * 2.5; // Fade in from center
    } else if (normalizedDistance > 0.9) {
      return (1.0 - normalizedDistance) * 10; // Fade out at edges
    } else {
      return 1.0; // Fully visible in middle zone
    }
  }

  Widget _buildDirectionLabel(String direction, bool isIdeal, bool isAvoid) {
    final isNorth = direction == 'N';

    Color backgroundColor;
    Color borderColor;
    double borderWidth;

    if (isIdeal) {
      backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.85);
      borderColor = const Color(0xFF66BB6A);
      borderWidth = 2.0;
    } else if (isAvoid) {
      backgroundColor = const Color(0xFFE53935).withValues(alpha: 0.85);
      borderColor = const Color(0xFFEF5350);
      borderWidth = 2.0;
    } else if (isNorth) {
      backgroundColor = Colors.red.withValues(alpha: 0.9);
      borderColor = Colors.white.withValues(alpha: 0.5);
      borderWidth = 1.5;
    } else {
      backgroundColor = Colors.black.withValues(alpha: 0.7);
      borderColor = Colors.white.withValues(alpha: 0.3);
      borderWidth = 1.0;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color:
                (isIdeal
                        ? const Color(0xFF4CAF50)
                        : isAvoid
                        ? const Color(0xFFE53935)
                        : Colors.black)
                    .withValues(alpha: 0.4),
            blurRadius: isIdeal || isAvoid ? 12 : 6,
            spreadRadius: isIdeal || isAvoid ? 2 : 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            direction,
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: Colors.white,
                  fontWeight: isNorth || isIdeal || isAvoid
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: isNorth ? 16.sp : 14.sp,
                )
                .merge(AppTypography.h3),
          ),
          if (isIdeal) ...[
            SizedBox(width: 4.w),
            Icon(Icons.check_circle, size: 16.w, color: Colors.white),
          ],
          if (isAvoid) ...[
            SizedBox(width: 4.w),
            Icon(Icons.warning, size: 16.w, color: Colors.white),
          ],
        ],
      ),
    );
  }
}
