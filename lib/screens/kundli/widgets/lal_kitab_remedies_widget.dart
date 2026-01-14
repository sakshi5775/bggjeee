import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LalKitabRemediesWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabRemediesWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabRemedies.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.lalKitabRemediesData.value;

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
              final planetData = entry.value as Map<String, dynamic>;
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

  Widget _buildPlanetCard(Map<String, dynamic> planetData) {
    final planet = planetData['planet'] as String? ?? '';
    final house = planetData['house'] as String? ?? '';
    final effects = planetData['effects'] as String? ?? '';
    final remedies = planetData['remedies'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ["#FFFFFF".toColor(), "#FFFFFF".toColor()],
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
                  // color: "#ed6f30".toColor(),
                  gradient: LinearGradient(
                    colors: ["#FF8C42".toColor(), "#E63946".toColor()],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  planet,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h3),
                ),
              ),
              Spacing.w(12),
              if (house.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: "#ed6f30".toColor().withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: AutoTranslateText(
                    'House: $house',
                    style: MyTextTheme.smallBCB
                        .copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w600,
                        )
                        .merge(AppTypography.body2),
                  ),
                ),
            ],
          ),
          Spacing.h(16),

          // Effects
          if (effects.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  // width: 120.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        "#FFF6C24D".toColor().withOpacity(0.10),
                        "#FFE8A34D".toColor().withOpacity(0.10),
                      ],
                    ),
                    // border: Border.all(color: Colors.deepOrange, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: "#ed6f30".toColor(),
                            size: 18.w,
                          ),
                          Spacing.w(8),
                          AutoTranslateText(
                            'Effects',
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: "#6F221E".toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: "#FF8C42".toColor(), width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                effects,
                style: MyTextTheme.smallBCN
                    .copyWith(color: "#6F221E".toColor(), height: 1.5)
                    .merge(AppTypography.body2),
              ),
            ),
            Spacing.h(16),
          ],

          // Remedies
          if (remedies.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  // width: 120.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        "#FFF6C24D".toColor().withOpacity(0.10),
                        "#FFE8A34D".toColor().withOpacity(0.10),
                      ],
                    ),
                    // border: Border.all(color: Colors.deepOrange, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.healing,
                            color: "#ed6f30".toColor(),
                            size: 18.w,
                          ),
                          Spacing.w(8),
                          AutoTranslateText(
                            'Remedies',
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: "#6F221E".toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            // ...remedies.asMap().entries.map((entry) {
            //   final index = entry.key;
            //   final remedy = entry.value.toString();
            //   return Padding(
            //     padding: EdgeInsets.only(bottom: 8.h),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           width: 24.w,
            //           height: 24.w,
            //           decoration: BoxDecoration(
            //             color: "#ed6f30".toColor().withOpacity(0.1),
            //             shape: BoxShape.circle,
            //           ),
            //           child: Center(
            //             child: AutoTranslateText(
            //               '${index + 1}',
            //               style: MyTextTheme.smallBCB
            //                   .copyWith(
            //                     color: "#ed6f30".toColor(),
            //                     fontWeight: FontWeight.bold,
            //                   )
            //                   .merge(AppTypography.body2),
            //             ),
            //           ),
            //         ),
            //         Spacing.w(12),
            //         Expanded(
            //           child: AutoTranslateText(
            //             remedy,
            //             style: MyTextTheme.smallBCN
            //                 .copyWith(color: "#6F221E".toColor(), height: 1.5)
            //                 .merge(AppTypography.body2),
            //           ),
            //         ),
            //       ],
            //     ),
            //   );
            // }).toList(),
            ...remedies.asMap().entries.map((entry) {
              final index = entry.key;
              final remedy = entry.value.toString();

              return Container(
                padding: EdgeInsets.all(14.w),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: "#ed6f30".toColor().withOpacity(0.18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Number Badge
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            "#ed6f30".toColor().withOpacity(0.9),
                            "#ff9f68".toColor(),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: "#ed6f30".toColor().withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: AutoTranslateText(
                        '${index + 1}',
                        style: MyTextTheme.smallBCB
                            .merge(AppTypography.body2)
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),

                    Spacing.w(14),

                    /// Remedy Text
                    Expanded(
                      child: AutoTranslateText(
                        remedy,
                        style: MyTextTheme.smallBCN
                            .merge(AppTypography.body2)
                            .copyWith(color: "#6F221E".toColor(), height: 1.6),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
