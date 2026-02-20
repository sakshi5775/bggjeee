import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Discreet widget to display remaining API calls (optional, dev mode)
/// Only shows in debug mode or when explicitly enabled
class TarotRemainingCallsWidget extends StatelessWidget {
  const TarotRemainingCallsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode (optional - can be removed for production)
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<TarotController>();

    return Obx(() {
      final remaining = controller.remainingApiCalls.value;
      if (remaining == null) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 8.h,
        right: 8.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: AutoTranslateText(
            'API Calls: $remaining',
            style: AppTypography.label.copyWith(
              color: Colors.white70,
            ),
          ),
        ),
      );
    });
  }
}


