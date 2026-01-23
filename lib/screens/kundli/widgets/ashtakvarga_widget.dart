import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AshtakvargaWidget extends StatelessWidget {
  final KundliResultController controller;

  const AshtakvargaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAshtakvarga.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(
                  color: "#ed6f30".toColor(),
                  strokeWidth: 2,
                ),
              ),
              Spacing.h(10),
              AutoTranslateText(
                'Loading Ashtakvarga data...',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.ashtakvargaData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Ashtakvarga data available',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
              fontSize: 12.sp,
            ),
          ),
        );
      }

      final order = data['ashtakvarga_order'] as List<dynamic>? ?? [];
      final points = data['ashtakvarga_points'] as List<dynamic>? ?? [];
      final totals = data['ashtakvarga_total'] as List<dynamic>? ?? [];

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: "#ed6f30".toColor().withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      "#FF8A3D".toColor(),
                      "#ed6f30".toColor(),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.table_chart_rounded,
                      size: 18.w,
                      color: Colors.white,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Ashtakvarga',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: _buildTable(order, points, totals),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTable(
    List<dynamic> order,
    List<dynamic> points,
    List<dynamic> totals,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Always use horizontal scroll to ensure all columns are visible
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _buildTableContent(order, points, totals),
          ),
        );
      },
    );
  }

  Widget _buildTableContent(
    List<dynamic> order,
    List<dynamic> points,
    List<dynamic> totals,
  ) {
    final planetCount = order.length;
    return Table(
      border: TableBorder.all(
        color: "#6F221E".toColor().withOpacity(0.15),
        width: 1,
      ),
      columnWidths: {
        0: FixedColumnWidth(58.w),
        for (int i = 1; i <= planetCount; i++) i: FixedColumnWidth(48.w),
        planetCount + 1: FixedColumnWidth(56.w),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: "#ed6f30".toColor().withOpacity(0.12),
          ),
          children: [
            _buildHeaderCell('House'),
            for (int i = 0; i < planetCount; i++)
              _buildHeaderCell(order[i]?.toString() ?? '--'),
            _buildHeaderCell('Total'),
          ],
        ),
        ...List.generate(12, (houseIndex) {
          return TableRow(
            decoration: BoxDecoration(
              color: houseIndex % 2 == 0
                  ? Colors.white
                  : "#ed6f30".toColor().withOpacity(0.04),
            ),
            children: [
              _buildHouseCell('H${houseIndex + 1}'),
              for (int planetIndex = 0; planetIndex < planetCount; planetIndex++)
                _buildDataCell(
                  _getPointForHouse(planetIndex, houseIndex, points),
                ),
              _buildTotalCell(
                houseIndex < totals.length
                    ? totals[houseIndex]?.toString() ?? '--'
                    : '--',
              ),
            ],
          );
        }),
      ],
    );
  }

  String _getPointForHouse(
    int planetIndex,
    int houseIndex,
    List<dynamic> points,
  ) {
    if (planetIndex < points.length && points[planetIndex] is List) {
      final planetPoints = points[planetIndex] as List;
      if (houseIndex < planetPoints.length) {
        return planetPoints[houseIndex]?.toString() ?? '--';
      }
    }
    return '--';
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildHouseCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 6.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCN.copyWith(
          color: "#6F221E".toColor(),
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildTotalCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
