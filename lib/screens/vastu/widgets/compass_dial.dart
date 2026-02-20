import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/// Premium compass dial widget with smooth rotation
class CompassDial extends StatefulWidget {
  final double heading;
  final bool isCalibrated;
  
  const CompassDial({
    Key? key,
    required this.heading,
    required this.isCalibrated,
  }) : super(key: key);

  @override
  State<CompassDial> createState() => _CompassDialState();
}

class _CompassDialState extends State<CompassDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  double _currentRotation = 0.0;
  double _targetRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200), // Within 180-220ms spec
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutCubic,
    ));
    
    _rotationController.addListener(() {
      setState(() {
        _currentRotation = _rotationAnimation.value;
      });
    });
  }

  @override
  void didUpdateWidget(CompassDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.heading != widget.heading) {
      _updateRotation();
    }
  }

  void _updateRotation() {
    // Calculate target rotation (compass rotates opposite to heading)
    _targetRotation = -widget.heading * math.pi / 180.0;
    
    // Update animation
    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: _targetRotation,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutCubic,
    ));
    
    _rotationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _currentRotation,
      child: Container(
        width: 280.w,
        height: 280.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CustomPaint(
          painter: CompassDialPainter(),
        ),
      ),
    );
  }
}

class CompassDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw outer circle
    final outerPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, outerPaint);
    
    // Draw direction markers
    final directions = ['N', 'E', 'S', 'W'];
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90 - 90) * math.pi / 180.0;
      final x = center.dx + (radius - 30) * math.cos(angle);
      final y = center.dy + (radius - 30) * math.sin(angle);
      
      // Draw line
      final linePaint = Paint()
        ..color = i == 0 ? Colors.red : Colors.black
        ..strokeWidth = i == 0 ? 3 : 2;
      canvas.drawLine(
        center,
        Offset(x, y),
        linePaint,
      );
      
      // Draw text
      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          fontSize: 20,
          fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
          color: i == 0 ? Colors.red : Colors.black,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );
    }
    
    // Draw center dot
    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


