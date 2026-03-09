import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_voice_call_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerVoiceCallView extends StatelessWidget {
  const AstrologerVoiceCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologerVoiceCallController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            // Header
            // Custom Header Implementation (Replaces CommonHeader)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => controller.endCall(),
                    ),
                    // Astrologer Details
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
                                ? const Icon(Icons.person)
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
                                  style: MyTextTheme.mediumBCB.copyWith(color: Colors.white),
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
            // Main content area
            Expanded(
              child: Stack(
                children: [
                  // Background Image
                  _buildBackgroundImage(controller),

                  // Loading overlay
                  Obx(
                    () => controller.isLoading.value
                        ? Container(
                            color: Colors.black.withValues(alpha: 0.7),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Color(0xFFDFB343),
                                  ),
                                  Spacing.h(16),
                                  AutoTranslateText(
                                    controller.callStatus.value,
                                    style: MyTextTheme.mediumBCN.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (controller
                                      .errorMessage
                                      .value
                                      .isNotEmpty) ...[
                                    Spacing.h(8),
                                    AutoTranslateText(
                                      controller.errorMessage.value,
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Overlay with call controls (SafeArea so not hidden by system nav bar)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      top: false,
                      child: _buildCallOverlay(controller),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(AstrologerVoiceCallController controller) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(controller.astrologer.profilePicture),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryGradient.colors.first.withValues(alpha: 0.2),
                  AppColors.primaryGradient.colors.last.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        color: Colors.grey.withValues(alpha: 0.3),
        child: Center(
          child: Icon(Icons.person, size: 200.w, color: Colors.grey),
        ),
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.withValues(alpha: 0.3),
            child: Center(
              child: Icon(Icons.person, size: 200.w, color: Colors.grey),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFFDFB343),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.withValues(alpha: 0.3),
            child: Center(
              child: Icon(Icons.person, size: 200.w, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  Widget _buildCallOverlay(AstrologerVoiceCallController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
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
          Obx(
            () {
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
                        color: connected ? AppColors.success : AppColors.templeGold,
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
            },
          ),
          Spacing.h(14),
          Obx(
            () {
              if (!controller.isCallConnected.value) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: AutoTranslateText(
                        '₹${controller.pricePerMinute.value.toStringAsFixed(0)}/min',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.templeGold,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
            },
          ),
          Spacing.h(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => _buildCallButton(
                  icon: Icons.volume_up,
                  color: AppColors.templeGold,
                  isActive: controller.isSpeakerOn.value,
                  onTap: () => controller.toggleSpeaker(),
                ),
              ),
              Obx(
                () => _buildCallButton(
                  icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                  color: AppColors.templeGold,
                  isActive: !controller.isMuted.value,
                  onTap: () => controller.toggleMute(),
                ),
              ),
              _buildCallButton(
                icon: Icons.call_end,
                color: AppColors.error,
                isActive: true,
                onTap: () => controller.endCall(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final isEnd = color == AppColors.error;
    Color bgColor = isEnd
        ? AppColors.error
        : (isActive ? color : color.withValues(alpha: 0.5));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
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
        child: Icon(icon, color: Colors.white, size: 26.w),
      ),
    );
  }
}
