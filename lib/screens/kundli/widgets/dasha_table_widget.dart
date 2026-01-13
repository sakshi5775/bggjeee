import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashaTableWidget extends StatelessWidget {
  final DashaController controller;

  const DashaTableWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Table Rows
            ...controller.dashaTableData.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              final isLast = index == controller.dashaTableData.length - 1;
              final leftText = row['left'] as String;
              final rightText = row['right'] as String;
              final hasRightColumn = rightText.isNotEmpty;
              
              return GestureDetector(
                onTap: () {
                  // Handle navigation based on left column text
                  if (leftText == 'Vimshottari Dasha') {
                    controller.navigateToVimshottariDasha();
                  } else if (leftText == 'Current Mahadasha') {
                    controller.navigateToCurrentMahadashaTab();
                  } else if (leftText == 'Yogini Dasha') {
                    controller.navigateToYoginiDasha();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isLast ? Colors.transparent : "#ed6f30".toColor().withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: hasRightColumn
                      ? _buildTwoColumnRow(leftText, rightText, index)
                      : _buildSingleColumnRow(leftText, index),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumnRow(String leftText, String rightText, int index) {
    return Row(
      children: [
        // Left Column
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: index == 0 ? "#ed6f30".toColor().withOpacity(0.05) : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AutoTranslateText(
              leftText,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        
        // Divider
        Container(
          width: 1,
          height: 40.h,
          color: "#ed6f30".toColor().withOpacity(0.2),
        ),
        
        // Right Column
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Handle navigation for right column
              if (rightText == 'Mahadasha') {
                controller.navigateToMahadashaTab();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: index == 0 ? "#ed6f30".toColor().withOpacity(0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                rightText,
                textAlign: TextAlign.center,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleColumnRow(String leftText, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: index == 1 ? "#ed6f30".toColor().withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: AutoTranslateText(
        leftText,
        textAlign: TextAlign.center,
        style: MyTextTheme.mediumBCN.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
