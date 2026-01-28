import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CartPriceSummaryWidget extends StatelessWidget {
  final NumberFormat currencyFormat;
  final double subtotal;
  final double discount;
  final double delivery;
  final double tax;
  final double total;

  const CartPriceSummaryWidget({
    super.key,
    required this.currencyFormat,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(19.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18.24.r),
        border: Border.all(
          color: '#E3B341'.toColor().withOpacity(0.2),
          width: 0.77.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: currencyFormat.format(subtotal),
          ),
          if (discount > 0)
            _SummaryRow(
              label: 'Discount',
              value: '- ${currencyFormat.format(discount)}',
              valueColor: Colors.green,
            ),
          _SummaryRow(
            label: 'Tax',
            value: currencyFormat.format(tax),
          ),
          _SummaryRow(
            label: 'Delivery Fee',
            value: delivery == 0 ? 'Free' : currencyFormat.format(delivery),
          ),
          Divider(
            height: 24.h,
            thickness: 1,
            color: Colors.black.withOpacity(0.05),
          ),
          _SummaryRow(
            label: 'Total',
            value: currencyFormat.format(total),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: '#68171E'.toColor(),
            ),
            valueStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: '#68171E'.toColor(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: labelStyle ??
                TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 15.96.sp,
                  color: '#68171E'.toColor(),
                  height: 1.43,
                ),
          ),
          AutoTranslateText(
            value,
            style: valueStyle ??
                TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 15.96.sp,
                  color: valueColor ?? '#68171E'.toColor(),
                  height: 1.43,
                ),
          ),
        ],
      ),
    );
  }
}
