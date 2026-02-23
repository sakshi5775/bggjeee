import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/screens/vastu/utils/heatmap_math_utils.dart';
import 'dart:math' as math;

/// Advanced Heatmap Overlay
/// Shows real-time energy zones with gradients and smooth transitions
class HeatmapOverlay extends StatefulWidget {
  final VastuRoomConfig roomConfig;
  final String currentDirection;
  final double heading;

  const HeatmapOverlay({
    Key? key,
    required this.roomConfig,
    required this.currentDirection,
    required this.heading,
  }) : super(key: key);

  @override
  State<HeatmapOverlay> createState() => _HeatmapOverlayState();
}

class _HeatmapOverlayState extends State<HeatmapOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(HeatmapOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentDirection != widget.currentDirection) {
      _transitionController.reset();
      _transitionController.forward();
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        return CustomPaint(
          painter: AdvancedHeatmapPainter(
            roomConfig: widget.roomConfig,
            currentDirection: widget.currentDirection,
            heading: widget.heading,
            transitionValue: _transitionController.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class AdvancedHeatmapPainter extends CustomPainter {
  final VastuRoomConfig roomConfig;
  final String currentDirection;
  final double heading;
  final double transitionValue;

  AdvancedHeatmapPainter({
    required this.roomConfig,
    required this.currentDirection,
    required this.heading,
    required this.transitionValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // Draw zones for each direction
    final allDirections = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

    for (final direction in allDirections) {
      final energyLevel = HeatmapMathUtils.calculateEnergyLevel(
        direction,
        roomConfig,
      );

      final color = Color(HeatmapMathUtils.getHeatmapColor(energyLevel));
      final opacity =
          HeatmapMathUtils.getZoneOpacity(energyLevel) * transitionValue;

      // Draw zone with gradient
      _drawZoneWithGradient(
        canvas,
        center,
        maxRadius,
        direction,
        color,
        opacity,
        energyLevel,
      );
    }

    // Draw current direction highlight
    _drawCurrentDirectionHighlight(canvas, center, maxRadius);
  }

  void _drawZoneWithGradient(
    Canvas canvas,
    Offset center,
    double maxRadius,
    String direction,
    Color baseColor,
    double opacity,
    double energyLevel,
  ) {
    final angle = _directionToAngle(direction);
    final startAngle = (angle - 22.5) * math.pi / 180.0;
    final sweepAngle = 45 * math.pi / 180.0;

    // Create gradient from center to edge
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        baseColor.withValues(alpha: opacity * 0.3),
        baseColor.withValues(alpha: opacity),
        baseColor.withValues(alpha: opacity * 0.3),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: maxRadius),
      )
      ..style = PaintingStyle.fill;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Draw border for important zones
    if (energyLevel >= 0.8 || energyLevel <= 0.3) {
      final borderPaint = Paint()
        ..color = baseColor.withValues(alpha: opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: maxRadius),
        startAngle,
        sweepAngle,
        false,
        borderPaint,
      );
    }
  }

  void _drawCurrentDirectionHighlight(
    Canvas canvas,
    Offset center,
    double maxRadius,
  ) {
    final angle = _directionToAngle(currentDirection);
    final startAngle = (angle - 22.5) * math.pi / 180.0;
    final sweepAngle = 45 * math.pi / 180.0;

    // Draw pulsing highlight for current direction
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3 * transitionValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 0.95),
      startAngle,
      sweepAngle,
      false,
      highlightPaint,
    );
  }

  double _directionToAngle(String direction) {
    switch (direction.toUpperCase()) {
      case 'N':
        return -90;
      case 'NE':
        return -45;
      case 'E':
        return 0;
      case 'SE':
        return 45;
      case 'S':
        return 90;
      case 'SW':
        return 135;
      case 'W':
        return 180;
      case 'NW':
        return -135;
      default:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AdvancedHeatmapPainter) {
      return oldDelegate.currentDirection != currentDirection ||
          oldDelegate.roomConfig.roomType != roomConfig.roomType ||
          oldDelegate.transitionValue != transitionValue;
    }
    return true;
  }
}
