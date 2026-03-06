import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Merged widget showing both Planet Significations and House Significators
class KpSignificationsMergedWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpSignificationsMergedWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoadingPlanet = controller.isLoadingKpPlanetSignifications.value;
      final isLoadingHouse = controller.isLoadingKpHouseSignificators.value;
      final isLoading = isLoadingPlanet || isLoadingHouse;

      if (isLoading) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final planetData = controller.kpPlanetSignificationsData.value;
      final houseData = controller.kpHouseSignificatorsData.value;

      final planetResponse =
          planetData?['data']?['response'] as Map<String, dynamic>?;
      final houseResponse =
          houseData?['data']?['response'] as Map<String, dynamic>?;

      final hasPlanetData = planetResponse != null && planetResponse.isNotEmpty;
      final hasHouseData = houseResponse != null && houseResponse.isNotEmpty;

      if (!hasPlanetData && !hasHouseData) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Planet Significations Section
            if (hasPlanetData) ...[
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleRow('Planet Significations', Icons.layers),
                    _buildTableHeader(const ['Planet', 'Houses']),
                    ...planetResponse.entries.toList().asMap().entries.map(
                          (e) {
                            final planet = e.value.key;
                            final houses = e.value.value as List<dynamic>? ?? [];
                            final housesStr = houses.isEmpty
                                ? '--'
                                : houses.map((h) => h.toString()).join(', ');
                            return _buildTableRow(planet, housesStr, e.key);
                          },
                        ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],
            // House Significators Section
            if (hasHouseData) ...[
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleRow('House Significators', Icons.home_work_rounded),
                    _buildTableHeader(const ['House', 'Significators']),
                    ...houseResponse.entries.toList().asMap().entries.map(
                          (e) {
                            final house = e.value.key;
                            final planets = e.value.value as List<dynamic>? ?? [];
                            final planetsStr = planets.isEmpty
                                ? '--'
                                : planets.map((p) => p.toString()).join(', ');
                            return _buildTableRow(house, planetsStr, e.key);
                          },
                        ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCard({required Widget child}) {
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
        children: [
          Expanded(
            flex: labels[0] == 'House' ? 1 : 2,
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
            flex: labels[0] == 'House' ? 4 : 3,
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

  Widget _buildTableRow(String first, String second, int index) {
    final isEven = index.isEven;
    final isHouseRow = first.contains('House') || RegExp(r'^[0-9]+$').hasMatch(first);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
          Expanded(
            flex: isHouseRow ? 1 : 2,
            child: _cell(first, isBold: true),
          ),
          Expanded(
            flex: isHouseRow ? 4 : 3,
            child: _cell(second),
          ),
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
        fontSize: 11.sp,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
