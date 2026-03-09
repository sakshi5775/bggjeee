import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/content_moderation/content_moderation.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controllers/astrologer_chat_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerChatView extends StatefulWidget {
  const AstrologerChatView({super.key});

  @override
  State<AstrologerChatView> createState() => _AstrologerChatViewState();
}

class _AstrologerChatViewState extends State<AstrologerChatView> {
  late final ScrollController scrollController;
  late final AstrologerChatController controller;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    final args = Get.arguments;
    AstrologerModel? astrologer;
    String? chatId;
    dynamic chatProfile;

    if (args is Map<String, dynamic>) {
      astrologer = args['astrologer'] as AstrologerModel?;
      chatId = args['chatId'] as String?;
      chatProfile = args['chatProfile'];
    } else if (args is AstrologerModel) {
      astrologer = args;
    }

    if (astrologer == null && chatId == null) {
      Get.back();
      return;
    }

    controller = Get.put(
      AstrologerChatController(
        astrologer: astrologer,
        initialChatId: chatId,
        chatProfile: chatProfile,
      ),
    );

    ever(controller.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            controller.onBackPressed();
          },
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header with gradient (no white)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: controller.onBackPressed,
                        child: Padding(
                          padding: EdgeInsets.all(6.r),
                          child: Icon(Icons.arrow_back_rounded, color: AppColors.templeGold, size: 24.w),
                        ),
                      ),
                      Spacing.w(10),
                      Expanded(
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.templeGold, width: 2),
                                  ),
                                  child: CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: AppColors.templeGold.withValues(alpha: 0.3),
                                    backgroundImage:
                                        controller.astrologer.profilePicture != null &&
                                                controller.astrologer.profilePicture!.isNotEmpty
                                            ? CachedNetworkImageProvider(controller.astrologer.profilePicture!)
                                            : null,
                                    child: controller.astrologer.profilePicture == null ||
                                            controller.astrologer.profilePicture!.isEmpty
                                        ? Icon(Icons.person_rounded, color: AppColors.templeGold, size: 24.w)
                                        : null,
                                  ),
                                ),
                                Obx(
                                  () => Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10.w,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        color: controller.effectiveOnlineStatus ? AppColors.success : Colors.grey,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.saffron, width: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacing.w(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AutoTranslateText(
                                    controller.astrologer.displayName,
                                    style: MyTextTheme.mediumBCB.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        Container(width: 5.w, height: 5.h, decoration: BoxDecoration(color: controller.effectiveOnlineStatus ? AppColors.success : Colors.grey[400], shape: BoxShape.circle)),
                                        Spacing.w(4),
                                        AutoTranslateText(
                                          controller.effectiveOnlineStatus ? 'Online' : 'Offline',
                                          style: MyTextTheme.smallBCN.copyWith(fontSize: 10.sp, color: AppColors.templeGold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // When CREATED: show 2-min countdown. When ACTIVE: show session timer
                      Obx(
                        () {
                          if (controller.sessionStatus.value == 'CREATED') {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AutoTranslateText('Wait', style: MyTextTheme.smallBCN.copyWith(color: AppColors.templeGold, fontSize: 10.sp)),
                                  AutoTranslateText(
                                    controller.formattedAcceptTimeout,
                                    style: MyTextTheme.mediumBCB.copyWith(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (controller.sessionStatus.value == 'ACTIVE' || controller.sessionStatus.value == 'EXPIRING') {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AutoTranslateText(
                                          'Time by balance',
                                          style: MyTextTheme.smallBCN.copyWith(
                                            color: AppColors.templeGold,
                                            fontSize: 10.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        Spacing.h(2),
                                        AutoTranslateText(
                                          controller.formattedTimer,
                                          style: MyTextTheme.mediumBCB.copyWith(
                                            color: controller.visualSecondsRemaining.value < 60 ? Colors.orange : Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacing.w(6),
                                GestureDetector(
                                  onTap: _showEndChatDialog,
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                    child: Icon(Icons.call_end_rounded, color: Colors.white, size: 18.w),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(child: _buildChatArea()),

                Obx(
                  () => controller.replyingToMessage.value != null
                      ? _buildReplyComposerBar()
                      : const SizedBox.shrink(),
                ),

                _buildMessageInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      color: Colors.transparent,
      child: Obx(() {
        if (controller.messages.isEmpty &&
            controller.sessionStatus.value == 'CREATED') {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(28.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(28.r),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepOrange.withValues(alpha: 0.4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Icon(Icons.schedule_rounded, size: 48.w, color: Colors.white),
                  ),
                  Spacing.h(24),
                  AutoTranslateText(
                    'Waiting for astrologer to accept',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textColorMaroon,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacing.h(12),
                  Obx(
                    () => AutoTranslateText(
                      'Time remaining: ${controller.formattedAcceptTimeout}',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: AppColors.saffron,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    'If the astrologer does not accept within 2 minutes, the request will be cancelled.',
                    style: MyTextTheme.smallBCN.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: controller.messages.length,
          padding: EdgeInsets.all(16.w),
          reverse: true,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            return _buildMessageBubble(
              message: message,
              isUser: message.isUser,
            );
          },
        );
      }),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: AppColors.gradientBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => SafeTextField(
                controller: controller.messageController,
                config: const ContentModerationConfig(
                  action: ModerationAction.block,
                  warningMessage: 'Please avoid offensive language.',
                ),
                enabled:
                    controller.sessionStatus.value == 'ACTIVE' &&
                    !controller.isSendingMessage.value,
                decoration: InputDecoration(
                  hintText: controller.sessionStatus.value == 'ACTIVE'
                      ? 'Type your message...'
                      : controller.sessionStatus.value == 'CREATED'
                      ? 'Waiting for astrologer to accept...'
                      : 'Chat ended',
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppColors.templeGold.withValues(alpha: 0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppColors.templeGold.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppColors.templeGold, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(
            () => IconButton(
              icon: controller.isSendingMessage.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.send, color: AppColors.saffron),
              onPressed:
                  controller.sessionStatus.value == 'ACTIVE'
                  ? controller.sendMessage
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required AstrologerChatMessage message,
    required bool isUser,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [AppColors.saffron, AppColors.saffronmix],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isUser ? 18.r : 4.r),
            bottomRight: Radius.circular(isUser ? 4.r : 18.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.replyTo != null)
              _buildReplyPreview(message.replyTo!, isUser),

            AutoTranslateText(
              message.content ?? '',
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTimeOfDay(message.sentAt),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isUser ? Colors.white70 : Colors.black54,
                  ),
                ),
                if (isUser) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message.status == 'READ' ? Icons.done_all : Icons.check,
                    size: 14.sp,
                    color: message.status == 'READ'
                        ? Colors.blueAccent
                        : Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(DateTime? time) {
    if (time == null) return '';
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildReplyPreview(ReplyData replyTo, bool isUser) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        replyTo.snippet,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10.sp,
          color: isUser ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildReplyComposerBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.templeGold.withValues(alpha: 0.12),
        border: Border(
          top: BorderSide(color: AppColors.templeGold.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${controller.replyingToMessage.value?.senderType == 'USER' ? 'You' : 'Astrologer'}',
                  style: TextStyle(fontSize: 10.sp, color: Colors.indigo),
                ),
                Text(
                  controller.replyingToMessage.value?.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: controller.cancelReply,
          ),
        ],
      ),
    );
  }

  void _showEndChatDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('End Chat?'),
        content: const Text('Are you sure you want to end this session?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.endChat();
            },
            child: const Text('End', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
