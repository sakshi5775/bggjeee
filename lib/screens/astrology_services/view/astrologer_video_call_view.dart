import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_video_call_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/network_image.dart';

class AstrologerVideoCallView extends StatelessWidget {
  const AstrologerVideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologerVideoCallController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            // Header (primaryGradient - same as voice call)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => controller.endCall(),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.r,
                            backgroundImage:
                                controller.astrologer.profilePicture != null &&
                                    controller
                                        .astrologer
                                        .profilePicture!
                                        .isNotEmpty
                                ? CachedNetworkImageProvider(
                                    controller.astrologer.profilePicture!,
                                  )
                                : null,
                            child:
                                controller.astrologer.profilePicture == null ||
                                    controller
                                        .astrologer
                                        .profilePicture!
                                        .isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          Spacing.w(8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoTranslateText(
                                  controller.astrologer.displayName,
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Obx(
                                  () => AutoTranslateText(
                                    controller.callStatus.value,
                                    style: MyTextTheme.smallBCN.copyWith(
                                      fontSize: 10.sp,
                                      color: AppColors.templeGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Timer & Balance (Hidden as per request)
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Obx(
                    //       () => AutoTranslateText(
                    //         controller.remainingTime.value,
                    //         style: MyTextTheme.mediumBCB.copyWith(
                    //           color:
                    //               (controller.remainingTime.value !=
                    //                       '00:00:00' &&
                    //                   !controller.remainingTime.value
                    //                       .startsWith('00:00:'))
                    //               ? Colors.black
                    //               : Colors.red,
                    //         ),
                    //       ),
                    //     ),
                    //     Obx(
                    //       () => AutoTranslateText(
                    //         '₹${controller.walletBalance.value.toStringAsFixed(1)}',
                    //         style: MyTextTheme.smallBCN.copyWith(
                    //           color: Colors.indigo[900],
                    //           fontSize: 10.sp,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox.shrink(),
                    Spacing.w(12),
                    // Red End Session Button Removed as per request
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            // Main Video Display Area
            Expanded(child: _buildVideoArea(controller)),

            // Footer with Controls (SafeArea so not hidden by system nav)
            SafeArea(top: false, child: _buildFooter(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoArea(AstrologerVideoCallController controller) {
    return Stack(
      children: [
        // Main Video Feed (Astrologer)
        Positioned.fill(child: _buildMainVideo(controller)),

        // Speaking Indicator (Bottom Left)
        Positioned(
          bottom: 16.h,
          left: 16.w,
          child: Obx(
            () => controller.isAstrologerSpeaking.value
                ? _buildSpeakingIndicator(controller.astrologer.displayName)
                : const SizedBox.shrink(),
          ),
        ),

        // User's Video Feed (Bottom Right - Inset)
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: Obx(() {
            if (controller.isVideoOn.value) {
              return _buildInsetVideo(controller);
            } else {
              return _buildInsetVideoPlaceholder(controller);
            }
          }),
        ),
      ],
    );
  }

  Widget _buildMainVideo(AstrologerVideoCallController controller) {
    return Obx(() {
      // Show loading indicator while initializing
      if (controller.isLoading.value) {
        return Container(
          color: const Color(0xFFE0E0E0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Color(0xFFDFB343)),
                Spacing.h(16),
                AutoTranslateText(
                  controller.errorMessage.value.isEmpty
                      ? 'Connecting...'
                      : controller.errorMessage.value,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFF5F2221),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Ringing state: gradient background + overlay (same style as voice call)
      if (controller.isRinging.value && !controller.isCallConnected.value) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: AppColors.gradientBackground),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(
                controller.astrologer.profilePicture,
                size: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryGradient.colors.first.withValues(
                        alpha: 0.2,
                      ),
                      AppColors.primaryGradient.colors.last.withValues(
                        alpha: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      'Ringing...',
                      style: MyTextTheme.largeBCB
                          .copyWith(color: Colors.white)
                          .merge(AppTypography.h2),
                    ),
                    Spacing.h(8),
                    AutoTranslateText(
                      'Waiting: ${controller.formattedRingingCountdown}',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: AppColors.templeGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      // Show remote video if available and connected, otherwise show placeholder
      if (controller.isCallConnected.value) {
        if (controller.isAstrologerVideoOn.value) {
          final remoteVideo = controller.getRemoteVideoView();
          if (remoteVideo != null) {
            return remoteVideo;
          }
        }
        // Show placeholder when astrologer video is off or not available
        return _buildRemoteVideoPlaceholder(controller);
      }

      // Fallback to profile image
      return Container(
        color: const Color(0xFFE0E0E0),
        child: Center(
          child: _buildImage(
            controller.astrologer.profilePicture,
            size: double.infinity,
          ),
        ),
      );
    });
  }

  Widget _buildSpeakingIndicator(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            name,
            style: MyTextTheme.smallBCB
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                .merge(AppTypography.body2),
          ),
          Spacing.h(2),
          AutoTranslateText(
            'Speaking...',
            style: MyTextTheme.smallBCN
                .copyWith(
                  color: const Color(0xFFDFB343), // Yellow
                )
                .merge(AppTypography.label),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoteVideoPlaceholder(
    AstrologerVideoCallController controller,
  ) {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam_off,
              size: 72.w,
              color: const Color(0xFF5F2221),
            ),
            Spacing.h(12),
            AutoTranslateText(
              '${controller.astrologer.displayName} turned off video',
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB
                  .copyWith(color: const Color(0xFF5F2221))
                  .merge(AppTypography.h2),
            ),
            Spacing.h(6),
            AutoTranslateText(
              'You will see their video once it is available again.',
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCN
                  .copyWith(color: const Color(0xFF666666))
                  .merge(AppTypography.body1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsetVideo(AstrologerVideoCallController controller) {
    return GestureDetector(
      onTap: () {
        // TODO: Expand/minimize video
      },
      child: Container(
        width: 120.w,
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFDFB343), // Gold border
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // User's video feed from Agora
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Obx(() {
                // Access observable to trigger rebuild
                final isVideoOn = controller.isVideoOn.value;
                if (isVideoOn) {
                  final localVideo = controller.getLocalVideoView();
                  if (localVideo != null) {
                    return SizedBox(
                      width: 120.w,
                      height: 160.h,
                      child: localVideo,
                    );
                  }
                }
                // Placeholder when video is off
                return Container(
                  color: Colors.grey.withValues(alpha: 0.5),
                  child: Center(
                    child: Icon(Icons.person, size: 60.w, color: Colors.white),
                  ),
                );
              }),
            ),
            // Expand icon (bottom right corner)
            Positioned(
              bottom: 4.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.open_in_full,
                  color: Colors.white,
                  size: 16.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsetVideoPlaceholder(AstrologerVideoCallController controller) {
    return Container(
      width: 120.w,
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFDFB343), width: 2),
      ),
      child: Center(
        child: Icon(Icons.videocam_off, color: Colors.white, size: 40.w),
      ),
    );
  }

  Widget _buildFooter(AstrologerVideoCallController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            controller.astrologer.displayName,
            style: MyTextTheme.largeBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(8),
          Obx(() {
            final connected = controller.isCallConnected.value;
            final status = controller.callStatus.value;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: connected
                          ? AppColors.success
                          : AppColors.templeGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    status,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            );
          }),
          Spacing.h(14),
          Obx(() {
            if (!controller.isCallConnected.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoTranslateText(
                      '₹${controller.pricePerMinute.value.toStringAsFixed(0)}/min',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.templeGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.w(16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule, color: Colors.white, size: 18.w),
                          Spacing.w(8),
                          AutoTranslateText(
                            'Waiting: ${controller.formattedRingingCountdown}',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (controller.callDuration.value == '00:00' ||
                controller.callDuration.value == '00:00:00') {
              return const SizedBox.shrink();
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: AutoTranslateText(
                controller.callDuration.value,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
          Spacing.h(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.volume_up,
                onTap: () => controller.toggleSpeaker(),
                isActive: controller.isSpeakerOn.value,
                color: AppColors.templeGold,
              ),
              Obx(
                () => _buildControlButton(
                  icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                  onTap: () => controller.toggleMute(),
                  isActive: !controller.isMuted.value,
                  color: AppColors.templeGold,
                ),
              ),
              _buildEndCallButton(() => controller.endCall()),
              Obx(
                () => _buildControlButton(
                  icon: controller.isVideoOn.value
                      ? Icons.videocam
                      : Icons.videocam_off,
                  onTap: () => controller.toggleVideo(),
                  isActive: controller.isVideoOn.value,
                  color: AppColors.templeGold,
                ),
              ),
              _buildControlButton(
                icon: Icons.flip_camera_ios,
                onTap: () => controller.switchCamera(),
                isActive: true,
                color: AppColors.templeGold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    Color color = AppColors.templeGold,
  }) {
    final isEnd = color == AppColors.error;
    final bgColor = isEnd
        ? AppColors.error
        : (isActive ? color : color.withValues(alpha: 0.5));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24.w),
      ),
    );
  }

  Widget _buildEndCallButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.error,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.call_end, color: Colors.white, size: 26.w),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 40}) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        width: size == double.infinity ? null : size.w,
        height: size == double.infinity ? null : size.h,
        color: Colors.grey.withValues(alpha: 0.3),
        child: Center(
          child: Icon(
            Icons.person,
            size: (size == double.infinity ? 200 : size / 2).w,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImageWithLoader(
        url: imageUrl,
        width: size == double.infinity ? null : size.w,
        height: size == double.infinity ? null : size.h,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imageUrl,
        width: size == double.infinity ? null : size.w,
        height: size == double.infinity ? null : size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size == double.infinity ? null : size.w,
            height: size == double.infinity ? null : size.h,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Center(
              child: Icon(
                Icons.person,
                size: (size == double.infinity ? 200 : size / 2).w,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
    }
  }
}
