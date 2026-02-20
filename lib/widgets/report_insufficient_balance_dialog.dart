import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/recharge_dialog.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Dialog to show when wallet balance is insufficient for report generation
class ReportInsufficientBalanceDialog extends StatelessWidget {
  final double currentBalance;
  final double requiredBalance;
  final String reportName;

  const ReportInsufficientBalanceDialog({
    super.key,
    required this.currentBalance,
    required this.requiredBalance,
    this.reportName = 'Report',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.cream],
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Insufficient Balance',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
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
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Balance Card
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withValues(alpha: 0.1),
                          Colors.red.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.red,
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
                                '₹${currentBalance.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacing.h(20),

                  // Required Balance Card
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.templeGold.withValues(alpha: 0.1),
                          AppColors.templeGold.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.templeGold.withValues(alpha: 0.3),
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
                            Icons.receipt_long_rounded,
                            color: AppColors.templeGold,
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
                                '₹${requiredBalance.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: '#68171E'.toColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacing.h(20),

                  // Message
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: '#68171E'.toColor().withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: '#68171E'.toColor(),
                          size: 20.w,
                        ),
                        Spacing.w(12),
                        Expanded(
                          child: AutoTranslateText(
                            'To generate the $reportName, you need a minimum wallet balance of ₹${requiredBalance.toStringAsFixed(1)}. You are short of ₹${(requiredBalance - currentBalance).toStringAsFixed(1)}.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.sp,
                              color: '#68171E'.toColor(),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacing.h(24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.back(),
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                alignment: Alignment.center,
                                child: AutoTranslateText(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
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
                                        fontSize: 16.sp,
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

