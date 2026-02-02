import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Planet KP (extended-horoscope/planet-kp) – same design as KundliHeader (#6F221E / #ed6f30), table with all API fields.
class PlanetKpWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const PlanetKpWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPlanetKp.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.planetKpData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Planet KP data available',
            style: MyTextTheme.mediumBCN
                .copyWith(color: '#6F221E'.toColor().withOpacity(0.6)),
          ),
        );
      }

      final planets = <Map<String, dynamic>>[];
      data.forEach((key, value) {
        if (key != 'callsRemaining' && value is Map<String, dynamic>) {
          planets.add(value);
        }
      });

      if (planets.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No planet data available',
            style: MyTextTheme.mediumBCN
                .copyWith(color: '#6F221E'.toColor().withOpacity(0.6)),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 1000.w, maxWidth: 1000.w),
            child: _planetCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitleRow('Planet KP', Icons.auto_awesome_rounded),
                  _buildTableHeader(const [
                    'Planet',
                    'Local Deg',
                    'Local DMS',
                    'Global Deg',
                    'Global DMS',
                    'Rasi No',
                    'Zodiac',
                    'House',
                    'Pseudo Nakshatra',
                    'Nakshatra Lord',
                    'Pada',
                    'Nakshatra No',
                    'Pseudo Rasi',
                    'Rasi No',
                    'Rasi Lord',
                    'Sub Lord',
                    'Sub Sub Lord',
                  ]),
                  ...planets.asMap().entries.map((e) => _buildTableRow(e.value, e.key)),
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
        border: Border.all(color: '#ed6f30'.toColor().withOpacity(0.2), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildTitleRow(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: '#ed6f30'.toColor().withOpacity(0.08),
        border: Border(
          bottom:
              BorderSide(color: '#ed6f30'.toColor().withOpacity(0.25), width: 1),
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

  static const List<int> _headerFlex = [
    2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  ];

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
                fontSize: 8.sp,
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
    final name = row['full_name']?.toString() ?? row['name']?.toString() ?? '--';
    final localDeg = row['local_degree'] != null ? _fmt(row['local_degree']) : '--';
    final localDms = row['local_degree_dms']?.toString() ?? '--';
    final globalDeg = row['global_degree'] != null ? _fmt(row['global_degree']) : '--';
    final globalDms = row['global_degree_dms']?.toString() ?? '--';
    final rasiNo = row['rasi_no']?.toString() ?? '--';
    final zodiac = row['zodiac']?.toString() ?? '--';
    final house = row['house']?.toString() ?? '--';
    final pseudoNakshatra = row['pseudo_nakshatra']?.toString() ?? '--';
    final nakshatraLord = row['pseudo_nakshatra_lord']?.toString() ?? '--';
    final pada = row['pseudo_nakshatra_pada']?.toString() ?? '--';
    final nakshatraNo = row['pseudo_nakshatra_no']?.toString() ?? '--';
    final pseudoRasi = row['pseudo_rasi']?.toString() ?? '--';
    final pseudoRasiNo = row['pseudo_rasi_no']?.toString() ?? '--';
    final rasiLord = row['pseudo_rasi_lord']?.toString() ?? '--';
    final subLord = row['sub_lord']?.toString() ?? '--';
    final subSubLord = row['sub_sub_lord']?.toString() ?? '--';

    final isEven = index.isEven;
    final cells = [
      name,
      localDeg,
      localDms,
      globalDeg,
      globalDms,
      rasiNo,
      zodiac,
      house,
      pseudoNakshatra,
      nakshatraLord,
      pada,
      nakshatraNo,
      pseudoRasi,
      pseudoRasiNo,
      rasiLord,
      subLord,
      subSubLord,
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isEven ? '#ed6f30'.toColor().withOpacity(0.04) : Colors.white,
        border: Border(
          bottom: BorderSide(
              color: '#ed6f30'.toColor().withOpacity(0.12), width: 1),
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
        fontSize: 8.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
