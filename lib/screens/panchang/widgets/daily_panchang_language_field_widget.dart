import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/daily_panchang_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class DailyPanchangLanguageFieldWidget extends StatelessWidget {
  final DailyPanchangController controller;

  const DailyPanchangLanguageFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        AutoTranslateText(
          'Language',
          style: MyTextTheme.mediumBCB.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Spacing.h(8.02),
        // Dropdown field
        Container(
          height: 53.h,
          padding: EdgeInsets.symmetric(horizontal: 16.04.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            borderRadius: BorderRadius.circular(10.03.r),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Obx(
            () => GestureDetector(
              onTap: () {
                // Show language selection dialog
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: AutoTranslateText(
                              'Select Language',
                              style: MyTextTheme.largeBCB.copyWith(
                                fontSize: 18,
                                color: "#6B1B1A".toColor(),
                              ),
                            ),
                          ),
                          ...controller.languages.entries.map((entry) {
                            return ListTile(
                              title: AutoTranslateText(entry.value),
                              onTap: () {
                                controller.selectedLanguage.value = entry.key;
                                Navigator.pop(context);
                              },
                              trailing:
                                  controller.selectedLanguage.value == entry.key
                                  ? Icon(
                                      Icons.check,
                                      color: "#F38B3B".toColor(),
                                    )
                                  : null,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Expanded(
                    child: AutoTranslateText(
                      controller.languages[controller.selectedLanguage.value] ??
                          'Language',
                      style: MyTextTheme.mediumBCN.copyWith(
                        fontSize: 16.04,
                        fontWeight: FontWeight.w500,
                        color: "#646464".toColor(),
                      ),
                    ),
                  ),
                  Icon(Icons.language, size: 24.h, color: "#646464".toColor()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
