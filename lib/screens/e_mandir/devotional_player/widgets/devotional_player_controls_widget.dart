import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

class DevotionalPlayerControlsWidget extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(AppConstant.eMandirButton1),
        Image.asset(AppConstant.eMandirButton2),
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
        Image.asset(AppConstant.eMandirButton3),
        Image.asset(AppConstant.eMandirButton4),
      ],
    );
  }
}
