import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VarshphalWidget extends StatelessWidget {
  final KundliResultController controller;

  const VarshphalWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // Tab Bar
          _buildTabBar(),
          
          // Tab Content
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
            color: "#6F221E".toColor().withOpacity(0.1),
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
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      "#ed6f30".toColor(),
                      "#ed6f30".toColor().withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : "#6F221E".toColor().withOpacity(0.6),
                size: 20.w,
              ),
              Spacing.w(8),
              Flexible(
                child: AutoTranslateText(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: isSelected ? Colors.white : "#6F221E".toColor().withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDetailsTab() {
    return Obx(() {
      if (controller.isLoadingVarshphalDetails.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Varshphal Details...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.varshphalDetailsData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Varshphal Details data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      // Check for error message
      if (data['error'] != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 64.w,
                color: "#ed6f30".toColor().withOpacity(0.5),
              ),
              Spacing.h(16),
              AutoTranslateText(
                data['error'].toString(),
                textAlign: TextAlign.center,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            _buildTitleSection('Varshphal Details'),
            Spacing.h(20),
            
            // Details Card
            _buildDetailsCard(data),
          ],
        ),
      );
    });
  }

  Widget _buildYearlyChartTab() {
    return Obx(() {
      if (controller.isLoadingVarshphalYearlyChart.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Varshphal Yearly Chart...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.varshphalYearlyChartData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Varshphal Yearly Chart data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      // Check for error message
      if (data['error'] != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 64.w,
                color: "#ed6f30".toColor().withOpacity(0.5),
              ),
              Spacing.h(16),
              AutoTranslateText(
                data['error'].toString(),
                textAlign: TextAlign.center,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            _buildTitleSection('Varshphal Yearly Chart'),
            Spacing.h(20),
            
            // Varshphal Date
            if (data['varshphal_date'] != null) ...[
              _buildDateCard(data['varshphal_date'].toString()),
              Spacing.h(20),
            ],
            
            // Zodiacs Chart
            if (data['zodiacs'] != null) ...[
              _buildZodiacsChart(data['zodiacs'] as Map<String, dynamic>),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#6F221E".toColor(),
            "#6F221E".toColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: "#6F221E".toColor().withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: AutoTranslateText(
              title,
              style: MyTextTheme.largeBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Map<String, dynamic> data) {
    final munthaSign = data['muntha_sign']?.toString() ?? '--';
    final munthaLord = data['muntha_lord']?.toString() ?? '--';
    final varshphalDate = data['varshphal_date']?.toString() ?? '--';
    final varshaLagna = data['varsha_lagna']?.toString() ?? '--';
    final varshaLagnaLord = data['varsha_lagna_lord']?.toString() ?? '--';
    final dinratriLord = data['dinratri_lord']?.toString() ?? '--';
    final trirashiLord = data['trirashi_lord']?.toString() ?? '--';
    final currentAyanamsa = data['current_ayanamsa']?.toString() ?? '--';
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Varshphal Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Muntha Sign', munthaSign),
          _buildDivider(),
          _buildInfoRow('Muntha Lord', munthaLord),
          _buildDivider(),
          _buildInfoRow('Varshphal Date', _formatDate(varshphalDate)),
          _buildDivider(),
          _buildInfoRow('Varsha Lagna', varshaLagna),
          _buildDivider(),
          _buildInfoRow('Varsha Lagna Lord', varshaLagnaLord),
          _buildDivider(),
          _buildInfoRow('Dinratri Lord', dinratriLord),
          _buildDivider(),
          _buildInfoRow('Trirashi Lord', trirashiLord),
          _buildDivider(),
          _buildInfoRow('Current Ayanamsa', currentAyanamsa),
        ],
      ),
    );
  }

  Widget _buildDateCard(String dateStr) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#DFB343".toColor().withOpacity(0.15),
            "#DFB343".toColor().withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#DFB343".toColor().withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: "#DFB343".toColor(),
            size: 24.w,
          ),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Varshphal Date',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  _formatDate(dateStr),
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacsChart(Map<String, dynamic> zodiacs) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.table_chart_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  'Planetary Positions in Zodiacs',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          // Generate zodiac cards for 1-12
          ...List.generate(12, (index) {
            final zodiacKey = (index + 1).toString();
            final planets = zodiacs[zodiacKey] as List<dynamic>? ?? [];
            return Padding(
              padding: EdgeInsets.only(bottom: index < 11 ? 16.h : 0),
              child: _buildZodiacCard(zodiacKey, planets),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildZodiacCard(String zodiacNumber, List<dynamic> planets) {
    final zodiacNames = [
      'Aries', 'Taurus', 'Gemini', 'Cancer',
      'Leo', 'Virgo', 'Libra', 'Scorpio',
      'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
    ];
    final zodiacIndex = int.tryParse(zodiacNumber) ?? 1;
    final zodiacName = zodiacIndex > 0 && zodiacIndex <= 12 
        ? zodiacNames[zodiacIndex - 1] 
        : 'Unknown';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: "#6F221E".toColor().withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#6F221E".toColor().withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  'Zodiac $zodiacNumber',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  zodiacName,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          if (planets.isEmpty)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                'No planets',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.4),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: planets.map((planet) {
                final planetData = planet as Map<String, dynamic>;
                final name = planetData['name']?.toString() ?? '--';
                final retro = planetData['retro'] as bool? ?? false;
                
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: retro
                        ? "#ed6f30".toColor().withOpacity(0.1)
                        : "#6F221E".toColor().withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: retro
                          ? "#ed6f30".toColor().withOpacity(0.3)
                          : "#6F221E".toColor().withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        name,
                        style: MyTextTheme.smallBCB.copyWith(
                          color: retro ? "#ed6f30".toColor() : "#6F221E".toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (retro) ...[
                        Spacing.w(4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: "#ed6f30".toColor(),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: AutoTranslateText(
                            'R',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: "#6F221E".toColor().withOpacity(0.1),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr == '--' || dateStr.isEmpty) return '--';
    try {
      // Try to parse the date string
      // Format: "Fri Oct 10 2025 06:21:10 PM"
      final date = DateFormat('EEE MMM dd yyyy hh:mm:ss a').parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      // If parsing fails, return as is
      return dateStr;
    }
  }
}

