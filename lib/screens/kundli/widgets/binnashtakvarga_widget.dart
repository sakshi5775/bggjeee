import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BinnashtakvargaWidget extends StatelessWidget {
  final KundliResultController controller;

  const BinnashtakvargaWidget({
    super.key,
    required this.controller,
  });

  // Available planets
  static const List<String> planets = [
    'Sun',
    'Moon',
    'Mars',
    'Mercury',
    'Jupiter',
    'Venus',
    'Saturn',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Binnashtakvarga',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Spacing.h(16),
            
            // Note Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: "#DFB343".toColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: "#DFB343".toColor().withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: "#DFB343".toColor(),
                    size: 24.w,
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      'Choose a planet to fetch its Binnashtakvarga information',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Spacing.h(20),
            
            // Planet Selection Grid
            AutoTranslateText(
              'Select Planet',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Spacing.h(12),
            
            // Planet Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: planets.length,
                  itemBuilder: (context, index) {
                    final planet = planets[index];
                    final isSelected = controller.selectedPlanetForBinnashtakvarga.value == planet;
                    final isLoading = controller.isLoadingBinnashtakvarga.value && isSelected;
                    
                    return GestureDetector(
                      onTap: isLoading ? null : () {
                        controller.fetchBinnashtakvargaData(planet);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? "#ed6f30".toColor()
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? "#ed6f30".toColor()
                                : "#DFB343".toColor().withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
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
                            if (isLoading)
                              SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                Icons.star,
                                color: isSelected 
                                    ? Colors.white
                                    : "#DFB343".toColor(),
                                size: 32.w,
                              ),
                            Spacing.h(8),
                            AutoTranslateText(
                              planet,
                              textAlign: TextAlign.center,
                              style: MyTextTheme.smallBCB.copyWith(
                                color: isSelected 
                                    ? Colors.white
                                    : "#6F221E".toColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            
            Spacing.h(24),
            
            // Data Display
            if (controller.isLoadingBinnashtakvarga.value && controller.selectedPlanetForBinnashtakvarga.value != null)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: "#ed6f30".toColor(),
                    ),
                    Spacing.h(16),
                    AutoTranslateText(
                      'Loading Binnashtakvarga data for ${controller.selectedPlanetForBinnashtakvarga.value}...',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
            else if (controller.binnashtakvargaData.value != null)
              _buildDataTable(controller.binnashtakvargaData.value!),
          ],
        ),
      );
    });
  }

  Widget _buildDataTable(Map<String, dynamic> data) {
    // Get all planet data
    final planetKeys = ['sun', 'moon', 'mars', 'mercury', 'jupiter', 'venus', 'saturn'];
    final ascendant = data['ascendant'] as List<dynamic>?;
    final total = data['Total'] as List<dynamic>?;
    
    return Container(
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
          // Selected Planet Info
          if (controller.selectedPlanetForBinnashtakvarga.value != null) ...[
            AutoTranslateText(
              'Binnashtakvarga for ${controller.selectedPlanetForBinnashtakvarga.value}',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(16),
          ],
          
          // Table
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _buildTableContent(planetKeys, data, ascendant, total),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(
    List<String> planetKeys,
    Map<String, dynamic> data,
    List<dynamic>? ascendant,
    List<dynamic>? total,
  ) {
    return Table(
      border: TableBorder.all(
        color: "#6F221E".toColor().withOpacity(0.2),
        width: 1,
      ),
      columnWidths: {
        0: FixedColumnWidth(80.w), // House column
        for (int i = 1; i <= planetKeys.length; i++)
          i: FixedColumnWidth(60.w), // Planet columns
        planetKeys.length + 1: FixedColumnWidth(60.w), // Ascendant column
        planetKeys.length + 2: FixedColumnWidth(70.w), // Total column
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: "#6F221E".toColor().withOpacity(0.1),
          ),
          children: [
            _buildHeaderCell('House'),
            for (String planet in planetKeys)
              _buildHeaderCell(planet.substring(0, 1).toUpperCase() + planet.substring(1)),
            _buildHeaderCell('Asc'),
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
              for (String planetKey in planetKeys)
                _buildDataCell(
                  _getPointForHouse(planetKey, houseIndex, data),
                ),
              // Ascendant point
              _buildDataCell(
                _getPointForHouse('ascendant', houseIndex, data, ascendant: ascendant),
              ),
              // Total for this house
              _buildTotalCell(
                houseIndex < (total?.length ?? 0)
                    ? total![houseIndex]?.toString() ?? '--'
                    : '--',
              ),
            ],
          );
        }),
      ],
    );
  }

  String _getPointForHouse(String planetKey, int houseIndex, Map<String, dynamic> data, {List<dynamic>? ascendant}) {
    if (planetKey == 'ascendant') {
      if (ascendant != null && houseIndex < ascendant.length) {
        return ascendant[houseIndex]?.toString() ?? '--';
      }
      return '--';
    }
    
    final planetData = data[planetKey] as List<dynamic>?;
    if (planetData != null && houseIndex < planetData.length) {
      return planetData[houseIndex]?.toString() ?? '--';
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

