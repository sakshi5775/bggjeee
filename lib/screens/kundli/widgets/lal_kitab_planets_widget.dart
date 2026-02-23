import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Lal Kitab Planets – compact table form (Planet, Rashi, Soya, Position, Nature).
class LalKitabPlanetsWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabPlanetsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabPlanets.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.lalKitabPlanetsData.value;
      final response = data?['data']?['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
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
        child: _planetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleRow('Lal Kitab Planets', Icons.public_rounded),
              _buildTableHeader(const [
                'Planet',
                'Rashi',
                'Soya',
                'Position',
                'Nature',
              ]),
              ...response.asMap().entries.map(
                (e) => _buildTableRow(e.value as Map<String, dynamic>, e.key),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _planetCard({required Widget child}) {
    return Container(
      width: double.infinity,
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

  static const List<int> _headerFlex = [
    2,
    1,
    1,
    1,
    1,
  ]; // Planet wider, rest equal

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
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> planet, int index) {
    final planetName = planet['planet'] as String? ?? '';
    final rashi = planet['rashi'] as String? ?? '';
    final soya = planet['soya'] as bool? ?? false;
    final position = planet['position'] as String? ?? '';
    final nature = planet['nature'] as String? ?? '';
    final isEven = index.isEven;
    final isBenefic = nature.toLowerCase().contains('benefic');
    final isMalefic =
        nature.toLowerCase().contains('melefic') ||
        nature.toLowerCase().contains('malefic');

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
        children: [
          Expanded(flex: 2, child: _cell(planetName, isBold: true)),
          Expanded(child: _cell(rashi)),
          Expanded(child: _cell(soya ? 'Yes' : 'No')),
          Expanded(child: _cell(position)),
          Expanded(
            child: _cell(
              nature,
              color: isBenefic ? Colors.green : (isMalefic ? Colors.red : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool isBold = false, Color? color}) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: color ?? '#6F221E'.toColor(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 10.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
