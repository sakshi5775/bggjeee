import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';

/// Dynamic Vastu Zone Overlay
/// Draws color-coded zones (green/red/neutral) based on room configuration
/// Rotates with the compass
class VastuZoneOverlay extends StatelessWidget {
  final double size;
  final double rotation;
  final VastuRoomConfig roomConfig;
  final String currentDirection;

  const VastuZoneOverlay({
    Key? key,
    required this.size,
    required this.rotation,
    required this.roomConfig,
    required this.currentDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If rotation is 0, it means parent is already rotating
    // Otherwise, apply rotation here
    Widget child = CustomPaint(
      size: Size(size, size),
      painter: VastuZonePainter(
        roomConfig: roomConfig,
        currentDirection: currentDirection,
      ),
    );

    if (rotation != 0) {
      child = Transform.rotate(angle: rotation, child: child);
    }

    return child;
  }
}

class VastuZonePainter extends CustomPainter {
  final VastuRoomConfig roomConfig;
  final String currentDirection;

  VastuZonePainter({required this.roomConfig, required this.currentDirection});

  // 16 directions mapping
  static const List<String> _directions = [
    'N',
    'NNE',
    'NE',
    'ENE',
    'E',
    'ESE',
    'SE',
    'SSE',
    'S',
    'SSW',
    'SW',
    'WSW',
    'W',
    'WNW',
    'NW',
    'NNW',
  ];

  // Color definitions
  static final Color _goodColor = '#2E7D32'.toColor(); // Emerald Green
  static final Color _badColor = '#C62828'.toColor(); // Deep Vermilion
  static final Color _neutralColor = '#E6CBA8'.toColor(); // Sand Gold

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Inner radius for zone ring (between direction ring and star)
    final innerRadius = radius * 0.35; // Start from 35% of radius
    final outerRadius = radius * 0.75; // End at 75% of radius

    // Draw 16 segments (one for each direction)
    for (int i = 0; i < 16; i++) {
      final direction = _directions[i];

      // Determine zone color
      Color zoneColor;
      if (roomConfig.isIdealDirection(direction)) {
        zoneColor = _goodColor;
      } else if (roomConfig.isAvoidDirection(direction)) {
        zoneColor = _badColor;
      } else {
        zoneColor = _neutralColor;
      }

      // Calculate angle for this segment
      // Each segment is 22.5 degrees (360 / 16)
      final startAngle = (i * 22.5 - 90) * math.pi / 180.0; // Start from North
      final sweepAngle = 22.5 * math.pi / 180.0;

      // Create path for segment
      final path = Path()
        ..moveTo(
          center.dx + innerRadius * math.cos(startAngle),
          center.dy + innerRadius * math.sin(startAngle),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..lineTo(
          center.dx + innerRadius * math.cos(startAngle + sweepAngle),
          center.dy + innerRadius * math.sin(startAngle + sweepAngle),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        )
        ..close();

      // Draw segment with gradient for depth (premium look)
      // Use semi-transparent colors to blend with base zone_ring.png image
      // Lower opacity so zone_ring.png texture shows through clearly
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            zoneColor.withValues(
              alpha: 0.65,
            ), // More transparent to show zone_ring.png texture
            zoneColor.withValues(alpha: 0.50),
            zoneColor.withValues(alpha: 0.60),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

      canvas.drawPath(path, paint);

      // Add subtle gold border between segments (premium detail)
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = '#D4AF37'.toColor().withValues(alpha: 0.4)
        ..strokeWidth = 1.0;

      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant VastuZonePainter oldDelegate) {
    return oldDelegate.roomConfig != roomConfig ||
        oldDelegate.currentDirection != currentDirection;
  }
}
