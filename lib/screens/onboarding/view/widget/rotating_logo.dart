import 'package:flutter/material.dart';

class RotatingLogo extends StatefulWidget {
  const RotatingLogo({super.key});

  @override
  State<RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<RotatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // speed control
    )..repeat(); // 🔁 infinite
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset("assets/images/logo.png", height: 100),
    );
  }
}
