import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'dart:math' as math;

/// Advanced AR Element Overlay
/// Visualizes Vastu elements with enhanced animations and particle effects
class ARElementOverlay extends StatefulWidget {
  final VastuRoomConfig roomConfig;
  final String currentDirection;
  final double heading;

  const ARElementOverlay({
    Key? key,
    required this.roomConfig,
    required this.currentDirection,
    required this.heading,
  }) : super(key: key);

  @override
  State<ARElementOverlay> createState() => _ARElementOverlayState();
}

class _ARElementOverlayState extends State<ARElementOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for element waves
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Particle animation (slower, for subtle effect)
    _particleController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final element = widget.roomConfig.elementType;
    final isIdeal = widget.roomConfig.isIdealDirection(widget.currentDirection);

    // Only show element visualization if direction is ideal or neutral
    if (widget.roomConfig.isAvoidDirection(widget.currentDirection)) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);

        return AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _particleAnimation]),
          builder: (context, child) {
            return CustomPaint(
              size: screenSize,
              painter: AdvancedElementPainter(
                element: element,
                pulseValue: _pulseAnimation.value,
                particleValue: _particleAnimation.value,
                screenSize: screenSize,
                heading: widget.heading,
                isIdeal: isIdeal,
              ),
            );
          },
        );
      },
    );
  }
}

class AdvancedElementPainter extends CustomPainter {
  final VastuElement element;
  final double pulseValue;
  final double particleValue;
  final Size screenSize;
  final double heading;
  final bool isIdeal;

  AdvancedElementPainter({
    required this.element,
    required this.pulseValue,
    required this.particleValue,
    required this.screenSize,
    required this.heading,
    required this.isIdeal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final elementData = _getElementData(element);

    // Draw multiple concentric waves for depth
    for (int i = 0; i < 3; i++) {
      final phase = (pulseValue + i * 0.33) % 1.0;
      final radius = 80.0 + (phase * 60.0);
      final opacity = (0.2 - (phase * 0.15)).clamp(0.0, 0.2);

      final paint = Paint()
        ..color = elementData['color'].withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }

    // Draw particle effects (lightweight)
    if (isIdeal) {
      _drawParticles(canvas, center, elementData);
    }

    // Draw element symbol/icon
    _drawElementSymbol(canvas, center, elementData);
  }

  Map<String, dynamic> _getElementData(VastuElement element) {
    switch (element) {
      case VastuElement.fire:
        return {
          'color': const Color(0xFFF38B3B),
          'symbol': '🔥',
          'gradient': [const Color(0xFFF38B3B), const Color(0xFFDD2914)],
        };
      case VastuElement.water:
        return {
          'color': const Color(0xFF2196F3),
          'symbol': '💧',
          'gradient': [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
        };
      case VastuElement.air:
        return {
          'color': const Color(0xFF9E9E9E),
          'symbol': '💨',
          'gradient': [const Color(0xFF9E9E9E), const Color(0xFFBDBDBD)],
        };
      case VastuElement.earth:
        return {
          'color': const Color(0xFF8D6E63),
          'symbol': '🌍',
          'gradient': [const Color(0xFF8D6E63), const Color(0xFFA1887F)],
        };
      case VastuElement.space:
        return {
          'color': const Color(0xFF9C27B0),
          'symbol': '✨',
          'gradient': [const Color(0xFF9C27B0), const Color(0xFFBA68C8)],
        };
    }
  }

  void _drawParticles(Canvas canvas, Offset center, Map<String, dynamic> data) {
    // Draw lightweight particles (only 8 particles for performance)
    for (int i = 0; i < 8; i++) {
      final angle = (particleValue * 2 * math.pi) + (i * math.pi / 4);
      final distance = 50.0 + (pulseValue * 30.0);
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);

      final paint = Paint()
        ..color = data['color'].withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 3.0, paint);
    }
  }

  void _drawElementSymbol(
    Canvas canvas,
    Offset center,
    Map<String, dynamic> data,
  ) {
    // Draw gradient circle as symbol
    final gradient = RadialGradient(
      colors: data['gradient'],
      stops: const [0.0, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: 25),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, paint);

    // Draw outer ring
    final ringPaint = Paint()
      ..color = data['color'].withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 30, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
