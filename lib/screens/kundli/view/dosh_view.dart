import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/dosh_table_widget.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kaalsarp_dosh_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/mangal_dosh_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/pitra_dosh_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DoshView extends BasePage<DoshController> {
  const DoshView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Dosh Report', showDrawer: true, showEndDrawer: false),
            _buildTabs(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  DoshTableWidget(controller: controller),
                  MangalDoshWidget(controller: controller),
                  KaalsarpDoshWidget(controller: controller),
                  PitraDoshWidget(controller: controller),
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

    return Container(
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
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 14.h,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Dosh Report',
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
                    _buildTab('Overview', 0, selectedIndex, orange, maroon),
                    SizedBox(width: 6.w),
                    _buildTab(
                      'MANGAL/MANGLIK DOSH',
                      1,
                      selectedIndex,
                      orange,
                      maroon,
                    ),
                    SizedBox(width: 6.w),
                    _buildTab(
                      'KAALSARP DOSH',
                      2,
                      selectedIndex,
                      orange,
                      maroon,
                    ),
                    SizedBox(width: 6.w),
                    _buildTab('PITRA DOSH', 3, selectedIndex, orange, maroon),
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

  Widget _buildTab(
    String title,
    int index,
    int selectedIndex,
    Color orange,
    Color maroon,
  ) {
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
            gradient: isSelected ? AppColors.orangeGradient : null,
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? null
                : Border.all(color: maroon.withValues(alpha: 0.2), width: 1),
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
          child: Center(
            child: AutoTranslateText(
              title,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(
                color: isSelected ? Colors.white : maroon,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSelectedTab(int selectedIndex) {
    final scrollController = controller.tabsScrollController;
    if (!scrollController.hasClients) return;

    final tabKey = controller.tabKeys[selectedIndex];
    if (tabKey?.currentContext != null) {
      Scrollable.ensureVisible(
        tabKey!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      final tabs = [
        'Overview',
        'MANGAL/MANGLIK DOSH',
        'KAALSARP DOSH',
        'PITRA DOSH',
      ];
      double totalWidth = 4.w;
      for (int i = 0; i < selectedIndex; i++) {
        final key = controller.tabKeys[i];
        if (key?.currentContext != null) {
          final renderBox =
              key!.currentContext!.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            totalWidth += renderBox.size.width + 6.w;
          } else {
            totalWidth += 44.0 + (tabs[i].length * 9.0) + 6.w;
          }
        } else {
          totalWidth += 44.0 + (tabs[i].length * 9.0) + 6.w;
        }
      }
      final viewportWidth = scrollController.position.viewportDimension;
      final selectedKey = controller.tabKeys[selectedIndex];
      double selectedTabWidth = 0;
      if (selectedKey?.currentContext != null) {
        final renderBox =
            selectedKey!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) selectedTabWidth = renderBox.size.width;
      }
      if (selectedTabWidth == 0) {
        selectedTabWidth = 44.0 + (tabs[selectedIndex].length * 9.0);
      }
      final targetPosition =
          totalWidth - (viewportWidth / 2) + (selectedTabWidth / 2);
      scrollController.animateTo(
        targetPosition.clamp(0.0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
