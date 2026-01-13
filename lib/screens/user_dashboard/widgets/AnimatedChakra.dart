import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedChakra extends StatefulWidget {
  final Widget child;
  const AnimatedChakra({super.key, required this.child});

  @override
  State<AnimatedChakra> createState() => _AnimatedChakraState();
}

class _AnimatedChakraState extends State<AnimatedChakra>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
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
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Opacity(
            opacity: 0.2,
            child: widget.child,
          ),
        );
      },
    );
  }
}
