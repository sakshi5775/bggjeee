import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/dasha_table_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/vimshottari_dasha_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/mahadasha_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/current_mahadasha_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/yogini_dasha_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashaView extends BasePage<DashaController> {
  const DashaView({super.key});

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
                const CommonHeader(title: 'Dasha'),
                _buildTabs(),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      DashaTableWidget(controller: controller),
                      VimshottariDashaWidget(controller: controller),
                      MahadashaWidget(controller: controller),
                      CurrentMahadashaWidget(controller: controller),
                      YoginiDashaWidget(controller: controller),
                    ],
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
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timeline, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Dasha Report',
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
                    _buildTab('DASHA', 0, selectedIndex, orange, maroon),
                    SizedBox(width: 6.w),
                    _buildTab(
                      'VIMSHOTTARI DASHA',
                      1,
                      selectedIndex,
                      orange,
                      maroon,
                    ),
                    SizedBox(width: 6.w),
                    _buildTab('MAHADASHA', 2, selectedIndex, orange, maroon),
                    SizedBox(width: 6.w),
                    _buildTab(
                      'CURRENT MAHADASHA',
                      3,
                      selectedIndex,
                      orange,
                      maroon,
                    ),
                    SizedBox(width: 6.w),
                    _buildTab('YOGINI DASHA', 4, selectedIndex, orange, maroon),
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
                : Border.all(color: maroon.withOpacity(0.2), width: 1),
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

    // Try to use Scrollable.ensureVisible for accurate scrolling
    final tabKey = controller.tabKeys[selectedIndex];
    if (tabKey?.currentContext != null) {
      final context = tabKey!.currentContext!;
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable != null) {
        final renderObject = context.findRenderObject();
        if (renderObject is RenderBox) {
          // Use ensureVisible to scroll the tab into view
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.5, // Center the tab
          );
          return;
        }
      }
    }

    // Fallback: Calculate position by measuring actual tab widths
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final tabs = [
        'DASHA',
        'VIMSHOTTARI DASHA',
        'MAHADASHA',
        'CURRENT MAHADASHA',
        'YOGINI DASHA',
      ];

      double totalWidth = 4.w; // initial SizedBox before tabs
      for (int i = 0; i < selectedIndex; i++) {
        final key = controller.tabKeys[i];
        if (key?.currentContext != null) {
          final renderBox =
              key!.currentContext!.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            totalWidth += renderBox.size.width + 6.w; // tab width + spacing
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
        if (renderBox != null) {
          selectedTabWidth = renderBox.size.width;
        }
      }

      if (selectedTabWidth == 0) {
        // Fallback estimation
        final selectedTabName = tabs[selectedIndex];
        selectedTabWidth = 44.0 + (selectedTabName.length * 9.0);
      }

      // Calculate position to center the selected tab
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
