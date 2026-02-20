import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:get/get.dart';

class RechargeDialog extends StatefulWidget {
  const RechargeDialog({Key? key}) : super(key: key);

  @override
  State<RechargeDialog> createState() => _RechargeDialogState();
}

class _RechargeDialogState extends State<RechargeDialog> {
  late final WalletController _controller;
  final TextEditingController _amountController = TextEditingController();
  final List<int> _quickAmounts = [10, 50, 100, 500, 1000, 2000];
  int? _selectedQuickAmount;

  @override
  void initState() {
    super.initState();
    // Ensure WalletController is registered before using it
    if (Get.isRegistered<WalletController>()) {
      _controller = Get.find<WalletController>();
    } else {
      _controller = Get.put(WalletController());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectQuickAmount(int amount) {
    setState(() {
      _selectedQuickAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  Future<void> _initiateRecharge() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ErrorUiUtils.showWarningSnackbar('Please enter an amount');
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ErrorUiUtils.showWarningSnackbar('Please enter a valid amount');
      return;
    }

    if (amount < _minRechargeAmount) {
      ErrorUiUtils.showWarningSnackbar(
        'Minimum recharge amount is ₹$_minRechargeAmount. Please enter at least ₹$_minRechargeAmount or choose from the quick amounts.',
      );
      return;
    }

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // For Razorpay, use startRazorpayRecharge which will open checkout
      await _controller.startRazorpayRecharge(amount);
      // Note: Razorpay will open checkout and handle payment callback
      // The dialog will close after successful payment in _handlePaymentSuccess
    } catch (e) {
      final errorStr = e.toString();
      String message = 'Failed to initiate recharge. Please try again.';
      if (errorStr.contains('Validation failed') ||
          errorStr.toLowerCase().contains('validation')) {
        message =
            'Amount not accepted. Please enter at least ₹$_minRechargeAmount or choose from the quick amounts.';
      } else if (errorStr.isNotEmpty) {
        final cleanMessage = errorStr
            .replaceFirst('Error During Communication: ', '')
            .trim();
        if (cleanMessage.isNotEmpty) message = cleanMessage;
      }
      ErrorUiUtils.showWarningSnackbar(message);
    } finally {
      if (Get.isDialogOpen == true) Get.back(); // Close loading dialog
    }
  }

  void _showPaymentInstructions(WalletRechargeData rechargeData) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppColors.cream.withValues(alpha: 0.3)],
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
              // Header
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AutoTranslateText(
                        'Payment Instructions',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.templeGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.templeGold.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: AutoTranslateText(
                        rechargeData.instructions ??
                            'Please complete the payment to recharge your wallet.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: '#68171E'.toColor(),
                          height: 1.5,
                        ),
                      ),
                    ),
                    Spacing.h(16),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: '#68171E'.toColor().withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: '#68171E'.toColor(),
                            size: 18.w,
                          ),
                          Spacing.w(8),
                          Expanded(
                            child: AutoTranslateText(
                              'Recharge ID: ${rechargeData.rechargeId}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: '#68171E'.toColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing.h(24),
                    Container(
                      width: double.infinity,
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
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            alignment: Alignment.center,
                            child: AutoTranslateText(
                              'Got it',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
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

  static const int _minRechargeAmount = 10;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                          'Add Money',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Recharge your wallet',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
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

            // Content - scrollable to prevent overflow
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount input
                      AutoTranslateText(
                        'Enter Amount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.h(12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.templeGold.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.templeGold.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: '#68171E'.toColor(),
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixText: '₹ ',
                            prefixStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.templeGold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.templeGold,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 18.h,
                            ),
                          ),
                        ),
                      ),

                      Spacing.h(24),

                      // Quick amounts
                      AutoTranslateText(
                        'Quick Amounts',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.h(12),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: _quickAmounts.map((amount) {
                          final isSelected = _selectedQuickAmount == amount;
                          return GestureDetector(
                            onTap: () => _selectQuickAmount(amount),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.orangeGradient
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.orangeGradient.colors.first
                                      : AppColors.templeGold.withValues(alpha: 0.3),
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors
                                              .orangeGradient
                                              .colors
                                              .first
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: AutoTranslateText(
                                '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : '#68171E'.toColor(),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      Spacing.h(28),

                      // Recharge button
                      Obx(
                        () => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient:
                                _controller.isInitiatingRecharge.value ||
                                    _controller.isVerifyingRecharge.value
                                ? null
                                : AppColors.orangeGradient,
                            color:
                                _controller.isInitiatingRecharge.value ||
                                    _controller.isVerifyingRecharge.value
                                ? Colors.grey[300]
                                : null,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow:
                                _controller.isInitiatingRecharge.value ||
                                    _controller.isVerifyingRecharge.value
                                ? null
                                : [
                                    BoxShadow(
                                      color: AppColors
                                          .orangeGradient
                                          .colors
                                          .first
                                          .withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap:
                                  _controller.isInitiatingRecharge.value ||
                                      _controller.isVerifyingRecharge.value
                                  ? null
                                  : _initiateRecharge,
                              borderRadius: BorderRadius.circular(20.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                alignment: Alignment.center,
                                child:
                                    _controller.isInitiatingRecharge.value ||
                                        _controller.isVerifyingRecharge.value
                                    ? SizedBox(
                                        height: 24.h,
                                        width: 24.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
                                            color: Colors.white,
                                            size: 22.w,
                                          ),
                                          Spacing.w(10),
                                          AutoTranslateText(
                                            'Add Money',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

