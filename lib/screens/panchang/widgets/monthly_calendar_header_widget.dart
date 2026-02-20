import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/monthly_calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class MonthlyCalendarHeaderWidget extends StatelessWidget {
  final MonthlyCalendarController controller;
  final VoidCallback? onLocationTap;
  final VoidCallback? onDateTap;

  const MonthlyCalendarHeaderWidget({
    super.key,
    required this.controller,
    this.onLocationTap,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            "#8B1925".toColor(), // rgba(139, 25, 37, 1)
            "#5D1C21".toColor(), // rgba(93, 28, 33, 1)
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5.75,
            offset: const Offset(0, 3.83),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.33.w,
            right: 15.33.w,
            top: 15.33.h,
            bottom: 15.33.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and Title Row
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 34.49.w,
                      height: 34.49.h,
                      padding: EdgeInsets.all(7.67.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.58.r),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                  ),
                  Spacing.w(12),
                  // Title Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with gold gradient
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE3B341), // rgba(227, 179, 65, 1)
                              Color(0xFFC9A033), // rgba(201, 160, 51, 1)
                            ],
                          ).createShader(bounds),
                          child: AutoTranslateText(
                            'Monthely Calender',
                            style: MyTextTheme.largeBCB.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.48,
                              color: Colors.white,
                              height: 1.34,
                            ),
                          ),
                        ),
                        Spacing.h(4),
                        // Subtitle
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE3B341),
                              Color(0xFFC9A033),
                            ],
                          ).createShader(bounds),
                          child: AutoTranslateText(
                            'Traditional Indian Calendar System',
                            style: MyTextTheme.mediumBCN.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.33,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacing.h(16),
              // Location and Date Buttons Row
              Row(
                children: [
                  // Location Button
                  Expanded(
                    child: GestureDetector(
                      onTap: onLocationTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(13.41.r),
                          border: Border.all(
                            color: Color(0xFFE3B341), // 2nd-gold
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFFE3B341),
                              size: 15.33.w,
                            ),
                            Spacing.w(6),
                            Expanded(
                              child: Obx(
                                () => AutoTranslateText(
                                  controller.selectedLocation.value,
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    fontSize: 13.41.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFE3B341),
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacing.w(6),
                  // Date Button
                  Expanded(
                    child: GestureDetector(
                      onTap: onDateTap ?? () => controller.selectDate(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(13.41.r),
                          border: Border.all(
                            color: Color(0xFFE3B341), // 2nd-gold
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Color(0xFFE3B341),
                              size: 15.w,
                            ),
                            Spacing.w(6),
                            Expanded(
                              child: Obx(
                                () => AutoTranslateText(
                                  controller.getMonthYearString(),
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    fontSize: 13.41.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFE3B341),
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
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
            ],
          ),
        ),
      ),
    );
  }
}


