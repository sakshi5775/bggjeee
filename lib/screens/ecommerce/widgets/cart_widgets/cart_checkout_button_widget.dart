import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CartCheckoutButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isProcessing;
  final String totalAmount;
  final NumberFormat currencyFormat;

  const CartCheckoutButtonWidget({
    super.key,
    this.onPressed,
    this.isProcessing = false,
    required this.totalAmount,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      width: double.infinity,
      height: 54.71.h,
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(258.68.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isProcessing ? null : onPressed,
          borderRadius: BorderRadius.circular(258.68.r),
          child: Center(
            child: isProcessing
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoTranslateText(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.white,
                          height: 1.56,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        totalAmount,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.white,
                          height: 1.56,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
