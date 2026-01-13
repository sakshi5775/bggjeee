import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LalKitabPlanetsWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabPlanetsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabPlanets.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.lalKitabPlanetsData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...response.map((planet) {
              final planetData = planet as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildPlanetCard(planetData),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildPlanetCard(Map<String, dynamic> planet) {
    final planetName = planet['planet'] as String? ?? '';
    final rashi = planet['rashi'] as String? ?? '';
    final soya = planet['soya'] as bool? ?? false;
    final position = planet['position'] as String? ?? '';
    final nature = planet['nature'] as String? ?? '';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#ed6f30".toColor().withOpacity(0.1),
            "#ed6f30".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
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
          // Planet Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  planetName,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h3),
                ),
              ),
              if (soya) ...[
                Spacing.w(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AutoTranslateText(
                    'Soya',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.label),
                  ),
                ),
              ],
            ],
          ),
          Spacing.h(16),
          
          // Details
          _buildDetailRow('Rashi', rashi),
          _buildDetailRow('Position', position),
          _buildDetailRow('Nature', nature, isNature: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isNature = false}) {
    Color? valueColor;
    if (isNature) {
      if (value.toLowerCase().contains('benefic')) {
        valueColor = Colors.green;
      } else if (value.toLowerCase().contains('melefic') || value.toLowerCase().contains('malefic')) {
        valueColor = Colors.red;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ).merge(AppTypography.body2),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isNature && valueColor != null
                    ? valueColor.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: isNature && valueColor != null
                    ? Border.all(
                        color: valueColor.withOpacity(0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: AutoTranslateText(
                value,
                textAlign: TextAlign.right,
                style: MyTextTheme.smallBCB.copyWith(
                  color: isNature && valueColor != null
                      ? valueColor
                      : "#6F221E".toColor(),
                  fontWeight: FontWeight.w600,
                ).merge(AppTypography.body2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

