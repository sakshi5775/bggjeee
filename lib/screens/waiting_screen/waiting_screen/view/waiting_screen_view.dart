import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/waiting_screen/waiting_screen/controller/waiting_screen_controller.dart';
import 'package:flutter/material.dart';

class WaitingScreenView extends BasePage<WaitingScreenController> {
  const WaitingScreenView({super.key});

  static const String _splashImagePath = 'assets/app/Astrobharat.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3D0C11), Color(0xFF5D1C21)],
          ),
        ),
        child: Center(
          child: Image.asset(
            _splashImagePath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
