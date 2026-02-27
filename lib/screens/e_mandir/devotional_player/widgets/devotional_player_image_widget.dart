import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';

class DevotionalPlayerImageWidget extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final track = controller.audioService.currentTrack;
      return Container(
        height: 280.h,
        width: 280.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: track != null && track.thumbnailUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: track.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: 280.w,
                  height: 280.h,
                  placeholder: (_, __) => _placeholder(),
                  errorWidget: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
      );
    });
  }

  Widget _placeholder() {
    return Container(
      width: 280.w,
      height: 280.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade200, Colors.deepOrange.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.music_note, size: 80.r, color: Colors.white54),
    );
  }
}
