import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class YoginiMahadashaSubWidget extends StatelessWidget {
  final DashaController controller;

  const YoginiMahadashaSubWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYoginiSub.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.yoginiSubData.value;
      
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

      final response = data['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Yogini Dasha Sub',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Spacing.h(16),
            
            // Main Dasha Items
            ...response.map((item) {
              final mainDasha = item['main_dasha'] as String? ?? '';
              final mainDashaLord = item['main_dasha_lord'] as String? ?? '';
              final subDashaList = item['sub_dasha_list'] as List<dynamic>? ?? [];
              final subDashaEndDates = item['sub_dasha_end_dates'] as List<dynamic>? ?? [];
              final subDashaStartDate = item['sub_dasha_start_dates'] as String? ?? '';
              
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Dasha Header
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: "#ed6f30".toColor().withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoTranslateText(
                                  'Main Dasha: $mainDasha',
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: "#6F221E".toColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacing.h(4),
                                AutoTranslateText(
                                  'Lord: $mainDashaLord',
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: "#ed6f30".toColor(),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (subDashaStartDate.isNotEmpty) ...[
                                  Spacing.h(4),
                                  AutoTranslateText(
                                    'Start: ${_formatDate(subDashaStartDate)}',
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: "#6F221E".toColor().withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Sub Dasha List
                    ...List.generate(subDashaList.length, (index) {
                      final isLast = index == subDashaList.length - 1;
                      final subDasha = subDashaList[index].toString();
                      final endDate = index < subDashaEndDates.length ? subDashaEndDates[index].toString() : '';
                      
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isLast ? Colors.transparent : "#ed6f30".toColor().withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoTranslateText(
                              subDasha,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: "#6F221E".toColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AutoTranslateText(
                              _formatDate(endDate),
                              style: MyTextTheme.smallBCN.copyWith(
                                color: "#6F221E".toColor().withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      // Try parsing formats like "Sat, Mar 5, 2022, 06:00:00 PM"
      final formats = [
        'EEE, MMM d, yyyy, hh:mm:ss a',
        'EEE, MMM d, yyyy, h:mm:ss a',
        'EEE MMM dd yyyy',
        'EEE, MMM dd yyyy',
        'MMM dd yyyy',
        'dd/MM/yyyy',
      ];
      
      for (final format in formats) {
        try {
          final date = DateFormat(format).parse(dateStr);
          return DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          continue;
        }
      }
      
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}

