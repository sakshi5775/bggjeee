import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Mini-player bar shown at the bottom of the library when a track is playing.
class MiniPlayerWidget extends GetView<DevotionalLibraryController> {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final service = controller.audioService;
      if (!service.isMiniPlayerVisible.value || service.currentTrack == null) {
        return const SizedBox.shrink();
      }

      final track = service.currentTrack!;
      final isPlaying = service.isPlaying.value;

      return GestureDetector(
        onTap: () => controller.navigateToPlayer(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: track.thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: track.thumbnailUrl,
                        width: 42.r,
                        height: 42.r,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              SizedBox(width: 10.w),

              // Title + Artist
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoTranslateText(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    AutoTranslateText(
                      track.artist.isNotEmpty ? track.artist : 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),

              // Play/Pause
              GestureDetector(
                onTap: () => service.togglePlay(),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.deepOrange,
                    size: 22.r,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Close / Stop
              GestureDetector(
                onTap: () => service.stopAndDismiss(),
                child: Icon(Icons.close, color: Colors.white, size: 22.r),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _placeholder() {
    return Container(
      width: 42.r,
      height: 42.r,
      color: Colors.white24,
      child: Icon(Icons.music_note, size: 20.r, color: Colors.white54),
    );
  }
}
