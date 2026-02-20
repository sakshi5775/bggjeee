import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/controllers/global_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class GlobalChatBanner extends StatelessWidget {
  const GlobalChatBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalChatController controller = Get.find<GlobalChatController>();

    return Obx(() {
      if (!controller.showBanner) return const SizedBox.shrink();

      final session = controller.activeSession.value;
      if (session == null) return const SizedBox.shrink();

      return Positioned(
        bottom: 100.h, // Above bottom navigation bar
        left: 16.w,
        right: 16.w,
        child: GestureDetector(
          onTap: () => controller.resumeActiveChat(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF5D1C21), // Dark Maroon
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFDFB343), // Gold border
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Activity Pulse
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'Active Chat Session',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: const Color(0xFFDFB343), // Gold
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      AutoTranslateText(
                        'Continue conversation with Astrologer',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFB343), // Gold
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble, color: Colors.white, size: 14.w),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        'JOIN',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
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
    });
  }
}

