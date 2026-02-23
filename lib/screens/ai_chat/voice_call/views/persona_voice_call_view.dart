import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
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
  final String platform; // web / android / ios

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            _header(persona, controller),
            SizedBox(height: 12.h),
            _statusSection(controller),
            const Spacer(),
            _transcriptionSection(controller),
            _aiResponseSection(controller),
            const Spacer(),
            _controls(controller),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _header(PersonaModel persona, VoiceCallController controller) {
    return Column(
      children: [
        Obx(() {
          final isRecording = controller.isRecording.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  height: 320.h,
                  width: 1.sw,
                  child: CachedNetworkImage(
                    imageUrl: persona.image ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: const Color(0xFFFFF2E5),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        size: 64.w,
                        color: AppColors.saffron,
                      ),
                    ),
                  ),
                ),
              ),
              if (isRecording)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Icon(Icons.mic, size: 48.w, color: Colors.red),
                ),
            ],
          );
        }),
        SizedBox(height: 12.h),
        AutoTranslateText(
          persona.name,
          style: MyTextTheme.mediumBCB
              .copyWith(fontWeight: FontWeight.w700, color: Colors.black87)
              .merge(AppTypography.h2),
        ),
      ],
    );
  }

  Widget _statusSection(VoiceCallController controller) {
    return Obx(() {
      // Only show time remaining, hide connection status
      final timeText = controller.remainingSeconds.value == 600
          ? 'Connecting...'
          : 'Remaining Time: ${controller.formattedRemaining}';

      return Column(
        children: [
          AutoTranslateText(
            timeText,
            style: MyTextTheme.mediumBCB
                .copyWith(color: Colors.black87)
                .merge(AppTypography.h3),
          ),
        ],
      );
    });
  }

  Widget _transcriptionSection(VoiceCallController controller) {
    return Obx(() {
      if (controller.transcription.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
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
        ),
      );
    });
  }

  Widget _aiResponseSection(VoiceCallController controller) {
    return Obx(() {
      if (controller.aiResponse.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Container(
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
        ),
      );
    });
  }

  Widget _controls(VoiceCallController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Volume button (mute/unmute - placeholder)
            _roundButton(
              icon: Icons.volume_up,
              bg: const Color(0xFFFFF2E5),
              iconColor: AppColors.saffron,
              onTap: () {
                // TODO: Implement mute/unmute functionality
              },
            ),
            // Microphone button (record/stop)
            Obx(() {
              final isRecording = controller.isRecording.value;
              final isProcessing = controller.isProcessing.value;
              return _roundButton(
                icon: isRecording ? Icons.mic : Icons.mic_off,
                bg: isRecording
                    ? Colors.red
                    : (isProcessing ? Colors.grey : const Color(0xFF1F1F1F)),
                iconColor: Colors.white,
                onTap: isProcessing ? null : () => controller.toggleRecording(),
              );
            }),
            // End call button
            _roundButton(
              icon: Icons.call_end,
              bg: Colors.redAccent,
              iconColor: Colors.white,
              onTap: () => controller.cancelCall(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required Color bg,
    required Color iconColor,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(56.r),
      child: Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 28.w),
      ),
    );
  }
}
