import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YoginiMahadashaMainWidget extends StatelessWidget {
  final DashaController controller;

  const YoginiMahadashaMainWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYoginiMain.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.yoginiMainData.value;
      
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

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final dashaList = response['dasha_list'] as List<dynamic>? ?? [];
      final dashaEndDates = response['dasha_end_dates'] as List<dynamic>? ?? [];
      final dashaLordList = response['dasha_lord_list'] as List<dynamic>? ?? [];
      final startDate = response['start_date'] as int? ?? 0;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Yogini Dasha Main',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Spacing.h(8),
            
            // Start Date
            if (startDate > 0)
              AutoTranslateText(
                'Start Date: $startDate',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            
            Spacing.h(16),
            
            // Dasha List
            Container(
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
                  // Header
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
                          flex: 2,
                          child: AutoTranslateText(
                            'Dasha',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Lord',
                            textAlign: TextAlign.center,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'End Date',
                            textAlign: TextAlign.right,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // List Items
                  ...List.generate(dashaList.length, (index) {
                    final isLast = index == dashaList.length - 1;
                    final dasha = dashaList[index].toString();
                    final lord = index < dashaLordList.length ? dashaLordList[index].toString() : '';
                    final endDate = index < dashaEndDates.length ? dashaEndDates[index].toString() : '';
                    
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
                        children: [
                          Expanded(
                            flex: 2,
                            child: AutoTranslateText(
                              dasha,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: "#6F221E".toColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AutoTranslateText(
                              lord,
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: "#ed6f30".toColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AutoTranslateText(
                              _formatDate(endDate),
                              textAlign: TextAlign.right,
                              style: MyTextTheme.smallBCN.copyWith(
                                color: "#6F221E".toColor().withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      // Try parsing formats like "Sat, Mar 6, 2027, 12:00:00 AM"
      final formats = [
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

