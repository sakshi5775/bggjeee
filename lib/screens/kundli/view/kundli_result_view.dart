import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
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

class KundliResultView extends BasePage<KundliResultController> {
  const KundliResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
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
                  return _buildTabContent(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            '#FF6B35'.toColor(),
            '#FF8C42'.toColor(),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            Spacing.w(16),
            // Title
            Expanded(
              child: AutoTranslateText(
                'Kundli',
                style: MyTextTheme.largeBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = selectedIndex == index;
              
              return GestureDetector(
                onTap: () => controller.onTabSelected(index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isSelected ? '#FF6B35'.toColor().withOpacity(0.1) : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? '#FF6B35'.toColor() : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: AutoTranslateText(
                    tab,
                    textAlign: TextAlign.center,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: isSelected ? '#FF6B35'.toColor() : '#3E2723'.toColor().withOpacity(0.6),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Features',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(12),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: controller.featureGridItems.length,
                itemBuilder: (context, index) {
                  final item = controller.featureGridItems[index];
                  return _buildFeatureCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    onTap: () => controller.onFeatureTap(item['title'] as String),
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
            gradient: LinearGradient(
            colors: [
              '#FF6B35'.toColor().withOpacity(0.9),
              '#FF8C42'.toColor().withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32.w,
            ),
            Spacing.h(8),
            AutoTranslateText(
              title,
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'More Features',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: controller.leftColumnFeatures.map((feature) {
                    return _buildFeatureListItem(
                      title: feature,
                      onTap: () => controller.onFeatureTap(feature),
                    );
                  }).toList(),
                ),
              ),
              Spacing.w(12),
              // Right column
              Expanded(
                child: Column(
                  children: controller.rightColumnFeatures.map((feature) {
                    return _buildFeatureListItem(
                      title: feature,
                      onTap: () => controller.onFeatureTap(feature),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
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
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: '#F5D7B8'.toColor().withOpacity(0.3),
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
        child: Row(
          children: [
            Expanded(
              child: AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: '#FF6B35'.toColor(),
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFeatures() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Additional Features',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(12),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: controller.additionalFeatures.length,
                itemBuilder: (context, index) {
                  final item = controller.additionalFeatures[index];
                  return _buildAdditionalFeatureCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    onTap: () => controller.onFeatureTap(item['title'] as String),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: '#F5D7B8'.toColor().withOpacity(0.3),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: '#FF6B35'.toColor(),
              size: 28.w,
            ),
            Spacing.h(8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.w500,
                ).merge(AppTypography.label),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature Grid
          _buildFeatureGrid(),
          
          Spacing.h(24),
          
          // Feature List (2 columns)
          _buildFeatureList(),
          
          Spacing.h(24),
          
          // Additional Features Grid
          _buildAdditionalFeatures(),
          
          Spacing.h(20),
        ],
      ),
    );
  }

}

