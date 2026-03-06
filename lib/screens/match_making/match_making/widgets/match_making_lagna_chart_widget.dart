import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays Boy and Girl Lagna charts using Kundli API (chart/d1) with given style.
/// Uses form data from match making; no user input. Language from form; falls back to 'en' if API fails.
class MatchMakingLagnaChartWidget extends StatefulWidget {
  final Map<String, dynamic> formData;
  /// Chart style: 'north', 'south', or 'east'
  final String chartStyle;

  const MatchMakingLagnaChartWidget({
    super.key,
    required this.formData,
    required this.chartStyle,
  });

  @override
  State<MatchMakingLagnaChartWidget> createState() =>
      _MatchMakingLagnaChartWidgetState();
}

class _MatchMakingLagnaChartWidgetState
    extends State<MatchMakingLagnaChartWidget> {
  final KundliService _kundliService = KundliService();
  String? _boySvg;
  String? _girlSvg;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCharts();
  }

  @override
  void didUpdateWidget(MatchMakingLagnaChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chartStyle != widget.chartStyle ||
        oldWidget.formData != widget.formData) {
      _fetchCharts();
    }
  }

  Future<void> _fetchCharts() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
      _boySvg = null;
      _girlSvg = null;
    });

    final form = widget.formData;
    final boyDob = (form['boyDob'] ?? '').toString().replaceAll('-', '/');
    final boyTob = (form['boyTob'] ?? '12:00').toString();
    final boyTz = (form['boyTz'] is num)
        ? (form['boyTz'] as num).toDouble()
        : double.tryParse(form['boyTz']?.toString() ?? '') ?? 5.5;
    final boyLat = (form['boyLat'] is num)
        ? (form['boyLat'] as num).toDouble()
        : double.tryParse(form['boyLat']?.toString() ?? '') ?? 0.0;
    final boyLon = (form['boyLon'] is num)
        ? (form['boyLon'] as num).toDouble()
        : double.tryParse(form['boyLon']?.toString() ?? '') ?? 0.0;

    final girlDob = (form['girlDob'] ?? '').toString().replaceAll('-', '/');
    final girlTob = (form['girlTob'] ?? '12:00').toString();
    final girlTz = (form['girlTz'] is num)
        ? (form['girlTz'] as num).toDouble()
        : double.tryParse(form['girlTz']?.toString() ?? '') ?? 5.5;
    final girlLat = (form['girlLat'] is num)
        ? (form['girlLat'] as num).toDouble()
        : double.tryParse(form['girlLat']?.toString() ?? '') ?? 0.0;
    final girlLon = (form['girlLon'] is num)
        ? (form['girlLon'] as num).toDouble()
        : double.tryParse(form['girlLon']?.toString() ?? '') ?? 0.0;

    String lang = (form['lang'] ?? 'en').toString();
    if (lang.isEmpty) lang = 'en';

    final style = widget.chartStyle.toLowerCase();
    final effectiveStyle = ['north', 'south', 'east'].contains(style)
        ? style
        : 'north';

    try {
      var boyData = await _kundliService.generateKundli(
        date: boyDob,
        time: boyTob,
        latitude: boyLat,
        longitude: boyLon,
        tz: boyTz,
        lang: lang,
        style: effectiveStyle,
      );
      if (boyData == null && lang != 'en') {
        boyData = await _kundliService.generateKundli(
          date: boyDob,
          time: boyTob,
          latitude: boyLat,
          longitude: boyLon,
          tz: boyTz,
          lang: 'en',
          style: effectiveStyle,
        );
      }

      var girlData = await _kundliService.generateKundli(
        date: girlDob,
        time: girlTob,
        latitude: girlLat,
        longitude: girlLon,
        tz: girlTz,
        lang: lang,
        style: effectiveStyle,
      );
      if (girlData == null && lang != 'en') {
        girlData = await _kundliService.generateKundli(
          date: girlDob,
          time: girlTob,
          latitude: girlLat,
          longitude: girlLon,
          tz: girlTz,
          lang: 'en',
          style: effectiveStyle,
        );
      }

      if (!mounted) return;
      setState(() {
        _boySvg = boyData?['data'] as String?;
        _girlSvg = girlData?['data'] as String?;
        _loading = false;
        if (_boySvg == null && _girlSvg == null) {
          _error = 'Could not load charts';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32.w,
              height: 32.w,
              child: CircularProgressIndicator(
                color: "#ed6f30".toColor(),
                strokeWidth: 2,
              ),
            ),
            Spacing.h(12),
            AutoTranslateText(
              'Loading Lagna charts...',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null && _boySvg == null && _girlSvg == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: AutoTranslateText(
            _error!,
            style: MyTextTheme.smallBCN.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final boyName = (widget.formData['boyName'] ?? 'Boy').toString();
    final girlName = (widget.formData['girlName'] ?? 'Girl').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Lagna Charts',
          style: MyTextTheme.largeBCB
              .copyWith(
                  color: '#68171E'.toColor(), fontWeight: FontWeight.bold)
              .merge(AppTypography.h2),
        ),
        Spacing.h(16),
        if (_boySvg != null && _boySvg!.isNotEmpty) ...[
          _buildChartCard(
            title: boyName,
            svgData: _boySvg!,
            isBoy: true,
          ),
          Spacing.h(20),
        ],
        if (_girlSvg != null && _girlSvg!.isNotEmpty)
          _buildChartCard(
            title: girlName,
            svgData: _girlSvg!,
            isBoy: false,
          ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required String svgData,
    required bool isBoy,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: "#ed6f30".toColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  isBoy ? AppConstant.kundliBoy : AppConstant.kundliGirl,
                  width: 36.w,
                  height: 36.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.person,
                    size: 24.w,
                    color: '#68171E'.toColor(),
                  ),
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          LayoutBuilder(
            builder: (context, constraints) {
              final chartSize = (constraints.maxWidth - 20.w).clamp(200.0, 400.w);
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    width: chartSize,
                    height: chartSize,
                    child: SvgPicture.string(
                      svgData,
                      width: chartSize,
                      height: chartSize,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      placeholderBuilder: (_) => Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            color: "#ed6f30".toColor(),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

