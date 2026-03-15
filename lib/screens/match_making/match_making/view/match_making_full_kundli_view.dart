import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MatchMakingFullKundliView extends StatelessWidget {
  const MatchMakingFullKundliView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // endDrawer: const CommonEndDrawer(),
          body: Center(
            child: AutoTranslateText(
              'No data available',
              style: MyTextTheme.mediumBCB.copyWith(color: "#6F221E".toColor()),
            ),
          ),
        ),
      );
    }

    final isBoy = args['isBoy'] as bool? ?? true;
    final astroDetails = args['astroDetails'] as Map<String, dynamic>? ?? {};
    final planetaryDetails =
        args['planetaryDetails'] as Map<String, dynamic>? ?? {};
    final formData = args['formData'] as Map<String, dynamic>?;
    final chartStyle =
        (args['chartStyle'] as String?)?.toLowerCase() ?? 'north';

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(title: '${isBoy ? 'Boy' : 'Girl'} Full Kundli'),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lagna chart from API when formData available (North/South/East)
                    if (formData != null && formData.isNotEmpty)
                      FullKundliLagnaChart(
                        formData: formData,
                        isBoy: isBoy,
                        chartStyle: chartStyle,
                      )
                    else if (planetaryDetails.isNotEmpty)
                      _buildSingleKundliChart(
                        planetaryDetails: planetaryDetails,
                        astroDetails: astroDetails,
                        isBoy: isBoy,
                      ),

                    Spacing.h(20),

                    _buildAstroDetailsSection(astroDetails),

                    Spacing.h(20),

                    if (planetaryDetails.isNotEmpty)
                      _buildPlanetaryDetailsSection(planetaryDetails),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstroDetailsSection(Map<String, dynamic> astroDetails) {
    if (astroDetails.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#DFB343".toColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Astrological Details',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          _buildDetailRow('Gana', astroDetails['gana'] as String?),
          _buildDetailRow('Yoni', astroDetails['yoni'] as String?),
          _buildDetailRow('Vasya', astroDetails['vasya'] as String?),
          _buildDetailRow('Nadi', astroDetails['nadi'] as String?),
          _buildDetailRow('Varna', astroDetails['varna'] as String?),
          _buildDetailRow('Paya', astroDetails['paya'] as String?),
          _buildDetailRow('Tatva', astroDetails['tatva'] as String?),
          _buildDetailRow('Birth Dasa', astroDetails['birth_dasa'] as String?),
          _buildDetailRow(
            'Current Dasa',
            astroDetails['current_dasa'] as String?,
          ),
          _buildDetailRow(
            'Birth Dasa Time',
            astroDetails['birth_dasa_time'] as String?,
          ),
          _buildDetailRow(
            'Current Dasa Time',
            astroDetails['current_dasa_time'] as String?,
          ),
          _buildDetailRow('Rasi', astroDetails['rasi'] as String?),
          _buildDetailRow('Nakshatra', astroDetails['nakshatra'] as String?),
          _buildDetailRow(
            'Nakshatra Pada',
            astroDetails['nakshatra_pada']?.toString(),
          ),
          _buildDetailRow(
            'Ascendant Sign',
            astroDetails['ascendant_sign'] as String?,
          ),
          if (astroDetails['lucky_gem'] != null)
            _buildListRow(
              'Lucky Gem',
              astroDetails['lucky_gem'] as List<dynamic>?,
            ),
          if (astroDetails['lucky_num'] != null)
            _buildListRow(
              'Lucky Number',
              astroDetails['lucky_num'] as List<dynamic>?,
            ),
          if (astroDetails['lucky_colors'] != null)
            _buildListRow(
              'Lucky Colors',
              astroDetails['lucky_colors'] as List<dynamic>?,
            ),
          if (astroDetails['lucky_letters'] != null)
            _buildListRow(
              'Lucky Letters',
              astroDetails['lucky_letters'] as List<dynamic>?,
            ),
          if (astroDetails['lucky_name_start'] != null)
            _buildListRow(
              'Lucky Name Start',
              astroDetails['lucky_name_start'] as List<dynamic>?,
            ),
        ],
      ),
    );
  }

  Widget _buildPlanetaryDetailsSection(Map<String, dynamic> planetaryDetails) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#DFB343".toColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Planetary Details',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          ...planetaryDetails.entries.map((entry) {
            final planetData = entry.value as Map<String, dynamic>?;
            if (planetData == null) return const SizedBox.shrink();

            final planetName =
                planetData['full_name'] as String? ??
                planetData['name'] as String? ??
                'Unknown';
            return _buildPlanetCard(planetName, planetData);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPlanetCard(String planetName, Map<String, dynamic> planetData) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3E6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: "#DFB343".toColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            planetName,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          _buildDetailRow(
            'Local Degree',
            planetData['local_degree']?.toString(),
          ),
          _buildDetailRow(
            'Global Degree',
            planetData['global_degree']?.toString(),
          ),
          _buildDetailRow('House', planetData['house']?.toString()),
          _buildDetailRow('Zodiac', planetData['zodiac'] as String?),
          _buildDetailRow('Nakshatra', planetData['nakshatra'] as String?),
          _buildDetailRow(
            'Nakshatra Lord',
            planetData['nakshatra_lord'] as String?,
          ),
          _buildDetailRow(
            'Nakshatra Pada',
            planetData['nakshatra_pada']?.toString(),
          ),
          _buildDetailRow('Zodiac Lord', planetData['zodiac_lord'] as String?),
          if (planetData['retro'] != null)
            _buildDetailRow(
              'Retrograde',
              planetData['retro'] == true ? 'Yes' : 'No',
            ),
          if (planetData['is_combust'] != null)
            _buildDetailRow(
              'Combust',
              planetData['is_combust'] == true ? 'Yes' : 'No',
            ),
          if (planetData['basic_avastha'] != null &&
              planetData['basic_avastha'] != '-')
            _buildDetailRow(
              'Basic Avastha',
              planetData['basic_avastha'] as String?,
            ),
          if (planetData['lord_status'] != null &&
              planetData['lord_status'] != '-')
            _buildDetailRow(
              'Lord Status',
              planetData['lord_status'] as String?,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: AutoTranslateText(
              '$label:',
              style: MyTextTheme.smallBCB
                  .copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body2),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN
                  .copyWith(color: "#6F221E".toColor())
                  .merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String label, List<dynamic>? values) {
    if (values == null || values.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: AutoTranslateText(
              '$label:',
              style: MyTextTheme.smallBCB
                  .copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body2),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              values.map((e) => e.toString()).join(', '),
              style: MyTextTheme.smallBCN
                  .copyWith(color: "#6F221E".toColor())
                  .merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleKundliChart({
    required Map<String, dynamic> planetaryDetails,
    Map<String, dynamic>? astroDetails,
    required bool isBoy,
  }) {
    // Extract planets and organize by house
    final houses = <int, List<_PlanetData>>{};

    for (int i = 0; i <= 9; i++) {
      final planetKey = i.toString();
      final planetData = planetaryDetails[planetKey] as Map<String, dynamic>?;
      if (planetData != null) {
        final house = planetData['house'] as int?;
        if (house != null && house >= 1 && house <= 12) {
          final localDegree = (planetData['local_degree'] as num? ?? 0)
              .toDouble();
          final name = planetData['name'] as String? ?? '';
          final fullName = planetData['full_name'] as String? ?? '';
          final retro = planetData['retro'] as bool? ?? false;
          final isCombust = planetData['is_combust'] as bool? ?? false;
          final isAscendant = i == 0;

          houses
              .putIfAbsent(house, () => [])
              .add(
                _PlanetData(
                  name: name,
                  fullName: fullName,
                  localDegree: localDegree,
                  retro: retro,
                  isCombust: isCombust,
                  isAscendant: isAscendant,
                ),
              );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Kundli Chart',
          style: MyTextTheme.largeBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(16),
        Container(
          margin: EdgeInsets.only(bottom: 20.h),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth > 0
                    ? constraints.maxWidth
                    : 350.w;
                final chartSize = math.min(maxWidth - 32.w, 400.w);

                return SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Base Kundli Image
                      Center(
                        child: Image.asset(
                          'assets/app/Kundli-Image.png',
                          width: chartSize,
                          height: chartSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: chartSize,
                              height: chartSize,
                              color: Colors.grey.withValues(alpha: 0.1),
                              child: Center(
                                child: AutoTranslateText(
                                  'Kundli Image',
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Profile image overlay
                      Positioned(
                        left: isBoy ? null : 8.w,
                        right: isBoy ? 8.w : null,
                        top: 8.h,
                        child: NetworkImageWithLoader(
                          url: isBoy
                              ? AppConstant.kundliBoy
                              : AppConstant.kundliGirl,
                          width: 50.w,
                          height: 50.w,
                          isCircular: true,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Place planets
                      ..._buildPlanetPlacements(houses, chartSize),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPlanetPlacements(
    Map<int, List<_PlanetData>> houses,
    double size,
  ) {
    final widgets = <Widget>[];
    final housePositions = _getHousePositions(size);

    houses.forEach((house, planets) {
      final position = housePositions[house];
      if (position == null) return;

      final houseCenterX = position['x']!;
      final houseCenterY = position['y']!;
      final planetCount = planets.length;
      final spacing = 35.w;

      for (int i = 0; i < planets.length; i++) {
        final planet = planets[i];
        double offsetX = 0;
        double offsetY = 0;

        if (planetCount == 1) {
          offsetX = 0;
          offsetY = 0;
        } else if (planetCount == 2) {
          offsetX = (i == 0 ? -spacing / 2 : spacing / 2);
          offsetY = 0;
        } else {
          final sqrtValue = math.sqrt(planetCount);
          final cols = sqrtValue.ceil().toInt();
          final row = i ~/ cols;
          final col = i % cols;
          offsetX = (col - (cols - 1) / 2) * spacing * 0.7;
          offsetY = (row - (planetCount / cols - 1) / 2) * spacing * 0.6;
        }

        widgets.add(
          Positioned(
            left: houseCenterX - 20.w + offsetX,
            top: houseCenterY - 15.h + offsetY,
            child: _buildPlanetWidget(planet),
          ),
        );
      }
    });

    return widgets;
  }

  Map<int, Map<String, double>> _getHousePositions(double size) {
    final center = size / 2;
    final outerRadius = size * 0.32;
    final innerRadius = size * 0.15;

    return {
      1: {
        'x': center + outerRadius * math.cos(270 * math.pi / 180),
        'y': center + outerRadius * math.sin(270 * math.pi / 180),
      },
      2: {
        'x': center + outerRadius * math.cos(300 * math.pi / 180),
        'y': center + outerRadius * math.sin(300 * math.pi / 180),
      },
      3: {
        'x': center + outerRadius * math.cos(330 * math.pi / 180),
        'y': center + outerRadius * math.sin(330 * math.pi / 180),
      },
      4: {
        'x': center + outerRadius * math.cos(0 * math.pi / 180),
        'y': center + outerRadius * math.sin(0 * math.pi / 180),
      },
      5: {
        'x': center + outerRadius * math.cos(30 * math.pi / 180),
        'y': center + outerRadius * math.sin(30 * math.pi / 180),
      },
      6: {
        'x': center + outerRadius * math.cos(60 * math.pi / 180),
        'y': center + outerRadius * math.sin(60 * math.pi / 180),
      },
      7: {
        'x': center + outerRadius * math.cos(90 * math.pi / 180),
        'y': center + outerRadius * math.sin(90 * math.pi / 180),
      },
      8: {
        'x': center + outerRadius * math.cos(120 * math.pi / 180),
        'y': center + outerRadius * math.sin(120 * math.pi / 180),
      },
      9: {
        'x': center + innerRadius * math.cos(180 * math.pi / 180),
        'y': center + innerRadius * math.sin(180 * math.pi / 180),
      },
      10: {
        'x': center + innerRadius * math.cos(270 * math.pi / 180),
        'y': center + innerRadius * math.sin(270 * math.pi / 180),
      },
      11: {
        'x': center + innerRadius * math.cos(0 * math.pi / 180),
        'y': center + innerRadius * math.sin(0 * math.pi / 180),
      },
      12: {
        'x': center + innerRadius * math.cos(90 * math.pi / 180),
        'y': center + innerRadius * math.sin(90 * math.pi / 180),
      },
    };
  }

  Widget _buildPlanetWidget(_PlanetData planet) {
    final degreeText = planet.localDegree.round().toString();
    final planetSymbol = _getPlanetSymbol(
      planet.name,
      planet.retro,
      planet.isCombust,
      planet.isAscendant,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoTranslateText(
            '$degreeText°',
            style: TextStyle(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w500,
              height: 1.0,
            ).merge(AppTypography.label),
          ),
          AutoTranslateText(
            planetSymbol,
            style: TextStyle(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
              height: 1.0,
            ).merge(AppTypography.label),
          ),
        ],
      ),
    );
  }

  String _getPlanetSymbol(
    String name,
    bool retro,
    bool isCombust,
    bool isAscendant,
  ) {
    final symbols = {
      'As': 'La',
      'Su': 'Su',
      'Mo': 'Mo',
      'Ma': 'Ma',
      'Me': 'Me',
      'Ju': 'Ju',
      'Ve': 'Ve',
      'Sa': 'Sa',
      'Ra': 'Ra',
      'Ke': 'Ke',
    };

    var symbol = symbols[name] ?? name;
    if (retro) symbol += '*';
    if (isCombust) symbol += '^';

    return symbol;
  }
}

/// Fetches and displays Lagna chart from Kundli API for one person (boy or girl).
class FullKundliLagnaChart extends StatefulWidget {
  final Map<String, dynamic> formData;
  final bool isBoy;
  final String chartStyle;

  const FullKundliLagnaChart({
    super.key,
    required this.formData,
    required this.isBoy,
    this.chartStyle = 'north',
  });

  @override
  State<FullKundliLagnaChart> createState() => _FullKundliLagnaChartState();
}

class _FullKundliLagnaChartState extends State<FullKundliLagnaChart> {
  final KundliService _kundliService = KundliService();
  String? _svg;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchChart();
  }

  Future<void> _fetchChart() async {
    final form = widget.formData;
    final dob = (widget.isBoy ? form['boyDob'] : form['girlDob'] ?? '')
        .toString()
        .replaceAll('-', '/');
    final tob = (widget.isBoy ? form['boyTob'] : form['girlTob'] ?? '12:00')
        .toString();
    final tz = (form[widget.isBoy ? 'boyTz' : 'girlTz'] is num)
        ? (form[widget.isBoy ? 'boyTz' : 'girlTz'] as num).toDouble()
        : double.tryParse(
                form[widget.isBoy ? 'boyTz' : 'girlTz']?.toString() ?? '',
              ) ??
              5.5;
    final lat = (form[widget.isBoy ? 'boyLat' : 'girlLat'] is num)
        ? (form[widget.isBoy ? 'boyLat' : 'girlLat'] as num).toDouble()
        : double.tryParse(
                form[widget.isBoy ? 'boyLat' : 'girlLat']?.toString() ?? '',
              ) ??
              0.0;
    final lon = (form[widget.isBoy ? 'boyLon' : 'girlLon'] is num)
        ? (form[widget.isBoy ? 'boyLon' : 'girlLon'] as num).toDouble()
        : double.tryParse(
                form[widget.isBoy ? 'boyLon' : 'girlLon']?.toString() ?? '',
              ) ??
              0.0;
    String lang = (form['lang'] ?? 'en').toString();
    if (lang.isEmpty) lang = 'en';
    final style =
        ['north', 'south', 'east'].contains(widget.chartStyle.toLowerCase())
        ? widget.chartStyle.toLowerCase()
        : 'north';

    try {
      var data = await _kundliService.generateKundli(
        date: dob,
        time: tob,
        latitude: lat,
        longitude: lon,
        tz: tz,
        lang: lang,
        style: style,
      );
      if (data == null && lang != 'en') {
        data = await _kundliService.generateKundli(
          date: dob,
          time: tob,
          latitude: lat,
          longitude: lon,
          tz: tz,
          lang: 'en',
          style: style,
        );
      }
      if (!mounted) return;
      setState(() {
        _svg = data?['data'] as String?;
        _loading = false;
        if (_svg == null) _error = 'Could not load chart';
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Lagna Chart',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: Color(0xFFed6f30)),
            ),
          ),
        ],
      );
    }
    if (_error != null || _svg == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Lagna Chart',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: AutoTranslateText(
                _error ?? 'Chart unavailable',
                style: MyTextTheme.smallBCN.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Lagna Chart',
          style: MyTextTheme.largeBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: "#ed6f30".toColor().withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(10.w),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartSize = (constraints.maxWidth - 20.w).clamp(
                  200.0,
                  400.w,
                );
                return SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: SvgPicture.string(
                    _svg!,
                    width: chartSize,
                    height: chartSize,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanetData {
  final String name;
  final String fullName;
  final double localDegree;
  final bool retro;
  final bool isCombust;
  final bool isAscendant;

  _PlanetData({
    required this.name,
    required this.fullName,
    required this.localDegree,
    required this.retro,
    required this.isCombust,
    required this.isAscendant,
  });
}
