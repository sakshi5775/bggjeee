import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/waiting_screen/waiting_screen/controller/waiting_screen_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

class WaitingScreenView extends BasePage<WaitingScreenController> {
  const WaitingScreenView({super.key});

  static const String _splashImagePath = 'assets/app/Astrobharat.png';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imageSize = size.shortestSide * 0.9;
    return Scaffold(
      backgroundColor: AppColors.saffronmix,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Image.asset(
              _splashImagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
