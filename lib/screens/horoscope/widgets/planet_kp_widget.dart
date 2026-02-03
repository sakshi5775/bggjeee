import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetKpWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const PlanetKpWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPlanetKp.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Planet KP Data...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.planetKpData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Planet KP data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(16),
            _buildPlanetTable(data),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.public_rounded,
              color: AppColors.golden,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Planet KP',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.golden,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Krishnamurti Paddhati',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.golden.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetTable(Map<String, dynamic> data) {
    // Handle if data is a list of planets
    List<Map<String, dynamic>> planets = [];
    if (data['planets'] is List) {
      planets = (data['planets'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } else if (data.entries.isNotEmpty) {
      // If data is a map of planet details
      data.forEach((key, value) {
        if (value is Map) {
          planets.add({'name': key, ...Map<String, dynamic>.from(value)});
        }
      });
    }

    if (planets.isEmpty) {
      // Show raw data as key-value pairs
      return _buildRawDataTable(data);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.table_chart_rounded,
                    color: Colors.white,
                    size: 18.w,
                  ),
                ),
                Spacing.w(10),
                Expanded(
                  child: AutoTranslateText(
                    'Planet Details',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Planet Rows
          ...planets.asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final planet = mapEntry.value;
            return _buildPlanetRow(index, planet);
          }),
        ],
      ),
    );
  }

  Widget _buildRawDataTable(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.table_chart_rounded,
                    color: Colors.white,
                    size: 18.w,
                  ),
                ),
                Spacing.w(10),
                Expanded(
                  child: AutoTranslateText(
                    'KP Details',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          ...data.entries.toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final entry = mapEntry.value;
            String displayValue = '';

            if (entry.value is List) {
              displayValue = (entry.value as List).join(', ');
            } else if (entry.value is Map) {
              displayValue = (entry.value as Map).entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(', ');
            } else {
              displayValue = entry.value?.toString() ?? '';
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.deepOrange.withOpacity(0.03),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AutoTranslateText(
                      _formatPropertyName(entry.key),
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AutoTranslateText(
                      displayValue,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlanetRow(int index, Map<String, dynamic> planet) {
    final planetName = planet['name']?.toString() ?? 'Unknown';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: index.isEven
            ? Colors.white
            : AppColors.deepOrange.withOpacity(0.03),
        border: Border(
          bottom: BorderSide(
            color: AppColors.deepOrange.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            planetName,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          ...planet.entries
              .where((e) => e.key != 'name' && e.value != null)
              .map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: AutoTranslateText(
                          _formatPropertyName(entry.key),
                          style: MyTextTheme.smallBCN.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: AutoTranslateText(
                          entry.value.toString(),
                          style: MyTextTheme.smallBCN.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  String _formatPropertyName(String key) {
    return key
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
