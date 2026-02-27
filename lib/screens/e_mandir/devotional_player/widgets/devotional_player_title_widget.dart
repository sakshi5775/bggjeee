import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class DevotionalPlayerTitleWidget extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final track = controller.audioService.currentTrack;
      return Column(
        children: [
          AutoTranslateText(
            track != null && track.title.isNotEmpty
                ? track.title
                : 'No Track Selected',
            style: AppTypography.h2.copyWith(
              color: const Color(0xFF4E342E),
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          AutoTranslateText(
            track != null && track.artist.isNotEmpty
                ? track.artist
                : track?.godCategory?.godName ?? '',
            style: AppTypography.body1.copyWith(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    });
  }
}
