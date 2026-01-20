import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalPlayerControlsWidget extends StatelessWidget {
  const DevotionalPlayerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DevotionalPlayerController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset("assets/images/Button (1).png"),
        Image.asset("assets/images/Button (2).png"),
        Obx(
          () => InkWell(
            onTap: controller.togglePlayPause,
            child: Container(
              height: 64,
              width: 64,
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
        Image.asset("assets/images/Button (3).png"),
        Image.asset("assets/images/Button (4).png"),
      ],
    );
  }
}
