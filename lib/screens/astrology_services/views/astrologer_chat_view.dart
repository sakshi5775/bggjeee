import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controllers/astrologer_chat_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
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
            scrollController.position.maxScrollExtent,
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
                CommonHeader(
                  title: '',
                  showDrawer: false,
                  showHome: false,
                  onBackTap: controller.onBackPressed,
                  customActions: [
                    // End Chat Button
                    Obx(
                      () => controller.sessionStatus.value == 'ACTIVE'
                          ? TextButton(
                              onPressed: _showEndChatDialog,
                              child: AutoTranslateText(
                                'End Chat',
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: '#6F221E'.toColor(),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                  titleWidget: Row(
                    children: [
                      // Profile Pic
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: '#6F221E'.toColor().withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Obx(() {
                          final astrologer = controller.astrologerRx.value;
                          final imageUrl =
                              astrologer?.profilePicture ??
                              controller.astrologerImage;

                          return ClipOval(
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Icon(
                                      Icons.person,
                                      color: '#6F221E'.toColor(),
                                    ),
                                    errorWidget: (_, __, ___) => Icon(
                                      Icons.person,
                                      color: '#6F221E'.toColor(),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: '#6F221E'.toColor(),
                                  ),
                          );
                        }),
                      ),
                      SizedBox(width: 10.w),

                      Expanded(
                        child: Obx(() {
                          final astrologer = controller.astrologerRx.value;
                          final name =
                              astrologer?.displayName ??
                              controller.astrologerName;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoTranslateText(
                                name,
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: '#6F221E'.toColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              // Billing Info Row
                              Wrap(
                                spacing: 4.w,
                                runSpacing: 2.h,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  // Rate
                                  if (controller.pricePerMinute.value > 0)
                                    _buildPill(
                                      '₹${controller.pricePerMinute.value.toStringAsFixed(0)}/min',
                                      Colors.black26,
                                    ),
                                  // Balance
                                  _buildPill(
                                    '₹${controller.walletBalance.value.toStringAsFixed(0)}',
                                    Colors.indigo[900]!,
                                  ),
                                  // Timer
                                  if (controller.sessionStatus.value ==
                                      'ACTIVE')
                                    _buildPill(
                                      _formatTime(
                                        controller.visualSecondsRemaining.value,
                                      ),
                                      controller.visualSecondsRemaining.value <
                                              60
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // LOW BALANCE WARNING BANNER
                Obx(() {
                  // CRITICAL: Only show warning if:
                  // 1. Explicitly set by socket event (server confirmed low balance), AND
                  // 2. Balance/minutes are actually loaded AND low (not just uninitialized)
                  // IMPORTANT: Don't show if user has 2+ minutes - only show when actually low
                  final hasLowBalance =
                      controller.showLowBalanceWarning.value &&
                      controller.walletBalance.value > 0 && // Balance is loaded
                      controller.availableMinutes.value >=
                          0 && // Minutes are calculated
                      controller.availableMinutes.value <
                          2 && // Actually less than 2 minutes
                      controller.sessionStatus.value == 'ACTIVE';

                  if (hasLowBalance) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 16.w,
                      ),
                      color: Colors.red[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 16.sp,
                            color: Colors.red[700],
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: AutoTranslateText(
                              "Low Balance! Recharge now to continue.",
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(
                                '/wallet',
                              ); // Assuming /wallet is the route
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              minimumSize: Size(0, 28.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              'Recharge',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

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

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.white24),
      ),
      child: AutoTranslateText(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildChatArea() {
    return Container(
      color: Colors.transparent,
      child: Obx(() {
        if (controller.messages.isEmpty &&
            controller.sessionStatus.value == 'CREATED') {
          return Center(child: Text('Waiting for astrologer to accept...'));
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: controller.messages.length,
          padding: EdgeInsets.all(16.w),
          reverse: true, // Messages are stored newest at index 0
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.white,
      child: Row(
        children: [
          // REMOVED IMAGE PICKER
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.messageController,
                enabled:
                    controller.sessionStatus.value == 'ACTIVE' &&
                    !controller.isSendingMessage.value,
                decoration: InputDecoration(
                  hintText: controller.sessionStatus.value == 'ACTIVE'
                      ? 'Type message...'
                      : 'Chat ended',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
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
              onPressed: controller.sessionStatus.value == 'ACTIVE'
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
        padding: EdgeInsets.all(12.w),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        decoration: BoxDecoration(
          color: isUser ? AppColors.saffron : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
      padding: EdgeInsets.all(8.w),
      color: Colors.grey[200],
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
              Get.back(); // close dialog
              controller.endChat();
            },
            child: const Text('End', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
