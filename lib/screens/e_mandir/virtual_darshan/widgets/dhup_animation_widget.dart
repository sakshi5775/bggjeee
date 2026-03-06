import 'dart:math';
import 'dart:ui';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Animated Dhup widget: performs one full circular orbit with a yellow
/// star-burst glow, then transitions back to the docked position.
class DhupAnimationWidget extends GetView<VirtualDarshanController> {
  const DhupAnimationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hidden when not active and not mid-transition
      if (!controller.isDhupActive.value &&
          controller.dhupTransitionController.value == 0.0) {
        return const SizedBox.shrink();
      }

      final dhupImage = controller.selectedDhupImage.value;

      return AnimatedBuilder(
        animation: Listenable.merge([
          controller.dhupTransitionController,
          controller.dhupCircleController,
        ]),
        builder: (context, child) {
          final size = MediaQuery.of(context).size;
          final centerX = size.width / 2;
          final centerY = size.height / 2;

          // Docked position (center-bottom, same as thali)
          final dockedY = size.height - 5.h - 130.h;
          final dockedX = centerX;

          // Circular path
          final t = controller.dhupCircleController.value;
          const radius = 130.0;
          final angle = 2 * pi * t;
          final circleX = centerX + radius * cos(angle);
          final circleY = centerY + radius * sin(angle);

          // Interpolate dock → circle
          final progress = controller.dhupTransitionAnimation.value;
          final currentX = lerpDouble(dockedX, circleX, progress)!;
          final currentY = lerpDouble(dockedY, circleY, progress)!;

          // Scale: slightly larger during animation
          final dhupScale = lerpDouble(80.w, 110.w, progress)!;

          // Glow fades near end of rotation
          final glowOpacity =
              progress *
              (1.0 - (t > 0.9 ? (t - 0.9) * 10 : 0.0)).clamp(0.0, 1.0);

          return Positioned(
            left: currentX - (dhupScale / 2),
            top: currentY - (dhupScale / 2),
            child: SizedBox(
              width: dhupScale,
              height: dhupScale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Yellow star glow
                  if (progress > 0.0) _buildGlow(dhupScale, glowOpacity),
                  // Dhup image
                  _buildImage(dhupImage, dhupScale),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildGlow(double scale, double opacity) {
    return Container(
      width: scale * 1.3,
      height: scale * 1.3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.6 * opacity),
            Colors.orange.withValues(alpha: 0.3 * opacity),
            Colors.yellow.withValues(alpha: 0.1 * opacity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.4 * opacity),
            blurRadius: 24,
            spreadRadius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl, double scale) {
    if (imageUrl.isNotEmpty) {
      return NetworkImageWithLoader(
        url: imageUrl,
        fit: BoxFit.contain,
        width: scale * 0.75,
        height: scale * 0.75,
      );
    }
    return Icon(
      Icons.local_fire_department,
      size: scale * 0.5,
      color: Colors.orange,
    );
  }
}
