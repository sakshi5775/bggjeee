import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

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
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.kpPlanetSignificatorsLevelWiseData.value;
      
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

      final response = data['data']?['response'] as Map<String, dynamic>?;
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
            ...response.entries.map((entry) {
              final planet = entry.key;
              final levels = entry.value as Map<String, dynamic>? ?? {};
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildPlanetCard(planet, levels),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildPlanetCard(String planet, Map<String, dynamic> levels) {
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
          // Planet Name Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  planet,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h3),
                ),
              ),
              Spacing.w(8),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        "#ed6f30".toColor().withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          
          // Levels
          ...levels.entries.map((levelEntry) {
            final level = levelEntry.key;
            final houses = levelEntry.value as List<dynamic>? ?? [];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border(
                    left: BorderSide(
                      color: "#ed6f30".toColor(),
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.layers,
                          color: "#ed6f30".toColor(),
                          size: 18.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          level,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#ed6f30".toColor(),
                            fontWeight: FontWeight.bold,
                          ).merge(AppTypography.body1),
                        ),
                      ],
                    ),
                    Spacing.h(12),
                    if (houses.isNotEmpty)
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: houses.map((house) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: "#ed6f30".toColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: "#ed6f30".toColor().withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: AutoTranslateText(
                              'House ${house.toString()}',
                              style: MyTextTheme.smallBCB.copyWith(
                                color: "#6F221E".toColor(),
                                fontWeight: FontWeight.w600,
                              ).merge(AppTypography.body2),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                              size: 14.w,
                            ),
                            Spacing.w(6),
                            AutoTranslateText(
                              'No houses',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: Colors.grey,
                              ).merge(AppTypography.body2),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

