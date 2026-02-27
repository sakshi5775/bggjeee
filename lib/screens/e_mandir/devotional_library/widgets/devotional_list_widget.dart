import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_card_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class DevotionalListWidget extends GetView<DevotionalLibraryController> {
  const DevotionalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingTracks.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.deepOrange),
        );
      }

      if (controller.tracks.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_off, size: 48.r, color: Colors.grey.shade400),
              SizedBox(height: 12.h),
              AutoTranslateText(
                'No tracks found',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 80.h),
        itemCount: controller.tracks.length,
        itemBuilder: (context, index) {
          final track = controller.tracks[index];
          return Obx(() {
            final currentTrack = controller.audioService.currentTrack;
            final isCurrentTrack =
                currentTrack != null && currentTrack.id == track.id;
            final isPlaying =
                isCurrentTrack && controller.audioService.isPlaying.value;

            return DevotionalCardWidget(
              track: track,
              isPlaying: isPlaying,
              isCurrentTrack: isCurrentTrack,
              onTap: () => controller.navigateToPlayer(trackIndex: index),
              onPlayTap: () => controller.togglePlayTrack(index),
            );
          });
        },
      );
    });
  }
}
