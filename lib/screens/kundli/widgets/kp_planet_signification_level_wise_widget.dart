import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// KP Planet Significators Level Wise – table (Planet | L1 | L2 | L3 | L4).
class KpPlanetSignificationLevelWiseWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpPlanetSignificationLevelWiseWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKpPlanetSignificatorsLevelWise.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.kpPlanetSignificatorsLevelWiseData.value;
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 600.w, maxWidth: 600.w),
            child: _planetCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitleRow(
                    'Planet Significators (Level Wise)',
                    Icons.layers,
                  ),
                  _buildTableHeader(const ['Planet', 'L1', 'L2', 'L3', 'L4']),
                  ...response.entries.toList().asMap().entries.map((e) {
                    final planet = e.value.key;
                    final levels = e.value.value as Map<String, dynamic>? ?? {};
                    final l1 =
                        (levels['L1'] as List<dynamic>?)
                            ?.map((x) => x.toString())
                            .join(', ') ??
                        '--';
                    final l2 =
                        (levels['L2'] as List<dynamic>?)
                            ?.map((x) => x.toString())
                            .join(', ') ??
                        '--';
                    final l3 =
                        (levels['L3'] as List<dynamic>?)
                            ?.map((x) => x.toString())
                            .join(', ') ??
                        '--';
                    final l4 =
                        (levels['L4'] as List<dynamic>?)
                            ?.map((x) => x.toString())
                            .join(', ') ??
                        '--';
                    return _buildTableRow(planet, l1, l2, l3, l4, e.key);
                  }),
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

  static const List<int> _headerFlex = [2, 2, 2, 2, 2];

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

  Widget _buildTableRow(
    String planet,
    String l1,
    String l2,
    String l3,
    String l4,
    int index,
  ) {
    final isEven = index.isEven;
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
          Expanded(flex: 2, child: _cell(planet, isBold: true)),
          Expanded(flex: 2, child: _cell(l1)),
          Expanded(flex: 2, child: _cell(l2)),
          Expanded(flex: 2, child: _cell(l3)),
          Expanded(flex: 2, child: _cell(l4)),
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
