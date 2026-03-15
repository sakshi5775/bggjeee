import 'package:astrobharataiuser/core/services/chat_minimize_manager.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Floating chat bubble shown when chat is minimized.
/// Tap to expand to full chat.
class FloatingChatBubbleOverlay extends StatelessWidget {
  const FloatingChatBubbleOverlay({super.key});

  /// Bottom nav height + padding to sit just above it.
  static const double _bottomNavHeight = 70;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatMinimizeManager>()) {
      return const SizedBox.shrink();
    }
    final manager = Get.find<ChatMinimizeManager>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomOffset = _bottomNavHeight + 16 + bottomPadding;

    return Obx(() {
      if (!manager.isMinimized.value) return const SizedBox.shrink();
      return Positioned(
        right: 20.w,
        bottom: bottomOffset,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            try {
              if (manager.isMinimized.value) manager.expandChat();
            } catch (_) {}
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: manager.imageUrl.value.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(28.r),
                            child: CachedNetworkImage(
                              imageUrl: manager.imageUrl.value,
                              width: 52.w,
                              height: 52.w,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white,
                                size: 26.w,
                              ),
                              errorWidget: (_, __, ___) => Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white,
                                size: 26.w,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white,
                            size: 26.w,
                          ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
