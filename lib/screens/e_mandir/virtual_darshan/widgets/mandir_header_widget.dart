import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Decorative mandir-style header with god name, category list, arch, and bells.
class MandirHeaderWidget extends StatelessWidget {
  const MandirHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VirtualDarshanController>();

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
                () => AutoTranslateText(
                  controller.currentGodName,
                  style: AppTypography.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                    // Fixed: special label button
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: handle special button tap
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'बुधवार विशेष',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                  child: _GhantaBell(imageUrl: AppConstant.rightGhantaImage),
                ),

                // Right ghanta hanging from arch
                Positioned(
                  right: -42.w,
                  top: 40.h,
                  child: _GhantaBell(imageUrl: AppConstant.leftGhantaImage),
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

  const _GhantaBell({required this.imageUrl});

  @override
  State<_GhantaBell> createState() => _GhantaBellState();
}

class _GhantaBellState extends State<_GhantaBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _swingController;
  late Animation<double> _swingAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _swingAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.25,
          end: -0.20,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.20,
          end: 0.15,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.15,
          end: -0.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.08,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_swingController);

    _startSwing();
  }

  @override
  void dispose() {
    _swingController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startSwing() {
    // Play sound when swing starts
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
        animation: _swingAnimation,
        builder: (_, child) {
          return Transform.rotate(
            angle: _swingAnimation.value * math.pi,
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
