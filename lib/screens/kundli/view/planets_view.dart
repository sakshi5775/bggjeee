import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/planets_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/planets_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetsView extends BasePage<PlanetsController> {
  const PlanetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Planet Consideration'),
            _buildTabs(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  _buildOverviewTab(),
                  _buildTransitTab(),
                  _buildDetailedReportTab(),
                  _buildWesternTab(),
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
    final tabs = ['Overview', 'Transit', 'Detailed', 'Western'];

    return Container(
      height: 48.h,
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
                    Icon(Icons.public, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Planets',
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
                                  : Border.all(color: maroon.withValues(alpha: 0.2)),
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

  Widget _buildOverviewTab() {
    return Obx(() {
      if (controller.isLoadingPlanetDetails.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: '#ed6f30'.toColor()),
              Spacing.h(16),
              AutoTranslateText(
                'Loading planet details...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#6F221E'.toColor().withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }
      if (controller.planetDetailsData.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.w,
                color: Colors.red.withValues(alpha: 0.7),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'No data available',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#6F221E'.toColor().withValues(alpha: 0.7),
                ),
              ),
              Spacing.h(16),
              ElevatedButton(
                onPressed: () => controller.fetchPlanetDetails(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: "#ed6f30".toColor(),
                  foregroundColor: Colors.white,
                ),
                child: AutoTranslateText('Retry'),
              ),
            ],
          ),
        );
      }
      return PlanetsWidget(
        controller: controller,
        aspectsData: controller.aspectsData.value,
      );
    });
  }

  Widget _buildTransitTab() {
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
                      items: PlanetsController.planetNames
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
                          controller.transitDatesData.value = null;
                          controller.fetchPlanetTransitDates(
                            v,
                            controller.selectedYear.value,
                          );
                        }
                      },
                    ),
                  ),
                  Spacing.w(10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: controller.selectedYear.value,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      items:
                          List.generate(10, (i) => DateTime.now().year - 5 + i)
                              .map(
                                (y) => DropdownMenuItem(
                                  value: y,
                                  child: AutoTranslateText('$y'),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          controller.selectedYear.value = v;
                          controller.transitDatesData.value = null;
                          controller.fetchPlanetTransitDates(
                            controller.selectedPlanet.value,
                            v,
                          );
                        }
                      },
                    ),
                  ),
                  Spacing.w(10),
                  IconButton(
                    icon: Icon(Icons.refresh, color: orange),
                    onPressed: () => controller.fetchPlanetTransitDates(
                      controller.selectedPlanet.value,
                      controller.selectedYear.value,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),
            if (controller.isLoadingTransit.value)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.h),
                  child: CircularProgressIndicator(color: orange),
                ),
              )
            else
              _buildTransitContent(),
          ],
        ),
      );
    });
  }

  Widget _buildTransitContent() {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);
    final data = controller.transitDatesData.value;
    final response = data?['response'] as Map<String, dynamic>?;
    final transitData = response?['transit_data'] as Map<String, dynamic>?;
    final planetName =
        response?['planet_name_en'] ??
        response?['planet_name'] ??
        controller.selectedPlanet.value;

    if (transitData == null || transitData.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: AutoTranslateText(
            'Select planet and year, then tap refresh to load transit dates.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: maroon.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    final entries = transitData.entries.toList()
      ..sort(
        (a, b) =>
            (int.tryParse(a.key) ?? 0).compareTo(int.tryParse(b.key) ?? 0),
      );
    final zodiacNames = [
      '',
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces',
    ];

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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A3D), orange],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  '$planetName Transit ${controller.selectedYear.value}',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(10),
          ...entries.map((e) {
            final m = e.value as Map<String, dynamic>;
            final date = m['date']?.toString() ?? '';
            final retro = m['retro'] as bool? ?? false;
            final zodiacNo = m['zodiac_no'];
            final zodiac =
                zodiacNo != null &&
                    zodiacNo is int &&
                    zodiacNo >= 1 &&
                    zodiacNo <= 12
                ? zodiacNames[zodiacNo]
                : '';
            final globalDegrees = m['global_degrees'];
            final degStr = globalDegrees is num
                ? '${globalDegrees.toStringAsFixed(1)}Â°'
                : globalDegrees?.toString() ?? '';
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: maroon.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: orange.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (retro)
                        Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Icon(Icons.replay, size: 14.w, color: orange),
                        ),
                      Expanded(
                        child: AutoTranslateText(
                          date,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: maroon,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      if (zodiac.isNotEmpty)
                        AutoTranslateText(
                          zodiac,
                          style: MyTextTheme.smallBCB.copyWith(
                            color: maroon,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                          ),
                        ),
                    ],
                  ),
                  if (degStr.isNotEmpty) ...[
                    Spacing.h(4),
                    AutoTranslateText(
                      'Position: $degStr',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: maroon.withValues(alpha: 0.8),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWesternTab() {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);

    return Obx(() {
      if (controller.isLoadingWesternPlanetDetails.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: orange),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Western chart...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: maroon.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }
      final western = controller.westernPlanetDetailsData.value;
      if (western == null || western.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.public, size: 48.w, color: maroon.withValues(alpha: 0.5)),
              Spacing.h(12),
              AutoTranslateText(
                'Western planet details require birth data.',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: maroon.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              Spacing.h(8),
              ElevatedButton(
                onPressed: () => controller.fetchWesternPlanetDetails(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                ),
                child: AutoTranslateText('Retry'),
              ),
            ],
          ),
        );
      }

      final keys = [
        'ascendant',
        'sun',
        'moon',
        'mercury',
        'venus',
        'mars',
        'jupiter',
        'saturn',
        'uranus',
        'neptune',
        'pluto',
        'chiron',
        'lilith',
        'midheaven',
        'sirius',
        'northnode',
        'southnode',
        'fortune',
      ];
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A3D), orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.public, size: 18.w, color: Colors.white),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Western Chart (Sidereal)',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),
            ...keys.where((k) => western[k] != null).map((key) {
              final m = western[key] as Map<String, dynamic>;
              final name =
                  m['full_name']?.toString() ?? m['name']?.toString() ?? key;
              final symbol =
                  m['symbol']?.toString() ??
                  m['zodiac_symbol']?.toString() ??
                  '';
              final zodiac = m['zodiac']?.toString() ?? '';
              final house = m['house']?.toString() ?? '';
              final element = m['zodiac_element']?.toString() ?? '';
              final quality = m['zodiac_quality']?.toString() ?? '';
              final isRetro = m['is_retro'] as bool? ?? false;
              final localDeg = m['local_degree'];
              final globalDeg = m['global_degree'];
              final localDegStr = localDeg is num
                  ? '${localDeg.toStringAsFixed(1)}Â°'
                  : '';
              final globalDegStr = globalDeg is num
                  ? '${globalDeg.toStringAsFixed(1)}Â°'
                  : '';
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
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
                    if (isRetro)
                      Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Icon(Icons.replay, size: 14.w, color: orange),
                      ),
                    if (symbol.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Text(symbol, style: TextStyle(fontSize: 14.sp)),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            name,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: maroon,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          if (zodiac.isNotEmpty || house.isNotEmpty)
                            AutoTranslateText(
                              '$zodiac${house.isNotEmpty ? ' â€¢ House $house' : ''}',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: maroon.withValues(alpha: 0.8),
                                fontSize: 11.sp,
                              ),
                            ),
                          if (element.isNotEmpty || quality.isNotEmpty)
                            AutoTranslateText(
                              '$element${quality.isNotEmpty ? ' â€¢ $quality' : ''}',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: maroon.withValues(alpha: 0.6),
                                fontSize: 10.sp,
                              ),
                            ),
                          if (localDegStr.isNotEmpty ||
                              globalDegStr.isNotEmpty) ...[
                            AutoTranslateText(
                              [
                                if (localDegStr.isNotEmpty)
                                  'Local: $localDegStr',
                                if (globalDegStr.isNotEmpty)
                                  'Global: $globalDegStr',
                              ].join(' | '),
                              style: MyTextTheme.smallBCN.copyWith(
                                color: maroon.withValues(alpha: 0.6),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildDetailedReportTab() {
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
              child: DropdownButtonFormField<String>(
                value: controller.selectedPlanet.value,
                decoration: InputDecoration(
                  labelText: 'Select Planet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
                items: PlanetsController.planetNames
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
                    controller.detailedReportData.value = null;
                    controller.fetchDetailedPlanetReport(v);
                  }
                },
              ),
            ),
            Spacing.h(10),
            if (controller.isLoadingDetailedReport.value)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.h),
                  child: CircularProgressIndicator(color: orange),
                ),
              )
            else
              _buildDetailedReportContent(),
          ],
        ),
      );
    });
  }

  Widget _buildDetailedReportContent() {
    const maroon = Color(0xFF6F221E);
    final response = controller.detailedReportData.value;

    if (response == null || response.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: AutoTranslateText(
            'Select a planet to view detailed report.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: maroon.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    final planetName = response['planet_name']?.toString() ?? '';
    final zodiacName = response['zodiac_name']?.toString() ?? '';
    final house = response['house'];
    final houseContent = response['house_content']?.toString() ?? '';
    final zodiacContent = response['zodiac_content']?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (houseContent.isNotEmpty)
          _compactCard('House $house - $zodiacName', houseContent, Icons.home),
        Spacing.h(10),
        if (zodiacContent.isNotEmpty)
          _compactCard('$planetName in $zodiacName', zodiacContent, Icons.star),
      ],
    );
  }

  Widget _compactCard(String title, String content, IconData icon) {
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


