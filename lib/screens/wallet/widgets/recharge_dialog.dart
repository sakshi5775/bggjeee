import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
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
  final WalletController _controller = Get.find<WalletController>();
  final TextEditingController _amountController = TextEditingController();
  final List<int> _quickAmounts = [100, 500, 1000, 2000, 5000, 10000];
  int? _selectedQuickAmount;

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
      Get.showSnackbar(
        GetSnackBar(
          message: 'Please enter an amount',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Please enter a valid amount',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount < 1) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Minimum recharge amount is ₹1',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call startRazorpayRecharge in controller
    Get.back(); // Close dialog first

    // We can show a loading indicator if needed, but controller handles flows
    // Or we can let the controller handle the loading UI
    await _controller.startRazorpayRecharge(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
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
                AutoTranslateText(
                  'Add Money',
                  style: AppTypography.h2.copyWith(
                    color: const Color(0xFF3D0C11),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.w),
                  onPressed: () => Get.back(),
                  color: const Color(0xFF3D0C11),
                ),
              ],
            ),

            Spacing.h(24),

            // Amount input
            AutoTranslateText(
              'Enter Amount',
              style: AppTypography.h3.copyWith(color: const Color(0xFF333333)),
            ),
            Spacing.h(8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                prefixText: '₹ ',
                prefixStyle: AppTypography.h2.copyWith(
                  color: const Color(0xFF333333),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE3B341)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFE3B341),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
              style: AppTypography.h2.copyWith(color: const Color(0xFF333333)),
            ),

            Spacing.h(20),

            // Quick amounts
            AutoTranslateText(
              'Quick Amounts',
              style: AppTypography.h3.copyWith(color: const Color(0xFF333333)),
            ),
            Spacing.h(12),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: _quickAmounts.map((amount) {
                final isSelected = _selectedQuickAmount == amount;
                return GestureDetector(
                  onTap: () => _selectQuickAmount(amount),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE3B341)
                          : const Color(0xFFF8F6F0),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE3B341)
                            : const Color(0xFFE3B341).withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: AutoTranslateText(
                      '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: AppTypography.h3.copyWith(
                        color: isSelected
                            ? const Color(0xFF3D0C11)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            Spacing.h(24),

            // Recharge button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _controller.isInitiatingRecharge.value ||
                          _controller.isVerifyingRecharge.value
                      ? null
                      : _initiateRecharge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D0C11),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _controller.isInitiatingRecharge.value ||
                          _controller.isVerifyingRecharge.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFE3B341),
                            ),
                          ),
                        )
                      : AutoTranslateText(
                          'Add Money',
                          style: AppTypography.h2.copyWith(
                            color: const Color(0xFFE3B341),
                          ),
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
