import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FriendshipTableWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const FriendshipTableWidget({
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
      if (controller.isLoadingFriendshipTable.value) {
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
                  'Loading Friendship Table...',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: primaryGradient.colors.first.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final data = controller.friendshipTableData.value;
      if (data == null) {
        return Container(
          decoration: BoxDecoration(
            gradient: gradientBackground,
          ),
          child: Center(
            child: AutoTranslateText(
              'No Friendship Table data available',
              style: MyTextTheme.mediumBCN.copyWith(
                color: primaryGradient.colors.first.withOpacity(0.7),
              ),
            ),
          ),
        );
      }

      final permanentTable = data['permanent_table'] as Map<String, dynamic>? ?? {};
      final temporaryFriendship = data['temporary_friendship'] as Map<String, dynamic>? ?? {};
      final fiveFoldFriendship = data['five_fold_friendship'] as Map<String, dynamic>? ?? {};

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
              if (permanentTable.isNotEmpty) _buildPermanentTable(permanentTable),
              Spacing.h(20),
              if (temporaryFriendship.isNotEmpty) _buildTemporaryFriendshipTable(temporaryFriendship),
              Spacing.h(20),
              if (fiveFoldFriendship.isNotEmpty) _buildFiveFoldFriendshipTable(fiveFoldFriendship),
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
              Icons.people_rounded,
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
                  'Friendship Table',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Planetary relationships',
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

  Widget _buildPermanentTable(Map<String, dynamic> permanentTable) {
    // Prepare table data
    final tableData = <Map<String, dynamic>>[];
    permanentTable.forEach((planet, relationships) {
      final rel = relationships as Map<String, dynamic>? ?? {};
      tableData.add({
        'planet': planet,
        'friends': (rel['Friends'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'neutral': (rel['Neutral'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'enemies': (rel['Enemies'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
      });
    });

    return _buildTableCard(
      title: 'Permanent Table',
      icon: Icons.table_chart_rounded,
      gradient: primaryGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Planet'),
        ),
        DataColumn(
          label: _buildTableHeader('Friends'),
        ),
        DataColumn(
          label: _buildTableHeader('Neutral'),
        ),
        DataColumn(
          label: _buildTableHeader('Enemies'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['planet'] as String, primaryGradient.colors.first)),
            DataCell(_buildTableCell(row['friends'] as String, Colors.green)),
            DataCell(_buildTableCell(row['neutral'] as String, Colors.orange)),
            DataCell(_buildTableCell(row['enemies'] as String, Colors.red)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTemporaryFriendshipTable(Map<String, dynamic> temporaryFriendship) {
    final tableData = <Map<String, dynamic>>[];
    temporaryFriendship.forEach((planet, relationships) {
      final rel = relationships as Map<String, dynamic>? ?? {};
      tableData.add({
        'planet': planet,
        'friends': (rel['Friends'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'enemies': (rel['Enemies'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
      });
    });

    return _buildTableCard(
      title: 'Temporary Friendship',
      icon: Icons.update_rounded,
      gradient: orangeGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Planet'),
        ),
        DataColumn(
          label: _buildTableHeader('Friends'),
        ),
        DataColumn(
          label: _buildTableHeader('Enemies'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['planet'] as String, orangeGradient.colors.first)),
            DataCell(_buildTableCell(row['friends'] as String, Colors.green)),
            DataCell(_buildTableCell(row['enemies'] as String, Colors.red)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFiveFoldFriendshipTable(Map<String, dynamic> fiveFoldFriendship) {
    final tableData = <Map<String, dynamic>>[];
    fiveFoldFriendship.forEach((planet, relationships) {
      final rel = relationships as Map<String, dynamic>? ?? {};
      tableData.add({
        'planet': planet,
        'intimateFriend': (rel['IntimateFriend'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'friends': (rel['Friends'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'neutral': (rel['Neutral'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'enemies': (rel['Enemies'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
        'bitterEnemy': (rel['BitterEnemy'] as List<dynamic>?)?.map((e) => e.toString()).join(', ') ?? '--',
      });
    });

    return _buildTableCard(
      title: 'Five Fold Friendship',
      icon: Icons.layers_rounded,
      gradient: primaryGradient,
      columns: [
        DataColumn(
          label: _buildTableHeader('Planet'),
        ),
        DataColumn(
          label: _buildTableHeader('Intimate Friend'),
        ),
        DataColumn(
          label: _buildTableHeader('Friends'),
        ),
        DataColumn(
          label: _buildTableHeader('Neutral'),
        ),
        DataColumn(
          label: _buildTableHeader('Enemies'),
        ),
        DataColumn(
          label: _buildTableHeader('Bitter Enemy'),
        ),
      ],
      rows: tableData.map((row) {
        return DataRow(
          cells: [
            DataCell(_buildTableCell(row['planet'] as String, primaryGradient.colors.first)),
            DataCell(_buildTableCell(row['intimateFriend'] as String, Colors.purple)),
            DataCell(_buildTableCell(row['friends'] as String, Colors.green)),
            DataCell(_buildTableCell(row['neutral'] as String, Colors.orange)),
            DataCell(_buildTableCell(row['enemies'] as String, Colors.red)),
            DataCell(_buildTableCell(row['bitterEnemy'] as String, Colors.red.shade900)),
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
}
