import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalPlayerProgressWidget
    extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Obx(
            () => Slider(
              value: controller.currentPosition.value,
              min: 0,
              max: controller.maxPosition.value,
              activeColor: AppColors.deepOrange,
              inactiveColor: AppColors.deepOrange.withValues(alpha: 0.25),
              onChanged: (value) {
                controller.onSliderChanged(value);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1:52",
                style: AppTypography.body2.copyWith(
                  color: AppColors.deepOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "5:23",
                style: AppTypography.body2.copyWith(
                  color: AppColors.deepOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

