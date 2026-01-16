import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// Confetti Animation Widget for Positive Results
class TarotConfettiWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration duration;

  const TarotConfettiWidget({
    super.key,
    this.onComplete,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<TarotConfettiWidget> createState() => _TarotConfettiWidgetState();
}

class _TarotConfettiWidgetState extends State<TarotConfettiWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final List<ConfettiParticle> _particles = [];
  final int _particleCount = 50;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _startAnimation();
  }

  void _initializeParticles() {
    final random = math.Random();
    _particles.clear();

    for (int i = 0; i < _particleCount; i++) {
      _particles.add(ConfettiParticle(
        x: random.nextDouble(),
        y: -0.1,
        angle: random.nextDouble() * 2 * math.pi,
        speed: 0.3 + random.nextDouble() * 0.5,
        color: _getRandomColor(random),
        size: 4 + random.nextDouble() * 6,
        shape: random.nextBool() ? ParticleShape.circle : ParticleShape.rectangle,
      ));
    }
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      AppColors.deepOrange, // Orange
      '#820B17'.toColor(), // Dark red
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
    ];
    return colors[random.nextInt(colors.length)];
  }

  void _startAnimation() {
    _controllers = List.generate(
      _particleCount,
      (index) => AnimationController(
        vsync: this,
        duration: widget.duration,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    // Start all animations
    for (var controller in _controllers) {
      controller.forward();
    }

    // Call onComplete after animation
    Future.delayed(widget.duration, () {
      if (mounted && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge(_animations),
        builder: (context, child) {
          return CustomPaint(
            painter: ConfettiPainter(
              particles: _particles,
              animations: _animations,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

enum ParticleShape { circle, rectangle }

class ConfettiParticle {
  double x;
  double y;
  double angle;
  double speed;
  Color color;
  double size;
  ParticleShape shape;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.shape,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final List<Animation<double>> animations;

  ConfettiPainter({
    required this.particles,
    required this.animations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length && i < animations.length; i++) {
      final particle = particles[i];
      final progress = animations[i].value;

      // Calculate position
      final x = particle.x * size.width;
      final y = particle.y * size.height + (progress * size.height * 1.5);
      final rotation = particle.angle + (progress * 4 * math.pi);

      // Draw particle
      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress * 0.5)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (particle.shape == ParticleShape.circle) {
        canvas.drawCircle(
          Offset.zero,
          particle.size,
          paint,
        );
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size * 1.5,
              height: particle.size,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return true;
  }
}

