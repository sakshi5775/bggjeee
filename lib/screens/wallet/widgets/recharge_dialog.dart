import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        'Minimum recharge amount is Rs $_minRechargeAmount. Please enter at least Rs $_minRechargeAmount or choose from the quick amounts.',
      );
      return;
    }

    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await _controller.startRazorpayRecharge(amount);
    } catch (e) {
      final errorStr = e.toString();
      String message = 'Failed to initiate recharge. Please try again.';
      if (errorStr.contains('Validation failed') ||
          errorStr.toLowerCase().contains('validation')) {
        message =
            'Amount not accepted. Please enter at least Rs $_minRechargeAmount or choose from the quick amounts.';
      } else if (errorStr.isNotEmpty) {
        final cleanMessage = errorStr
            .replaceFirst('Error During Communication: ', '')
            .trim();
        if (cleanMessage.isNotEmpty) message = cleanMessage;
      }
      ErrorUiUtils.showWarningSnackbar(message);
    } finally {
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  static const int _minRechargeAmount = 10;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
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
                          'Add Money',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Recharge your wallet',
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
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Enter Amount',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColorMaroon,
                      ),
                    ),
                    Spacing.h(10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.templeGold.withValues(alpha: 0.35),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.templeGold.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColorMaroon,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 20.sp,
                          ),
                          prefixText: '\u20B9 ',
                          prefixStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.sp,
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
                    Spacing.h(22),
                    AutoTranslateText(
                      'Quick Amounts',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColorMaroon,
                      ),
                    ),
                    Spacing.h(10),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: _quickAmounts.map((amount) {
                        final isSelected = _selectedQuickAmount == amount;
                        return GestureDetector(
                          onTap: () => _selectQuickAmount(amount),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              gradient:
                                  isSelected ? AppColors.orangeGradient : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.orangeGradient.colors.first
                                    : AppColors.templeGold.withValues(alpha: 0.35),
                                width: isSelected ? 2 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.orangeGradient
                                            .colors.first
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: AutoTranslateText(
                              _formatAmount(amount),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textColorMaroon,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Spacing.h(28),
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
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow:
                              _controller.isInitiatingRecharge.value ||
                                      _controller.isVerifyingRecharge.value
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: AppColors.orangeGradient
                                            .colors.first
                                            .withValues(alpha: 0.4),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
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
                            borderRadius: BorderRadius.circular(18.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                              alignment: Alignment.center,
                              child:
                                  _controller.isInitiatingRecharge.value ||
                                          _controller.isVerifyingRecharge.value
                                      ? SizedBox(
                                          height: 26.h,
                                          width: 26.w,
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
                                              size: 24.w,
                                            ),
                                            Spacing.w(10),
                                            AutoTranslateText(
                                              'Add Money',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 17.sp,
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
          ],
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    if (str.length <= 3) return '\u20B9$str';
    final buffer = StringBuffer('\u20B9');
    var i = str.length % 3;
    if (i == 0) i = 3;
    buffer.write(str.substring(0, i));
    for (; i < str.length; i += 3) {
      buffer.write(',');
      buffer.write(str.substring(i, i + 3));
    }
    return buffer.toString();
  }
}
