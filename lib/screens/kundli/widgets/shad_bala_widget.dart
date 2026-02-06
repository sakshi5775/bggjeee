import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Shad Bala (Vedic) – displays all bala sections from API in themed tables.
class ShadBalaWidget extends StatelessWidget {
  final KundliResultController controller;

  const ShadBalaWidget({super.key, required this.controller});

  static String _formatSectionKey(String key) {
    if (key.isEmpty) return key;
    final normalized = key
        .replaceAll('_', ' ')
        .replaceAllMapped(RegExp(r'^.| .'), (m) => m.group(0)!.toUpperCase());
    if (key == 'chesta_Bala') return 'Chesta Bala';
    if (key == 'naisargeka_balas') return 'Naisargeka Balas';
    if (key == 'drik_bala') return 'Drik Bala';
    if (key == 'total_balas') return 'Total Balas';
    if (key == 'total_sthana_bala') return 'Total Sthana Bala';
    if (key == 'saptavargaja_bala') return 'Saptavargaja Bala';
    if (key == 'ojayugma_bala') return 'Ojayugma Bala';
    if (key == 'kendra_bala') return 'Kendra Bala';
    if (key == 'drekkna_bala') return 'Drekkna Bala';
    if (key == 'nathonnatha_bala') return 'Nathonnatha Bala';
    if (key == 'dig_bala') return 'Dig Bala';
    if (key == 'paksha_bala') return 'Paksha Bala';
    if (key == 'thribhaga_bala') return 'Thribhaga Bala';
    if (key == 'abda_bala') return 'Abda Bala';
    if (key == 'masa_bala') return 'Masa Bala';
    if (key == 'vara_bala') return 'Vara Bala';
    if (key == 'hora_bala') return 'Hora Bala';
    if (key == 'ayana_bala') return 'Ayana Bala';
    if (key == 'uccha_bala') return 'Uccha Bala';
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingShadBala.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: '#ed6f30'.toColor()),
              Spacing.h(12),
              AutoTranslateText(
                'Loading Shad Bala...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#6F221E'.toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.shadBalaData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Shad Bala data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      // Order of sections to match API; include only keys that exist and are non-empty maps
      const orderedKeys = [
        'uccha_bala',
        'saptavargaja_bala',
        'ojayugma_bala',
        'kendra_bala',
        'drekkna_bala',
        'total_sthana_bala',
        'nathonnatha_bala',
        'dig_bala',
        'paksha_bala',
        'thribhaga_bala',
        'abda_bala',
        'masa_bala',
        'vara_bala',
        'hora_bala',
        'ayana_bala',
        'chesta_Bala',
        'naisargeka_balas',
        'drik_bala',
        'total_balas',
        'ratio',
      ];
      final sectionKeys = <String>[
        ...orderedKeys.where((k) {
          final v = data[k];
          return v is Map && v.isNotEmpty;
        }),
      ];
      for (final k in data.keys) {
        if (sectionKeys.contains(k)) continue;
        final v = data[k];
        if (v is Map && v.isNotEmpty) sectionKeys.add(k);
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...sectionKeys.map((key) {
              final raw = data[key];
              if (raw is! Map || raw.isEmpty) return const SizedBox.shrink();
              final map = Map<String, dynamic>.from(
                raw.map((k, v) => MapEntry(k.toString(), v)),
              );
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildSectionCard(
                  title: _formatSectionKey(key),
                  planetValues: map,
                ),
              );
            }),
            Spacing.h(12),
            const ConsultAstrologerCard(),
            Spacing.h(32),
          ],
        ),
      );
    });
  }

  Widget _buildSectionCard({
    required String title,
    required Map<String, dynamic> planetValues,
  }) {
    return _planetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitleRow(title, Icons.bar_chart_rounded),
          _buildTableHeader(const ['Planet', 'Value']),
          ...planetValues.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            final value = e.value;
            final valueStr = value == null
                ? '--'
                : (value is num)
                ? value is int
                      ? value.toString()
                      : (value as double).toStringAsFixed(2)
                : value.toString();
            return _buildRow(e.key, valueStr, index);
          }),
        ],
      ),
    );
  }

  Widget _planetCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: '#ed6f30'.toColor().withOpacity(0.2),
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
        color: '#ed6f30'.toColor().withOpacity(0.08),
        border: Border(
          bottom: BorderSide(
            color: '#ed6f30'.toColor().withOpacity(0.25),
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

  Widget _buildTableHeader(List<String> labels) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(gradient: AppColors.orangeGradient),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[0],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[1],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String planet, String value, int index) {
    final isEven = index.isEven;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isEven ? '#ed6f30'.toColor().withOpacity(0.04) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: '#ed6f30'.toColor().withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _cell(planet, isBold: true)),
          Expanded(flex: 2, child: _cell(value)),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool isBold = false}) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: '#6F221E'.toColor(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 10.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
