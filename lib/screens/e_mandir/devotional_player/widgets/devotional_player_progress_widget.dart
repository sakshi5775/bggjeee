import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalPlayerProgressWidget extends StatelessWidget {
  const DevotionalPlayerProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DevotionalPlayerController>();

    return Column(
      children: [
        Obx(
          () => SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 14,
              ),
            ),
            child: Slider(
              value: controller.currentPosition.value,
              min: 0,
              max: controller.maxPosition.value,
              activeColor: Colors.deepOrange,
              inactiveColor: Colors.deepOrange.withOpacity(0.25),
              onChanged: controller.onPositionChanged,
            ),
          ),
        ),
        Padding(
          padding: AppPaddings.symmetric(h: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                "1:52",
                style: MyTextTheme.smallBCN.copyWith(
                  color: Colors.deepOrange.shade400,
                  fontWeight: FontWeight.w500,
                ),
                translate: false,
              ),
              AutoTranslateText(
                "5:23",
                style: MyTextTheme.smallBCN.copyWith(
                  color: Colors.deepOrange.shade400,
                  fontWeight: FontWeight.w500,
                ),
                translate: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
