import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String totalAmount;
  final VoidCallback? onClose;

  const CartHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.totalAmount,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            '#820B17'.toColor(), // Dark maroon
            '#68171E'.toColor(), // Medium maroon
            '#5D1C21'.toColor(), // Darker maroon
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.18.r),
          bottomRight: Radius.circular(26.18.r),
        ),
      ),
      child: Stack(
        children: [
          // Decorative golden dots
          ...List.generate(8, (index) {
            final positions = [
              Offset(306.56.w, 240.01.h),
              Offset(86.76.w, 221.52.h),
              Offset(210.5.w, 241.35.h),
              Offset(27.71.w, 67.05.h),
              Offset(69.47.w, 19.5.h),
              Offset(123.13.w, 6.54.h),
              Offset(178.69.w, 232.08.h),
              Offset(151.72.w, 163.86.h),
            ];
            return Positioned(
              left: positions[index].dx,
              top: positions[index].dy,
              child: Container(
                width: 4.36.w,
                height: 4.36.h,
                decoration: BoxDecoration(
                  color: '#E3B341'.toColor().withOpacity(0.3 + (index * 0.1)),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(26.18.w, 40.04.h, 26.18.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onClose,
                          child: Icon(
                            Icons.arrow_back,
                            color: '#DFB343'.toColor(),
                            size: 21.81.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        AutoTranslateText(
                          title,
                          style: TextStyle(
                            fontFamily: 'Baloo Bhai 2',
                            fontWeight: FontWeight.w500,
                            fontSize: 26.sp,
                            color: '#DFB343'.toColor(),
                            height: 1.17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.72.h),
                // Subtitle
                if (subtitle != null)
                  AutoTranslateText(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 15.27.sp,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.43,
                    ),
                  ),
                SizedBox(height: 8.72.h),
                // Total Amount Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(17.45.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(17.45.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Total Amount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 15.27.sp,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.43,
                        ),
                      ),
                      SizedBox(height: 4.36.h),
                      AutoTranslateText(
                        totalAmount,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 32.72.sp,
                          color: '#E3B341'.toColor(),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
