import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalPlayerControlsWidget
    extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final service = controller.audioService;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle
        Obx(
          () => IconButton(
            icon: Icon(
              Icons.shuffle,
              color: service.isShuffle.value
                  ? AppColors.deepOrange
                  : Colors.grey.shade500,
              size: 24.r,
            ),
            onPressed: service.toggleShuffle,
          ),
        ),

        // Previous
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: const Color(0xFF4E342E),
            size: 36.r,
          ),
          onPressed: service.playPrevious,
        ),

        // Play / Pause
        Obx(
          () => GestureDetector(
            onTap: service.togglePlay,
            child: Container(
              height: 64.r,
              width: 64.r,
              decoration: const BoxDecoration(
                color: AppColors.deepOrange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                service.isPlaying.value ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 36.r,
              ),
            ),
          ),
        ),

        // Next
        IconButton(
          icon: Icon(
            Icons.skip_next,
            color: const Color(0xFF4E342E),
            size: 36.r,
          ),
          onPressed: service.playNext,
        ),

        // Repeat
        Obx(
          () => IconButton(
            icon: Icon(
              Icons.repeat,
              color: service.isRepeat.value
                  ? AppColors.deepOrange
                  : Colors.grey.shade500,
              size: 24.r,
            ),
            onPressed: service.toggleRepeat,
          ),
        ),
      ],
    );
  }
}
