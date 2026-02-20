import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Lal Kitab Remedies section widget for Predictions view.
class LalKitabRemediesPredictionsWidget extends StatelessWidget {
  final PredictionsController controller;

  const LalKitabRemediesPredictionsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoadingLalKitabRemedies.value;
      final data = controller.lalKitabRemediesData.value;

      if (loading && data == null) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: CircularProgressIndicator(color: '#ed6f30'.toColor(), strokeWidth: 2),
          ),
        );
      }

      if (data == null || data.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: AutoTranslateText(
              'No data available',
              style: MyTextTheme.mediumBCN.copyWith(color: '#6F221E'.toColor().withOpacity(0.6)),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: AutoTranslateText(
              'No data available',
              style: MyTextTheme.mediumBCN.copyWith(color: '#6F221E'.toColor().withOpacity(0.6)),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: '#ed6f30'.toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Lal Kitab Remedies',
                style: MyTextTheme.mediumBCB
                    .copyWith(color: '#6F221E'.toColor(), fontWeight: FontWeight.bold)
                    .merge(AppTypography.h3),
              ),
            ],
          ),
          Spacing.h(12),
          ...response.entries.map<Widget>((entry) {
            final planetData = entry.value as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildPlanetCard(planetData),
            );
          }),
        ],
      );
    });
  }

  Widget _buildPlanetCard(Map<String, dynamic> planetData) {
    final planet = planetData['planet'] as String? ?? '';
    final house = planetData['house'] as String? ?? '';
    final effects = planetData['effects'] as String? ?? '';
    final remedies = planetData['remedies'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: '#ed6f30'.toColor().withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  planet,
                  style: MyTextTheme.mediumBCB
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                      .merge(AppTypography.h3),
                ),
              ),
              if (house.isNotEmpty) ...[
                Spacing.w(12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: '#ed6f30'.toColor().withOpacity(0.3), width: 1),
                  ),
                  child: AutoTranslateText(
                    'House: $house',
                    style: MyTextTheme.smallBCB
                        .copyWith(color: '#6F221E'.toColor(), fontWeight: FontWeight.w600)
                        .merge(AppTypography.body2),
                  ),
                ),
              ],
            ],
          ),
          if (effects.isNotEmpty) ...[
            Spacing.h(16),
            Row(
              children: [
                Icon(Icons.info_outline, color: '#ed6f30'.toColor(), size: 18.w),
                Spacing.w(8),
                AutoTranslateText(
                  'Effects',
                  style: MyTextTheme.mediumBCB
                      .copyWith(color: '#6F221E'.toColor(), fontWeight: FontWeight.bold)
                      .merge(AppTypography.body1),
                ),
              ],
            ),
            Spacing.h(8),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: '#FF8C42'.toColor(), width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                effects,
                style: MyTextTheme.smallBCN
                    .copyWith(color: '#6F221E'.toColor(), height: 1.5)
                    .merge(AppTypography.body2),
              ),
            ),
          ],
          if (remedies.isNotEmpty) ...[
            Spacing.h(10),
            Row(
              children: [
                Icon(Icons.healing, color: '#ed6f30'.toColor(), size: 18.w),
                Spacing.w(8),
                AutoTranslateText(
                  'Remedies',
                  style: MyTextTheme.mediumBCB
                      .copyWith(color: '#6F221E'.toColor(), fontWeight: FontWeight.bold)
                      .merge(AppTypography.body1),
                ),
              ],
            ),
            Spacing.h(8),
            ...remedies.asMap().entries.map((entry) {
              final index = entry.key;
              final remedy = entry.value.toString();
              return Container(
                padding: EdgeInsets.all(14.w),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: '#ed6f30'.toColor().withOpacity(0.18)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ['#ed6f30'.toColor().withOpacity(0.9), '#ff9f68'.toColor()],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: AutoTranslateText(
                        '${index + 1}',
                        style: MyTextTheme.smallBCB
                            .merge(AppTypography.body2)
                            .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacing.w(14),
                    Expanded(
                      child: AutoTranslateText(
                        remedy,
                        style: MyTextTheme.smallBCN
                            .merge(AppTypography.body2)
                            .copyWith(color: '#6F221E'.toColor(), height: 1.6),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
