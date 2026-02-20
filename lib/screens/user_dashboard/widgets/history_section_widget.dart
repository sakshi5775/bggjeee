import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HistorySectionWidget extends BasePage<UserDashboardController> {
  const HistorySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'History',
                style: AppTypography.h2.copyWith(
                  color: '#820B17'.toColor(),
                  letterSpacing: -0.05,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.consultationHistory),
                child: Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: AutoTranslateText(
                    'View All',
                    style: AppTypography.body1.copyWith(
                      color: '#9D4807'.toColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(4),
          _buildHistoryPlaceholderCard(context),
        ],
      ),
    );
  }

  Widget _buildHistoryPlaceholderCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.consultationHistory),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#DBCCA8'.toColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: '#FCE5AA'.toColor(),
                border: Border.all(color: AppColors.deepOrange, width: 1.5),
              ),
              child: Icon(
                Icons.history,
                size: 28.w,
                color: '#9D4807'.toColor(),
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Consultation History',
                    style: AppTypography.body1.copyWith(
                      color: '#3D0C11'.toColor(),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    'View your chat, call & video history',
                    style: AppTypography.body2.copyWith(
                      color: '#6F221E'.toColor().withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     _buildActionButton(
            //       icon: Icons.chat_bubble_outline,
            //       onTap: () => Get.toNamed(AppRoutes.consultationHistory),
            //     ),
            //     Spacing.h(6),
            //     _buildActionButton(
            //       icon: Icons.description_outlined,
            //       onTap: () => Get.toNamed(AppRoutes.consultationHistory),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 18.w, color: Colors.white),
      ),
    );
  }
}


