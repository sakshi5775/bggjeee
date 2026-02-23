import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'dart:math' as math;

/// Smart contextual overlay showing ideal/avoid directions
class ContextualOverlay extends StatelessWidget {
  final String currentDirection;
  final VastuRoomConfig roomConfig;

  const ContextualOverlay({
    Key? key,
    required this.currentDirection,
    required this.roomConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors disabled per request; no overlay drawn
    return const SizedBox.shrink();
  }
}

class ContextualOverlayPainter extends CustomPainter {
  final String currentDirection;
  final VastuRoomConfig roomConfig;

  ContextualOverlayPainter({
    required this.currentDirection,
    required this.roomConfig,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw ideal directions in green (subtle, spiritual)
    for (final direction in roomConfig.idealDirections) {
      _drawDirectionIndicator(
        canvas,
        center,
        radius,
        direction,
        const Color(0xFF4CAF50).withValues(alpha: 0.25), // Softer green
        const Color(0xFF4CAF50),
      );
    }

    // Draw avoid directions in red (subtle warning)
    for (final direction in roomConfig.avoidDirections) {
      _drawDirectionIndicator(
        canvas,
        center,
        radius,
        direction,
        const Color(0xFFE53935).withValues(alpha: 0.15), // Softer red
        const Color(0xFFE53935),
      );
    }

    // Highlight current direction
    final isIdeal = roomConfig.isIdealDirection(currentDirection);
    final isAvoid = roomConfig.isAvoidDirection(currentDirection);

    if (isIdeal || isAvoid) {
      _drawCurrentDirectionHighlight(
        canvas,
        center,
        radius,
        currentDirection,
        isIdeal ? Colors.green : Colors.red,
      );
    }
  }

  void _drawDirectionIndicator(
    Canvas canvas,
    Offset center,
    double radius,
    String direction,
    Color fillColor,
    Color strokeColor,
  ) {
    final angle = _directionToAngle(direction);
    final startAngle = (angle - 15) * math.pi / 180;
    final sweepAngle = 30 * math.pi / 180;

    // Draw arc
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      borderPaint,
    );
  }

  void _drawCurrentDirectionHighlight(
    Canvas canvas,
    Offset center,
    double radius,
    String direction,
    Color color,
  ) {
    final angle = _directionToAngle(direction);
    final x = center.dx + (radius - 10) * math.cos(angle * math.pi / 180);
    final y = center.dy + (radius - 10) * math.sin(angle * math.pi / 180);

    // Draw pulsing circle
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 12, paint);

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(x, y), 12, borderPaint);
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
    if (oldDelegate is ContextualOverlayPainter) {
      return oldDelegate.currentDirection != currentDirection ||
          oldDelegate.roomConfig.roomType != roomConfig.roomType;
    }
    return true;
  }
}
