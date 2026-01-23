import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FallingFlowerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final double startX;
  final OverlayEntry entry;
  final String imagePath;
  final double screenHeight;

  late AnimationController animationController;
  late Animation<double> fallAnimation;
  late Animation<double> rotationAnimation;
  late double fixedX;
  late double size;
  final Random random = Random();

  FallingFlowerController({
    required this.startX,
    required this.entry,
    required this.imagePath,
    required this.screenHeight,
  });

  @override
  void onInit() {
    super.onInit();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    fixedX = startX;

    final duration = Duration(milliseconds: 14000 + random.nextInt(4000));

    animationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    fallAnimation = Tween<double>(
      begin: -0.15,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    ));

    rotationAnimation = Tween<double>(
      begin: 0,
      end: (random.nextBool() ? 1 : -1) * pi,
    ).animate(animationController);

    size = 28 + random.nextDouble() * 20;

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        entry.remove();
        Get.delete<FallingFlowerController>();
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  double get topPosition => fallAnimation.value * screenHeight;

  double get rotationAngle => rotationAnimation.value;

  double get opacity {
    final progress = fallAnimation.value;
    if (progress > 0.85) {
      return (1.0 - progress) / 0.15;
    }
    return 1.0;
  }
}
