import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/divya_darshan/controller/divya_darshan_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Decorative mandir-style header with god name, category list, arch, and bells.
class MandirHeaderWidget extends StatelessWidget {
  const MandirHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VirtualDarshanController>();
    final divyaDarshanController = Get.put(DivyaDarshanController());

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient section: god name centered ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
            decoration: BoxDecoration(gradient: AppColors.goldenGradient),
            child: Center(
              child: Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AutoTranslateText(
                    controller.currentGodName,
                    style: AppTypography.h2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Category thumbnails row ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(gradient: AppColors.goldenGradient),
            child: SizedBox(
              height: 50.h,
              child: Obx(() {
                final selectedIdx = controller.currentCategoryIndex.value;
                final count = controller.categoriesCount;
                if (count == 0) return const SizedBox.shrink();
                return Row(
                  children: [
                    // Fixed: special label button replaced with animated circular avatar
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Obx(() {
                        final items = divyaDarshanController.divyaDarshanItems;
                        if (items.isEmpty || items.first.godCategory == null) {
                          return const SizedBox.shrink();
                        }

                        final firstItem = items.first;
                        final String imageUrl =
                            firstItem.godCategory!.godImageUrl;

                        return _AnimatedStoryAvatar(
                          imageUrl: imageUrl,
                          onTap: () {
                            Get.toNamed(AppRoutes.divyaDarshan);
                          },
                        );
                      }),
                    ),

                    // Fixed: divider + spacing
                    SizedBox(width: 8.w),
                    VerticalDivider(
                      width: 1.w,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),

                    // Scrollable: category thumbnails + "+" button
                    Expanded(
                      child: ListView.builder(
                        controller: controller.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: count + 1,
                        itemBuilder: (_, index) {
                          // Last item: circular + button
                          if (index == count) {
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: handle + button tap
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.3),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14.r,
                                  ),
                                ),
                              ),
                            );
                          }

                          // Category items
                          final isSelected = selectedIdx == index;
                          final catImage = controller.godCategories.isNotEmpty
                              ? controller.godCategories[index].godImage
                              : controller.fallbackGodsList[index].profileImage;
                          final isVideo = VirtualDarshanController.isVideoUrl(
                            catImage,
                          );
                          return Center(
                            child: GestureDetector(
                              onTap: () => controller.navigateToGod(index),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                width: 40.w,
                                height: 40.w,
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.orange,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 36.w,
                                    height: 36.w,
                                    child: isVideo
                                        ? _buildVideoThumbnail(size: 36.w)
                                        : Image.network(
                                            catImage,
                                            fit: BoxFit.cover,
                                            width: 36.w,
                                            height: 36.w,
                                            errorBuilder: (_, __, ___) =>
                                                Icon(Icons.person, size: 14.r),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          // ── Mandir arch + bells ──
          SizedBox(
            width: double.infinity,
            height: 290.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Arch image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80.h,
                  child: Image.network(
                    AppConstant.mandirHeaderImage,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => SizedBox(height: 80.h),
                  ),
                ),

                // Left ghanta hanging from arch
                Positioned(
                  left: -42.w,
                  top: 40.h,
                  child: _GhantaBell(
                    imageUrl: AppConstant.rightGhantaImage,
                    swingDirection: -1,
                  ),
                ),

                // Right ghanta hanging from arch
                Positioned(
                  right: -42.w,
                  top: 40.h,
                  child: _GhantaBell(
                    imageUrl: AppConstant.leftGhantaImage,
                    swingDirection: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}

/// An animated ghanta bell that swings on load and on tap.
class _GhantaBell extends StatefulWidget {
  final String imageUrl;
  final int swingDirection; // -1 = left, 1 = right

  const _GhantaBell({required this.imageUrl, this.swingDirection = -1});

  @override
  State<_GhantaBell> createState() => _GhantaBellState();
}

class _GhantaBellState extends State<_GhantaBell>
    with TickerProviderStateMixin {
  late AnimationController _swingController;
  late Animation<double> _swingAnimation;

  // Separate controller for smooth continuous aarti swinging
  late AnimationController _aartiSwingController;
  late Animation<double> _aartiSwingAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Worker? _aartiWorker;
  bool _isAartiSwinging = false;

  @override
  void initState() {
    super.initState();

    // Original tap-to-swing (decaying swing)
    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _swingAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.06 * widget.swingDirection,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.06 * widget.swingDirection,
          end: -0.04 * widget.swingDirection,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.04 * widget.swingDirection,
          end: 0.03 * widget.swingDirection,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.03 * widget.swingDirection,
          end: -0.02 * widget.swingDirection,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.02 * widget.swingDirection,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_swingController);

    // Smooth continuous pendulum for aarti mode (goes 0 → 0.20, then reverses)
    _aartiSwingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _aartiSwingAnimation = Tween<double>(
      begin: 0.0,
      end: 0.04 * widget.swingDirection,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_aartiSwingController);

    // Listen to aarti state
    if (Get.isRegistered<VirtualDarshanController>()) {
      final controller = Get.find<VirtualDarshanController>();
      _aartiWorker = ever(controller.isAartiActive, (bool active) {
        if (active) {
          _startLoopingSwing();
        } else {
          _stopLoopingSwing();
        }
      });
      if (controller.isAartiActive.value) {
        _startLoopingSwing();
      } else {
        _startSwing();
      }
    } else {
      _startSwing();
    }
  }

  void _startLoopingSwing() {
    _swingController.reset();
    _aartiSwingController.repeat(reverse: true);
    setState(() => _isAartiSwinging = true);
  }

  void _stopLoopingSwing() {
    _aartiSwingController.reset();
    setState(() => _isAartiSwinging = false);
  }

  @override
  void dispose() {
    _aartiWorker?.dispose();
    _swingController.dispose();
    _aartiSwingController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startSwing() {
    if (!_swingController.isAnimating) {
      _audioPlayer.play(UrlSource(AppConstant.bellSound));
      _swingController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _startSwing,
      child: AnimatedBuilder(
        animation: _isAartiSwinging ? _aartiSwingAnimation : _swingAnimation,
        builder: (_, child) {
          final angle = _isAartiSwinging
              ? _aartiSwingAnimation.value
              : _swingAnimation.value;
          return Transform.rotate(
            angle: angle * math.pi,
            alignment: Alignment.topCenter,
            child: child,
          );
        },
        child: Image.network(
          widget.imageUrl,
          width: 180.w,
          height: 210.h,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => SizedBox(width: 80.w, height: 110.h),
        ),
      ),
    );
  }
}

class _AnimatedStoryAvatar extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onTap;
  const _AnimatedStoryAvatar({required this.imageUrl, required this.onTap});

  @override
  State<_AnimatedStoryAvatar> createState() => _AnimatedStoryAvatarState();
}

class _AnimatedStoryAvatarState extends State<_AnimatedStoryAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _animController,
            child: Container(
              width: 48.r,
              height: 48.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFFE1306C),
                    Color(0xFFF77737),
                    Color(0xFFFCAF45),
                    Color(0xFF833AB4),
                    Color(0xFFE1306C),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 44.r,
            height: 44.r,
            padding: EdgeInsets.all(2.r),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21.r),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
