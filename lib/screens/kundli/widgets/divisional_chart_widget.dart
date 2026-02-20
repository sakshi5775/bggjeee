import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class DivisionalChartWidget extends StatelessWidget {
  final KundliResultController controller;

  const DivisionalChartWidget({super.key, required this.controller});

  // Available divisional chart types with descriptions (D2 removed)
  static const List<Map<String, String>> divisions = [
    {'code': 'D1', 'name': 'D1', 'desc': 'Rashi'},
    {'code': 'D3', 'name': 'D3', 'desc': 'Drekkana'},
    {'code': 'D4', 'name': 'D4', 'desc': 'Chaturthamsha'},
    {'code': 'D5', 'name': 'D5', 'desc': 'Panchamsha'},
    {'code': 'D6', 'name': 'D6', 'desc': 'Shashthamsha'},
    {'code': 'D7', 'name': 'D7', 'desc': 'Saptamamsha'},
    {'code': 'D8', 'name': 'D8', 'desc': 'Ashtamamsha'},
    {'code': 'D9', 'name': 'D9', 'desc': 'Navamsha'},
    {'code': 'D10', 'name': 'D10', 'desc': 'Dashamamsha'},
    {'code': 'D11', 'name': 'D11', 'desc': 'Rudramsha'},
    {'code': 'D12', 'name': 'D12', 'desc': 'Dwadashamamsha'},
    {'code': 'D16', 'name': 'D16', 'desc': 'Shodashamsha'},
    {'code': 'D20', 'name': 'D20', 'desc': 'Vimshamsha'},
    {'code': 'D24', 'name': 'D24', 'desc': 'Chaturvimshamsha'},
    {'code': 'D27', 'name': 'D27', 'desc': 'Saptavimshamsha'},
    {'code': 'D30', 'name': 'D30', 'desc': 'Trimshamsha'},
    {'code': 'D40', 'name': 'D40', 'desc': 'Khavedamsha'},
    {'code': 'D45', 'name': 'D45', 'desc': 'Akshvedamsha'},
    {'code': 'D60', 'name': 'D60', 'desc': 'Shashtiamsha'},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDivision = controller.selectedDivisionForChart.value;
      final data = controller.divisionalChartData.value;

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
                  _buildHeader(),
                  _buildDivisionSlider(selectedDivision),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: _buildContent(context, selectedDivision, data),
                  ),
                ],
              ),
            ),
            Spacing.h(12),
            const ConsultAstrologerCard(),
            Spacing.h(32),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(gradient: AppColors.orangeGradient),
      child: Row(
        children: [
          Icon(Icons.table_chart_rounded, size: 18.w, color: Colors.white),
          Spacing.w(8),
          AutoTranslateText(
            'Divisional Chart',
            style: MyTextTheme.mediumBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivisionSlider(String? selectedDivision) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: "#ed6f30".toColor().withOpacity(0.06),
        border: Border(
          bottom: BorderSide(
            color: "#ed6f30".toColor().withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 36.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: divisions.length,
          separatorBuilder: (_, __) => SizedBox(width: 6.w),
          itemBuilder: (context, index) {
            final d = divisions[index];
            final code = d['code']!;
            final isSelected = selectedDivision == code;
            return GestureDetector(
              onTap: () => controller.fetchDivisionalChartData(code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.orangeGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : "#ed6f30".toColor().withOpacity(0.35),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: AutoTranslateText(
                  code,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: isSelected ? Colors.white : "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    String? selectedDivision,
    Map<String, dynamic>? data,
  ) {
    if (controller.isLoadingDivisionalChart.value) {
      return _buildLoadingState(selectedDivision);
    }
    if (selectedDivision != null && data != null) {
      return _buildDataTable(context, data, selectedDivision);
    }
    return _buildEmptyState();
  }

  Widget _buildLoadingState(String? selectedDivision) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              color: "#ed6f30".toColor(),
              strokeWidth: 2,
            ),
          ),
          Spacing.w(10),
          AutoTranslateText(
            'Loading ${selectedDivision ?? 'chart'}...',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 36.w,
            color: "#6F221E".toColor().withOpacity(0.35),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Select a division (D1–D60) to view chart data',
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    Map<String, dynamic> data,
    String selectedDivision,
  ) {
    final houseNo = data['house_no'] as Map<String, dynamic>? ?? {};
    final zodiacNo = data['zodiac_no'] as Map<String, dynamic>? ?? {};
    final divisionInfo = divisions.firstWhere(
      (d) => d['code'] == selectedDivision,
      orElse: () => {
        'code': selectedDivision,
        'name': selectedDivision,
        'desc': '',
      },
    );
    final desc = divisionInfo['desc'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AutoTranslateText(
              '$selectedDivision Chart',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
            if (desc.isNotEmpty) ...[
              AutoTranslateText(
                ' • ',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                  fontSize: 12.sp,
                ),
              ),
              Flexible(
                child: AutoTranslateText(
                  desc,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        Spacing.h(10),
        _buildHouseTable(context, houseNo, 'House', Icons.home_outlined),
        Spacing.h(10),
        _buildZodiacTable(context, zodiacNo, 'Zodiac', Icons.star_outline),
      ],
    );
  }

  Widget _buildHouseTable(
    BuildContext context,
    Map<String, dynamic> houseNo,
    String title,
    IconData icon,
  ) {
    return _buildCompactTable(
      context: context,
      title: title,
      icon: icon,
      columnLabel: 'House',
      rowCount: 12,
      rowKey: (i) => (i + 1).toString(),
      cellLabel: (k) => 'H$k',
      getPlanets: (k) => houseNo[k] as List<dynamic>? ?? [],
    );
  }

  Widget _buildZodiacTable(
    BuildContext context,
    Map<String, dynamic> zodiacNo,
    String title,
    IconData icon,
  ) {
    return _buildCompactTable(
      context: context,
      title: title,
      icon: icon,
      columnLabel: 'Zodiac',
      rowCount: 12,
      rowKey: (i) => (i + 1).toString(),
      cellLabel: (k) => 'Z$k',
      getPlanets: (k) => zodiacNo[k] as List<dynamic>? ?? [],
    );
  }

  Widget _buildCompactTable({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String columnLabel,
    required int rowCount,
    required String Function(int i) rowKey,
    required String Function(String k) cellLabel,
    required List<dynamic> Function(String k) getPlanets,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final col1 = (screenWidth * 0.22).clamp(56.0, 90.0);
    // final col2 = (screenWidth * 0.68).clamp(180.0, 320.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14.w, color: "#ed6f30".toColor()),
            Spacing.w(6),
            AutoTranslateText(
              title,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        Spacing.h(6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: "#6F221E".toColor().withOpacity(0.12),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(
                    color: "#6F221E".toColor().withOpacity(0.12),
                    width: 1,
                  ),
                  columnWidths: {
                    0: FixedColumnWidth(Get.width * 0.2),
                    1: FixedColumnWidth(Get.width * 0.7),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: "#ed6f30".toColor().withOpacity(0.1),
                      ),
                      children: [
                        _buildTableHeaderCell(columnLabel),
                        _buildTableHeaderCell('Planets'),
                      ],
                    ),
                    ...List.generate(rowCount, (i) {
                      final k = rowKey(i);
                      return TableRow(
                        decoration: BoxDecoration(
                          color: i % 2 == 0
                              ? Colors.white
                              : "#ed6f30".toColor().withOpacity(0.04),
                        ),
                        children: [
                          _buildTableDataCell(cellLabel(k), isHeader: true),
                          _buildPlanetsCell(getPlanets(k)),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
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

  Widget _buildTableDataCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildPlanetsCell(List<dynamic> planets) {
    if (planets.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Center(
          child: AutoTranslateText(
            '—',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.35),
              fontSize: 11.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      child: Wrap(
        spacing: 5.w,
        runSpacing: 5.h,
        children: planets.map<Widget>((planet) {
          final planetData = planet as Map<String, dynamic>;
          final name = planetData['name']?.toString() ?? '--';
          final fullName = planetData['full_name']?.toString() ?? '';
          final zodiac = planetData['zodiac']?.toString() ?? '';
          final retro = planetData['retro'] as bool? ?? false;
          final sub = fullName.isNotEmpty && zodiac.isNotEmpty
              ? '$fullName, $zodiac'
              : fullName.isNotEmpty
              ? fullName
              : zodiac;

          return Container(
            constraints: BoxConstraints(maxWidth: 110.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: retro
                  ? "#ed6f30".toColor().withOpacity(0.1)
                  : "#6F221E".toColor().withOpacity(0.05),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: retro
                    ? "#ed6f30".toColor().withOpacity(0.3)
                    : "#6F221E".toColor().withOpacity(0.12),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AutoTranslateText(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: MyTextTheme.smallBCB.copyWith(
                          color: retro
                              ? "#ed6f30".toColor()
                              : "#6F221E".toColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    if (retro) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: "#ed6f30".toColor(),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: AutoTranslateText(
                          'R',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (sub.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  AutoTranslateText(
                    sub,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.6),
                      fontSize: 9.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
