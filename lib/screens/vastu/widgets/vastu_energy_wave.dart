import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Vastu Energy Wave Widget
/// Subtle animated wave for spiritual feel
class VastuEnergyWave extends StatefulWidget {
  final Color waveColor;
  final double intensity;

  const VastuEnergyWave({
    Key? key,
    required this.waveColor,
    this.intensity = 1.0,
  }) : super(key: key);

  @override
  State<VastuEnergyWave> createState() => _VastuEnergyWaveState();
}

class _VastuEnergyWaveState extends State<VastuEnergyWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          painter: EnergyWavePainter(
            color: widget.waveColor,
            animation: _waveController,
            intensity: widget.intensity,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class EnergyWavePainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;
  final double intensity;

  EnergyWavePainter({
    required this.color,
    required this.animation,
    required this.intensity,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;
    
    // Draw multiple concentric waves
    for (int i = 0; i < 3; i++) {
      final phase = (animation.value + i * 0.33) % 1.0;
      final radius = maxRadius * 0.3 * phase;
      final opacity = (1.0 - phase) * 0.2 * intensity;
      
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


