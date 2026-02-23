import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoshTableWidget extends StatelessWidget {
  final DoshController controller;

  const DoshTableWidget({super.key, required this.controller});

  static const Color _maroon = Color(0xFF6F221E);
  static const Color _orange = Color(0xFFed6f30);
  static const Color _orangeLight = Color(0xFFFF8A3D);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: _orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Dosh Options',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: _maroon,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            ...controller.doshTableData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final title = item['title'] as String;
              final icon = item['icon'] as IconData;
              final isLast = index == controller.doshTableData.length - 1;

              return InkWell(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isLast
                            ? Colors.transparent
                            : _maroon.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 22.w),
                      ),
                      Spacing.w(12),
                      Expanded(
                        child: AutoTranslateText(
                          title,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: _maroon,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: _maroon, size: 14.w),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
