import 'dart:math';
import 'dart:ui';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/mandir_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/offering_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/collection_bottom_sheet.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/dhup_animation_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VirtualDarshanView extends GetView<VirtualDarshanController> {
  const VirtualDarshanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Vertical Image/Video Reel wrapped with horizontal swipe
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                // Swipe left → next category, swipe right → previous
                if (details.primaryVelocity == null) return;

                if (details.primaryVelocity! < -200) {
                  // Swipe left → next category
                  _stopAllAnimations(controller, context);
                  controller.swipeToCategory(
                    controller.currentCategoryIndex.value + 1,
                  );
                } else if (details.primaryVelocity! > 200) {
                  // Swipe right → previous category
                  _stopAllAnimations(controller, context);
                  controller.swipeToCategory(
                    controller.currentCategoryIndex.value - 1,
                  );
                }
              },
              child: Obx(() {
                if (controller.isLoadingCategoryImages.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }
                if (controller.godsCount == 0) {
                  return const Center(child: Text('No Data Found'));
                }
                return PageView.builder(
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
                );
              }),
            ),
            // Unified Thali: animates from bottom center to circular Aarti path
            Obx(() {
              final thaliImage = controller.selectedThaliImage.value.isNotEmpty
                  ? controller.selectedThaliImage.value
                  : controller.thaliItemImage.value;
              final thaliIndex = controller.pujaItemCategories.indexWhere(
                (c) =>
                    c.slug.toLowerCase().contains('thali') ||
                    c.name.toLowerCase().contains('thali'),
              );

              return AnimatedBuilder(
                animation: Listenable.merge([
                  controller.thaliTransitionController,
                  controller.aartiController,
                ]),
                builder: (context, child) {
                  // Screen dimensions for calculating the center
                  final size = MediaQuery.of(context).size;
                  final centerX = size.width / 2;
                  final centerY = size.height / 2;

                  // 1. Bottom Docked Position
                  // The dock is at bottom: 16.h, visually centered.
                  final dockedY =
                      size.height -
                      5.h -
                      130.h; // roughly the vertical center of the dock
                  final dockedX = centerX;

                  // 2. Aarti Circular Path
                  // Calculate where it should be on the circle right now
                  final t = controller.aartiController.value;
                  const radius = 140.0;
                  final angle = 2 * pi * t;
                  final circleDx = radius * cos(angle);
                  final circleDy = radius * sin(angle);

                  // Absolute circular position relative to top-left
                  final aartiX = centerX + circleDx;
                  final aartiY = centerY + circleDy;

                  // 3. Interpolate between Dock and Aarti Circle based on transition animation
                  final progress = controller.thaliTransitionAnimation.value;

                  // When progress is 0.0, thali is at docked position.
                  // When progress is 1.0, thali is on the Aarti circle.
                  final currentX = lerpDouble(dockedX, aartiX, progress)!;
                  final currentY = lerpDouble(dockedY, aartiY, progress)!;

                  // Scale up slightly when in Aarti mode
                  final thaliScale = lerpDouble(120.w, 150.w, progress)!;

                  return Positioned(
                    left: currentX - (thaliScale / 2),
                    top: currentY - (thaliScale / 2),
                    child: InkWell(
                      onTap: () {
                        // Only open bottom sheet if NOT doing Aarti
                        if (progress == 0.0) {
                          if (thaliIndex != -1 &&
                              controller.offeringTabController != null &&
                              thaliIndex <
                                  controller.offeringTabController!.length) {
                            controller.offeringTabController!.animateTo(
                              thaliIndex,
                            );
                            controller.selectedCategoryIndex.value = thaliIndex;
                            controller.loadCategoryItems(
                              controller.pujaItemCategories[thaliIndex].id,
                            );
                          }
                          _openOfferingBottomSheet(context);
                        }
                      },
                      child: (thaliImage.isNotEmpty)
                          ? NetworkImageWithLoader(
                              url: thaliImage,
                              fit: BoxFit.contain,
                              width: thaliScale,
                              height: thaliScale,
                            )
                          : Image.asset(
                              AppConstant.eMandirLadduIcon,
                              width: 75.w,
                              height: 75.h,
                            ),
                    ),
                  );
                },
              );
            }),
            // Animated Dhup: one circle with yellow star glow
            const DhupAnimationWidget(),
            // Mandir decorative header
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MandirHeaderWidget(),
            ),

            // Positioned(
            //   top: 14.h,
            //   left: 10.w,
            //   child: InkWell(
            //     onTap: () => Get.back(),
            //     child: _CircleIcon(Icons.arrow_back),
            //   ),
            // ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: InkWell(
                onTap: () => controller.showHowToEarnPunyaDialog(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.white,
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => AutoTranslateText(
                          controller.punyaWallet.value?.wallet?.coins
                                  .toString() ??
                              '0',
                          style: AppTypography.h2.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      CircleAvatar(
                        radius: 14.r,
                        backgroundImage: const AssetImage(
                          AppConstant.eMandirOmmIcon,
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
                child: GestureDetector(
                  onTap: () => _openOfferingBottomSheet(context),
                  child: Container(
                    width: 55.w,
                    height: 55.h,
                    padding: AppPaddings.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.gradientBackground,
                      border: Border.all(
                        color: AppColors.deepOrangemix,
                        width: 2,
                      ),
                    ),
                    child:
                        controller.selectedOfferingIcon.value.startsWith('http')
                        // ? Image.network(
                        //     controller.selectedOfferingIcon.value,
                        //     fit: BoxFit.cover,
                        //     width: 40.w,
                        //     height: 40.h,
                        //     errorBuilder: (_, __, ___) => Image.asset(
                        //       AppConstant.eMandirLadduIcon,
                        //       width: 40.w,
                        //       height: 40.h,
                        //     ),
                        //   )
                        ? NetworkImageWithLoader(
                            url: controller.selectedOfferingIcon.value,
                            fit: BoxFit.cover,
                            width: 40.w,
                            height: 40.h,
                          )
                        : Image.asset(
                            controller.selectedOfferingIcon.value,
                            width: 40.w,
                            height: 40.h,
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
                child: Container(
                  width: 55.w,
                  height: 55.h,
                  padding: AppPaddings.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.gradientBackground,
                    border: Border.all(
                      color: AppColors.deepOrangemix,
                      width: 2,
                    ),
                  ),

                  child: NetworkImageWithLoader(
                    url: AppConstant.sriMandirDiyaAArti,
                    fit: BoxFit.fill,
                    width: 40.w,
                    height: 40.h,
                  ),
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

            Positioned(
              bottom: 150.h,
              left: 18.w,
              child: InkWell(
                onTap: () => showSpecialBhogBottomSheet(context, controller),
                child: Container(
                  width: 55.w,
                  height: 55.h,
                  padding: AppPaddings.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.deepOrangemix,
                      width: 2,
                    ),
                    gradient: AppColors.gradientBackground,
                  ),
                  child: Image.network(
                    AppConstant.specialBhog,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(AppConstant.eMandirLibraryAarti),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 150.h,
              right: 18.w,
              child: InkWell(
                onTap: () => _showMandirItemsBottomSheet(context, controller),
                child: Container(
                  width: 55.w,
                  height: 55.h,
                  padding: AppPaddings.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.deepOrangemix,
                      width: 2,
                    ),
                    gradient: AppColors.gradientBackground,
                  ),
                  // child: Image.network(
                  //   AppConstant.mandirItems,
                  //   fit: BoxFit.cover,
                  //   errorBuilder: (_, __, ___) =>
                  //       Image.asset(AppConstant.eMandirLibraryAarti),
                  // ),
                  child: NetworkImageWithLoader(
                    url: AppConstant.mandirItems,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 22.h,
              right: 18.w,
              child: InkWell(
                onTap: () => showCollectionBottomSheet(context),
                child: Container(
                  width: 55.w,
                  height: 55.h,
                  padding: AppPaddings.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.deepOrangemix,
                      width: 2,
                    ),
                    gradient: AppColors.gradientBackground,
                  ),
                  // child: Image.network(
                  //   AppConstant.collectionSangrahIcon,

                  //   fit: BoxFit.fill,
                  //   errorBuilder: (_, __, ___) =>
                  //       Image.asset(AppConstant.eMandirLibraryAarti),
                  // ),
                  child: NetworkImageWithLoader(
                    url: AppConstant.collectionSangrahIcon,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

      child: NetworkImageWithLoader(
        url: imageUrl,
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
          Navigator.pop(sheetContext);
          controller.useCoinItem(item, context);
        },
      ),
    );
  }

  void showSpecialBhogBottomSheet(
    BuildContext context,
    VirtualDarshanController controller,
  ) {
    if (controller.specialBhogData.value == null ||
        controller.specialBhogData.value!.data == null) {
      Get.snackbar(
        "Notice",
        "No special bhog available for today",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final data = controller.specialBhogData.value!.data!;
    final bhogs = data.bhogs;
    final godCategory = data.godCategory;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFFFF6ED)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    if (godCategory != null)
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: NetworkImage(godCategory.godThumbnail),
                        onBackgroundImageError: (_, __) =>
                            const AssetImage(AppConstant.eMandirOmmIcon),
                      )
                    else
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: const AssetImage(
                          AppConstant.eMandirOmmIcon,
                        ),
                      ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Special Bhog",
                            style: AppTypography.h3.copyWith(
                              fontWeight: FontWeight.bold,
                              color: "#6F221E".toColor(),
                            ),
                          ),
                          Text(
                            controller.specialBhogData.value!.message,
                            style: AppTypography.body2.copyWith(
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              if (bhogs.isEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: Text(
                    "No bhogs available.",
                    style: AppTypography.body1.copyWith(color: Colors.grey),
                  ),
                )
              else
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: bhogs.length,
                      itemBuilder: (context, index) {
                        final bhog = bhogs[index];
                        return GestureDetector(
                          onTap: () {
                            Get.back();
                            controller.offerSpecialBhog(bhog, context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.orange.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: NetworkImageWithLoader(
                                      url: bhog.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.r),
                                      bottomRight: Radius.circular(12.r),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        bhog.bhogName,
                                        style: AppTypography.body2.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppConstant.coin,
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            bhog.coin.toString(),
                                            style: AppTypography.body2.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void _showMandirItemsBottomSheet(
    BuildContext context,
    VirtualDarshanController controller,
  ) {
    if (controller.mandirItemsData.value == null) {
      Get.snackbar(
        "Notice",
        "No mandir items available",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final data = controller.mandirItemsData.value!;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return DefaultTabController(
          length: 2,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFFFF6ED)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Customize Mandir",
                  style: AppTypography.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepOrangemix,
                  ),
                ),
                TabBar(
                  labelColor: AppColors.deepOrangemix,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.deepOrangemix,
                  tabs: const [
                    Tab(text: "Bells"),
                    Tab(text: "Mandir Arch"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Bells Tab
                      GridView.builder(
                        padding: EdgeInsets.all(16.r),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                        ),
                        itemCount: data.bells.length,
                        itemBuilder: (context, index) {
                          final bell = data.bells[index];
                          return GestureDetector(
                            onTap: () {
                              controller.applyBellSelection(bell);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: NetworkImageWithLoader(
                                      url: bell.leftBell,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: NetworkImageWithLoader(
                                      url: bell.rightBell,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Mandir Arch Tab
                      GridView.builder(
                        padding: EdgeInsets.all(16.r),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                        ),
                        itemCount: data.upperMandirFront.length,
                        itemBuilder: (context, index) {
                          final arch = data.upperMandirFront[index];
                          return GestureDetector(
                            onTap: () {
                              controller.applyArchSelection(arch);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: NetworkImageWithLoader(
                                  url: arch.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
      _videoController.setLooping(false);
      _videoController.setVolume(0);
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

void _stopAllAnimations(
  VirtualDarshanController controller,
  BuildContext context,
) {
  if (controller.isAartiActive.value) {
    controller.toggleAarti(context);
  }

  // Stop raining flowers
  controller.activeFlowers.clear();
  controller.flowerTimer?.cancel();
  controller.flowerTimer = null;

  // Stop Audio Contexts
  try {
    controller.audioPlayer.pause();
    controller.shankhPlayer.stop();
  } catch (_) {}
}
