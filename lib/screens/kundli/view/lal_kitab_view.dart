import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kundli_header.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_table_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_kundli_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_remedies_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_debts_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_varshphal_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_houses_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_planets_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_chart_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Lal Kitab view – same design as Kundli Result: KundliHeader, gradient, drawer, horizontal tabs.
class LalKitabView extends BasePage<LalKitabController> {
  const LalKitabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FFF6C2'.toColor(), '#FFF9E5'.toColor()],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        drawer: UserDashboardView.buildDrawer(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ['#FFF6C2'.toColor(), '#FFF9E5'.toColor()],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                KundliHeader(title: 'Lal Kitab'),
                _buildTabs(),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.tabNames.length,
                    itemBuilder: (context, index) {
                      return RefreshIndicator(
                        onRefresh: () async {
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

  Widget _buildTabs() {
    const orange = Color(0xFFed6f30);
    const orangeLight = Color(0xFFFF8A3D);
    const maroon = Color(0xFF6F221E);

    return Container(
      height: 48.h,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelectedTab(selectedIndex);
        });

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
                    Icon(Icons.menu_book_rounded, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Lal Kitab',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 4.w),
                    ...controller.tabNames.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;
                      final isSelected = selectedIndex == index;
                      if (!controller.tabKeys.containsKey(index)) {
                        controller.tabKeys[index] = GlobalKey();
                      }
                      final tabKey = controller.tabKeys[index]!;

                      return Padding(
                        key: tabKey,
                        padding: EdgeInsets.only(right: 6.w),
                        child: GestureDetector(
                          onTap: () => controller.onTabSelected(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected ? orange : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: maroon.withOpacity(0.2),
                                      width: 1,
                                    ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: orange.withOpacity(0.25),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: AutoTranslateText(
                                tab,
                                textAlign: TextAlign.center,
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: isSelected ? Colors.white : maroon,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 12.sp,
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

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return LalKitabTableWidget(controller: controller);
      case 1:
        return LalKitabKundliWidget(controller: controller);
      case 2:
        return LalKitabRemediesWidget(controller: controller);
      case 3:
        return LalKitabDebtsWidget(controller: controller);
      case 4:
        return LalKitabVarshphalWidget(controller: controller);
      case 5:
        return LalKitabHousesWidget(controller: controller);
      case 6:
        return LalKitabPlanetsWidget(controller: controller);
      case 7:
        return LalKitabChartWidget(controller: controller);
      default:
        return LalKitabTableWidget(controller: controller);
    }
  }

  void _scrollToSelectedTab(int selectedIndex) {
    final tabKey = controller.tabKeys[selectedIndex];
    if (tabKey?.currentContext != null) {
      Scrollable.ensureVisible(
        tabKey!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }
}
