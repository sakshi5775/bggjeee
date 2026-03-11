import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/recharge_dialog.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Dialog to show when wallet balance is insufficient.
/// Shown globally for any paid action; user cannot proceed without recharging.
class WalletRechargeDialog extends StatelessWidget {
  final double currentBalance;
  final double requiredBalance;
  /// Optional e.g. astrologer/persona name. If null, generic message is shown.
  final String? contextName;
  /// Optional custom message. If null, uses contextName or generic text.
  final String? customMessage;
  /// Deprecated: use [contextName]. Kept for backward compatibility.
  final String? astrologerName;

  const WalletRechargeDialog({
    super.key,
    required this.currentBalance,
    required this.requiredBalance,
    this.contextName,
    this.customMessage,
    this.astrologerName,
  });

  String get _message {
    if (customMessage != null && customMessage!.isNotEmpty) return customMessage!;
    final name = contextName ?? astrologerName;
    if (name != null && name.isNotEmpty) {
      return 'Minimum wallet balance required to talk with $name is \u20B9${requiredBalance.toStringAsFixed(1)}. Please recharge your wallet.';
    }
    return 'Insufficient wallet balance. Minimum required is \u20B9${requiredBalance.toStringAsFixed(1)}. Please recharge your wallet to continue.';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientBackground,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 12.w, 20.h),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Insufficient Balance',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Wallet recharge required',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // No close (X) button - user must choose Recharge or Go Back
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.error.withValues(alpha: 0.12),
                          AppColors.error.withValues(alpha: 0.06),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.error,
                            size: 24.w,
                          ),
                        ),
                        Spacing.w(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoTranslateText(
                                'Available Balance',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacing.h(4),
                              AutoTranslateText(
                                '\u20B9${currentBalance.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.h(16),
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.templeGold.withValues(alpha: 0.12),
                          AppColors.templeGold.withValues(alpha: 0.06),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.templeGold.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.templeGold.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.textColorMaroon,
                            size: 24.w,
                          ),
                        ),
                        Spacing.w(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoTranslateText(
                                'Required Balance',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacing.h(4),
                              AutoTranslateText(
                                '\u20B9${requiredBalance.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColorMaroon,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.h(18),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.textColorMaroon.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.textColorMaroon.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.textColorMaroon,
                          size: 20.w,
                        ),
                        Spacing.w(12),
                        Expanded(
                          child: AutoTranslateText(
                            _message,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.sp,
                              color: AppColors.textColorMaroon,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.h(24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: AutoTranslateText(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      Spacing.w(12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.orangeGradient.colors.first
                                    .withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                Get.dialog(const RechargeDialog());
                              },
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                    Spacing.w(8),
                                    AutoTranslateText(
                                      'Recharge Now',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
