import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetKpWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const PlanetKpWidget({
    super.key,
    required this.controller,
  });

  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPlanetKp.value) {
        return Container(
          decoration: BoxDecoration(
            gradient: gradientBackground,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(orangeGradient.colors.first),
                ),
                Spacing.h(16),
                AutoTranslateText(
                  'Loading Planet KP...',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: primaryGradient.colors.first.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final data = controller.planetKpData.value;
      if (data == null) {
        return Container(
          decoration: BoxDecoration(
            gradient: gradientBackground,
          ),
          child: Center(
            child: AutoTranslateText(
              'No Planet KP data available',
              style: MyTextTheme.mediumBCN.copyWith(
                color: primaryGradient.colors.first.withOpacity(0.7),
              ),
            ),
          ),
        );
      }

      // Extract planets from data (keys are "0", "1", "2", etc.)
      final planets = <Map<String, dynamic>>[];
      data.forEach((key, value) {
        if (key != 'callsRemaining' && value is Map<String, dynamic>) {
          planets.add(value);
        }
      });

      if (planets.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            gradient: gradientBackground,
          ),
          child: Center(
            child: AutoTranslateText(
              'No planet data available',
              style: MyTextTheme.mediumBCN.copyWith(
                color: primaryGradient.colors.first.withOpacity(0.7),
              ),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(),
              Spacing.h(20),
              _buildMergedPlanetTable(planets),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryGradient.colors.first.withOpacity(0.3),
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
              Icons.auto_awesome_rounded,
              color: const Color(0xFFDFB343),
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Planet KP',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Krishnamurti Paddhati Details',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFFDFB343).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMergedPlanetTable(List<Map<String, dynamic>> planets) {
    // Exclude metadata keys
    final excludedKeys = ['name', 'full_name', 'id', '_id', 'callsRemaining'];
    
    // Collect all unique property keys across all planets
    final allPropertyKeys = <String>{};
    for (final planet in planets) {
      planet.forEach((key, value) {
        if (!excludedKeys.contains(key) && 
            value != null && 
            value is! Map && 
            value is! List) {
          allPropertyKeys.add(key);
        }
      });
    }
    
    // Convert to sorted list for consistent column order
    final sortedPropertyKeys = allPropertyKeys.toList()..sort();
    
    // Build columns: Planet name + all properties
    final columns = <DataColumn>[
      DataColumn(
        label: _buildTableHeader('Planet'),
      ),
      ...sortedPropertyKeys.map((key) => DataColumn(
        label: _buildTableHeader(_formatPropertyName(key)),
      )),
    ];
    
    // Build rows: one row per planet
    final rows = planets.map((planet) {
      final planetName = planet['full_name']?.toString() ?? 
                        planet['name']?.toString() ?? 
                        'Unknown';
      
      // Build cells: planet name + all property values
      final cells = <DataCell>[
        DataCell(_buildTableCell(planetName, primaryGradient.colors.first)),
        ...sortedPropertyKeys.map((key) {
          final value = planet[key];
          final displayValue = (value != null && value is! Map && value is! List) 
              ? value.toString() 
              : '--';
          return DataCell(_buildTableCell(displayValue, orangeGradient.colors.first));
        }),
      ];
      
      return DataRow(cells: cells);
    }).toList();

    return _buildTableCard(
      title: 'All Planets KP Data',
      icon: Icons.table_chart_rounded,
      gradient: orangeGradient,
      columns: columns,
      rows: rows,
    );
  }

  Widget _buildTableCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required List<DataColumn> columns,
    required List<DataRow> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: gradient.colors.first.withOpacity(0.2),
          width: 1.5,
        ),
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
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: gradient,
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
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        title,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        Spacing.h(2),
                        AutoTranslateText(
                          subtitle,
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
          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                gradient.colors.first.withOpacity(0.1),
              ),
              dataRowColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return gradient.colors.first.withOpacity(0.2);
                }
                return null;
              }),
              columns: columns,
              rows: rows,
              dividerThickness: 1,
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: gradient.colors.first.withOpacity(0.1),
                  width: 1,
                ),
                verticalInside: BorderSide(
                  color: gradient.colors.first.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: AutoTranslateText(
        text,
        style: MyTextTheme.smallBCB.copyWith(
          color: primaryGradient.colors.first,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: AutoTranslateText(
        text,
        style: MyTextTheme.smallBCN.copyWith(
          color: color,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatPropertyName(String key) {
    // Convert snake_case to Title Case
    return key
        .split('_')
        .map((word) => word.isEmpty 
            ? '' 
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}










