import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_voice_call_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
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
              decoration: BoxDecoration(color: Colors.transparent),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
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
                                  style: MyTextTheme.mediumBCB,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Obx(
                                  () => AutoTranslateText(
                                    controller.callStatus.value,
                                    style: MyTextTheme.smallBCN.copyWith(
                                      fontSize: 10.sp,
                                      color: controller.isCallConnected.value
                                          ? Colors.green
                                          : Colors.orange,
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
                            color: Colors.black.withOpacity(0.7),
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

                  // Overlay with call controls
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildCallOverlay(controller),
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
      decoration: BoxDecoration(color: Colors.black),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Astrologer profile image
          _buildImage(controller.astrologer.profilePicture),

          // Gradient overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
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
        color: Colors.grey.withOpacity(0.3),
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
            color: Colors.grey.withOpacity(0.3),
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
            color: Colors.grey.withOpacity(0.3),
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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Astrologer Name
          AutoTranslateText(
            controller.astrologer.displayName,
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h1),
            textAlign: TextAlign.center,
          ),
          Spacing.h(8),
          // Call Status
          Obx(
            () => AutoTranslateText(
              controller.callStatus.value,
              style: MyTextTheme.mediumBCN
                  .copyWith(color: const Color(0xFF666666))
                  .merge(AppTypography.h3),
              textAlign: TextAlign.center,
            ),
          ),
          Spacing.h(8),

          // Rate per minute - ALWAYS visible
          Obx(
            () => controller.pricePerMinute.value > 0
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: AutoTranslateText(
                      'Rate: ₹${controller.pricePerMinute.value.toStringAsFixed(0)}/min',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: const Color(0xFFDFB343),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Call Duration (only show when connected) - Format: hh:mm:ss
          Obx(
            () =>
                controller.isCallConnected.value &&
                    controller.callDuration.value != '00:00:00'
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: AutoTranslateText(
                      controller.callDuration.value,
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: const Color(0xFF5F2221),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Wallet Balance & Billing Info (only show when connected)
          Obx(
            () => controller.isCallConnected.value
                ? _buildBillingInfo(controller)
                : const SizedBox.shrink(),
          ),

          Spacing.h(24),
          // Call Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Speaker Button
              Obx(
                () => _buildCallButton(
                  icon: Icons.volume_up,
                  color: const Color(0xFFFF9800), // Orange
                  isActive: controller.isSpeakerOn.value,
                  onTap: () => controller.toggleSpeaker(),
                ),
              ),
              // Mute Button
              Obx(
                () => _buildCallButton(
                  icon: Icons.mic_off,
                  color: Colors.black,
                  isActive: controller.isMuted.value,
                  onTap: () => controller.toggleMute(),
                ),
              ),
              // End Call Button
              _buildCallButton(
                icon: Icons.call_end,
                color: Colors.red,
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
    // Determine background color based on active state and type
    Color bgColor;
    if (color == Colors.red) {
      // End call button always red
      bgColor = Colors.red;
    } else {
      // Mic/Speaker: Active (On) -> Red, Inactive (Off/Mute) -> Black
      bgColor = isActive ? Colors.red : Colors.black;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.w,
        height: 64.h,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28.w),
      ),
    );
  }

  Widget _buildBillingInfo(AstrologerVoiceCallController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: controller.showLowBalanceWarning.value
              ? Colors.orange
              : const Color(0xFFDFB343).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Price per minute
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Rate/Min:',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
              Obx(
                () => AutoTranslateText(
                  '₹${controller.pricePerMinute.value.toStringAsFixed(0)}/min',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: const Color(0xFF5F2221),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(6),
          // Wallet Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Wallet Balance:',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
              Obx(
                () => AutoTranslateText(
                  '₹${controller.walletBalance.value.toStringAsFixed(0)}',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: controller.walletBalance.value < 50
                        ? Colors.red
                        : const Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(6),
          // Total Cost (Cumulative charges so far)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Charges So Far:',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
              Obx(
                () => AutoTranslateText(
                  '₹${controller.totalCost.value.toStringAsFixed(0)}',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: const Color(0xFF5F2221),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Remaining time based on balance - Format: hh:mm:ss
          Obx(() {
            if (controller.remainingTime.value != '00:00:00') {
              return Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Available Time:',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                    AutoTranslateText(
                      controller.remainingTime.value,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: controller.showLowBalanceWarning.value
                            ? Colors.orange
                            : const Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
