import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LalKitabVarshphalWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabVarshphalWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabVarshphalChart.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.lalKitabVarshphalChartData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final svgData = data['data'] as String?;
      if (svgData == null || svgData.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No chart data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      // Get form data to extract DOB
      final formData = controller.formData.value;
      final dob = formData?['date'] as String? ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Selector
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Select Varshphal Year',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.body1),
                  ),
                  Spacing.h(12),
                  Obx(() {
                    // Generate list of years (current year ± 10 years)
                    final currentYear = DateTime.now().year;
                    final years = List.generate(21, (index) => currentYear - 10 + index);
                    
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: "#ed6f30".toColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: "#ed6f30".toColor().withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: DropdownButton<int>(
                        value: controller.selectedVarshphalYear.value,
                        isExpanded: true,
                        underline: SizedBox.shrink(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: "#ed6f30".toColor(),
                        ),
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w600,
                        ).merge(AppTypography.body1),
                        items: years.map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: AutoTranslateText('$year'),
                          );
                        }).toList(),
                        onChanged: (int? newYear) {
                          if (newYear != null) {
                            controller.updateVarshphalYear(newYear);
                          }
                        },
                      ),
                    );
                  }),
                  Spacing.h(12),
                  // Auto-generated date display (read-only)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size: 16.w,
                        ),
                        Spacing.w(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoTranslateText(
                                'Varshphal Date (Auto-Generated)',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: Colors.grey,
                                ).merge(AppTypography.label),
                              ),
                              Spacing.h(2),
                              Obx(() {
                                final dobParts = dob.split('/');
                                String displayDate = '';
                                if (dobParts.length >= 2) {
                                  final day = dobParts[0].padLeft(2, '0');
                                  final month = dobParts[1].padLeft(2, '0');
                                  displayDate = '$day/$month/${controller.selectedVarshphalYear.value}';
                                }
                                return AutoTranslateText(
                                  displayDate,
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: "#6F221E".toColor(),
                                    fontWeight: FontWeight.bold,
                                  ).merge(AppTypography.h3),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(16),
            
            // Info Label
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: "#ed6f30".toColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: "#ed6f30".toColor().withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: "#ed6f30".toColor(),
                        size: 18.w,
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: AutoTranslateText(
                          'Varshphal is calculated from birthday to birthday. Date is auto-selected based on your birth date (DD/MM) + selected year.',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor(),
                            height: 1.4,
                          ).merge(AppTypography.body2),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  Obx(() {
                    // Check if varshphal date would match birth date
                    final dobParts = dob.split('/');
                    if (dobParts.length >= 3) {
                      final dobYear = int.tryParse(dobParts[2]) ?? 0;
                      if (dobYear == controller.selectedVarshphalYear.value) {
                        return Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 16.w,
                              ),
                              Spacing.w(8),
                              Expanded(
                                child: AutoTranslateText(
                                  'Note: Year matches birth year. System will auto-adjust to next year.',
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: Colors.orange.shade800,
                                      height: 1.3,
                                    ).merge(AppTypography.label),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
            Spacing.h(16),
            
            // Chart Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.maxWidth;
                  return Container(
                    width: size,
                    height: size,
                    padding: EdgeInsets.all(16.w),
                    child: SvgPicture.string(
                      svgData,
                      width: size - 32.w,
                      height: size - 32.w,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

