import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoshTableWidget extends StatelessWidget {
  final DoshController controller;

  const DoshTableWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Table Rows
          ...controller.doshTableData.map((item) {
            final title = item['title'] as String;
            final icon = item['icon'] as IconData;
            
            return GestureDetector(
              onTap: () {
                if (title == 'Mangal/Manglik Dosh') {
                  controller.navigateToMangalDoshTab();
                } else if (title == 'Kaalsarp Dosh') {
                  controller.navigateToKaalsarpDoshTab();
                } else if (title == 'Pitra Dosh') {
                  controller.navigateToPitraDoshTab();
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [
                  //     "#ed6f30".toColor().withOpacity(0.9),
                  //     "#ed6f30".toColor().withOpacity(0.7),
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  color: Colors.white,
                  border: Border.all(color: Colors.deepOrange),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.2),
                        gradient: LinearGradient(colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 28.w,
                      ),
                    ),
                    Spacing.w(16),
                    Expanded(
                      child: AutoTranslateText(
                        title,
                        style: AppTypography.h2.copyWith(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepOrange,
                      size: 18.w,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

