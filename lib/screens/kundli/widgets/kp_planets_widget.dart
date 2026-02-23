import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// KP Planet Details – compact table (planet-details API: planets + ascendant, all fields).
class KpPlanetsWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpPlanetsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKpPlanetDetails.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.kpPlanetDetailsData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final planets = response['planets'] as List<dynamic>? ?? [];
      final ascendant = response['ascendant'] as Map<String, dynamic>?;

      final rows = <Map<String, dynamic>>[];
      if (ascendant != null) {
        rows.add({'name': ascendant['name'] ?? 'Ascendant', ...ascendant});
      }
      for (final p in planets) {
        rows.add(p as Map<String, dynamic>);
      }
      if (rows.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 900.w, maxWidth: 900.w),
            child: _planetCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitleRow('KP Planet Details', Icons.public_rounded),
                  _buildTableHeader(const [
                    'Planet',
                    'Longitude',
                    'Longitude DMS',
                    'Latitude',
                    'Distance',
                    'Speed',
                    'Sidereal Long.',
                    'Sign',
                    'Sign Lord',
                    'Nakshatra',
                    'Nakshatra Lord',
                    'Sub Lord',
                    'Sub Sub Lord',
                  ]),
                  ...rows.asMap().entries.map(
                    (e) => _buildTableRow(e.value, e.key),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _planetCard({required Widget child}) {
    return Container(
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

  static const List<int> _headerFlex = [2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

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
        children: List.generate(labels.length, (i) {
          final flex = i < _headerFlex.length ? _headerFlex[i] : 1;
          return Expanded(
            flex: flex,
            child: AutoTranslateText(
              labels[i],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }

  String _fmt(dynamic v) {
    if (v == null) return '--';
    if (v is num) return v is double ? v.toStringAsFixed(2) : v.toString();
    return v.toString();
  }

  Widget _buildTableRow(Map<String, dynamic> row, int index) {
    final name = row['name'] as String? ?? '--';
    final longitude = _fmt(row['longitude']);
    final longitudeDms = row['longitude_dms']?.toString() ?? '--';
    final latitude = row['latitude'] != null ? _fmt(row['latitude']) : '--';
    final distance = row['distance'] != null ? _fmt(row['distance']) : '--';
    final speed = row['speed'] != null ? _fmt(row['speed']) : '--';
    final sidereal = row['siderealLongitude'] != null
        ? _fmt(row['siderealLongitude'])
        : '--';
    final sign = row['sign']?.toString() ?? '--';
    final signLord = row['signLord']?.toString() ?? '--';
    final nakshatra = row['nakshatra']?.toString() ?? '--';
    final nakshatraLord = row['nakshatraLord']?.toString() ?? '--';
    final subLord = row['subLord']?.toString() ?? '--';
    final subSubLord = row['subSubLord']?.toString() ?? '--';

    final isEven = index.isEven;
    final cells = [
      name,
      longitude,
      longitudeDms,
      latitude,
      distance,
      speed,
      sidereal,
      sign,
      signLord,
      nakshatra,
      nakshatraLord,
      subLord,
      subSubLord,
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isEven
            ? '#ed6f30'.toColor().withValues(alpha: 0.04)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: '#ed6f30'.toColor().withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(cells.length, (i) {
          final flex = i < _headerFlex.length ? _headerFlex[i] : 1;
          return Expanded(
            flex: flex,
            child: _cell(cells[i], isBold: i == 0),
          );
        }),
      ),
    );
  }

  Widget _cell(String text, {bool isBold = false}) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: '#6F221E'.toColor(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 9.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
