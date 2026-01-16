import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/value/dimension.dart';

class DashaTableWidget extends StatelessWidget {
  final DashaController controller;

  const DashaTableWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: EdgeInsets.all(8.w),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // child: Column(
        //   children: [
        //     // Table Rows
        //     ...controller.dashaTableData.asMap().entries.map((entry) {
        //       final index = entry.key;
        //       final row = entry.value;
        //       final isLast = index == controller.dashaTableData.length - 1;
        //       final leftText = row['left'] as String;
        //       final rightText = row['right'] as String;
        //       final hasRightColumn = rightText.isNotEmpty;

        //       return GestureDetector(
        //         onTap: () {
        //           // Handle navigation based on left column text
        //           if (leftText == 'Vimshottari Dasha') {
        //             controller.navigateToVimshottariDasha();
        //           } else if (leftText == 'Current Mahadasha') {
        //             controller.navigateToCurrentMahadashaTab();
        //           } else if (leftText == 'Yogini Dasha') {
        //             controller.navigateToYoginiDasha();
        //           }
        //         },
        //         child: Container(
        //           padding: EdgeInsets.all(16.w),
        //           decoration: BoxDecoration(
        //             border: Border(
        //               bottom: BorderSide(
        //                 color: isLast ? Colors.transparent : "#ed6f30".toColor().withOpacity(0.1),
        //                 width: 1,
        //               ),
        //             ),
        //           ),
        //           child: hasRightColumn
        //               ? _buildTwoColumnRow(leftText, rightText, index)
        //               : _buildSingleColumnRow(leftText, index),
        //         ),
        //       );
        //     }).toList(),
        //   ],
        // ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: "#ed6f30".toColor().withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Spacing.w(12),
                  AutoTranslateText(
                    "Runing Dasha",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'baloo2',
                    ),
                  ),
                ],
              ),
              ...controller.dashaTableData.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                final isLast = index == controller.dashaTableData.length - 1;
                final leftText = row['left'] as String;
                final rightText = row['right'] as String;
                final hasRightColumn = rightText.isNotEmpty;

                return InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () {
                    if (leftText == 'Vimshottari Dasha') {
                      controller.navigateToVimshottariDasha();
                    } else if (leftText == 'Current Mahadasha') {
                      controller.navigateToCurrentMahadashaTab();
                    } else if (leftText == 'Yogini Dasha') {
                      controller.navigateToYoginiDasha();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isLast
                                ? Colors.transparent
                                : "#ed6f30".toColor().withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: hasRightColumn
                          ? _buildTwoColumnRow(leftText, rightText, index)
                          : _buildSingleColumnRow(leftText, index),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTwoColumnRow(String leftText, String rightText, int index) {
    // return Row(
    //   children: [
    //     // Left Column
    //     Expanded(
    //       child: Container(
    //         padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
    //         decoration: BoxDecoration(
    //           color: index == 0
    //               ? "#ed6f30".toColor().withOpacity(0.05)
    //               : Colors.transparent,
    //           borderRadius: BorderRadius.circular(8.r),
    //         ),
    //         child: AutoTranslateText(
    //           leftText,
    //           textAlign: TextAlign.center,
    //           style: MyTextTheme.mediumBCN.copyWith(
    //             color: "#6F221E".toColor(),
    //             fontWeight: FontWeight.w500,
    //           ),
    //         ),
    //       ),
    //     ),

    //     // Divider
    //     Container(
    //       width: 1,
    //       height: 40.h,
    //       color: "#ed6f30".toColor().withOpacity(0.2),
    //     ),

    //     // Right Column
    //     Expanded(
    //       child: GestureDetector(
    //         onTap: () {
    //           // Handle navigation for right column
    //           if (rightText == 'Mahadasha') {
    //             controller.navigateToMahadashaTab();
    //           }
    //         },
    //         child: Container(
    //           padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
    //           decoration: BoxDecoration(
    //             color: index == 0
    //                 ? "#ed6f30".toColor().withOpacity(0.05)
    //                 : Colors.transparent,
    //             borderRadius: BorderRadius.circular(8.r),
    //           ),
    //           child: AutoTranslateText(
    //             rightText,
    //             textAlign: TextAlign.center,
    //             style: MyTextTheme.mediumBCN.copyWith(
    //               color: "#6F221E".toColor(),
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    return Row(
      children: [
        /// Left Column
        Expanded(
          child: Container(
            // height: 60.h,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: index == 0
                  ? "#ed6f30".toColor().withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AutoTranslateText(
              leftText,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),

        /// Vertical Divider
        Container(
          width: 1,
          height: 36.h,
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: "#ed6f30".toColor().withOpacity(0.2),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),

        /// Right Column (Clickable)
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: () {
              if (rightText == 'Mahadasha') {
                controller.navigateToMahadashaTab();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: index == 0
                    ? "#ed6f30".toColor().withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: AutoTranslateText(
                rightText,
                textAlign: TextAlign.center,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleColumnRow(String leftText, int index) {
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
    //   decoration: BoxDecoration(
    //     color: index == 1
    //         ? "#ed6f30".toColor().withOpacity(0.05)
    //         : Colors.transparent,
    //     borderRadius: BorderRadius.circular(8.r),
    //   ),
    //   child: AutoTranslateText(
    //     leftText,
    //     textAlign: TextAlign.center,
    //     style: MyTextTheme.mediumBCN.copyWith(
    //       color: "#6F221E".toColor(),
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    // );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: index == 1
            ? "#ed6f30".toColor().withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: AutoTranslateText(
        leftText,
        textAlign: TextAlign.center,
        style: MyTextTheme.mediumBCN.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: index == 1 ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
