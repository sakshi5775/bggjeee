import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetsWidget extends StatelessWidget {
  /// Controller with [planetDetailsData] (e.g. PlanetsController or KundliResultController).
  final dynamic controller;

  /// When true, only the content column is built (no scroll). Use when embedded
  /// e.g. below Lagna actions slider.
  final bool embedded;

  /// Optional aspects data (from vedic/western/aspects API). Pass when available.
  final Map<String, dynamic>? aspectsData;

  const PlanetsWidget({
    super.key,
    required this.controller,
    this.embedded = false,
    this.aspectsData,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.planetDetailsData.value;
      final isLoading = controller.isLoadingPlanetDetails.value;
      if (data == null) {
        if (embedded && isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
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
                SizedBox(width: 10.w),
                AutoTranslateText(
                  'Loading...',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Padding(
            padding: EdgeInsets.all(embedded ? 24.w : 0),
            child: AutoTranslateText(
              'No data available',
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ),
            ),
          ),
        );
      }

      final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlanetsSection(data),
          Spacing.h(6),
          _buildLuckyThingsSection(data),
          Spacing.h(6),
          _buildBirthDetailsSection(data),
          Spacing.h(6),
          if (data['panchang'] != null) ...[
            _buildPanchangSection(data['panchang'] as Map<String, dynamic>),
            Spacing.h(6),
          ],
          if (data['ghatka_chakra'] != null) ...[
            _buildGhatkaChakraSection(
              data['ghatka_chakra'] as Map<String, dynamic>,
            ),
            Spacing.h(6),
          ],
          _buildDasaSection(data),
          if (aspectsData != null && aspectsData!.isNotEmpty) ...[
            Spacing.h(6),
            _buildAspectsSection(aspectsData!),
          ],
          if (!embedded) Spacing.h(6),
        ],
      );

      if (embedded) {
        return content;
      }
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        child: content,
      );
    });
  }

  Widget _buildPlanetsSection(Map<String, dynamic> data) {
    final planets = <Map<String, dynamic>>[];
    for (int i = 0; i <= 9; i++) {
      final planetKey = i.toString();
      if (data[planetKey] != null) {
        planets.add(data[planetKey] as Map<String, dynamic>);
      }
    }
    if (planets.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: 'Planetary Positions',
      icon: Icons.star_outline_rounded,
      compact: true,
      child: _buildPlanetsTable(planets),
    );
  }

  static const _planetHeaders = [
    'Planet',
    'Zodiac',
    'House',
    'Nakshatra',
    'Nak Lord',
    'Pada',
    'Zod Lord',
    'L°',
    'G°',
    'Prog%',
    'Set',
    'Avastha',
    'Lord St',
    'Combust',
  ];

  Widget _buildPlanetsTable(List<Map<String, dynamic>> planets) {
    final oc = "#ed6f30".toColor();
    final maroon = "#6F221E".toColor();
    final headerStyle = MyTextTheme.smallBCB.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 9.sp,
    );
    final cellStyle = MyTextTheme.smallBCN.copyWith(
      color: maroon,
      fontSize: 9.sp,
    );
    const n = 14;
    final columnWidths = <int, TableColumnWidth>{
      for (int i = 0; i < n; i++) i: FixedColumnWidth(52.w),
    };
    columnWidths[0] = FixedColumnWidth(64.w);  // Planet
    columnWidths[3] = FixedColumnWidth(58.w);  // Nakshatra

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ["#FF8A3D".toColor(), oc],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            children: [
              for (int c = 0; c < n; c++)
                _tableCell(
                  _planetHeaders[c],
                  headerStyle,
                  align: c == 0 ? TextAlign.left : TextAlign.center,
                ),
            ],
          ),
          for (int i = 0; i < planets.length; i++) ...[
            TableRow(
              decoration: BoxDecoration(
                color: i.isOdd ? oc.withOpacity(0.04) : Colors.transparent,
              ),
              children: _planetCells(planets[i], cellStyle),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _planetCells(Map<String, dynamic> p, TextStyle cellStyle) {
    final av = (p['basic_avastha']?.toString() ?? '').trim().isEmpty
        ? '–'
        : (p['basic_avastha']?.toString() ?? '–');
    final ls = (p['lord_status']?.toString() ?? '').trim().isEmpty
        ? '–'
        : (p['lord_status']?.toString() ?? '–');
    final comb = (p['is_combust'] == null || p['is_combust'] == '-')
        ? '–'
        : (p['is_combust']?.toString() ?? '–');

    return [
      _tableCell(
        p['full_name']?.toString() ?? p['name']?.toString() ?? '–',
        cellStyle,
        align: TextAlign.left,
      ),
      _tableCell(p['zodiac']?.toString() ?? '–', cellStyle),
      _tableCell(p['house']?.toString() ?? '–', cellStyle),
      _tableCell(p['nakshatra']?.toString() ?? '–', cellStyle),
      _tableCell(p['nakshatra_lord']?.toString() ?? '–', cellStyle),
      _tableCell(p['nakshatra_pada']?.toString() ?? '–', cellStyle),
      _tableCell(p['zodiac_lord']?.toString() ?? '–', cellStyle),
      _tableCell(_formatDegree(p['local_degree']), cellStyle),
      _tableCell(_formatDegree(p['global_degree']), cellStyle),
      _tableCell('${_formatPercentage(p['progress_in_percentage'])}%', cellStyle),
      _tableCell(p['is_planet_set']?.toString() ?? '–', cellStyle),
      _tableCell(av, cellStyle),
      _tableCell(ls, cellStyle),
      _tableCell(comb, cellStyle),
    ];
  }

  Widget _tableCell(String text, TextStyle style, {TextAlign align = TextAlign.center}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
      child: AutoTranslateText(
        text,
        style: style,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatPercentage(dynamic v) {
    if (v == null) return '–';
    if (v is num) return v.toStringAsFixed(2);
    return v.toString();
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    bool compact = false,
  }) {
    final pad = compact ? 6.w : 10.w;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: "#ed6f30".toColor().withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: compact ? 6.h : 8.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ["#FF8A3D".toColor(), "#ed6f30".toColor()],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: compact ? 14.w : 16.w, color: Colors.white),
                Spacing.w(6),
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 11.sp : 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(pad), child: child),
        ],
      ),
    );
  }

  Widget _buildLuckyThingsSection(Map<String, dynamic> data) {
    final items = <Widget>[];
    if (data['lucky_gem'] != null) items.add(_buildLuckyItem('Lucky Gem', data['lucky_gem']));
    if (data['lucky_num'] != null) items.add(_buildLuckyItem('Lucky Number', data['lucky_num']));
    if (data['lucky_colors'] != null) items.add(_buildLuckyItem('Lucky Colors', data['lucky_colors']));
    if (data['lucky_letters'] != null) items.add(_buildLuckyItem('Lucky Letters', data['lucky_letters']));
    if (data['lucky_name_start'] != null) items.add(_buildLuckyItem('Lucky Name Start', data['lucky_name_start']));
    if (items.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: 'Lucky Things',
      icon: Icons.auto_awesome,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildLuckyItem(String label, dynamic value) {
    final displayValue = value is List ? value.join(', ') : value.toString();
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 9.sp,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              displayValue,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDetailsSection(Map<String, dynamic> data) {
    final items = <Widget>[];
    if (data['rasi'] != null) items.add(_buildDetailRow('Rasi', data['rasi'].toString()));
    if (data['nakshatra'] != null) items.add(_buildDetailRow('Nakshatra', data['nakshatra'].toString()));
    if (data['nakshatra_pada'] != null) items.add(_buildDetailRow('Nakshatra Pada', data['nakshatra_pada'].toString()));
    if (items.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: 'Birth Details',
      icon: Icons.cake_outlined,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildPanchangSection(Map<String, dynamic> panchang) {
    final rows = <Widget>[];
    void add(String k, String v) => rows.add(_buildDetailRow(k, v));
    if (panchang['day_of_birth'] != null) add('Day of Birth', panchang['day_of_birth'].toString());
    if (panchang['day_lord'] != null) add('Day Lord', panchang['day_lord'].toString());
    if (panchang['hora_lord'] != null) add('Hora Lord', panchang['hora_lord'].toString());
    if (panchang['sunrise_at_birth'] != null) add('Sunrise at Birth', panchang['sunrise_at_birth'].toString());
    if (panchang['sunset_at_birth'] != null) add('Sunset at Birth', panchang['sunset_at_birth'].toString());
    if (panchang['karana'] != null) add('Karana', panchang['karana'].toString());
    if (panchang['yoga'] != null) add('Yoga', panchang['yoga'].toString());
    if (panchang['tithi'] != null) add('Tithi', panchang['tithi'].toString());
    if (panchang['ayanamsa'] != null) add('Ayanamsa', panchang['ayanamsa'].toString());
    if (panchang['ayanamsa_name'] != null) add('Ayanamsa Name', panchang['ayanamsa_name'].toString());
    if (rows.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: 'Panchang',
      icon: Icons.nightlight_round,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  Widget _buildGhatkaChakraSection(Map<String, dynamic> ghatkaChakra) {
    final rows = <Widget>[];
    void add(String k, String v) => rows.add(_buildDetailRow(k, v));
    if (ghatkaChakra['rasi'] != null) add('Rasi', ghatkaChakra['rasi'].toString());
    if (ghatkaChakra['tithi'] != null) {
      final t = ghatkaChakra['tithi'];
      add('Tithi', t is List ? t.join(', ') : t.toString());
    }
    if (ghatkaChakra['day'] != null) add('Day', ghatkaChakra['day'].toString());
    if (ghatkaChakra['nakshatra'] != null) add('Nakshatra', ghatkaChakra['nakshatra'].toString());
    if (ghatkaChakra['tatva'] != null) add('Tatva', ghatkaChakra['tatva'].toString());
    if (ghatkaChakra['lord'] != null) add('Lord', ghatkaChakra['lord'].toString());
    if (ghatkaChakra['same_sex_lagna'] != null) add('Same Sex Lagna', ghatkaChakra['same_sex_lagna'].toString());
    if (ghatkaChakra['opposite_sex_lagna'] != null) add('Opposite Sex Lagna', ghatkaChakra['opposite_sex_lagna'].toString());
    if (rows.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: 'Ghatka Chakra',
      icon: Icons.grain,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  Widget _buildAspectsSection(Map<String, dynamic> aspectsData) {
    final aspectTypes = ['conjunction', 'opposition', 'trine', 'square', 'sextile', 'quincunx', 'semi-square', 'quintile', 'semi-sextile'];
    final rows = <Widget>[];
    for (final type in aspectTypes) {
      final list = aspectsData[type] as List<dynamic>?;
      if (list == null || list.isEmpty) continue;
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final planetOne = m['planet_one']?.toString() ?? '';
        final planetTwo = m['planet_two']?.toString() ?? '';
        final orb = m['orb'];
        final aspect = m['aspect']?.toString() ?? type;
        final orbStr = orb != null ? (orb is num ? orb.toStringAsFixed(2) : orb.toString()) : '-';
        rows.add(_buildDetailRow('$planetOne ↔ $planetTwo', '$aspect (orb: $orbStr°)'));
      }
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return _sectionCard(
      title: 'Aspects',
      icon: Icons.linear_scale,
      compact: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
    );
  }

  Widget _buildDasaSection(Map<String, dynamic> data) {
    final rows = <Widget>[];
    if (data['birth_dasa'] != null) rows.add(_buildDetailRow('Birth Dasa', data['birth_dasa'].toString()));
    if (data['current_dasa'] != null) rows.add(_buildDetailRow('Current Dasa', data['current_dasa'].toString()));
    if (data['birth_dasa_time'] != null) rows.add(_buildDetailRow('Birth Dasa Time', data['birth_dasa_time'].toString()));
    if (data['current_dasa_time'] != null) rows.add(_buildDetailRow('Current Dasa Time', data['current_dasa_time'].toString()));
    if (rows.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: 'Dasa',
      icon: Icons.schedule,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 9.sp,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDegree(dynamic degree) {
    if (degree == null) return '-';
    if (degree is num) {
      return degree.toStringAsFixed(2);
    }
    return degree.toString();
  }
}
