import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_image_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_title_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_progress_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_controls_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class DevotionalPlayerView extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final service = controller.audioService;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            // Header
            CommonHeader(
              showDrawer: false,
              titleWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  service.currentTrack?.godCategory?.godName ?? '',
                  style: AppTypography.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              customActions: [
                // InkWell(
                //   onTap: () => controller.navigateToLyrics(),
                //   borderRadius: BorderRadius.circular(20),
                //   child: Container(
                //     padding: const EdgeInsets.all(8),
                //     decoration: const BoxDecoration(
                //       color: Colors.white,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Icon(
                //       Icons.description,
                //       color: AppColors.deepOrange,
                //       size: 20.r,
                //     ),
                //   ),
                // ),
                // SizedBox(width: 8.w),
              ],
            ),

            // Player content + track list
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    const DevotionalPlayerImageWidget(),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: const DevotionalPlayerTitleWidget(),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: const DevotionalPlayerProgressWidget(),
                    ),
                    SizedBox(height: 12.h),
                    const DevotionalPlayerControlsWidget(),
                    SizedBox(height: 24.h),

                    // Track list heading
                    Obx(() {
                      final track = service.currentTrack;
                      final godName = track?.godCategory?.godName ?? '';
                      if (godName.isEmpty && service.playlist.length <= 1) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoTranslateText(
                            godName.isNotEmpty
                                ? 'Divine Music of $godName'
                                : 'Up Next',
                            style: AppTypography.h3.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: const Color(0xFF4E342E),
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 8.h),

                    // Playlist
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: service.playlist.length,
                        itemBuilder: (context, index) {
                          final track = service.playlist[index];
                          return Obx(() {
                            final isCurrent =
                                service.currentIndex.value == index;
                            return InkWell(
                              onTap: () => service.playTrack(index),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 6.h),
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.deepOrange.withValues(
                                          alpha: 0.08,
                                        )
                                      : Colors.white.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: isCurrent
                                      ? Border.all(color: AppColors.deepOrange)
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: track.thumbnailUrl.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: track.thumbnailUrl,
                                              width: 42.r,
                                              height: 42.r,
                                              fit: BoxFit.cover,
                                              errorWidget: (_, __, ___) =>
                                                  _miniPlaceholder(),
                                            )
                                          : _miniPlaceholder(),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            track.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.sp,
                                              color: isCurrent
                                                  ? AppColors.deepOrange
                                                  : Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            track.artist.isNotEmpty
                                                ? track.artist
                                                : 'Unknown',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isCurrent)
                                      Icon(
                                        Icons.equalizer,
                                        color: AppColors.deepOrange,
                                        size: 20.r,
                                      )
                                    else
                                      Text(
                                        track.formattedDuration,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniPlaceholder() {
    return Container(
      width: 42.r,
      height: 42.r,
      color: Colors.orange.shade50,
      child: Icon(Icons.music_note, size: 20.r, color: Colors.orange.shade300),
    );
  }
}
