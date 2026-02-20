import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'dart:math' as math;

/// Room-Aware AR Guidance Widget
/// Shows visual highlights for ideal/avoid directions with tooltips
class RoomAwareARGuidance extends StatefulWidget {
  final VastuRoomConfig roomConfig;
  final String currentDirection;
  final double heading;
  final double? gyroRotation;

  const RoomAwareARGuidance({
    Key? key,
    required this.roomConfig,
    required this.currentDirection,
    required this.heading,
    this.gyroRotation,
  }) : super(key: key);

  @override
  State<RoomAwareARGuidance> createState() => _RoomAwareARGuidanceState();
}

class _RoomAwareARGuidanceState extends State<RoomAwareARGuidance>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  String? _hoveredDirection;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        final center = Offset(screenSize.width / 2, screenSize.height / 2);
        final radius = math.min(screenSize.width, screenSize.height) * 0.4;
        
        return AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Stack(
              children: [
                // Draw ideal direction highlights (green glow)
                ...widget.roomConfig.idealDirections.map((direction) {
                  return _buildDirectionHighlight(
                    direction,
                    screenSize,
                    center,
                    radius,
                    isIdeal: true,
                  );
                }),
                
                // Draw avoid direction warnings (red pulse)
                ...widget.roomConfig.avoidDirections.map((direction) {
                  return _buildDirectionHighlight(
                    direction,
                    screenSize,
                    center,
                    radius,
                    isIdeal: false,
                  );
                }),
                
                // Draw tooltip for hovered direction
                if (_hoveredDirection != null)
                  _buildTooltip(_hoveredDirection!, screenSize, center, radius),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDirectionHighlight(
    String direction,
    Size screenSize,
    Offset center,
    double radius, {
    required bool isIdeal,
  }) {
    final position = _calculateDirectionPosition(direction, center, radius);
    final glowIntensity = _glowController.value;
    
    return Positioned(
      left: position.dx - 60.w,
      top: position.dy - 60.h,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _hoveredDirection = _hoveredDirection == direction ? null : direction;
          });
        },
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isIdeal
                  ? [
                      const Color(0xFF4CAF50).withValues(alpha: 0.3 * glowIntensity),
                      const Color(0xFF4CAF50).withValues(alpha: 0.0),
                    ]
                  : [
                      const Color(0xFFE53935).withValues(alpha: 0.3 * glowIntensity),
                      const Color(0xFFE53935).withValues(alpha: 0.0),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: isIdeal
                    ? const Color(0xFF4CAF50).withValues(alpha: 0.5 * glowIntensity)
                    : const Color(0xFFE53935).withValues(alpha: 0.5 * glowIntensity),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              isIdeal ? Icons.check_circle : Icons.warning,
              color: isIdeal
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
              size: 32.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip(
    String direction,
    Size screenSize,
    Offset center,
    double radius,
  ) {
    final position = _calculateDirectionPosition(direction, center, radius);
    final isIdeal = widget.roomConfig.isIdealDirection(direction);
    final isAvoid = widget.roomConfig.isAvoidDirection(direction);
    final guidance = widget.roomConfig.getGuidanceForDirection(direction);
    
    return Positioned(
      left: position.dx - 100.w,
      top: position.dy - 80.h,
      child: Container(
        width: 200.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: (isIdeal
                  ? const Color(0xFF4CAF50)
                  : isAvoid
                      ? const Color(0xFFE53935)
                      : Colors.blueGrey)
              .withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              '$direction Direction',
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.body2),
            ),
            SizedBox(height: 4.h),
            AutoTranslateText(
              guidance,
              style: MyTextTheme.smallBCN.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ).merge(AppTypography.body2),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Offset _calculateDirectionPosition(
    String direction,
    Offset center,
    double radius,
  ) {
    final directionAngles = {
      'N': -90.0,
      'NE': -45.0,
      'E': 0.0,
      'SE': 45.0,
      'S': 90.0,
      'SW': 135.0,
      'W': 180.0,
      'NW': -135.0,
    };
    
    final baseAngle = directionAngles[direction] ?? 0.0;
    final adjustedAngle = (baseAngle - widget.heading) * math.pi / 180.0;
    final gyroAdjustment = (widget.gyroRotation ?? 0.0) * 0.1;
    final finalAngle = adjustedAngle + gyroAdjustment;
    
    final x = center.dx + radius * math.cos(finalAngle);
    final y = center.dy + radius * math.sin(finalAngle);
    
    return Offset(x, y);
  }
}


