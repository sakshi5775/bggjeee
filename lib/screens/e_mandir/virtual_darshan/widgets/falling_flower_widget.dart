import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:flutter/material.dart';

import '../../../../app_manager/network_image.dart';

class FallingFlowerWidget extends StatelessWidget {
  final FallingFlowerState flowerState;

  const FallingFlowerWidget({super.key, required this.flowerState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flowerState.animationController,
      builder: (_, child) {
        return Positioned(
          top: flowerState.topPosition,
          left: flowerState.fixedX,
          child: Transform.rotate(
            angle: flowerState.rotationAngle,
            child: Opacity(
              opacity: flowerState.opacity.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: flowerState.imagePath.startsWith('http')
          ? NetworkImageWithLoader(
              url: flowerState.imagePath,
              width: flowerState.size,
              fit: BoxFit.cover,
              height: flowerState.size,
            )
          : Image.asset(
              flowerState.imagePath,
              width: flowerState.size,
              fit: BoxFit.cover,
              height: flowerState.size,
            ),
    );
  }
}
