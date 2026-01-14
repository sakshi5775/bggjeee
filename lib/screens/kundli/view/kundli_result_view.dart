import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ascendant_report_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ashtakvarga_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ashtakvarga_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/binnashtakvarga_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/birth_details_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/chalit_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/divisional_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/daily_panchang_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lagna_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/moon_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/navamsha_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/sun_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/transit_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/varshphal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class KundliResultView extends BasePage<KundliResultController> {
  const KundliResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF6C2), Color(0xFFFFE8A3), Color(0xFFFFD580)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        // backgroundColor: AppColors.lightBackground,
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.gradientBackground),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Tabs
                _buildTabs(),

                // Content
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.tabs.length,
                    itemBuilder: (context, index) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          // Refresh the current tab content
                          controller.onTabSelected(index);
                        },
                        child: _buildTabContent(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.turmericYellow,
                  size: 24.w,
                ),
              ),
            ),
            Spacing.w(16),
            // Title
            Expanded(
              child: AutoTranslateText(
                'Kundli Report',
                style: MyTextTheme.veryLargeBCB
                    .copyWith(
                      color: AppColors.turmericYellow,
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
            ),
            // Placeholder for future actions
            Opacity(
              opacity: 0,
              child: Icon(Icons.more_vert, color: AppColors.turmericYellow),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    final isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () => controller.onTabSelected(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.deepOrange.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected
                                  ? AppColors.deepOrange
                                  : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: isSelected
                                ? AppColors.deepOrange
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          child: AutoTranslateText(
                            tab,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Tab indicator
            Container(
              height: 6.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.tabs.length,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  // return _buildTabIndicator(index);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Features',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(8),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: controller.featureGridItems.length,
                itemBuilder: (context, index) {
                  final item = controller.featureGridItems[index];
                  return _buildFeatureCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    onTap: () =>
                        controller.onFeatureTap(item['title'] as String),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.deepOrange, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.textLight, size: 32.w),
            ),
            Spacing.h(8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.dividerLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and view all button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'More Features',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
                Obx(() {
                  final allFeatures = [
                    ...controller.leftColumnFeatures,
                    ...controller.rightColumnFeatures,
                  ];

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      // color: AppColors.cardLight,
                      gradient: LinearGradient(
                        colors: [AppColors.deepOrange, AppColors.error],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.deepOrange, width: 1),
                    ),
                    child: TextButton(
                      onPressed: allFeatures.length > 5
                          ? () {
                              controller.showAllFeatures.toggle();
                            }
                          : null,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: AutoTranslateText(
                        controller.showAllFeatures.value
                            ? 'Show Less'
                            : 'View All',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            Spacing.h(8),
            // Single column layout with view all functionality
            Obx(() {
              // Combine both left and right column features into a single list
              final allFeatures = [
                ...controller.leftColumnFeatures,
                ...controller.rightColumnFeatures,
              ];

              // Show only first 5 features by default
              final displayedFeatures = controller.showAllFeatures.value
                  ? allFeatures
                  : allFeatures.take(5).toList();

              return Column(
                children: [
                  ...displayedFeatures.map((feature) {
                    return _buildFeatureListItem(
                      title: feature,
                      onTap: () => controller.onFeatureTap(feature),
                    );
                  }).toList(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureListItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          // color: AppColors.cardLight,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cardLight, const Color(0xFFFFF8F0)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.dividerLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.deepOrange,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFeatures() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Additional Features',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(8),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: controller.additionalFeatures.length,
                itemBuilder: (context, index) {
                  final item = controller.additionalFeatures[index];
                  return _buildAdditionalFeatureCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    onTap: () =>
                        controller.onFeatureTap(item['title'] as String),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalFeatureCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          border: Border.all(color: AppColors.deepOrange, width: 1),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.textLight, size: 32.w),
            ),
            Spacing.h(8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    final tabName = controller.tabs[index].toLowerCase();

    // Show Basic chart (index 0)
    if (index == 0) {
      return _buildOtherTabsContent();
    }

    // Show SVG chart when LAGNA tab is selected
    if (index == 1) {
      return const LagnaChartWidget();
    }

    // Show Navamsha chart when NAVAMSHA tab is selected
    if (index == 2) {
      return const NavamshaChartWidget();
    }

    // Show Sun chart when SUN tab is selected
    if (index == 3) {
      return const SunChartWidget();
    }

    // Show Moon chart when MOON tab is selected
    if (index == 4) {
      return const MoonChartWidget();
    }

    // Show Chalit chart when BHAV-CHALIT tab is selected
    if (index == 5) {
      return const ChalitChartWidget();
    }

    // Show Birth Details when BIRTH DETAILS tab is selected
    if (tabName == 'birth details') {
      return BirthDetailsWidget(controller: controller);
    }

    // Show Ashtakvarga when ASHTAKVARGA tab is selected
    if (tabName == 'ashtakvarga') {
      return AshtakvargaWidget(controller: controller);
    }

    // Show Divisional Chart when DIVISIONAL CHART tab is selected
    if (tabName == 'divisional chart') {
      return DivisionalChartWidget(controller: controller);
    }

    // Show Planets tab - navigate to Planets screen (handled in controller)
    if (tabName == 'planets') {
      return _buildOtherTabsContent();
    }

    // Show Ascendant Report when ASCENDANT REPORT tab is selected
    if (tabName == 'ascendant report') {
      return AscendantReportWidget(controller: controller);
    }

    // Show Daily Panchang when PANCHANG tab is selected
    if (tabName == 'panchang') {
      return DailyPanchangWidget(controller: controller);
    }

    // Show Binnashtakvarga when BINNASHTAKVARGA tab is selected
    if (tabName == 'binnashtakvarga') {
      return BinnashtakvargaWidget(controller: controller);
    }

    // Show Transit chart when TRANSIT tab is selected
    if (tabName == 'transit') {
      return const TransitChartWidget();
    }

    // Show Ashtakvarga Chart when ASHTAKVARGA CHART tab is selected
    if (tabName == 'ashtakvarga chart') {
      return AshtakvargaChartWidget(controller: controller);
    }

    // Show Varshphal when VARSHPHAL tab is selected
    if (tabName == 'varshphal') {
      return VarshphalWidget(controller: controller);
    }

    // Show features for other tabs
    return _buildOtherTabsContent();
  }

  Widget _buildOtherTabsContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature Grid
          _buildFeatureGrid(),

          Spacing.h(20),

          // Feature List (2 columns)
          _buildFeatureList(),

          Spacing.h(20),

          // Additional Features Grid
          _buildAdditionalFeatures(),

          Spacing.h(16),
        ],
      ),
    );
  }

  // Enhanced tab indicator
  Widget _buildTabIndicator(int index) {
    return Obx(() {
      final isSelected = controller.selectedTabIndex.value == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? 30.w : 8.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepOrange : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2.r),
        ),
      );
    });
  }
}
