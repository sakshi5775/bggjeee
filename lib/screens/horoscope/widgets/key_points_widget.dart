import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KeyPointsWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const KeyPointsWidget({
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
      if (controller.isLoadingExtendedKundali.value) {
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
                  'Loading Key Points...',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: primaryGradient.colors.first.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final data = controller.extendedKundaliData.value;
      if (data == null) {
        return Container(
          decoration: BoxDecoration(
            gradient: gradientBackground,
          ),
          child: Center(
            child: AutoTranslateText(
              'No Key Points data available',
              style: MyTextTheme.mediumBCN.copyWith(
                color: primaryGradient.colors.first.withOpacity(0.7),
              ),
            ),
          ),
        );
      }

      // Group all data dynamically
      final groupedData = _groupDataByCategory(data);
      
      return Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              _buildTitleSection(),
              Spacing.h(20),
              
              // Display tables for each category
              if (groupedData['basic'] != null && groupedData['basic']!.isNotEmpty) ...[
                _buildBasicInfoTable(groupedData['basic']!),
                Spacing.h(20),
              ],
              
              if (groupedData['astrological'] != null && groupedData['astrological']!.isNotEmpty) ...[
                _buildAstrologicalTable(groupedData['astrological']!),
                Spacing.h(20),
              ],
              
              if (groupedData['stones'] != null && groupedData['stones']!.isNotEmpty) ...[
                _buildStonesTable(groupedData['stones']!),
                Spacing.h(20),
              ],
              
              // Display any remaining ungrouped data
              if (groupedData['other'] != null && groupedData['other']!.isNotEmpty) ...[
                _buildOtherTable(groupedData['other']!),
              ],
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
              Icons.star_rounded,
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
                  'Key Points',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Extended Kundali Information',
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

  Map<String, Map<String, String>> _groupDataByCategory(Map<String, dynamic> data) {
    final grouped = <String, Map<String, String>>{
      'basic': {},
      'astrological': {},
      'stones': {},
      'other': {},
    };
    
    // Astrological keywords
    final astrologicalKeywords = [
      'sign', 'nakshatra', 'rasi', 'rasi_lord', 'tithi', 'karana', 'yoga',
      'ascendant', 'sun', 'moon', 'planet', 'house', 'lord', 'pada'
    ];
    
    // Stones keywords
    final stonesKeywords = ['stone', 'gem', 'rudraksh'];
    
    // Basic info keywords
    final basicKeywords = ['gana', 'yoni', 'vasya', 'nadi', 'varna', 'paya', 'tatva', 'name'];
    
    data.forEach((key, value) {
      // Skip nested objects and lists
      if (value is Map || value is List) return;
      if (value == null) return;
      
      final lowerKey = key.toLowerCase();
      final formattedKey = _formatPropertyName(key);
      
      // Categorize based on key name
      bool categorized = false;
      
      // Check for astrological
      for (final keyword in astrologicalKeywords) {
        if (lowerKey.contains(keyword)) {
          grouped['astrological']![formattedKey] = value.toString();
          categorized = true;
          break;
        }
      }
      
      // Check for stones
      if (!categorized) {
        for (final keyword in stonesKeywords) {
          if (lowerKey.contains(keyword)) {
            grouped['stones']![formattedKey] = value.toString();
            categorized = true;
            break;
          }
        }
      }
      
      // Check for basic info
      if (!categorized) {
        for (final keyword in basicKeywords) {
          if (lowerKey.contains(keyword)) {
            grouped['basic']![formattedKey] = value.toString();
            categorized = true;
            break;
          }
        }
      }
      
      // If not categorized, add to other
      if (!categorized) {
        grouped['other']![formattedKey] = value.toString();
      }
    });
    
    return grouped;
  }

  Widget _buildBasicInfoTable(Map<String, String> data) {
    if (data.isEmpty) return SizedBox.shrink();
    
    final tableData = data.entries.map((entry) => {
      'property': entry.key,
      'value': entry.value,
    }).toList();

    return _buildTableCard(
      title: 'Basic Information',
      icon: Icons.info_outline_rounded,
      gradient: primaryGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Property'),
        ),
        DataColumn(
          label: _buildTableHeader('Value'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['property'] as String, primaryGradient.colors.first)),
            DataCell(_buildTableCell(row['value'] as String, primaryGradient.colors.first)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAstrologicalTable(Map<String, String> data) {
    if (data.isEmpty) return SizedBox.shrink();
    
    final tableData = data.entries.map((entry) => {
      'property': entry.key,
      'value': entry.value,
    }).toList();

    return _buildTableCard(
      title: 'Astrological Details',
      icon: Icons.auto_awesome_rounded,
      gradient: primaryGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Property'),
        ),
        DataColumn(
          label: _buildTableHeader('Value'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['property'] as String, primaryGradient.colors.first)),
            DataCell(_buildTableCell(row['value'] as String, primaryGradient.colors.first)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStonesTable(Map<String, String> data) {
    if (data.isEmpty) return SizedBox.shrink();
    
    final tableData = data.entries.map((entry) => {
      'property': entry.key,
      'value': entry.value,
    }).toList();

    return _buildTableCard(
      title: 'Stones & Lucky Elements',
      icon: Icons.diamond_rounded,
      gradient: orangeGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Property'),
        ),
        DataColumn(
          label: _buildTableHeader('Value'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['property'] as String, orangeGradient.colors.first)),
            DataCell(_buildTableCell(row['value'] as String, orangeGradient.colors.first)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTableCard({
    required String title,
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
                    color: gradient == primaryGradient ? const Color(0xFFDFB343) : Colors.white,
                    size: 20.w,
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: gradient == primaryGradient ? const Color(0xFFDFB343) : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget _buildOtherTable(Map<String, String> data) {
    if (data.isEmpty) return SizedBox.shrink();
    
    final tableData = data.entries.map((entry) => {
      'property': entry.key,
      'value': entry.value,
    }).toList();

    return _buildTableCard(
      title: 'Other Information',
      icon: Icons.info_outline_rounded,
      gradient: primaryGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Property'),
        ),
        DataColumn(
          label: _buildTableHeader('Value'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['property'] as String, primaryGradient.colors.first)),
            DataCell(_buildTableCell(row['value'] as String, primaryGradient.colors.first)),
          ],
        );
      }).toList(),
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










