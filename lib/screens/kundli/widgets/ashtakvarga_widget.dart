import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class AshtakvargaWidget extends StatelessWidget {
  final KundliResultController controller;

  const AshtakvargaWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading if fetching data
      if (controller.isLoadingAshtakvarga.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Ashtakvarga data...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
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
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      final order = data['ashtakvarga_order'] as List<dynamic>? ?? [];
      final points = data['ashtakvarga_points'] as List<dynamic>? ?? [];
      final totals = data['ashtakvarga_total'] as List<dynamic>? ?? [];

      // Debug: Print data to verify
      debugPrint('Ashtakvarga Order: $order');
      debugPrint('Ashtakvarga Points: $points');
      debugPrint('Ashtakvarga Totals: $totals');
      debugPrint('Order length: ${order.length}, Points length: ${points.length}, Totals length: ${totals.length}');

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Ashtakvarga',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Spacing.h(16),
            
            // Ashtakvarga Table Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
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
                  // Table with both vertical and horizontal scroll
                  _buildTable(order, points, totals),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTable(List<dynamic> order, List<dynamic> points, List<dynamic> totals) {
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

  Widget _buildTableContent(List<dynamic> order, List<dynamic> points, List<dynamic> totals) {
    // Ensure we have valid data
    final planetCount = order.length;
    final pointsCount = points.length;
    
    debugPrint('Building table with $planetCount planets and $pointsCount point rows');
    
    return Table(
      border: TableBorder.all(
        color: "#6F221E".toColor().withOpacity(0.2),
        width: 1,
      ),
      columnWidths: {
        0: FixedColumnWidth(80.w), // House column
        for (int i = 1; i <= planetCount; i++)
          i: FixedColumnWidth(60.w), // Planet columns
        planetCount + 1: FixedColumnWidth(70.w), // Total column
      },
      children: [
        // Header row: House | Planet1 | Planet2 | ... | Total
        TableRow(
          decoration: BoxDecoration(
            color: "#6F221E".toColor().withOpacity(0.1),
          ),
          children: [
            _buildHeaderCell('House'),
            for (int i = 0; i < planetCount; i++)
              _buildHeaderCell(order[i]?.toString() ?? '--'),
            _buildHeaderCell('Total'),
          ],
        ),
        // Data rows for each house (1-12)
        ...List.generate(12, (houseIndex) {
          return TableRow(
            decoration: BoxDecoration(
              color: houseIndex % 2 == 0 
                  ? Colors.white 
                  : "#DFB343".toColor().withOpacity(0.05),
            ),
            children: [
              // House number
              _buildHouseCell('H${houseIndex + 1}'),
              // Points for each planet in this house
              for (int planetIndex = 0; planetIndex < planetCount; planetIndex++)
                _buildDataCell(
                  _getPointForHouse(planetIndex, houseIndex, points),
                ),
              // Total for this house
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
  
  String _getPointForHouse(int planetIndex, int houseIndex, List<dynamic> points) {
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
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHouseCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCN.copyWith(
          color: "#6F221E".toColor(),
        ),
      ),
    );
  }

  Widget _buildTotalCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.mediumBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

