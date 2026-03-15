import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/transit_today_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TransitTodayView extends BasePage<TransitTodayController> {
  const TransitTodayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Transit Today', showDrawer: true, showEndDrawer: false),
            _buildTabs(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  _buildPredictionTab(),
                  _buildTransitsTab(),
                  _buildChartTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    const orange = Color(0xFFed6f30);
    const orangeLight = Color(0xFFFF8A3D);
    const maroon = Color(0xFF6F221E);
    final tabs = ['Prediction', 'Transits', 'Chart'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [orangeLight, orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Transit',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.tabsScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    SizedBox(width: 4.w),
                    ...List.generate(tabs.length, (i) {
                      if (!controller.tabKeys.containsKey(i))
                        controller.tabKeys[i] = GlobalKey();
                      final isSelected = selectedIndex == i;
                      return Padding(
                        key: controller.tabKeys[i],
                        padding: EdgeInsets.only(right: 6.w),
                        child: GestureDetector(
                          onTap: () => controller.onTabSelected(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? orange : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: maroon.withValues(alpha: 0.2),
                                    ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: orange.withValues(alpha: 0.25),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: AutoTranslateText(
                              tabs[i],
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: isSelected ? Colors.white : maroon,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPredictionTab() {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);

    return Obx(() {
      if (controller.isLoadingPrediction.value) {
        return Center(child: CircularProgressIndicator(color: orange));
      }
      final data = controller.dailyPredictionData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'Generate Kundli first to view transit prediction.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: maroon.withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final planetSentence = data['planet_sentence']?.toString() ?? '';
      final totalScore = data['total_score'] as Map<String, dynamic>?;
      final totalText = totalScore?['split_response']?.toString() ?? '';
      final keys = [
        'physique',
        'health',
        'relationship',
        'career',
        'travel',
        'family',
        'friends',
        'finances',
        'status',
      ];

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (planetSentence.isNotEmpty)
              _compactCard(Icons.auto_awesome, 'Overview', planetSentence),
            Spacing.h(10),
            if (totalText.isNotEmpty)
              _compactCard(Icons.summarize, 'Summary', totalText),
            Spacing.h(10),
            ...keys.map((k) {
              final v = data[k] as Map<String, dynamic>?;
              if (v == null) return const SizedBox.shrink();
              final score = v['score'];
              final text = v['split_response']?.toString() ?? '';
              if (text.isEmpty) return const SizedBox.shrink();
              final label = k[0].toUpperCase() + k.substring(1);
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _compactCard(
                  Icons.star,
                  '$label${score != null ? ' ($score)' : ''}',
                  text,
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTransitsTab() {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);

    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: maroon.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedPlanet.value,
                      decoration: InputDecoration(
                        labelText: 'Planet',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      items: TransitTodayController.planetNames
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: AutoTranslateText(
                                p[0].toUpperCase() + p.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          controller.selectedPlanet.value = v;
                          controller.dailyTransitsData.value = null;
                          controller.fetchDailyTransits();
                        }
                      },
                    ),
                  ),
                  Spacing.w(10),
                  IconButton(
                    icon: Icon(Icons.refresh, color: orange),
                    onPressed: controller.refreshTransits,
                  ),
                ],
              ),
            ),
            Spacing.h(10),
            if (controller.isLoadingTransits.value)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.h),
                  child: CircularProgressIndicator(color: orange),
                ),
              )
            else
              _buildTransitsContent(),
          ],
        ),
      );
    });
  }

  Widget _buildTransitsContent() {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);
    final data = controller.dailyTransitsData.value;
    final list =
        data?['response'] as List<dynamic>? ?? data as List<dynamic>? ?? [];

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: AutoTranslateText(
            'Select planet and tap refresh to load daily transits.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: maroon.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((e) {
        final m = e as Map<String, dynamic>;
        final transitPlanet = m['transit_planet']?.toString() ?? '';
        final natalPlanet = m['natal_planet']?.toString() ?? '';
        final natalPlanetZodiac = m['natal_planet_zodiac']?.toString() ?? '';
        final aspect = m['aspect']?.toString() ?? '';
        final startTime = m['start_time']?.toString() ?? '';
        final endTime = m['end_time']?.toString() ?? '';
        final exactTime = m['exact_time']?.toString() ?? '';
        final startDegree = m['start_degree'];
        final endDegree = m['end_degree'];
        final startDegreeZodiac = m['start_degree_zodiac']?.toString() ?? '';
        final endDegreeZodiac = m['end_degree_zodiac']?.toString() ?? '';
        final isRetrograde = m['is_retrograde'] as bool? ?? false;
        final sd = startDegree is num
            ? startDegree.toStringAsFixed(1)
            : startDegree?.toString() ?? '';
        final ed = endDegree is num
            ? endDegree.toStringAsFixed(1)
            : endDegree?.toString() ?? '';
        final degreeStr = (sd.isNotEmpty || ed.isNotEmpty)
            ? '${sd.isNotEmpty ? '$sd°' : ''}${startDegreeZodiac.isNotEmpty ? ' $startDegreeZodiac' : ''}${sd.isNotEmpty && ed.isNotEmpty ? ' – ' : ''}${ed.isNotEmpty ? '$ed°' : ''}${endDegreeZodiac.isNotEmpty ? ' $endDegreeZodiac' : ''}'
                  .trim()
            : '';
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: maroon.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isRetrograde)
                    Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: Icon(Icons.replay, size: 14.w, color: orange),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A3D), orange],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: AutoTranslateText(
                      natalPlanetZodiac.isNotEmpty
                          ? '$transitPlanet → $natalPlanet ($natalPlanetZodiac)'
                          : '$transitPlanet → $natalPlanet',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    aspect,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: maroon,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              if (startTime.isNotEmpty || endTime.isNotEmpty) ...[
                Spacing.h(6),
                AutoTranslateText(
                  '$startTime – $endTime',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: maroon.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                  ),
                ),
              ],
              if (exactTime.isNotEmpty) ...[
                Spacing.h(4),
                AutoTranslateText(
                  'Exact: $exactTime',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: orange,
                    fontSize: 10.sp,
                  ),
                ),
              ],
              if (degreeStr.isNotEmpty &&
                  !degreeStr.contains('° – °') &&
                  degreeStr.length > 2) ...[
                Spacing.h(4),
                AutoTranslateText(
                  'Degrees: $degreeStr',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: maroon.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChartTab() {
    const orange = Color(0xFFed6f30);
    const maroon = Color(0xFF6F221E);

    return Obx(() {
      if (controller.isLoadingChart.value) {
        return Center(child: CircularProgressIndicator(color: orange));
      }
      final svg = controller.transitChartSvg.value;
      if (svg == null || svg.isEmpty) {
        final hasForm = controller.hasFormData;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoTranslateText(
                hasForm
                    ? 'Unable to load chart. Tap refresh to try again.'
                    : 'Generate Kundli first to view transit chart.',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: maroon.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              if (hasForm) ...[
                Spacing.h(12),
                IconButton(
                  icon: Icon(Icons.refresh, color: orange, size: 32.w),
                  onPressed: controller.refreshChart,
                ),
              ],
            ],
          ),
        );
      }

      try {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Center(
            child: SizedBox(
              width: 280.w,
              height: 280.w,
              child: SvgPicture.string(svg, fit: BoxFit.contain),
            ),
          ),
        );
      } catch (e) {
        return Center(
          child: AutoTranslateText(
            'Unable to display chart.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: const Color(0xFF6F221E).withValues(alpha: 0.6),
            ),
          ),
        );
      }
    });
  }

  Widget _compactCard(IconData icon, String title, String content) {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A3D), orange],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: Colors.white, size: 16.w),
              ),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: maroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(
              color: maroon,
              fontSize: 11.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
