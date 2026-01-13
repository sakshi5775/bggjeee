import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: -_controller.value * 2 * math.pi,
            child: CustomPaint(
              size: const Size(80, 80),
              painter: _FullGradientCircularPainter(),
            ),
          );
        },
      ),
    );
  }
}

class _FullGradientCircularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    const strokeWidth = 12.0;

    // Create gradient with a short dark section and long fade
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: [
        const Color(0xFF582622), // Dark brown - solid
        const Color(0xFF582622), // Keep solid for a bit
        const Color(0xFF8B7B7A), // Medium fade
        const Color(0xFFB8ACAB), // Light fade
        const Color(0xFFD4C5C4), // Very light
        const Color(0x00FFFFFF), // Completely transparent
      ],
      stops: const [0.0, 0.15, 0.35, 0.55, 0.75, 1.0],
      transform: const GradientRotation(-math.pi / 2), // Start from top
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Draw FULL circle (360 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 2, // Full 360 degrees
      false,
      paint,
    );

    // Manually draw rounded cap at the START/END point (where dark meets transparent)
    // This is at the top position after gradient rotation
    final capAngle = -math.pi / 2; // Top position
    final capX = center.dx + radius * math.cos(capAngle);
    final capY = center.dy + radius * math.sin(capAngle);

    final capPaint = Paint()
      ..color =
          const Color(0xFF582622) // Dark brown
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(capX, capY), strokeWidth / 2, capPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
