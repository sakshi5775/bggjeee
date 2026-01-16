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

class CurrentMahadashaWidget extends StatelessWidget {
  final DashaController controller;

  const CurrentMahadashaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCurrentMahadasha.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.currentMahadashaData.value;

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

      return SingleChildScrollView(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: "#FFFFFF".toColor(),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: "#E3B341".toColor(), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.alarm_add_outlined,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                      Spacing.w(16),
                      // Title
                      // Current Dashas Section
                      AutoTranslateText(
                        'Current Mahadasha',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'baloo2',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacing.h(20),

            // Order of Dashas Section
            if (response['order_of_dashas'] != null)
              _buildOrderOfDashasSection(
                response['order_of_dashas'] as Map<String, dynamic>,
              ),

            Spacing.h(20),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: "#FFFFFF".toColor(),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: "#ed6f30".toColor().withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.alarm_add_outlined,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                      Spacing.w(16),
                      // Title
                      // Current Dashas Section
                      AutoTranslateText(
                        'Current Dashas',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'baloo2',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacing.h(12),

            // Individual Dashas
            if (response['mahadasha'] != null)
              _buildDashaCard(
                'Mahadasha',
                response['mahadasha'] as Map<String, dynamic>,
                Icons.star,
              ),

            if (response['antardasha'] != null)
              _buildDashaCard(
                'Antar Dasha',
                response['antardasha'] as Map<String, dynamic>,
                Icons.star_border,
              ),

            if (response['paryantardasha'] != null)
              _buildDashaCard(
                'Paryantar Dasha',
                response['paryantardasha'] as Map<String, dynamic>,
                Icons.star_half,
              ),

            if (response['Shookshamadasha'] != null)
              _buildDashaCard(
                'Shooksham Dasha',
                response['Shookshamadasha'] as Map<String, dynamic>,
                Icons.star_outline,
              ),

            if (response['Pranadasha'] != null)
              _buildDashaCard(
                'Pran Dasha',
                response['Pranadasha'] as Map<String, dynamic>,
                Icons.auto_awesome,
              ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderOfDashasSection(Map<String, dynamic> orderOfDashas) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#ed6f30".toColor().withOpacity(0.1),
            "#ed6f30".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                  color: "#FFFFFF".toColor().withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.timeline,
                  color: "#ed6f30".toColor(),
                  size: 20.w,
                ),
              ),

              Spacing.w(8),
              AutoTranslateText(
                'Order of Dashas',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          if (orderOfDashas['major'] != null)
            _buildOrderCard(
              'Major',
              orderOfDashas['major'] as Map<String, dynamic>,
              0,
            ),
          if (orderOfDashas['minor'] != null)
            _buildOrderCard(
              'Minor',
              orderOfDashas['minor'] as Map<String, dynamic>,
              1,
            ),
          if (orderOfDashas['sub_minor'] != null)
            _buildOrderCard(
              'Sub Minor',
              orderOfDashas['sub_minor'] as Map<String, dynamic>,
              2,
            ),
          if (orderOfDashas['sub_sub_minor'] != null)
            _buildOrderCard(
              'Sub Sub Minor',
              orderOfDashas['sub_sub_minor'] as Map<String, dynamic>,
              3,
            ),
          if (orderOfDashas['sub_sub_sub_minor'] != null)
            _buildOrderCard(
              'Sub Sub Sub Minor',
              orderOfDashas['sub_sub_sub_minor'] as Map<String, dynamic>,
              4,
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(String label, Map<String, dynamic> item, int index) {
    final name = item['name'] as String? ?? '';
    final start = item['start'] as String? ?? '';
    final end = item['end'] as String? ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(left: BorderSide(color: "#ed6f30".toColor(), width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: AutoTranslateText(
                  label,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#ed6f30".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  name,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Start',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.6),
                      ),
                    ),
                    Spacing.h(2),
                    AutoTranslateText(
                      _formatDate(start),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: "#ed6f30".toColor().withOpacity(0.2),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'End',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withOpacity(0.6),
                        ),
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        _formatDate(end),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashaCard(
    String title,
    Map<String, dynamic> item,
    IconData icon,
  ) {
    final name = item['name'] as String? ?? '';
    final start = item['start'] as String? ?? '';
    final end = item['end'] as String? ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  "#ed6f30".toColor().withOpacity(0.1),
                  "#ed6f30".toColor().withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(icon, color: Color(0x0FFFFFFFFF), size: 20.w),
                ),
                Spacing.w(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        title,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        name,
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: "#ed6f30".toColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Start Date',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withOpacity(0.6),
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        _formatDate(start),
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50.h,
                  color: "#ed6f30".toColor().withOpacity(0.2),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'End Date',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor().withOpacity(0.6),
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          _formatDate(end),
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
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
