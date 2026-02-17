import 'dart:math';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/offering_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../utils/app_colors.dart';

class VirtualDarshanView extends GetView<VirtualDarshanController> {
  const VirtualDarshanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Vertical Image/Video Reel - Center of screen (like Instagram Reels)
            Obx(
              () => controller.godsCount == 0
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: controller.verticalPageController,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.godsCount,
                      onPageChanged: (index) {
                        controller.currentGodIndex.value = index;
                      },
                      itemBuilder: (context, index) {
                        final mediaUrl = controller.getGodImageAt(index);
                        if (VirtualDarshanController.isVideoUrl(mediaUrl)) {
                          return _VirtualDarshanVideoPlayer(
                            key: ValueKey('video_$index'),
                            videoUrl: mediaUrl,
                          );
                        }
                        return _buildGodImageDisplay(mediaUrl);
                      },
                    ),
            ),
            IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: controller.aartiController,
                  builder: (_, __) {
                    if (!controller.aartiController.isAnimating) {
                      return const SizedBox();
                    }

                    final t = controller.aartiController.value;
                    const radius = 140.0;
                    final angle = 2 * pi * t;
                    final x = radius * cos(angle);
                    final y = radius * sin(angle);

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Image.asset(
                        AppConstant.eMandirAartiIcon,
                        width: 50.w,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: _CircleIcon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10.w),
                  AutoTranslateText(
                    'Virtual Darshan',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 10.h,
              right: 10.w,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.white,
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Obx(
                          () => AutoTranslateText(
                            controller.punyaWallet.value?.wallet?.coins
                                    .toString() ??
                                '0',
                            style: AppTypography.h3.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.0.w),
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundImage: const AssetImage(
                            AppConstant.eMandirOmmIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Obx(
              () => controller.godsCount == 0
                  ? const SizedBox.shrink()
                  : Positioned(
                      top: 60.h,
                      left: 12.w,
                      right: 2.w,
                      child: SizedBox(
                        height: 50.h,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  _buildGodAvatar(
                                    controller.currentGodImage,
                                    radius: 20.r,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0.w),
                                    child: AutoTranslateText(
                                      controller.currentGodName,
                                      style: AppTypography.body1.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ListView.builder(
                                controller: controller.scrollController,
                                itemCount: controller.godsCount,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  final isSelected =
                                      controller.currentGodIndex.value == index;
                                  final godMedia = controller.getGodImageAt(
                                    index,
                                  );
                                  final isVideo =
                                      VirtualDarshanController.isVideoUrl(
                                        godMedia,
                                      );
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.navigateToGod(index),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: isSelected
                                            ? Border.all(
                                                color: Colors.orange,
                                                width: 3,
                                              )
                                            : null,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.orange,
                                            Colors.deepOrange,
                                          ],
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Container(
                                          width: 50.r,
                                          height: 40.r,
                                          color: Colors.grey.shade200,
                                          child: isVideo
                                              ? _buildVideoThumbnail(size: 40.r)
                                              : _buildThumbnailImage(godMedia),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Obx(
              () => Positioned(
                bottom: 90.h,
                left: 18.w,
                child: InkWell(
                  onTap: () => _openOfferingBottomSheet(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child:
                          controller.selectedOfferingIcon.value.startsWith(
                            'http',
                          )
                          ? Image.network(
                              controller.selectedOfferingIcon.value,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset(AppConstant.eMandirLadduIcon),
                            )
                          : Image.asset(controller.selectedOfferingIcon.value),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 90.h,
              right: 18.w,
              child: InkWell(
                onTap: () => controller.toggleAarti(context),
                child: Image.network(
                  AppConstant.eMandirThaliIcon,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset(AppConstant.eMandirLadduIcon),
                ),
              ),
            ),
            Positioned(
              bottom: 22.h,
              left: 18.w,
              child: InkWell(
                onTap: controller.playShankh,
                child: Image.asset(AppConstant.eMandirSankhIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a circular avatar that handles both image and video URLs.
  Widget _buildGodAvatar(String mediaUrl, {required double radius}) {
    if (VirtualDarshanController.isVideoUrl(mediaUrl)) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade800,
        child: Icon(Icons.videocam_rounded, color: Colors.orange, size: radius),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: mediaUrl.startsWith('http')
          ? NetworkImage(mediaUrl)
          : AssetImage(mediaUrl) as ImageProvider,
    );
  }

  /// Build a small play-icon overlay for video thumbnails in the horizontal list.
  Widget _buildVideoThumbnail({required double size}) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade800,
      child: Center(
        child: Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.orange,
          size: size * 0.6,
        ),
      ),
    );
  }

  /// Build an image thumbnail for the horizontal list.
  Widget _buildThumbnailImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.fill,
        width: 40.r,
        height: 40.r,
        errorBuilder: (_, __, ___) => Icon(Icons.person, size: 24.r),
      );
    }
    return Image.asset(imageUrl, fit: BoxFit.cover, width: 50.r, height: 40.r);
  }

  /// Build full-screen image display for the vertical PageView.
  Widget _buildGodImageDisplay(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: imageUrl.startsWith('http')
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.orange,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  void _openOfferingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => OfferingBottomSheetWidget(
        onSelect: (item) {
          Get.back();
          controller.useCoinItem(item, context);
        },
      ),
    );
  }
}

/// Full-screen video player widget for the vertical PageView.
///
/// Manages its own [VideoPlayerController] lifecycle. Auto-plays,
/// loops, and starts muted. Tap to toggle play/pause.
class _VirtualDarshanVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const _VirtualDarshanVideoPlayer({super.key, required this.videoUrl});

  @override
  State<_VirtualDarshanVideoPlayer> createState() =>
      _VirtualDarshanVideoPlayerState();
}

class _VirtualDarshanVideoPlayerState
    extends State<_VirtualDarshanVideoPlayer> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    try {
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.setVolume(0); // Start muted
      _videoController.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Auto-hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showControls = false);
        }
      });
    } catch (e) {
      debugPrint('[VirtualDarshanVideoPlayer] Init error: $e');
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _showControls = true;
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });

    // Auto-hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _videoController.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleMute() {
    setState(() {
      final currentVolume = _videoController.value.volume;
      _videoController.setVolume(currentVolume > 0 ? 0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.white),
              SizedBox(height: 8),
              Text(
                'Failed to load video',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video fills the entire screen
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

            // Play/Pause overlay
            if (_showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _videoController.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

            // Mute/Unmute button (bottom-right)
            Positioned(
              bottom: 30,
              right: 25,
              child: GestureDetector(
                onTap: _toggleMute,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _videoController.value.volume > 0
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;

  const _CircleIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26.sp),
    );
  }
}
