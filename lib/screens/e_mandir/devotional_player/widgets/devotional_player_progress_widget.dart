import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalPlayerProgressWidget
    extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final service = controller.audioService;
          final position = service.currentPosition.value;
          final duration = service.totalDuration.value;
          final maxVal = duration.inMilliseconds > 0
              ? duration.inMilliseconds.toDouble()
              : 1.0;
          final curVal = position.inMilliseconds.toDouble().clamp(0.0, maxVal);

          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: AppColors.deepOrange,
              inactiveTrackColor: AppColors.deepOrange.withValues(alpha: 0.2),
              thumbColor: AppColors.deepOrange,
            ),
            child: Slider(
              value: curVal,
              min: 0,
              max: maxVal,
              onChanged: (value) {
                service.seek(Duration(milliseconds: value.toInt()));
              },
            ),
          );
        }),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(() {
            final service = controller.audioService;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.formatDuration(service.currentPosition.value),
                  style: TextStyle(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  service.formatDuration(service.totalDuration.value),
                  style: TextStyle(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
