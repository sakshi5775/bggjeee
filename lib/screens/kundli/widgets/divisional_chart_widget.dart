import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      final svgData = controller.divisionalChartSvgData.value;

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
                  color: "#ed6f30".toColor().withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                    child: _buildContent(context, selectedDivision, svgData),
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
        color: "#ed6f30".toColor().withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: "#ed6f30".toColor().withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 36.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: DivisionalChartWidget.divisions.length,
          separatorBuilder: (_, __) => SizedBox(width: 6.w),
          itemBuilder: (context, index) {
            final d = DivisionalChartWidget.divisions[index];
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
                        : "#ed6f30".toColor().withValues(alpha: 0.35),
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
    String? svgData,
  ) {
    if (controller.isLoadingDivisionalChart.value) {
      return _buildLoadingState(selectedDivision);
    }
    if (selectedDivision != null && svgData != null && svgData.isNotEmpty) {
      return _buildSvgChart(context, selectedDivision, svgData);
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
              color: "#6F221E".toColor().withValues(alpha: 0.7),
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
            color: "#6F221E".toColor().withValues(alpha: 0.35),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Select a division (D1–D60) to view chart data',
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSvgChart(
    BuildContext context,
    String selectedDivision,
    String svgData,
  ) {
    final divisionInfo = DivisionalChartWidget.divisions.firstWhere(
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
                  color: "#6F221E".toColor().withValues(alpha: 0.6),
                  fontSize: 12.sp,
                ),
              ),
              Flexible(
                child: AutoTranslateText(
                  desc,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        Spacing.h(10),
        LayoutBuilder(
          builder: (context, constraints) {
            final chartSize = constraints.maxWidth;
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: SvgPicture.string(
                    svgData,
                    width: chartSize,
                    height: chartSize,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    placeholderBuilder: (context) => Container(
                      color: Colors.grey.withValues(alpha: 0.08),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: "#ed6f30".toColor(),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    semanticsLabel: '$selectedDivision Chart',
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
