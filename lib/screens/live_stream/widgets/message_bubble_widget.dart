import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubbleWidget extends StatelessWidget {
  final StreamMessage message;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getColorFromName(String name) {
    final colors = [
      const Color(0xFFF38B3B),
      const Color(0xFFDD2914),
      const Color(0xFFFFD700),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFF96CEB4),
      const Color(0xFFFFEAA7),
      const Color(0xFFDDA15E),
    ];
    final hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'TEXT') {
      final senderColor = _getColorFromName(message.senderName);
      
      return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar circle
            Container(
              width: 28.w,
              height: 28.w,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    senderColor,
                    senderColor.withValues(alpha: 0.7),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: senderColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: AutoTranslateText(
                  _getInitials(message.senderName),
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.label),
                ),
              ),
            ),
            // Message bubble
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: Radius.circular(18.r),
                    bottomRight: Radius.circular(18.r),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: senderColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sender name
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4.w,
                          height: 4.w,
                          margin: EdgeInsets.only(right: 6.w),
                          decoration: BoxDecoration(
                            color: senderColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        AutoTranslateText(
                          message.senderName,
                          style: MyTextTheme.smallBCB.copyWith(
                            color: senderColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(4),
                    // Message content
                    AutoTranslateText(
                      message.content ?? '',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: Colors.white,
                        height: 1.4,
                        letterSpacing: 0.2,
                      ).merge(AppTypography.body1),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(4),
                    // Timestamp
                    AutoTranslateText(
                      _formatTime(message.sentAt),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ).merge(AppTypography.label),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (message.messageType == 'REACTION') {
      return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF38B3B).withValues(alpha: 0.95),
                const Color(0xFFDD2914).withValues(alpha: 0.95),
                const Color(0xFFF38B3B).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF38B3B).withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reaction icon with background
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AutoTranslateText(
                  message.reactionType ?? 'âœ¨',
                  style: AppTypography.h1,
                ),
              ),
              Spacing.w(12),
              // Sender name and timestamp
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    message.senderName,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ).merge(AppTypography.body1),
                  ),
                  Spacing.h(2),
                  AutoTranslateText(
                    _formatTime(message.sentAt),
                    style: MyTextTheme.smallBCN.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ).merge(AppTypography.label),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (message.messageType == 'GIFT') {
      return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFFD700).withValues(alpha: 0.95),
                const Color(0xFFFFA500).withValues(alpha: 0.95),
                const Color(0xFFFFD700).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFFFFD700).withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gift icon with sparkle effect
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: AutoTranslateText(
                      message.reactionType ?? 'ðŸŽ',
                      style: AppTypography.h1,
                    ),
                  ),
                  // Sparkle effect
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Icon(
                        Icons.star,
                        size: 12.w,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.w(12),
              // Gift info
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF3E2723),
                        ).merge(AppTypography.body1),
                        children: [
                          TextSpan(
                            text: message.senderName,
                            style: MyTextTheme.smallBCB.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3E2723),
                            ),
                          ),
                          TextSpan(
                            text: ' sent ',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: const Color(0xFF3E2723).withValues(alpha: 0.8),
                            ),
                          ),
                          TextSpan(
                            text: message.content ?? 'a gift',
                            style: MyTextTheme.smallBCB.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3E2723),
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      _formatTime(message.sentAt),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF3E2723).withValues(alpha: 0.6),
                      ).merge(AppTypography.label),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
}


