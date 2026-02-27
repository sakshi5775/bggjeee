import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import '../data_model/devotional_music_model.dart';

class DevotionalCardWidget extends StatelessWidget {
  final DevotionalMusicItem track;
  final bool isPlaying;
  final bool isCurrentTrack;
  final VoidCallback onTap;
  final VoidCallback onPlayTap;

  const DevotionalCardWidget({
    super.key,
    required this.track,
    this.isPlaying = false,
    this.isCurrentTrack = false,
    required this.onTap,
    required this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: isCurrentTrack
              ? AppColors.deepOrange.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isCurrentTrack ? AppColors.deepOrange : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: track.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.thumbnailUrl,
                      width: 50.r,
                      height: 50.r,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _thumbnailPlaceholder(),
                      errorWidget: (_, __, ___) => _thumbnailPlaceholder(),
                    )
                  : _thumbnailPlaceholder(),
            ),
            SizedBox(width: 12.w),

            // Title + Artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: isCurrentTrack
                          ? AppColors.deepOrange
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  AutoTranslateText(
                    track.artist.isNotEmpty ? track.artist : 'Unknown Artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body2.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Duration
            AutoTranslateText(
              track.formattedDuration,
              style: AppTypography.body2.copyWith(
                color: Colors.grey.shade500,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(width: 8.w),

            // Play/Pause button (inline)
            GestureDetector(
              onTap: onPlayTap,
              child: Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentTrack
                      ? AppColors.deepOrange
                      : AppColors.deepOrange.withValues(alpha: 0.12),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isCurrentTrack ? Colors.white : AppColors.deepOrange,
                  size: 18.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: 50.r,
      height: 50.r,
      color: Colors.orange.shade50,
      child: Icon(Icons.music_note, size: 24.r, color: Colors.orange.shade300),
    );
  }
}
