import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainBannerWidget extends GetView<NamasteHomeController> {
  const MainBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = AppConstant.eMandirGanesha;
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Container(
      height: 450.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background image
            isNetworkImage
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 450.h,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  )
                : Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 450.h,
                  ),
            // Overlay content
            Positioned(
              top: 10.h,
              right: 10.w,
              child: Row(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: controller.toggleVolumeSlider,
                      onLongPress: controller.muteUnmute,
                      child: _CircleIcon(
                        _getVolumeIcon(controller.volume.value),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _AnimatedFullscreenButton(
                    onTap: controller.navigateToVirtualDarshan,
                  ),
                ],
              ),
            ),

            // Positioned(
            //   top: 70.h,
            //   left: 12.w,
            //   right: 12.w,
            //   child: SizedBox(
            //     height: 50.h,
            //     child: Row(
            //       children: [
            //         Container(
            //           padding: EdgeInsets.all(3.w),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(30.r),
            //             color: Colors.white,
            //           ),
            //           child: Row(
            //             children: [
            //               CircleAvatar(
            //                 radius: 13.r,
            //                 backgroundImage: const AssetImage(
            //                   AppConstant.eMandirGanesha,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.all(4.0.w),
            //                 child: AutoTranslateText(
            //                   'Shri Ganesh',
            //                   style: AppTypography.label.copyWith(
            //                     color: Colors.orange,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Spacing.w(30),
            //         Container(
            //           padding: EdgeInsets.all(2.w),
            //           decoration: const BoxDecoration(
            //             shape: BoxShape.circle,
            //             gradient: LinearGradient(
            //               colors: [Colors.orange, Colors.deepOrange],
            //             ),
            //           ),
            //           child: CircleAvatar(
            //             radius: 16.r,
            //             backgroundImage: const AssetImage(
            //               AppConstant.eMandirPlusIcon,
            //             ),
            //           ),
            //         ),
            //         Spacing.w(10),
            //         Expanded(
            //           child: ListView.separated(
            //             itemCount: 15,
            //             separatorBuilder: (context, index) => Spacing.w(5),
            //             scrollDirection: Axis.horizontal,
            //             itemBuilder: (context, index) {
            //               return Container(
            //                 padding: EdgeInsets.all(2.w),
            //                 decoration: const BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   gradient: LinearGradient(
            //                     colors: [Colors.orange, Colors.deepOrange],
            //                   ),
            //                 ),
            //                 child: CircleAvatar(
            //                   radius: 16.r,
            //                   backgroundImage: const AssetImage(
            //                     AppConstant.eMandirGodIcon,
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Obx(
              () => controller.showVolumeSlider.value
                  ? Positioned(
                      top: 60.h,
                      right: 10.w,
                      child: _VolumeSliderWidget(),
                    )
                  : const SizedBox.shrink(),
            ),
            // Positioned(
            //   bottom: 90.h,
            //   left: 18.w,
            //   child: Image.asset(AppConstant.eMandirAartiIcon),
            // ),
            // Positioned(
            //   bottom: 22.h,
            //   left: 18.w,
            //   child: InkWell(
            //     onTap: () {},
            //     child: Image.asset(
            //       AppConstant.eMandirLadduIcon,
            //       width: 50.w,
            //       height: 50.h,
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 90.h,
              right: 18.w,
              child: InkWell(
                onTap: controller.toggleShankh,
                child: Image.asset(AppConstant.eMandirSankhIcon),
              ),
            ),
            Positioned(
              bottom: 22.h,
              right: 18.w,
              child: InkWell(
                onTap: controller.navigateToDevotionalLibrary,
                child: Image.asset(
                  AppConstant.eMandirListenNowIcon,
                  width: 50.w,
                  height: 50.h,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: AutoTranslateText(
                    'Listen Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVolumeIcon(double volume) {
    if (volume == 0.0) {
      return Icons.volume_off;
    } else if (volume < 0.5) {
      return Icons.volume_down;
    } else {
      return Icons.volume_up;
    }
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
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26.sp),
    );
  }
}

class _VolumeSliderWidget extends GetView<NamasteHomeController> {
  const _VolumeSliderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -15.h,
            right: -10.w,
            child: IconButton(
              onPressed: () {
                controller.showVolumeSlider.value = false;
              },
              icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.decreaseVolume,
                    child: Icon(
                      Icons.volume_down,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Slider(
                        value: controller.volume.value,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          controller.setVolume(value);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.increaseVolume,
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  '${(controller.volume.value * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedFullscreenButton extends GetView<NamasteHomeController> {
  final VoidCallback onTap;

  const _AnimatedFullscreenButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller.fullscreenAnimationController,
        builder: (context, child) {
          return SizedBox(
            width: 70.w,
            height: 70.h,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Pulsing outer ring
                Transform.scale(
                  scale:
                      1.0 + (controller.fullscreenPulseAnimation.value * 0.3),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.withOpacity(
                        0.2 * (1 - controller.fullscreenPulseAnimation.value),
                      ),
                    ),
                  ),
                ),
                // Main button with bounce animation
                Transform.scale(
                  scale: controller.fullscreenScaleAnimation.value,
                  child: Container(
                    width: 46.w,
                    height: 46.h,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 26.w,
                      height: 26.h,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Arrow indicators
                          Positioned(
                            top: -2.h,
                            child: Opacity(
                              opacity:
                                  controller.fullscreenPulseAnimation.value,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.orange,
                                size: 12.sp,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2.h,
                            child: Opacity(
                              opacity:
                                  controller.fullscreenPulseAnimation.value,
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.orange,
                                size: 12.sp,
                              ),
                            ),
                          ),
                          Positioned(
                            left: -2.w,
                            child: Opacity(
                              opacity:
                                  controller.fullscreenPulseAnimation.value,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.orange,
                                size: 12.sp,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -2.w,
                            child: Opacity(
                              opacity:
                                  controller.fullscreenPulseAnimation.value,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.orange,
                                size: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
