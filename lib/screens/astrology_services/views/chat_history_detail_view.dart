import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatHistoryDetailView extends StatelessWidget {
  const ChatHistoryDetailView({super.key});

  static String _str(dynamic v) => v?.toString() ?? '';
  static String? _strOrNull(dynamic v) => v == null ? null : v.toString();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final map = args is Map<String, dynamic> ? args : null;
    final chatId = _str(map?['chatId']);
    final transcript = map?['transcript'];
    final msgList = transcript is Map ? transcript['messages'] : null;
    final messages = msgList is List ? msgList : <dynamic>[];

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              CommonHeader(
                title: 'Chat History',
                subtitle: chatId.isNotEmpty
                    ? AutoTranslateText(
                        chatId.length > 24 ? '${chatId.substring(0, 24)}...' : chatId,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          color: AppColors.textColorMaroon.withValues(alpha: 0.8),
                        ),
                      )
                    : null,
                showBackButton: true,
                onBackTap: () => Get.back(),
                showWallet: false,
              ),
              if (messages.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.orangeGradient.colors.first.withValues(alpha: 0.15),
                                AppColors.orangeGradient.colors.last.withValues(alpha: 0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 56.w,
                            color: AppColors.orangeGradient.colors.first,
                          ),
                        ),
                        Spacing.h(16),
                        AutoTranslateText(
                          'No messages in this chat',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.sp,
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.message_rounded, size: 20.w, color: Colors.white),
                            Spacing.w(8),
                            AutoTranslateText(
                              messages.length == 1 ? '1 message' : '${messages.length} messages',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final raw = messages[index];
                              final message = raw is Map ? raw : <String, dynamic>{};
                              final senderType = _str(message['senderType']);
                              final type = senderType.isEmpty ? 'USER' : senderType;
                              final isUser = type.toUpperCase() == 'USER';
                              final content = _str(message['content']);
                              final sentAt = _strOrNull(message['sentAt']);
                              final msgType = _str(message['messageType']);
                              final isText = msgType.isEmpty || msgType.toUpperCase() == 'TEXT';

                              DateTime? dateTime;
                              if (sentAt != null && sentAt.isNotEmpty) {
                                try {
                                  dateTime = DateTime.parse(sentAt);
                                } catch (_) {}
                              }

                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isUser) ...[
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: AppColors.primaryGradient,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.3),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 18.r,
                                          backgroundColor: Colors.transparent,
                                          child: Icon(Icons.person_rounded, size: 18.w, color: Colors.white),
                                        ),
                                      ),
                                      Spacing.w(8),
                                    ],
                                    Flexible(
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                        decoration: BoxDecoration(
                                          gradient: isUser ? AppColors.orangeGradient : LinearGradient(
                                            colors: [
                                              Colors.white,
                                              AppColors.primaryGradient.colors.first.withValues(alpha: 0.06),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.r),
                                            topRight: Radius.circular(16.r),
                                            bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                                            bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                                          ),
                                          border: isUser ? null : Border.all(
                                            color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isUser
                                                  ? AppColors.orangeGradient.colors.first.withValues(alpha: 0.25)
                                                  : Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (isText)
                                              AutoTranslateText(
                                                content,
                                                style: TextStyle(
                                                  color: isUser ? Colors.white : AppColors.textColorMaroon,
                                                  fontSize: 14.sp,
                                                  height: 1.4,
                                                  fontFamily: 'Poppins',
                                                ),
                                              )
                                            else
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.image_rounded,
                                                    size: 18.w,
                                                    color: isUser ? Colors.white : AppColors.textColorMaroon,
                                                  ),
                                                  Spacing.w(8),
                                                  AutoTranslateText(
                                                    'Image',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: isUser ? Colors.white : AppColors.textColorMaroon,
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (dateTime != null) ...[
                                              Spacing.h(6),
                                              AutoTranslateText(
                                                DateFormat('HH:mm').format(dateTime),
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: isUser ? Colors.white.withValues(alpha: 0.85) : Colors.grey[600],
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isUser) ...[
                                      Spacing.w(8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: 18.r,
                                          backgroundColor: Colors.transparent,
                                          child: Icon(Icons.person_rounded, size: 18.w, color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
