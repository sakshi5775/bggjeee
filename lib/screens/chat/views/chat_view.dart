import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';

import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/chat/controllers/chat_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class ChatView extends StatefulWidget {
  final PersonaModel persona;

  const ChatView({super.key, required this.persona});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Standardized Header
              CommonHeader(
                onBackTap: () {
                  // Check if user has sent messages (has conversation)
                  if (controller.messages.isNotEmpty &&
                      controller.conversationId.value.isNotEmpty) {
                    // Show review popup before going back
                    _showReviewPromptOnBack(controller);
                  } else {
                    Get.back();
                  }
                },
                customActions: [
                  // End Session Button
                  Obx(() {
                    if (controller.messages.isEmpty)
                      return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            title: AutoTranslateText(
                              'End Chat',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            content: AutoTranslateText(
                              'Are you sure you want to end this chat?',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF666666),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: AutoTranslateText(
                                  'Cancel',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Get.back(); // Close confirmation dialog
                                    // Show review prompt before ending chat
                                    _showReviewPromptOnEndChat(controller);
                                  },
                                  child: AutoTranslateText(
                                    'End Chat',
                                    style: MyTextTheme.smallBCB.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.saffron.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.saffron.withValues(alpha: 0.3),
                          ),
                        ),
                        child: AutoTranslateText(
                          "End",
                          style: MyTextTheme.smallBCB.copyWith(
                            color: const Color(0xFF6F221E),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                titleWidget: Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child:
                            widget.persona.image != null &&
                                widget.persona.image!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.persona.image!,
                                width: 36.w,
                                height: 36.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.saffron,
                                    size: 20.w,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.saffron.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.saffron,
                                    size: 20.w,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.saffron.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.saffron,
                                  size: 20.w,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Name and Online status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoTranslateText(
                            widget.persona.name,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: const Color(0xFF6F221E),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              AutoTranslateText(
                                "Online",
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: Colors.green,
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

              // Chat Messages Area
              Expanded(child: _buildChatArea(controller)),

              // Topic selection chips (shown after AI's first response)
              Obx(() {
                if (!controller.showTopicChips.value ||
                    controller.messages.length < 2) {
                  return const SizedBox.shrink();
                }
                return _buildTopicChips(controller);
              }),

              // Message Input
              _buildMessageInput(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea(ChatController controller) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Stack(
        children: [
          // Background pattern with golden speckles
          CustomPaint(painter: _SpecklePainter(), size: Size.infinite),

          // Messages list
          Obx(() {
            final messageCount = controller.messages.length;
            final isTyping = controller.isTyping.value;
            final isLoading = controller.isLoading.value;
            final displayedText = controller.displayedMessage.value;

            // Show typing indicator if loading or typing with displayed text
            final showTypingIndicator =
                isLoading || (isTyping && displayedText.isNotEmpty);
            final itemCount = messageCount + (showTypingIndicator ? 1 : 0);

            return ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Show typing indicator or animated message if it's the last item
                if (index == itemCount - 1 && showTypingIndicator) {
                  // Auto-scroll to bottom when typing
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  // Show typing indicator (three dots) if loading and no displayed text yet
                  if (isLoading && displayedText.isEmpty) {
                    return _buildTypingIndicator();
                  }

                  // Show animated message if we have displayed text
                  if (displayedText.isNotEmpty) {
                    return _buildMessageBubble(
                      content: displayedText,
                      isUser: false,
                      timestamp: DateTime.now(),
                      controller: controller,
                      showAnimated: true,
                    );
                  }

                  // Fallback to typing indicator
                  return _buildTypingIndicator();
                }

                // Show normal message
                final message = controller.messages[index];
                final isUser = message.role == 'user';

                return _buildMessageBubble(
                  content: message.content,
                  isUser: isUser,
                  timestamp: message.timestamp,
                  controller: controller,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0), // Light beige for assistant
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: 0),
                SizedBox(width: 4.w),
                _TypingDot(delay: 200),
                SizedBox(width: 4.w),
                _TypingDot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String content,
    required bool isUser,
    required DateTime timestamp,
    required ChatController controller,
    bool showAnimated = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) SizedBox(width: 0),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: isUser ? AppColors.orangeGradient : null,
              color: isUser
                  ? null
                  : const Color(0xFFFFF8F0), // Light beige for assistant
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isUser
                    ? Radius.circular(16.r)
                    : Radius.circular(4.r),
                bottomRight: isUser
                    ? Radius.circular(4.r)
                    : Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message content with newline support
                _buildMessageText(content: content, isUser: isUser),
                SizedBox(height: 4.h),
                // Timestamp
                AutoTranslateText(
                  controller.formatTime(timestamp),
                  style: MyTextTheme.smallBCN.copyWith(
                    color: isUser
                        ? Colors.white.withValues(alpha: 0.8)
                        : const Color(0xFF666666).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageText({required String content, required bool isUser}) {
    // Handle newlines properly - split by single and double newlines
    final paragraphs = content.split('\n\n');

    return RichText(
      text: TextSpan(
        style: MyTextTheme.smallBCN.copyWith(
          color: isUser ? Colors.white : const Color(0xFF5F2221),
          height: 1.4,
        ),
        children: paragraphs.asMap().entries.expand((entry) {
          final isLast = entry.key == paragraphs.length - 1;
          final paragraph = entry.value;

          // Split paragraph by single newlines
          final lines = paragraph.split('\n');

          // Create text spans for each line
          final lineSpans = lines.asMap().entries.map((lineEntry) {
            final isLastLine = lineEntry.key == lines.length - 1;
            return TextSpan(
              text: lineEntry.value,
              children: isLastLine ? null : [const TextSpan(text: '\n')],
            );
          }).toList();

          // Add double newline between paragraphs (except after last)
          if (!isLast && lineSpans.isNotEmpty) {
            lineSpans.add(const TextSpan(text: '\n\n'));
          }

          return lineSpans;
        }).toList(),
      ),
    );
  }

  Widget _buildTopicChips(ChatController controller) {
    final topics = [
      {'label': 'Career', 'icon': Icons.work, 'value': 'Career'},
      {
        'label': 'Love & Relationships',
        'icon': Icons.favorite,
        'value': 'Love & Relationships',
      },
      {'label': 'Marriage', 'icon': Icons.favorite_border, 'value': 'Marriage'},
      {'label': 'Health', 'icon': Icons.health_and_safety, 'value': 'Health'},
      {
        'label': 'Finance',
        'icon': Icons.account_balance_wallet,
        'value': 'Finance',
      },
      {'label': 'Education', 'icon': Icons.school, 'value': 'Education'},
      {'label': 'Family', 'icon': Icons.people, 'value': 'Family'},
      {
        'label': 'Spiritual Guidance',
        'icon': Icons.auto_awesome,
        'value': 'Spiritual Guidance',
      },
      {'label': 'Other', 'icon': Icons.more_horiz, 'value': 'Other'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 18.w,
                color: const Color(0xFF666666),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: AutoTranslateText(
                  'What would you like to know about? (Optional)',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                    fontSize: 14.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: topics.map((topic) {
                final isSelected =
                    controller.selectedTopic.value == topic['value'];
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () =>
                        controller.selectTopic(topic['value'] as String),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.orangeGradient : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFFE0E0E0),
                          width: isSelected ? 0 : 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            topic['icon'] as IconData,
                            size: 18.w,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF666666),
                          ),
                          SizedBox(width: 6.w),
                          AutoTranslateText(
                            topic['label'] as String,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF666666),
                              fontSize: 13.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // AutoTranslateText input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: AppColors.orangeGradient.colors.first.withValues(
                    alpha: 0.3,
                  ),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: controller.messageController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF5F2221),
                ),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF999999),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.sendMessage();
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Send button
          Obx(() {
            final hasText = controller.messageText.value.trim().isNotEmpty;
            final isLoading = controller.isLoading.value;
            final isTyping = controller.isTyping.value;

            return GestureDetector(
              onTap: (hasText && !isLoading && !isTyping)
                  ? () {
                      controller.sendMessage();
                      // Scroll to bottom after sending
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    }
                  : null,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: (hasText && !isLoading && !isTyping)
                      ? AppColors.orangeGradient
                      : null,
                  color: (hasText && !isLoading && !isTyping)
                      ? null
                      : AppColors.orangeGradient.colors.first.withValues(
                          alpha: 0.5,
                        ),
                  shape: BoxShape.circle,
                  boxShadow: (hasText && !isLoading && !isTyping)
                      ? [
                          BoxShadow(
                            color: AppColors.orangeGradient.colors.first
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Icon(Icons.send, color: Colors.white, size: 22.w),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Custom painter for golden speckles background
class _SpecklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.saffron.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw random golden speckles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Review prompt functions
extension ChatViewReviewPrompt on _ChatViewState {
  void _showReviewPromptOnBack(ChatController controller) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.star, color: AppColors.saffron, size: 24.w),
            SizedBox(width: 8.w),
            Expanded(
              child: AutoTranslateText(
                'Rate Your Experience',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                ),
              ),
            ),
          ],
        ),
        content: AutoTranslateText(
          'Would you like to rate your experience with ${widget.persona.displayName}?',
          style: MyTextTheme.smallBCN.copyWith(color: const Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText(
              'Maybe Later',
              style: MyTextTheme.smallBCN.copyWith(
                color: const Color(0xFF666666),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close prompt dialog
              Get.back(
                result: {'showReviewPrompt': true},
              ); // Go back from chat with result
            },
            child: AutoTranslateText(
              'Rate Now',
              style: MyTextTheme.smallBCB.copyWith(color: AppColors.saffron),
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewPromptOnEndChat(ChatController controller) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.star, color: AppColors.saffron, size: 24.w),
            SizedBox(width: 8.w),
            Expanded(
              child: AutoTranslateText(
                'End Chat & Rate',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                ),
              ),
            ),
          ],
        ),
        content: AutoTranslateText(
          'Would you like to rate your experience with ${widget.persona.displayName} before ending the chat?',
          style: MyTextTheme.smallBCN.copyWith(color: const Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close prompt dialog
              controller.deleteConversation();
              // Just go back, no rating
              Get.back();
            },
            child: AutoTranslateText(
              'End Without Rating',
              style: MyTextTheme.smallBCN.copyWith(
                color: const Color(0xFF666666),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close prompt dialog
              // Return result for review
              Get.back(result: {'showReviewPrompt': true});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffron,
              foregroundColor: Colors.white,
            ),
            child: AutoTranslateText(
              'Rate & End Chat',
              style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Typing dot widget with animation
class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation after delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + (_animation.value * 0.7),
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppColors.orangeGradient.colors.first,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
