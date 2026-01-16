import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/planets_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PlanetsWidget extends StatelessWidget {
  final PlanetsController controller;

  const PlanetsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.planetDetailsData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Planets Section
            _buildPlanetsSection(data),

            Spacing.h(20),

            // Lucky Things Section
            _buildLuckyThingsSection(data),

            Spacing.h(20),

            // Birth Details Section
            _buildBirthDetailsSection(data),

            Spacing.h(20),

            // Panchang Section
            if (data['panchang'] != null)
              _buildPanchangSection(data['panchang'] as Map<String, dynamic>),

            if (data['panchang'] != null) Spacing.h(20),

            // Ghatka Chakra Section
            if (data['ghatka_chakra'] != null)
              _buildGhatkaChakraSection(
                data['ghatka_chakra'] as Map<String, dynamic>,
              ),

            if (data['ghatka_chakra'] != null) Spacing.h(20),

            // Dasa Section
            _buildDasaSection(data),

            Spacing.h(20),
          ],
        ),
      );
    });
  }

  Widget _buildPlanetsSection(Map<String, dynamic> data) {
    final planets = <String, Map<String, dynamic>>{};

    // Extract planets (0-9)
    for (int i = 0; i <= 9; i++) {
      final planetKey = i.toString();
      if (data[planetKey] != null) {
        planets[planetKey] = data[planetKey] as Map<String, dynamic>;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.star_outline_outlined,
                      color: "#FFFFFF".toColor(),
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  _buildSectionTitle('Planetary Positions'),
                ],
              ),
            ],
          ),
        ),

        Spacing.h(12),
        ...planets.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildPlanetCard(entry.value),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPlanetCard(Map<String, dynamic> planet) {
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
          // Planet Name
          Row(
            children: [
              AutoTranslateText(
                planet['full_name']?.toString() ??
                    planet['name']?.toString() ??
                    'Unknown',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontSize: 14.sp,
                ),
              ),
              Spacing.w(8),
              if (planet['name'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: "#ed6f30".toColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: AutoTranslateText(
                    planet['name'].toString(),
                    style: MyTextTheme.smallBCB.copyWith(
                      color: "#ed6f30".toColor(),
                    ),
                  ),
                ),
            ],
          ),
          Spacing.h(12),

          // Planet Details Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 3 : 2,
                childAspectRatio: isWide ? 2.5 : 2.2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                children: [
                  _buildDetailItem(
                    'Zodiac',
                    planet['zodiac']?.toString() ?? '-',
                  ),
                  _buildDetailItem('House', planet['house']?.toString() ?? '-'),
                  _buildDetailItem(
                    'Nakshatra',
                    planet['nakshatra']?.toString() ?? '-',
                  ),
                  _buildDetailItem(
                    'Nakshatra Lord',
                    planet['nakshatra_lord']?.toString() ?? '-',
                  ),
                  _buildDetailItem(
                    'Nakshatra Pada',
                    planet['nakshatra_pada']?.toString() ?? '-',
                  ),
                  _buildDetailItem(
                    'Zodiac Lord',
                    planet['zodiac_lord']?.toString() ?? '-',
                  ),
                  _buildDetailItem(
                    'Local Degree',
                    _formatDegree(planet['local_degree']),
                  ),
                  _buildDetailItem(
                    'Global Degree',
                    _formatDegree(planet['global_degree']),
                  ),
                  _buildDetailItem(
                    'Progress',
                    '${_formatPercentage(planet['progress_in_percentage'])}%',
                  ),
                  if (planet['basic_avastha'] != null &&
                      planet['basic_avastha'].toString().trim().isNotEmpty)
                    _buildDetailItem(
                      'Basic Avastha',
                      planet['basic_avastha']?.toString() ?? '-',
                    ),
                  if (planet['lord_status'] != null &&
                      planet['lord_status'].toString().trim().isNotEmpty)
                    _buildDetailItem(
                      'Lord Status',
                      planet['lord_status']?.toString() ?? '-',
                    ),
                  _buildDetailItem(
                    'Is Planet Set',
                    planet['is_planet_set']?.toString() ?? '-',
                  ),
                  if (planet['is_combust'] != null &&
                      planet['is_combust'] != '-')
                    _buildDetailItem(
                      'Is Combust',
                      planet['is_combust']?.toString() ?? '-',
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: "#FF8C42".toColor().withOpacity(0.05),
        border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
          Spacing.h(4),
          AutoTranslateText(
            value,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyThingsSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.star_outline_outlined,
                      color: "#FFFFFF".toColor(),
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  _buildSectionTitle('Lucky Things'),
                ],
              ),
            ],
          ),
        ),

        // _buildSectionTitle('Lucky Things'),
        Spacing.h(12),
        Container(
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
              if (data['lucky_gem'] != null)
                _buildLuckyItem('Lucky Gem', data['lucky_gem']),
              if (data['lucky_num'] != null)
                _buildLuckyItem('Lucky Number', data['lucky_num']),
              if (data['lucky_colors'] != null)
                _buildLuckyItem('Lucky Colors', data['lucky_colors']),
              if (data['lucky_letters'] != null)
                _buildLuckyItem('Lucky Letters', data['lucky_letters']),
              if (data['lucky_name_start'] != null)
                _buildLuckyItem('Lucky Name Start', data['lucky_name_start']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLuckyItem(String label, dynamic value) {
    String displayValue = '';
    if (value is List) {
      displayValue = value.join(', ');
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              displayValue,
              style: MyTextTheme.smallBCN.copyWith(color: "#6F221E".toColor()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDetailsSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: "#FFFFFF".toColor(),
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  _buildSectionTitle('Birth Details'),
                ],
              ),
            ],
          ),
        ),

        Spacing.h(12),
        Container(
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
              if (data['rasi'] != null)
                _buildDetailRow('Rasi', data['rasi'].toString()),
              if (data['nakshatra'] != null)
                _buildDetailRow('Nakshatra', data['nakshatra'].toString()),
              if (data['nakshatra_pada'] != null)
                _buildDetailRow(
                  'Nakshatra Pada',
                  data['nakshatra_pada'].toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPanchangSection(Map<String, dynamic> panchang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.star_outline_outlined,
                      color: "#FFFFFF".toColor(),
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  _buildSectionTitle('Panchang'),
                ],
              ),
            ],
          ),
        ),

        Spacing.h(12),
        Container(
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
              if (panchang['day_of_birth'] != null)
                _buildDetailRow(
                  'Day of Birth',
                  panchang['day_of_birth'].toString(),
                ),
              if (panchang['day_lord'] != null)
                _buildDetailRow('Day Lord', panchang['day_lord'].toString()),
              if (panchang['hora_lord'] != null)
                _buildDetailRow('Hora Lord', panchang['hora_lord'].toString()),
              if (panchang['sunrise_at_birth'] != null)
                _buildDetailRow(
                  'Sunrise at Birth',
                  panchang['sunrise_at_birth'].toString(),
                ),
              if (panchang['sunset_at_birth'] != null)
                _buildDetailRow(
                  'Sunset at Birth',
                  panchang['sunset_at_birth'].toString(),
                ),
              if (panchang['karana'] != null)
                _buildDetailRow('Karana', panchang['karana'].toString()),
              if (panchang['yoga'] != null)
                _buildDetailRow('Yoga', panchang['yoga'].toString()),
              if (panchang['tithi'] != null)
                _buildDetailRow('Tithi', panchang['tithi'].toString()),
              if (panchang['ayanamsa'] != null)
                _buildDetailRow('Ayanamsa', panchang['ayanamsa'].toString()),
              if (panchang['ayanamsa_name'] != null)
                _buildDetailRow(
                  'Ayanamsa Name',
                  panchang['ayanamsa_name'].toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGhatkaChakraSection(Map<String, dynamic> ghatkaChakra) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.description,
                      color: "#FFFFFF".toColor(),
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  _buildSectionTitle('Ghatka Chakra'),
                ],
              ),
            ],
          ),
        ),

        Spacing.h(12),
        Container(
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
              if (ghatkaChakra['rasi'] != null)
                _buildDetailRow('Rasi', ghatkaChakra['rasi'].toString()),
              if (ghatkaChakra['tithi'] != null) ...[
                Builder(
                  builder: (context) {
                    final tithi = ghatkaChakra['tithi'];
                    if (tithi is List) {
                      return _buildDetailRow('Tithi', tithi.join(', '));
                    } else {
                      return _buildDetailRow('Tithi', tithi.toString());
                    }
                  },
                ),
              ],
              if (ghatkaChakra['day'] != null)
                _buildDetailRow('Day', ghatkaChakra['day'].toString()),
              if (ghatkaChakra['nakshatra'] != null)
                _buildDetailRow(
                  'Nakshatra',
                  ghatkaChakra['nakshatra'].toString(),
                ),
              if (ghatkaChakra['tatva'] != null)
                _buildDetailRow('Tatva', ghatkaChakra['tatva'].toString()),
              if (ghatkaChakra['lord'] != null)
                _buildDetailRow('Lord', ghatkaChakra['lord'].toString()),
              if (ghatkaChakra['same_sex_lagna'] != null)
                _buildDetailRow(
                  'Same Sex Lagna',
                  ghatkaChakra['same_sex_lagna'].toString(),
                ),
              if (ghatkaChakra['opposite_sex_lagna'] != null)
                _buildDetailRow(
                  'Opposite Sex Lagna',
                  ghatkaChakra['opposite_sex_lagna'].toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDasaSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#FFFFFF".toColor(),
            border: Border.all(color: "#FF8C42".toColor(), width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.star_outline_outlined,
                      color: "#FFFFFF".toColor(),
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  _buildSectionTitle('Dasa'),
                ],
              ),
            ],
          ),
        ),

        Spacing.h(12),
        Container(
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
              if (data['birth_dasa'] != null)
                _buildDetailRow('Birth Dasa', data['birth_dasa'].toString()),
              if (data['current_dasa'] != null)
                _buildDetailRow(
                  'Current Dasa',
                  data['current_dasa'].toString(),
                ),
              if (data['birth_dasa_time'] != null)
                _buildDetailRow(
                  'Birth Dasa Time',
                  data['birth_dasa_time'].toString(),
                ),
              if (data['current_dasa_time'] != null)
                _buildDetailRow(
                  'Current Dasa Time',
                  data['current_dasa_time'].toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return AutoTranslateText(
      title,
      style: MyTextTheme.mediumBCB.copyWith(
        color: "#6F221E".toColor(),
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(color: "#6F221E".toColor()),
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

  String _formatPercentage(dynamic percentage) {
    if (percentage == null) return '-';
    if (percentage is num) {
      return percentage.toStringAsFixed(2);
    }
    return percentage.toString();
  }
}
