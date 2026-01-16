import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/dasha_table_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/vimshottari_dasha_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/mahadasha_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/current_mahadasha_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/yogini_dasha_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class DashaView extends BasePage<DashaController> {
  const DashaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: '#FFF8E1'.toColor(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ['#FFF6C2'.toColor(), '#FFF9E5'.toColor()],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Tabs (always visible)
              _buildTabs(),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ['#3D0C11'.toColor(), '#5D1C21'.toColor()],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: "#E3B341".toColor(),
              size: 24.w,
            ),
            onPressed: () {
              if (controller.selectedTabIndex.value != 0) {
                controller.navigateToDashaTab();
              } else {
                Get.back();
              }
            },
          ),

          Spacing.w(8),

          // Title
          Expanded(
            child: AutoTranslateText(
              'Dasha',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: "#E3B341".toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.h2),
            ),
          ),
        ],
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('DASHA', 0),
            _buildTab('VIMSHOTTARI DASHA', 1),
            _buildTab('MAHADASHA', 2),
            _buildTab('CURRENT MAHADASHA', 3),
            _buildTab('YOGINI DASHA', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Obx(() {
      final isSelected = controller.selectedTabIndex.value == index;

      return GestureDetector(
        onTap: () {
          controller.onTabSelected(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected
                ? '#FF6B35'.toColor().withOpacity(0.1)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? '#FF6B35'.toColor() : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: isSelected
                      ? '#FF6B35'.toColor()
                      : '#3E2723'.toColor().withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                )
                .merge(AppTypography.body1),
          ),
        ),
      );
    });
  }
}
