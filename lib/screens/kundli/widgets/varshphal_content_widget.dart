import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/varshphal_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Content widget for standalone Varshphal page â€“ uses VarshphalController.
/// Same design as VarshphalWidget (#6F221E / #ed6f30).
class VarshphalContentWidget extends StatelessWidget {
  final VarshphalController controller;

  const VarshphalContentWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: controller.selectedVarshphalTab.value == 0
                ? _buildDetailsTab()
                : _buildYearlyChartTab(),
          ),
        ],
      );
    });
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#ed6f30'.toColor().withValues(alpha: 0.2),
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
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              'Varshphal Details',
              0,
              Icons.info_outline_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: '#ed6f30'.toColor().withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildTabButton(
              'Yearly Chart',
              1,
              Icons.table_chart_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedVarshphalTab.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectedVarshphalTab.value = index;
          if (index == 0) {
            controller.fetchVarshphalDetails();
          } else {
            controller.fetchVarshphalYearlyChart();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.orangeGradient : null,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : '#6F221E'.toColor().withValues(alpha: 0.6),
                size: 18.w,
              ),
              Spacing.w(8),
              Flexible(
                child: AutoTranslateText(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: isSelected
                        ? Colors.white
                        : '#6F221E'.toColor().withValues(alpha: 0.7),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _planetCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: '#ed6f30'.toColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildTitleRow(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: '#ed6f30'.toColor().withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: '#ed6f30'.toColor().withValues(alpha: 0.25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.w, color: '#ed6f30'.toColor()),
          Spacing.w(8),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#6F221E'.toColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Obx(() {
      if (controller.isLoadingVarshphalDetails.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.varshphalDetailsData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Varshphal Details data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      if (data['error'] != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 48.w,
                color: '#ed6f30'.toColor().withValues(alpha: 0.5),
              ),
              Spacing.h(12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AutoTranslateText(
                  data['error'].toString(),
                  textAlign: TextAlign.center,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#6F221E'.toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: _planetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleRow('Varshphal Details', Icons.calendar_today_rounded),
              _buildTableHeader(const ['Field', 'Value']),
              _buildDetailRow('Muntha Sign', data['muntha_sign'], 0),
              _buildDetailRow('Muntha Lord', data['muntha_lord'], 1),
              _buildDetailRow(
                'Varshphal Date',
                data['varshphal_date'] != null
                    ? _formatDate(data['varshphal_date'].toString())
                    : null,
                2,
              ),
              _buildDetailRow('Varsha Lagna', data['varsha_lagna'], 3),
              _buildDetailRow(
                'Varsha Lagna Lord',
                data['varsha_lagna_lord'],
                4,
              ),
              _buildDetailRow('Dinratri Lord', data['dinratri_lord'], 5),
              _buildDetailRow('Trirashi Lord', data['trirashi_lord'], 6),
              _buildDetailRow('Current Ayanamsa', data['current_ayanamsa'], 7),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTableHeader(List<String> labels) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FF8A3D'.toColor(), '#ed6f30'.toColor()],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[0],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              labels[1],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, int index) {
    final text = value?.toString() ?? '--';
    final isEven = index.isEven;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isEven ? '#ed6f30'.toColor().withValues(alpha: 0.04) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: '#ed6f30'.toColor().withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _cell(label, isBold: true)),
          Expanded(flex: 3, child: _cell(text)),
        ],
      ),
    );
  }

  Widget _buildYearlyChartTab() {
    return Obx(() {
      if (controller.isLoadingVarshphalYearlyChart.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.varshphalYearlyChartData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Varshphal Yearly Chart data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      if (data['error'] != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 48.w,
                color: '#ed6f30'.toColor().withValues(alpha: 0.5),
              ),
              Spacing.h(12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AutoTranslateText(
                  data['error'].toString(),
                  textAlign: TextAlign.center,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#6F221E'.toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final zodiacs = data['zodiacs'] as Map<String, dynamic>?;
      final houseNo = zodiacs?['house_no'] as Map<String, dynamic>?;
      final zodiacNo = zodiacs?['zodiac_no'] as Map<String, dynamic>?;
      final varshphalDate = data['varshphal_date']?.toString();

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (varshphalDate != null && varshphalDate.isNotEmpty) ...[
              _planetCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 20.w,
                        color: '#ed6f30'.toColor(),
                      ),
                      Spacing.w(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoTranslateText(
                              'Varshphal Date',
                              style: MyTextTheme.smallBCB.copyWith(
                                color: '#6F221E'.toColor().withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacing.h(2),
                            AutoTranslateText(
                              _formatDate(varshphalDate),
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: '#6F221E'.toColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.h(12),
            ],
            if (houseNo != null && houseNo.isNotEmpty) ...[
              _planetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleRow(
                      'House-wise positions',
                      Icons.home_work_rounded,
                    ),
                    _buildChartTableHeader(const ['House', 'Planets']),
                    ...List.generate(12, (i) {
                      final key = (i + 1).toString();
                      final list = houseNo[key] as List<dynamic>? ?? [];
                      final planetsStr = _formatPlanetList(list);
                      return _buildChartRow(key, planetsStr, i);
                    }),
                  ],
                ),
              ),
              Spacing.h(12),
            ],
            if (zodiacNo != null && zodiacNo.isNotEmpty) ...[
              _planetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleRow(
                      'Zodiac-wise positions',
                      Icons.public_rounded,
                    ),
                    _buildChartTableHeader(const ['Zodiac No', 'Planets']),
                    ...List.generate(12, (i) {
                      final key = (i + 1).toString();
                      final list = zodiacNo[key] as List<dynamic>? ?? [];
                      final planetsStr = _formatPlanetList(list);
                      return _buildChartRow(key, planetsStr, i);
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildChartTableHeader(List<String> labels) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FF8A3D'.toColor(), '#ed6f30'.toColor()],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: AutoTranslateText(
              labels[0],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 4,
            child: AutoTranslateText(
              labels[1],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPlanetList(List<dynamic> list) {
    if (list.isEmpty) return '--';
    return list
        .map((e) {
          final m = e as Map<String, dynamic>;
          final name =
              m['name']?.toString() ?? m['full_name']?.toString() ?? '--';
          final zodiac = m['zodiac']?.toString() ?? '';
          final retro = m['retro'] as bool? ?? false;
          final part = zodiac.isNotEmpty ? '$name ($zodiac)' : name;
          return retro ? '$part R' : part;
        })
        .join(', ');
  }

  Widget _buildChartRow(String key, String planetsStr, int index) {
    final isEven = index.isEven;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isEven ? '#ed6f30'.toColor().withValues(alpha: 0.04) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: '#ed6f30'.toColor().withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: _cell(key, isBold: true)),
          Expanded(flex: 4, child: _cell(planetsStr)),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool isBold = false}) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: '#6F221E'.toColor(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 10.sp,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr == '--' || dateStr.isEmpty) return '--';
    try {
      final date = DateFormat('EEE MMM dd yyyy hh:mm:ss a').parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

