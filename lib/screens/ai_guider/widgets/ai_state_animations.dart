import 'package:astrobharataiuser/screens/ai_guider/controller/ai_guider_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AI Orb Animation (Idle state)
class AiOrbAnimation extends StatefulWidget {
  const AiOrbAnimation({super.key});

  @override
  State<AiOrbAnimation> createState() => _AiOrbAnimationState();
}

class _AiOrbAnimationState extends State<AiOrbAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.8),
                    Colors.orange.withValues(alpha: 0.6),
                    Colors.deepOrange.withValues(alpha: 0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.5),
                    blurRadius: 30.r,
                    spreadRadius: 5.r,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: 60.w,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Waveform Animation (Listening state)
class WaveformAnimation extends StatefulWidget {
  const WaveformAnimation({super.key});

  @override
  State<WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<WaveformAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0.3, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              width: 8.w,
              height: 40.h * _animations[index].value,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4.r),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Thinking Dots Animation
class ThinkingDotsAnimation extends StatefulWidget {
  const ThinkingDotsAnimation({super.key});

  @override
  State<ThinkingDotsAnimation> createState() => _ThinkingDotsAnimationState();
}

class _ThinkingDotsAnimationState extends State<ThinkingDotsAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..repeat(),
    );

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].forward();
      });
    }

    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _animations[index].value,
              child: Container(
                width: 12.w,
                height: 12.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Speaking Glow Pulse Animation
class SpeakingGlowAnimation extends StatefulWidget {
  const SpeakingGlowAnimation({super.key});

  @override
  State<SpeakingGlowAnimation> createState() => _SpeakingGlowAnimationState();
}

class _SpeakingGlowAnimationState extends State<SpeakingGlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.amber.withValues(alpha: _glowAnimation.value * 0.9),
                Colors.orange.withValues(alpha: _glowAnimation.value * 0.7),
                Colors.deepOrange.withValues(alpha: _glowAnimation.value * 0.5),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(
                  alpha: _glowAnimation.value * 0.6,
                ),
                blurRadius: 40.r * _glowAnimation.value,
                spreadRadius: 10.r * _glowAnimation.value,
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.volume_up, size: 60.w, color: Colors.white),
          ),
        );
      },
    );
  }
}

/// Interrupted Fade Animation
class InterruptedFadeAnimation extends StatefulWidget {
  const InterruptedFadeAnimation({super.key});

  @override
  State<InterruptedFadeAnimation> createState() =>
      _InterruptedFadeAnimationState();
}

class _InterruptedFadeAnimationState extends State<InterruptedFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Icon(
                Icons.pause_circle_outline,
                size: 60.w,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Main State Animation Widget
class AiStateAnimation extends StatelessWidget {
  const AiStateAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AiGuiderController>();

    return Obx(() {
      switch (controller.currentState.value) {
        case AiGuiderState.idle:
          return const AiOrbAnimation();
        case AiGuiderState.listening:
          return const WaveformAnimation();
        case AiGuiderState.thinking:
          return const ThinkingDotsAnimation();
        case AiGuiderState.speaking:
          return const SpeakingGlowAnimation();
        case AiGuiderState.interrupted:
          return const InterruptedFadeAnimation();
      }
    });
  }
}
