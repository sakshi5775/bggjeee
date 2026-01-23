import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalPlayerControlsWidget extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset("assets/images/Button (1).png"),
        Image.asset("assets/images/Button (2).png"),
        Obx(() => GestureDetector(
          onTap: () {
            controller.togglePlay();
          },
          child: Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              color: AppColors.deepOrange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 36,
            ),
          ),
        )),
        Image.asset("assets/images/Button (3).png"),
        Image.asset("assets/images/Button (4).png"),
      ],
    );
  }
}
