import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/shodashvarga_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/division_chart_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShodashvargaView extends BasePage<ShodashvargaController> {
  const ShodashvargaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Shodashvarga'),
            _buildTabs(),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.tabs.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDivisionsTable(),
                          Spacing.h(12),
                          const ConsultAstrologerCard(),
                          Spacing.h(12),
                        ],
                      ),
                    );
                  }
                  final division = controller.tabs[index];
                  // Obx ensures chart appears as soon as fetch completes (svgDataMap updates)
                  return Obx(() {
                    final svgData = controller.getSvgDataForDivision(division);
                    return DivisionChartWidget(
                      svgData: svgData,
                      divisionName: division,
                    );
                  });
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
    const maroon = Color(0xFF6F221E);

    return Container(
      color: Colors.transparent,
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
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_module, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Divisions',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 4.w),
                    ...controller.tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;
                      final isSelected = selectedIndex == index;
                      return Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: GestureDetector(
                          onTap: () => controller.onTabSelected(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppColors.orangeGradient
                                  : null,
                              borderRadius: BorderRadius.circular(12.r),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: maroon.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                            ),
                            child: Center(
                              child: AutoTranslateText(
                                tab,
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: isSelected ? Colors.white : maroon,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
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

  Widget _planetCard({required Widget child}) {
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

  Widget _buildDivisionsTable() {
    return _planetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitleRow('Shodashvarga', Icons.table_chart_rounded),
          _buildTableHeader(const ['Division', 'Code', 'Description']),
          ...controller.divisions.asMap().entries.map((entry) {
            final index = entry.key;
            final division = entry.value;
            return _buildDivisionRow(division, index);
          }),
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
            flex: 2,
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
            flex: 1,
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
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[2],
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

  Widget _buildDivisionRow(Map<String, dynamic> division, int index) {
    final isEven = index.isEven;
    return GestureDetector(
      onTap: () => controller.onDivisionTap(division['code'] as String),
      child: Container(
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
              flex: 2,
              child: _cell(division['name'] as String, isBold: true),
            ),
            Expanded(
              flex: 1,
              child: _cell(
                division['code'] as String,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: _cell(
                division['description'] as String,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell(
    String text, {
    bool isBold = false,
    TextAlign textAlign = TextAlign.left,
  }) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: '#6F221E'.toColor(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 10.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
