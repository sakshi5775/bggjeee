import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ascendant_report_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/shad_bala_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ashtakvarga_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ashtakvarga_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/binnashtakvarga_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/birth_details_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/chalit_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/divisional_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/daily_panchang_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lagna_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/planets_tab_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/moon_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/navamsha_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/sun_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/transit_chart_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KundliResultView extends BasePage<KundliResultController> {
  const KundliResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        drawer: UserDashboardView.buildDrawer(context),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Kundli Report'),
            _buildTabs(),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.visibleTabIndices.length,
                itemBuilder: (context, index) {
                  final fullIndex = controller.visibleTabIndices[index];
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.onTabSelected(fullIndex);
                    },
                    child: _buildTabContent(fullIndex),
                  );
                },
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

    return Container(
      height: 56.h,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Obx(() {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: CachedNetworkImage(
                        imageUrl: AppConstant.serviceGenerateKundali,
                        width: 24.w,
                        height: 24.w,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Center(
                            child: SizedBox(
                              width: 12.w,
                              height: 12.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Icon(
                          Icons.auto_stories_rounded,
                          size: 14.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Kundli Report',
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
              child: CommonTabSlider(
                tabs: controller.visibleTabIndices
                    .map((i) => controller.tabs[i])
                    .toList(),
                selectedIndex: controller.visibleTabIndices.indexOf(
                  controller.selectedTabIndex.value,
                ),
                onTabSelected: (index) {
                  controller.onTabSelected(controller.visibleTabIndices[index]);
                },
                scrollController: controller.tabsScrollController,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Features',
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          // Spacing.h(6),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 4 : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 6.w,
                  mainAxisSpacing: 6.h,
                ),
                itemCount: controller.featureGridItems.length,
                itemBuilder: (context, index) {
                  final item = controller.featureGridItems[index];
                  return _buildFeatureCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    imageUrl: item['imageUrl'] as String?,
                    pricingKey: item['pricingKey'] as String? ?? '',
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
    String? imageUrl,
    String pricingKey = '',
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Use SizedBox.expand so Container fills the grid cell
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.deepOrange.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => Center(
                          child: SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.deepOrange,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Icon(
                          Icons.image_not_supported,
                          color: AppColors.textLight,
                          size: 22.w,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: AppColors.textLight, size: 18.w),
                    ),
                  Spacing.h(4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: AutoTranslateText(
                      title,
                      textAlign: TextAlign.center,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Paid badge
          if (pricingKey.isNotEmpty) _buildPaidBadge(pricingKey),
        ],
      ),
    );
  }

  Widget _buildPaidBadge(String pricingKey) {
    if (!Get.isRegistered<AiPricingController>()) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      final pricingCtrl = Get.find<AiPricingController>();
      final pricing = pricingCtrl.getPricingFor(pricingKey);
      if (pricing == null) return const SizedBox.shrink();

      final price = pricingCtrl.getDisplayPrice(pricingKey);
      final badgeText = price.isNotEmpty ? price : 'Paid';

      return Positioned(
        top: -4.h,
        right: -4.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFF6B35), const Color(0xFFF38B3B)],
            ),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            badgeText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFeatureList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dividerLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'More Features',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                Obx(() {
                  final allFeatures = [
                    ...controller.leftColumnFeatures,
                    ...controller.rightColumnFeatures,
                  ];
                  if (allFeatures.length <= 5) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () => controller.showAllFeatures.toggle(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.deepOrange.withValues(alpha: 0.5),
                        ),
                      ),
                      child: AutoTranslateText(
                        controller.showAllFeatures.value
                            ? 'Show Less'
                            : 'View All',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            Spacing.h(6),
            Obx(() {
              final allFeatures = [
                ...controller.leftColumnFeatures,
                ...controller.rightColumnFeatures,
              ];
              final displayedFeatures = controller.showAllFeatures.value
                  ? allFeatures
                  : allFeatures.take(5).toList();

              return Column(
                children: displayedFeatures
                    .map(
                      (feature) => _buildFeatureListItem(
                        title: feature,
                        onTap: () => controller.onFeatureTap(feature),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  static String? _featureListImageUrl(String title) {
    final t = title.toLowerCase();
    if (t == 'panchang') return AppConstant.servicePanchang;
    return null;
  }

  Widget _buildFeatureListItem({
    required String title,
    required VoidCallback onTap,
  }) {
    final imageUrl = _featureListImageUrl(title);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cardLight, const Color(0xFFFFF8F0)],
          ),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.dividerLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => SizedBox(width: 28.w, height: 28.w),
                  errorWidget: (_, __, ___) =>
                      SizedBox(width: 28.w, height: 28.w),
                ),
              ),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  // fontSize: 13.sp,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.deepOrange,
              size: 12.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFeatures() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Additional Features',
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          Spacing.h(6),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 4 : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 6.w,
                  mainAxisSpacing: 6.h,
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
          border: Border.all(
            color: AppColors.deepOrange.withValues(alpha: 0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.textLight, size: 18.w),
            ),
            Spacing.h(4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
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

    // Show Planets tab: header + slider bar + PlanetsWidget below
    if (tabName == 'planets') {
      return PlanetsTabWidget(controller: controller);
    }

    // Show Ascendant Report when ASCENDANT REPORT tab is selected
    if (tabName == 'summary(lagna) report') {
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

    // Varshphal opens as standalone page (see onFeatureTap)

    // Show Shad Bala when Shad Bala tab is selected
    if (tabName == 'shad bala') {
      return ShadBalaWidget(controller: controller);
    }

    // Show "Coming Soon" for additional features tabs
    final additionalFeaturesTabs = [
      'bhav madhya',
      'person details',
      'ghatak and favourable',
      'reports',
      'friendship',
      'avkahada chakra',
      'download pdf',
    ];

    if (additionalFeaturesTabs.contains(tabName)) {
      return _buildComingSoonContent(tabName);
    }

    // Show features for other tabs
    return _buildOtherTabsContent();
  }

  Widget _buildComingSoonContent(String tabName) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hourglass_empty,
                color: Colors.white,
                size: 36.w,
              ),
            ),
            Spacing.h(16),
            AutoTranslateText(
              'Coming Soon',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'This feature is under development.\nWe will notify you when it\'s ready!',
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherTabsContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureGrid(),
          Spacing.h(1),
          //  _buildAdditionalFeatures(),

          // Spacing.h(12),
          _buildFeatureList(),
          Spacing.h(12),
        ],
      ),
    );
  }
}


