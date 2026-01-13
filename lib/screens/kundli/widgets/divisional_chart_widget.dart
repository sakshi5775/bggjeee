import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DivisionalChartWidget extends StatelessWidget {
  final KundliResultController controller;

  const DivisionalChartWidget({
    super.key,
    required this.controller,
  });

  // Available divisional chart types with descriptions
  static const List<Map<String, String>> divisions = [
    {'code': 'D1', 'name': 'D1', 'desc': 'Rashi'},
    {'code': 'D2', 'name': 'D2', 'desc': 'Hora'},
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Title Section
            _buildTitleSection(),
            Spacing.h(20),
            
            // Enhanced Note Card
            _buildNoteCard(),
            Spacing.h(20),
            
            // Enhanced Division Selection
            _buildDivisionSelection(selectedDivision),
            Spacing.h(24),
            
            // Loading indicator or data table
            if (controller.isLoadingDivisionalChart.value)
              _buildLoadingState(selectedDivision)
            else if (selectedDivision != null && data != null)
              _buildDataTable(data, selectedDivision)
            else
              _buildEmptyState(),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
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
              Icons.table_chart_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Divisional Chart',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Select a division to view planetary positions',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
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
        boxShadow: [
          BoxShadow(
            color: "#DFB343".toColor().withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: "#DFB343".toColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: "#DFB343".toColor(),
              size: 24.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'How to use',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Choose a Divisional Chart type from below to fetch and view detailed planetary positions in houses and zodiacs.',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivisionSelection(String? selectedDivision) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Available Divisions',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: divisions.map((division) {
            final code = division['code']!;
            final name = division['name']!;
            final desc = division['desc']!;
            final isSelected = selectedDivision == code;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.fetchDivisionalChartData(code),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
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
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? "#ed6f30".toColor()
                            : "#DFB343".toColor().withOpacity(0.4),
                        width: isSelected ? 2 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: "#ed6f30".toColor().withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoTranslateText(
                          name,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: isSelected ? Colors.white : "#6F221E".toColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          desc,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : "#6F221E".toColor().withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState(String? selectedDivision) {
    return Container(
      padding: EdgeInsets.all(40.w),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: "#ed6f30".toColor(),
            strokeWidth: 3,
          ),
          Spacing.h(20),
          AutoTranslateText(
            'Loading ${selectedDivision ?? 'chart'} data...',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Please wait',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
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
          Icon(
            Icons.table_chart_outlined,
            size: 64.w,
            color: "#6F221E".toColor().withOpacity(0.3),
          ),
          Spacing.h(16),
          AutoTranslateText(
            'No Chart Selected',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Select a division from above to view chart data',
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(Map<String, dynamic> data, String selectedDivision) {
    final houseNo = data['house_no'] as Map<String, dynamic>? ?? {};
    final zodiacNo = data['zodiac_no'] as Map<String, dynamic>? ?? {};
    final divisionInfo = divisions.firstWhere(
      (d) => d['code'] == selectedDivision,
      orElse: () => {'code': selectedDivision, 'name': selectedDivision, 'desc': ''},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Header
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                "#ed6f30".toColor(),
                "#ed6f30".toColor().withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: "#ed6f30".toColor().withOpacity(0.3),
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
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
              Spacing.w(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      '$selectedDivision Chart',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (divisionInfo['desc']?.isNotEmpty ?? false) ...[
                      Spacing.h(4),
                      AutoTranslateText(
                        divisionInfo['desc']!,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacing.h(24),
        
        // House Number Table
        _buildHouseTable(houseNo, 'House Number', Icons.home_outlined),
        Spacing.h(24),
        
        // Zodiac Number Table
        _buildZodiacTable(zodiacNo, 'Zodiac Number', Icons.star_outline),
      ],
    );
  }

  Widget _buildHouseTable(Map<String, dynamic> houseNo, String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: "#6F221E".toColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: "#6F221E".toColor(),
                size: 20.w,
              ),
            ),
            Spacing.w(12),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacing.h(16),
        Container(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;
                final houseColumnWidth = (screenWidth * 0.25).clamp(70.0, 100.0);
                final planetsColumnWidth = (screenWidth * 0.65).clamp(200.0, 350.0);
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.1),
                          width: 1,
                        ),
                        verticalInside: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.1),
                          width: 1,
                        ),
                        top: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                        bottom: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                        left: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                        right: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      columnWidths: {
                        0: FixedColumnWidth(houseColumnWidth),
                        1: FixedColumnWidth(planetsColumnWidth),
                      },
                      children: [
                        // Header row
                        TableRow(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                "#6F221E".toColor().withOpacity(0.15),
                                "#6F221E".toColor().withOpacity(0.1),
                              ],
                            ),
                          ),
                          children: [
                            _buildHeaderCell('House', Icons.home),
                            _buildHeaderCell('Planets', Icons.auto_awesome),
                          ],
                        ),
                        // Data rows for each house (1-12)
                        ...List.generate(12, (houseIndex) {
                          final houseKey = (houseIndex + 1).toString();
                          final planets = houseNo[houseKey] as List<dynamic>? ?? [];
                          
                          return TableRow(
                            decoration: BoxDecoration(
                              color: houseIndex % 2 == 0
                                  ? Colors.white
                                  : "#DFB343".toColor().withOpacity(0.03),
                            ),
                            children: [
                              _buildDataCell('H$houseKey', isHeader: true),
                              _buildPlanetsCell(planets),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZodiacTable(Map<String, dynamic> zodiacNo, String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: "#6F221E".toColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: "#6F221E".toColor(),
                size: 20.w,
              ),
            ),
            Spacing.w(12),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacing.h(16),
        Container(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;
                final zodiacColumnWidth = (screenWidth * 0.25).clamp(70.0, 100.0);
                final planetsColumnWidth = (screenWidth * 0.65).clamp(200.0, 350.0);
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.1),
                          width: 1,
                        ),
                        verticalInside: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.1),
                          width: 1,
                        ),
                        top: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                        bottom: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                        left: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                        right: BorderSide(
                          color: "#6F221E".toColor().withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      columnWidths: {
                        0: FixedColumnWidth(zodiacColumnWidth),
                        1: FixedColumnWidth(planetsColumnWidth),
                      },
                      children: [
                        // Header row
                        TableRow(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                "#6F221E".toColor().withOpacity(0.15),
                                "#6F221E".toColor().withOpacity(0.1),
                              ],
                            ),
                          ),
                          children: [
                            _buildHeaderCell('Zodiac', Icons.star),
                            _buildHeaderCell('Planets', Icons.auto_awesome),
                          ],
                        ),
                        // Data rows for each zodiac (1-12)
                        ...List.generate(12, (zodiacIndex) {
                          final zodiacKey = (zodiacIndex + 1).toString();
                          final planets = zodiacNo[zodiacKey] as List<dynamic>? ?? [];
                          
                          return TableRow(
                            decoration: BoxDecoration(
                              color: zodiacIndex % 2 == 0
                                  ? Colors.white
                                  : "#DFB343".toColor().withOpacity(0.03),
                            ),
                            children: [
                              _buildDataCell('Z$zodiacKey', isHeader: true),
                              _buildPlanetsCell(planets),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: constraints.maxWidth < 100 ? 12.w : 16.w,
                color: "#6F221E".toColor(),
              ),
              SizedBox(width: constraints.maxWidth < 100 ? 4.w : 6.w),
              Flexible(
                child: AutoTranslateText(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: constraints.maxWidth < 100 ? 11.sp : 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDataCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: isHeader
            ? BoxDecoration(
                color: "#6F221E".toColor().withOpacity(0.08),
                borderRadius: BorderRadius.circular(8.r),
              )
            : null,
        child: AutoTranslateText(
          text,
          textAlign: TextAlign.center,
          style: isHeader
              ? MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                )
              : MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor(),
                ),
        ),
      ),
    );
  }

  Widget _buildPlanetsCell(List<dynamic> planets) {
    if (planets.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: "#6F221E".toColor().withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AutoTranslateText(
              'Empty',
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.4),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: planets.map((planet) {
          final planetData = planet as Map<String, dynamic>;
          final name = planetData['name']?.toString() ?? '--';
          final fullName = planetData['full_name']?.toString() ?? '';
          final zodiac = planetData['zodiac']?.toString() ?? '';
          final retro = planetData['retro'] as bool? ?? false;
          
          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = (constraints.maxWidth * 0.45).clamp(80.0, 130.0);
              
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
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
                                color: retro ? "#ed6f30".toColor() : "#6F221E".toColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (retro) ...[
                            SizedBox(width: 3.w),
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
                      if (fullName.isNotEmpty || zodiac.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Flexible(
                          child: AutoTranslateText(
                            fullName.isNotEmpty && zodiac.isNotEmpty
                                ? '$fullName, $zodiac'
                                : fullName.isNotEmpty
                                    ? fullName
                                    : zodiac,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: "#6F221E".toColor().withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
