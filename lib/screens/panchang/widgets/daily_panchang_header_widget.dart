import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/daily_panchang_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class DailyPanchangHeaderWidget extends StatelessWidget {
  final DailyPanchangController controller;
  final VoidCallback? onLocationTap;

  const DailyPanchangHeaderWidget({
    super.key,
    required this.controller,
    this.onLocationTap,
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
          padding: EdgeInsets.symmetric(horizontal: 15.33.w, vertical: 15.33.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title row
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 34.49.w,
                      height: 34.49.h,
                      padding: EdgeInsets.all(7.67.w),
                      child: Icon(
                        Icons.arrow_back,
                        color: "#E3B341".toColor(),
                        size: 20.w,
                      ),
                    ),
                  ),
                  Spacing.w(12),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          "Today's Panchang",
                          style: MyTextTheme.largeBCB.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.48,
                            foreground: Paint()
                              ..shader =
                                  LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      "#E3B341"
                                          .toColor(), // rgba(227, 179, 65, 1)
                                      "#C9A033"
                                          .toColor(), // rgba(201, 160, 51, 1)
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          'Vedic Details for the seleceted date',
                          style: MyTextTheme.smallBCN.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            foreground: Paint()
                              ..shader =
                                  LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      "#E3B341".toColor(),
                                      "#C9A033".toColor(),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacing.h(20),
              // Location and Date buttons
              Row(
                children: [
                  // Location button
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
                            color: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                "#E3B341".toColor(),
                                "#C9A033".toColor(),
                              ],
                            ).colors.first,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: "#E3B341".toColor(),
                              size: 15.33.w,
                            ),
                            Spacing.w(6),
                            Obx(
                              () => AutoTranslateText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                controller.selectedLocation.value,
                                style: MyTextTheme.smallBCB.copyWith(
                                  fontSize: 13.41.sp,
                                  fontWeight: FontWeight.w500,
                                  color: "#E3B341".toColor(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacing.w(6),
                  // Date button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectDate(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(13.41.r),
                          border: Border.all(
                            color: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                "#E3B341".toColor(),
                                "#C9A033".toColor(),
                              ],
                            ).colors.first,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: "#E3B341".toColor(),
                              size: 15.w,
                            ),
                            Spacing.w(6),
                            Obx(
                              () => AutoTranslateText(
                                controller.selectedDate.value.day ==
                                            DateTime.now().day &&
                                        controller.selectedDate.value.month ==
                                            DateTime.now().month &&
                                        controller.selectedDate.value.year ==
                                            DateTime.now().year
                                    ? 'Today'
                                    : DateFormat(
                                        'dd MMM',
                                      ).format(controller.selectedDate.value),
                                style: MyTextTheme.smallBCB.copyWith(
                                  fontSize: 13.41.sp,
                                  fontWeight: FontWeight.w500,
                                  color: "#E3B341".toColor(),
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

