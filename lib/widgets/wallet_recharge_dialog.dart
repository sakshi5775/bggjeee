import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/recharge_dialog.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Dialog to show when wallet balance is insufficient
class WalletRechargeDialog extends StatelessWidget {
  final double currentBalance;
  final double requiredBalance;
  final String astrologerName;

  const WalletRechargeDialog({
    Key? key,
    required this.currentBalance,
    required this.requiredBalance,
    required this.astrologerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        constraints: BoxConstraints(maxWidth: 400.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoTranslateText(
                    'Insufficient wallet balance',
                    style: AppTypography.h2.copyWith(
                      color: const Color(0xFF5F2221),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.w, color: const Color(0xFF5F2221)),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            
            Spacing.h(16),
            
            // Available Balance
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Available Balance',
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    '₹${currentBalance.toStringAsFixed(1)}',
                    style: AppTypography.h2.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            Spacing.h(16),
            
            // Message
            AutoTranslateText(
              'Minimum wallet balance required to talk with $astrologerName is ₹${requiredBalance.toStringAsFixed(1)}. Please recharge your wallet.',
              style: AppTypography.body1.copyWith(
                color: const Color(0xFF5F2221),
                height: 1.5,
              ),
            ),
            
            Spacing.h(24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    child: AutoTranslateText(
                      'Cancel',
                      style: AppTypography.h3.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // Show recharge dialog
                      Get.dialog(const RechargeDialog());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDFB343),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: AutoTranslateText(
                      'Recharge',
                      style: AppTypography.h3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




