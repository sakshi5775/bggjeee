import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LagnaChartWidget extends StatelessWidget {
  const LagnaChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KundliResultController>();

    return Obx(() {
      final svgData = controller.svgData.value;
      if (svgData == null || svgData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: const Color(0xFFDFB343)),
              Spacing.h(16),
              AutoTranslateText(
                'Loading chart...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chartSize = constraints.maxWidth - 32.w;
                  return Center(
                    child: Container(
                      width: chartSize,
                      height: chartSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: SvgPicture.string(
                          svgData,
                          width: chartSize,
                          height: chartSize,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          placeholderBuilder: (context) => Container(
                            width: chartSize,
                            height: chartSize,
                            color: Colors.grey.withOpacity(0.1),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: "#ed6f30".toColor(),
                              ),
                            ),
                          ),
                          semanticsLabel: 'Lagna Chart',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Spacing.h(16),

            // Legend
            _buildLegend(),

            Spacing.h(20),

            // Action Buttons
            _buildActionButtons(controller),

            Spacing.h(20),

            // Planetary Degrees
            _buildPlanetaryDegrees(),

            Spacing.h(20),
          ],
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.table_chart_rounded,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
              ),
              Spacing.w(16),
              AutoTranslateText(
                'Lagna Chart',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: Color(0xFF3D0C11),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
            ],
          ),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem('*', 'Retrograde'),
              _buildLegendItem('^', 'Combust'),
              _buildLegendItem('□', 'Vargottama'),
              _buildLegendItem('↑', 'Exalted'),
              _buildLegendItem('↓', 'Debilitated'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String symbol, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoTranslateText(
          symbol,
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            fontFamily: 'Baloo2',
          ),
        ),
        Spacing.w(4),
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN.copyWith(
            color: "#6F221E".toColor().withOpacity(0.7),
            fontSize: 16.sp,
            fontFamily: 'Baloo2',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(KundliResultController controller) {
    // Fetch planet details if not loaded (to get yoga data)
    if (controller.planetDetailsData.value == null &&
        !controller.isLoadingPlanetDetails.value) {
      controller.fetchPlanetDetails();
    }

    return Obx(() {
      // Get yoga from planet details (reactive)
      String yogaButtonText = 'Raj Yoga';
      final planetData = controller.planetDetailsData.value;
      if (planetData != null) {
        final panchang = planetData['panchang'] as Map<String, dynamic>?;
        final yoga = panchang?['yoga']?.toString();
        if (yoga != null && yoga.isNotEmpty) {
          yogaButtonText = yoga;
        }
      }

      final actionButtons = [
        'Planet',
        'Dasha',
        'Predictions',
        'KP System',
        'Shodashvarga',
        'Lal Kitab',
        'Varshphal',
        yogaButtonText, // Dynamic yoga button
        'Transit',
      ];

      return Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Icon(Icons.ac_unit, color: Colors.white),
                ),
                Spacing.w(12),
                AutoTranslateText(
                  'Actions',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'baloo2',
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            Spacing.h(12),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: actionButtons.length,
                  itemBuilder: (context, index) {
                    final buttonText = actionButtons[index];
                    // Check if this is the yoga button (7th index)
                    final isYogaButton = index == 7;
                    return _buildActionButton(
                      buttonText,
                      controller,
                      isYogaButton: isYogaButton,
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButton(
    String title,
    KundliResultController controller, {
    bool isYogaButton = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle Yoga button navigation
        if (isYogaButton) {
          Get.toNamed(
            AppRoutes.yog,
            arguments: {'formData': controller.formData.value},
          );
          return;
        }

        final titleLower = title.toLowerCase();

        // Map of action buttons to their routes
        final routeMap = {
          'planet': AppRoutes.planets,
          'planets': AppRoutes.planets,
          'dasha': AppRoutes.dasha,
          'predictions': AppRoutes.predictions,
          'kp system': AppRoutes.kpSystem,
          'shodashvarga': AppRoutes.shodashvarga,
          'lal kitab': AppRoutes.lalKitab,
          'varshphal': null, // Will be handled by onFeatureTap
        };

        // Handle Varshphal separately - it's a widget, not a route
        if (titleLower == 'varshphal') {
          controller.onFeatureTap(title);
          return;
        }

        // Check if there's a direct route for this action
        final route = routeMap[titleLower];
        if (route != null) {
          // Navigate to the route
          Get.toNamed(
            route,
            arguments: {'formData': controller.formData.value},
          );
          return;
        }

        // Check if it's a tab in the controller
        final tabIndex = controller.tabs.indexWhere(
          (tab) => tab.toLowerCase() == titleLower,
        );

        if (tabIndex != -1) {
          // It's a tab, switch to it
          controller.onTabSelected(tabIndex);
          return;
        }

        // Try onFeatureTap - it might handle some features like Transit
        // But we need to check if it actually navigates or just switches tabs
        final featureLower = titleLower;

        // Check if onFeatureTap will handle it by checking known features
        final handledFeatures = [
          'birth details',
          'panchang',
          'ashtakvarga',
          'binnashtakvarga',
          'divisional chart',
          'ashtakvarga chart',
          'ascendant report',
        ];

        if (handledFeatures.contains(featureLower)) {
          controller.onFeatureTap(title);
          return;
        }

        // For features not handled above, navigate to coming soon
        Get.toNamed(AppRoutes.comingSoon);
      },
      child: Container(
        decoration: BoxDecoration(
          color: "#FFFFFF".toColor(),
          border: Border.all(color: Colors.deepOrange, width: 1),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: "#ed6f30".toColor().withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [Color(0xFFFF8A3D), Color(0xFFED6F30)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: AutoTranslateText(
              title,
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white, // IMPORTANT: white hi rakho
                fontSize: isYogaButton ? 11.sp : 12.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: isYogaButton ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanetaryDegrees() {
    final controller = Get.find<KundliResultController>();

    return Obx(() {
      if (controller.isLoadingPlanetDetails.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Planetary Positions',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFDFB343).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(color: "#ed6f30".toColor()),
              ),
            ),
          ],
        );
      }

      final planetData = controller.planetDetailsData.value;
      if (planetData == null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Planetary Positions',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFDFB343).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: AutoTranslateText(
                'Planetary positions will be displayed here',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }

      // Extract planets (0-9)
      final planets = <String, Map<String, dynamic>>{};
      for (int i = 0; i <= 9; i++) {
        final planetKey = i.toString();
        if (planetData[planetKey] != null) {
          planets[planetKey] = planetData[planetKey] as Map<String, dynamic>;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFFF8C42),
                    Color(0xFFE63946)
                  ],),
                  borderRadius: BorderRadius.circular(12.r)
                  ),
                  child: Icon(Icons.ac_unit, color: Colors.white),
              ),
              Spacing.w(12),
              AutoTranslateText(
            'Planetary Positions',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
            ],
          ),
          
          Spacing.h(12),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFDFB343).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    childAspectRatio: isWide ? 3.5 : 2.8,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: planets.length,
                  itemBuilder: (context, index) {
                    final planetKey = planets.keys.elementAt(index);
                    final planet = planets[planetKey]!;
                    return _buildPlanetPositionCard(planet);
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPlanetPositionCard(Map<String, dynamic> planet) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: "#6F221E".toColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Planet Name Row
          Row(
            children: [
              Expanded(
                child: AutoTranslateText(
                  planet['full_name']?.toString() ??
                      planet['name']?.toString() ??
                      'Unknown',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (planet['name'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: "#ed6f30".toColor().withOpacity(0.2),
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
          Spacing.h(8),
          // Details Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlanetDetail(
                      'Zodiac',
                      planet['zodiac']?.toString() ?? '-',
                    ),
                    Spacing.h(4),
                    _buildPlanetDetail(
                      'House',
                      planet['house']?.toString() ?? '-',
                    ),
                  ],
                ),
              ),
              Spacing.w(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlanetDetail(
                      'Degree',
                      _formatDegree(planet['local_degree']),
                    ),
                    Spacing.h(4),
                    _buildPlanetDetail(
                      'Nakshatra',
                      planet['nakshatra']?.toString() ?? '-',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetDetail(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 60.w,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: AutoTranslateText(
            value,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDegree(dynamic degree) {
    if (degree == null) return '-';
    if (degree is num) {
      return '${degree.toStringAsFixed(2)}°';
    }
    return '$degree°';
  }
}
