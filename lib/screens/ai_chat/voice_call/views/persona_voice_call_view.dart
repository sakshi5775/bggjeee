import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/voice_call/controllers/persona_voice_call_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoiceCallView extends StatelessWidget {
  final PersonaModel persona;
  final String platform;

  const VoiceCallView({
    super.key,
    required this.persona,
    this.platform = 'android',
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      VoiceCallController(persona: persona, platform: platform),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initiate();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            // Header (same as astrologer voice call)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => controller.cancelCall(),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.r,
                            backgroundImage: persona.image != null &&
                                    persona.image!.isNotEmpty
                                ? CachedNetworkImageProvider(persona.image!)
                                : null,
                            child: persona.image == null ||
                                    persona.image!.isEmpty
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
                                  persona.name,
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Obx(
                                  () => AutoTranslateText(
                                    controller.connectionStatus.value,
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
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            // Main content: background image + transcription/response + controls
            Expanded(
              child: Stack(
                children: [
                  _buildBackgroundImage(persona, controller),
                  _buildTranscriptionAndResponse(controller),
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

  Widget _buildBackgroundImage(
      PersonaModel persona, VoiceCallController controller) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (persona.image != null && persona.image!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: persona.image!,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey.withValues(alpha: 0.3),
                child: Center(
                  child: Icon(Icons.person, size: 120.w, color: Colors.grey),
                ),
              ),
            )
          else
            Container(
              color: Colors.grey.withValues(alpha: 0.3),
              child: Center(
                child: Icon(Icons.person, size: 120.w, color: Colors.grey),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryGradient.colors.first
                      .withValues(alpha: 0.2),
                  AppColors.primaryGradient.colors.last.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionAndResponse(VoiceCallController controller) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              if (controller.transcription.value.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.mic, size: 16.w, color: Colors.blue),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          'You said:',
                          style: MyTextTheme.smallBCB
                              .copyWith(color: Colors.blue)
                              .merge(AppTypography.body2),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    AutoTranslateText(
                      controller.transcription.value,
                      style: MyTextTheme.mediumBCN
                          .copyWith(color: Colors.black87)
                          .merge(AppTypography.body1),
                    ),
                  ],
                ),
              );
            }),
            Obx(() {
              if (controller.aiResponse.value.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smart_toy, size: 16.w, color: Colors.green),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          '${controller.persona.name}:',
                          style: MyTextTheme.smallBCB
                              .copyWith(color: Colors.green)
                              .merge(AppTypography.body2),
                        ),
                        if (controller.isPlaying.value) ...[
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 12.w,
                            height: 12.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    AutoTranslateText(
                      controller.aiResponse.value,
                      style: MyTextTheme.mediumBCN
                          .copyWith(color: Colors.black87)
                          .merge(AppTypography.body1),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCallOverlay(VoiceCallController controller) {
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
            controller.persona.name,
            style: MyTextTheme.largeBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(8),
          Obx(() {
            final status = controller.connectionStatus.value;
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
                      color: status == 'Ready' || status == 'Connected'
                          ? AppColors.success
                          : AppColors.templeGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Remaining: ${controller.formattedRemaining}',
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
                onTap: () => controller.cancelCall(),
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
