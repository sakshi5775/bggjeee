import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AscendantReportWidget extends StatelessWidget {
  final KundliResultController controller;

  const AscendantReportWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAscendantReport.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(
                  color: "#ed6f30".toColor(),
                  strokeWidth: 2,
                ),
              ),
              Spacing.h(10),
              AutoTranslateText(
                'Loading...',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.ascendantReportData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Ascendant Report data available',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.7),
              fontSize: 12.sp,
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: "#ed6f30".toColor().withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(data),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoBlock(data),
                    Spacing.h(10),
                    _buildPredictions(data),
                    Spacing.h(10),
                    _buildCharacteristics(data),
                    Spacing.h(10),
                    _buildSpiritualBlock(data),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    final ascendant = data['ascendant']?.toString() ?? '--';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ["#FF8A3D".toColor(), "#ed6f30".toColor()],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.white, size: 18.w),
          Spacing.w(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  'Ascendant (Lagna) Report',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                AutoTranslateText(
                  'Ascendant: $ascendant',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(Map<String, dynamic> data) {
    final rows = <(String, String)>[
      ('Ascendant Lord', data['ascendant_lord']?.toString() ?? '--'),
      ('Lord Location', data['ascendant_lord_location']?.toString() ?? '--'),
      ('Lord House', 'House ${data['ascendant_lord_house_location'] ?? '--'}'),
      ('Strength', data['ascendant_lord_strength']?.toString() ?? '--'),
      ('Symbol', data['symbol']?.toString() ?? '--'),
      ('Characteristics', data['zodiac_characteristics']?.toString() ?? '--'),
    ];
    final loc = data['verbal_location']?.toString() ?? '';
    if (loc.isNotEmpty && loc != '--') {
      rows.add(('Location', loc));
    }
    return _section(
      title: 'Ascendant Information',
      icon: Icons.info_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _row(rows[i].$1, rows[i].$2),
            if (i < rows.length - 1) _div(),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictions(Map<String, dynamic> data) {
    final gen = data['general_prediction']?.toString() ?? '';
    final pers = data['personalised_prediction']?.toString() ?? '';
    if (gen.isEmpty && pers.isEmpty) return const SizedBox.shrink();
    return _section(
      title: 'Predictions',
      icon: Icons.auto_awesome_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (gen.isNotEmpty) ...[
            _label('General'),
            Spacing.h(4),
            _body(gen),
            if (pers.isNotEmpty) Spacing.h(8),
          ],
          if (pers.isNotEmpty) ...[
            _label('Personalised'),
            Spacing.h(4),
            _body(pers),
          ],
        ],
      ),
    );
  }

  Widget _buildCharacteristics(Map<String, dynamic> data) {
    final flagship = data['flagship_qualities']?.toString() ?? '';
    final good = data['good_qualities']?.toString() ?? '';
    final bad = data['bad_qualities']?.toString() ?? '';
    if (flagship.isEmpty && good.isEmpty && bad.isEmpty) {
      return const SizedBox.shrink();
    }
    return _section(
      title: 'Characteristics',
      icon: Icons.psychology_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (flagship.isNotEmpty) ...[
            _chipLabel('Flagship Qualities'),
            Spacing.h(4),
            _body(flagship),
            if (good.isNotEmpty || bad.isNotEmpty) Spacing.h(6),
          ],
          if (good.isNotEmpty) ...[
            _chipLabel('Good Qualities'),
            Spacing.h(4),
            _body(good),
            if (bad.isNotEmpty) Spacing.h(6),
          ],
          if (bad.isNotEmpty) ...[
            _chipLabel('Areas to Improve'),
            Spacing.h(4),
            _body(bad),
          ],
        ],
      ),
    );
  }

  Widget _buildSpiritualBlock(Map<String, dynamic> data) {
    final advice = data['spirituality_advice']?.toString() ?? '';
    final gem = data['lucky_gem']?.toString() ?? '';
    final fasting = data['day_for_fasting']?.toString() ?? '';
    final mantra = data['gayatri_mantra']?.toString() ?? '';
    if (advice.isEmpty && gem.isEmpty && fasting.isEmpty && mantra.isEmpty) {
      return const SizedBox.shrink();
    }
    return _section(
      title: 'Spiritual & Lucky',
      icon: Icons.self_improvement_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (advice.isNotEmpty) ...[
            _chipLabel('Spirituality Advice'),
            Spacing.h(4),
            _body(advice),
            if (gem.isNotEmpty || fasting.isNotEmpty || mantra.isNotEmpty)
              Spacing.h(6),
          ],
          if (gem.isNotEmpty) _row('Lucky Gem', gem),
          if (gem.isNotEmpty && (fasting.isNotEmpty || mantra.isNotEmpty))
            _div(),
          if (fasting.isNotEmpty) _row('Day for Fasting', fasting),
          if (fasting.isNotEmpty && mantra.isNotEmpty) _div(),
          if (mantra.isNotEmpty) ...[
            _chipLabel('Gayatri Mantra'),
            Spacing.h(4),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: "#ed6f30".toColor().withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: "#ed6f30".toColor().withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: AutoTranslateText(
                mantra,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor(),
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: "#ed6f30".toColor().withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: "#ed6f30".toColor().withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: "#ed6f30".toColor(), size: 16.w),
              Spacing.w(6),
              AutoTranslateText(
                title,
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
            ),
          ),
          Spacing.w(8),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _div() => Divider(
    height: 1,
    thickness: 1,
    color: "#6F221E".toColor().withValues(alpha: 0.1),
  );

  Widget _label(String t) => AutoTranslateText(
    t,
    style: MyTextTheme.smallBCB.copyWith(
      color: "#6F221E".toColor(),
      fontWeight: FontWeight.w600,
      fontSize: 11.sp,
    ),
  );

  Widget _chipLabel(String t) => AutoTranslateText(
    t,
    style: MyTextTheme.smallBCB.copyWith(
      color: "#ed6f30".toColor(),
      fontWeight: FontWeight.w600,
      fontSize: 11.sp,
    ),
  );

  Widget _body(String t) => AutoTranslateText(
    t,
    style: MyTextTheme.smallBCN.copyWith(
      color: "#6F221E".toColor().withValues(alpha: 0.85),
      height: 1.45,
      fontSize: 11.sp,
    ),
  );
}
