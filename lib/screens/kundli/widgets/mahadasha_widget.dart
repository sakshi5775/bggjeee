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

class MahadashaWidget extends StatelessWidget {
  final DashaController controller;

  const MahadashaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMahadasha.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.mahadashaData.value;

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

      final mahadashaList = response['mahadasha'] as List<dynamic>? ?? [];
      final mahadashaOrder =
          response['mahadasha_order'] as List<dynamic>? ?? [];
      final startYear = response['start_year'] as int?;
      final dashaStartDate = response['dasha_start_date'] as String? ?? '';
      final dashaRemaining =
          response['dasha_remaining_at_birth'] as String? ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.all(08.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: "#FFFFFF".toColor(),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: "#ed6f30".toColor(), width: 1),
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
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                      Spacing.w(16),
                      AutoTranslateText(
                        'Mahadasha',
                        style: MyTextTheme.largeBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'baloo2',
                        ),
                      ),
                    ],
                  ),

                  // Title
                  // AutoTranslateText(
                  //   'Mahadasha',
                  //   style: MyTextTheme.largeBCB.copyWith(
                  //     color: "#6F221E".toColor(),
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Spacing.h(16),

                  // Info Cards
                  if (startYear != null)
                    _buildInfoCard('Start Year', startYear.toString()),

                  if (dashaStartDate.isNotEmpty)
                    _buildInfoCard(
                      'Dasha Start Date',
                      _formatDate(dashaStartDate),
                    ),

                  if (dashaRemaining.isNotEmpty)
                    _buildInfoCard('Dasha Remaining at Birth', dashaRemaining),
                ],
              ),
            ),

            Spacing.h(16),

            // Mahadasha List
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
                            'Planet',
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
                  ...List.generate(mahadashaList.length, (index) {
                    final isLast = index == mahadashaList.length - 1;
                    final planet = mahadashaList[index].toString();
                    final endDate = index < mahadashaOrder.length
                        ? mahadashaOrder[index].toString()
                        : '';

                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isLast
                                ? Colors.transparent
                                : "#ed6f30".toColor().withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AutoTranslateText(
                              planet,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: "#6F221E".toColor(),
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

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: "#ed6f30".toColor(), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ),
            ),
          ),
          Spacing.w(8),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              value,
              textAlign: TextAlign.right,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#ed6f30".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final formats = [
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
