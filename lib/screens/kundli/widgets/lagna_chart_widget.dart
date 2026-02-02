import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/planets_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LagnaChartWidget extends StatelessWidget {
  const LagnaChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KundliResultController>();

    return Obx(() {
      final svgData = controller.svgData.value;
      final selectedAction = controller.selectedLagnaAction.value;
      if (svgData == null || svgData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32.w,
                height: 32.w,
                child: CircularProgressIndicator(
                  color: "#ed6f30".toColor(),
                  strokeWidth: 2,
                ),
              ),
              Spacing.h(12),
              AutoTranslateText(
                'Loading chart...',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartWithLegend(svgData),
            Spacing.h(10),
            _buildActionButtons(controller, selectedAction),
            Spacing.h(10),
            _buildContentBelowSlider(controller, selectedAction),
            Spacing.h(12),
            const ConsultAstrologerCard(),
            Spacing.h(12),
          ],
        ),
      );
    });
  }

  Widget _buildChartWithLegend(String svgData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final chartSize = constraints.maxWidth - 20.w;
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    width: chartSize,
                    height: chartSize,
                    child: SvgPicture.string(
                      svgData,
                      width: chartSize,
                      height: chartSize,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      placeholderBuilder: (context) => Container(
                        color: Colors.grey.withOpacity(0.08),
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              color: "#ed6f30".toColor(),
                              strokeWidth: 2,
                            ),
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
          Spacing.h(8),
          Wrap(
            spacing: 6.w,
            runSpacing: 4.h,
            children: [
              _buildLegendChip('*', 'Retro'),
              _buildLegendChip('^', 'Combust'),
              _buildLegendChip('□', 'Vargottama'),
              _buildLegendChip('↑', 'Exalt'),
              _buildLegendChip('↓', 'Debil'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendChip(String symbol, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: "#ed6f30".toColor().withOpacity(0.08),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            symbol,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
          Spacing.w(2),
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.75),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    KundliResultController controller,
    String? selectedAction,
  ) {
    if (controller.planetDetailsData.value == null &&
        !controller.isLoadingPlanetDetails.value) {
      controller.fetchPlanetDetails();
    }

    return Obx(() {
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
        yogaButtonText,
        'Transit',
      ];

      final isPlanetSelected = selectedAction == 'planet';

      return Container(
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
            color: "#ed6f30".toColor().withOpacity(0.2),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    "#FF8A3D".toColor(),
                    "#ed6f30".toColor(),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 18.w,
                    color: Colors.white,
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Actions',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: actionButtons.length,
                  separatorBuilder: (_, __) => SizedBox(width: 6.w),
                  itemBuilder: (context, index) {
                    final buttonText = actionButtons[index];
                    final isYogaButton = index == 7;
                    final isPlanet = index == 0;
                    return _buildActionChip(
                      buttonText,
                      controller,
                      isYogaButton: isYogaButton,
                      isPlanet: isPlanet,
                      isPlanetSelected: isPlanet && isPlanetSelected,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContentBelowSlider(
    KundliResultController controller,
    String? selectedAction,
  ) {
    if (selectedAction == 'planet') {
      return PlanetsWidget(controller: controller, embedded: true);
    }
    return _buildPlanetaryDegrees();
  }

  Widget _buildActionChip(
    String title,
    KundliResultController controller, {
    bool isYogaButton = false,
    bool isPlanet = false,
    bool isPlanetSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isPlanet) {
          controller.selectedLagnaAction.value =
              isPlanetSelected ? null : 'planet';
          return;
        }
        if (isYogaButton) {
          Get.toNamed(
            AppRoutes.yog,
            arguments: {'formData': controller.formData.value},
          );
          return;
        }
        final titleLower = title.toLowerCase();
        final routeMap = {
          'dasha': AppRoutes.dasha,
          'predictions': AppRoutes.predictions,
          'kp system': AppRoutes.kpSystem,
          'shodashvarga': AppRoutes.shodashvarga,
          'lal kitab': AppRoutes.lalKitab,
        };
        if (titleLower == 'varshphal') {
          controller.onFeatureTap(title);
          return;
        }
        final route = routeMap[titleLower];
        if (route != null) {
          Get.toNamed(route, arguments: {'formData': controller.formData.value});
          return;
        }
        final tabIndex = controller.tabs.indexWhere(
          (tab) => tab.toLowerCase() == titleLower,
        );
        if (tabIndex != -1) {
          controller.onTabSelected(tabIndex);
          return;
        }
        final handledFeatures = [
          'birth details', 'panchang', 'ashtakvarga', 'binnashtakvarga',
          'divisional chart', 'ashtakvarga chart', 'ascendant report',
        ];
        if (handledFeatures.contains(titleLower)) {
          controller.onFeatureTap(title);
          return;
        }
        Get.toNamed(AppRoutes.comingSoon);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isPlanetSelected
              ? LinearGradient(
                  colors: ["#FF8A3D".toColor(), "#ed6f30".toColor()],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPlanetSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isPlanetSelected ? "#ed6f30".toColor() : "#ed6f30".toColor().withOpacity(0.35),
            width: isPlanetSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: AutoTranslateText(
          title,
          textAlign: TextAlign.center,
          style: MyTextTheme.smallBCB.copyWith(
            color: isPlanetSelected ? Colors.white : "#6F221E".toColor(),
            fontSize: isYogaButton ? 9.sp : 10.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: isYogaButton ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildPlanetaryDegrees() {
    final controller = Get.find<KundliResultController>();

    return Obx(() {
      if (controller.isLoadingPlanetDetails.value) {
        return _planetCard(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: CircularProgressIndicator(
                    color: "#ed6f30".toColor(),
                    strokeWidth: 2,
                  ),
                ),
                Spacing.w(10),
                AutoTranslateText(
                  'Loading planetary positions...',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final planetData = controller.planetDetailsData.value;
      if (planetData == null) {
        return _planetCard(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: AutoTranslateText(
              'Planetary positions will be displayed here',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      final planets = <String, Map<String, dynamic>>{};
      for (int i = 0; i <= 9; i++) {
        final planetKey = i.toString();
        if (planetData[planetKey] != null) {
          planets[planetKey] = planetData[planetKey] as Map<String, dynamic>;
        }
      }

      return _planetCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: "#ed6f30".toColor().withOpacity(0.08),
                border: Border(
                  bottom: BorderSide(
                    color: "#ed6f30".toColor().withOpacity(0.25),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 18.w,
                    color: "#ed6f30".toColor(),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Planetary Positions',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            _buildPlanetaryTableHeader(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: planets.length,
              itemBuilder: (context, index) {
                final planetKey = planets.keys.elementAt(index);
                final planet = planets[planetKey]!;
                return _buildPlanetPositionCard(planet, index);
              },
            ),
          ],
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildPlanetaryTableHeader() {
    const labels = ['Planet', 'Sign', 'Degree', 'Nakshatra', 'House'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#FF8A3D".toColor(),
            "#ed6f30".toColor(),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[0],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          for (int i = 1; i < labels.length; i++)
            Expanded(
              child: AutoTranslateText(
                labels[i],
                style: MyTextTheme.smallBCB.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlanetPositionCard(Map<String, dynamic> planet, int index) {
    final isEven = index.isEven;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isEven
            ? "#ed6f30".toColor().withOpacity(0.04)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: "#ed6f30".toColor().withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildValueChip(planet['full_name'], true),
          _buildValueChip(planet['zodiac'], false),
          _buildValueChip(_formatDegree(planet['local_degree']), false),
          _buildValueChip(planet['nakshatra'], false),
          _buildValueChip(planet['house'], false),
        ],
      ),
    );
  }

  Widget _buildValueChip(dynamic value, [bool isPlanet = false]) {
    return Expanded(
      flex: isPlanet ? 2 : 1,
      child: AutoTranslateText(
        value?.toString() ?? '-',
        style: MyTextTheme.smallBCB.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: isPlanet ? FontWeight.w600 : FontWeight.w500,
          fontSize: 10.sp,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
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
