import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/falling_flower_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FallingFlowerWidget extends GetView<FallingFlowerController> {
  const FallingFlowerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (_, child) {
        return Positioned(
          top: controller.topPosition,
          left: controller.fixedX,
          child: Transform.rotate(
            angle: controller.rotationAngle,
            child: Opacity(
              opacity: controller.opacity.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: Image.asset(
        controller.imagePath,
        width: controller.size,
        height: controller.size,
      ),
    );
  }
}
