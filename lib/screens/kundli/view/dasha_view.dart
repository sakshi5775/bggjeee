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

class DashaView extends BasePage<DashaController> {
  const DashaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: '#FFF8E1'.toColor(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF6C2), Color(0xFFFFE8A3), Color(0xFFFFD580)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
              // Expanded(
              //   child: PageView(
              //     controller: controller.pageController,
              //     onPageChanged: controller.onPageChanged,
              //     children: [
              //       pageCard(child: DashaTableWidget(controller: controller)),
              //       pageCard(child: VimshottariDashaWidget(controller: controller)),
              //       pageCard(child: MahadashaWidget(controller: controller)),
              //       pageCard(child: CurrentMahadashaWidget(controller: controller)),
              //       pageCard(child: YoginiDashaWidget(controller: controller)),
              //     ],
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      cardWrap(DashaTableWidget(controller: controller)),

                      Spacing.h(16),

                      cardWrap(VimshottariDashaWidget(controller: controller)),

                      Spacing.h(16),

                      cardWrap(MahadashaWidget(controller: controller)),

                      Spacing.h(16),

                      cardWrap(CurrentMahadashaWidget(controller: controller)),

                      Spacing.h(16),

                      cardWrap(YoginiDashaWidget(controller: controller)),

                      Spacing.h(24), // bottom breathing space
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
          colors: [Color(0xFF3D0C11), Color(0xFF5D1C21)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFF7C443), size: 24.w),
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
                    color: Color(0xFFF7C443),
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
      padding: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
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
        // child: Container(
        //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(30.r),
        //     color: isSelected
        //         ? '#FF6B35'.toColor().withOpacity(0.1)
        //         : const Color(0x00F8F7F7),
        //     border: Border(
        //       bottom: BorderSide(
        //         color: isSelected ? '#FF6B35'.toColor() : Colors.transparent,
        //         width: 3,
        //       ),
        //     ),
        //   ),
        //   child: AutoTranslateText(
        //     title,
        //     style: MyTextTheme.mediumBCB
        //         .copyWith(
        //           color: isSelected
        //               ? '#FF6B35'.toColor()
        //               : '#3E2723'.toColor().withOpacity(0.6),
        //           fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        //         )
        //         .merge(AppTypography.body1),
        //   ),
        // ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: isSelected
                ? '#FF6B35'.toColor().withOpacity(0.15)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? '#FF6B35'.toColor()
                  : '#FF6B35'.toColor().withOpacity(0.25),
              width: 1.2,
            ),
          ),
          child: AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: isSelected
                      ? '#FF6B35'.toColor()
                      : '#3E2723'.toColor().withOpacity(0.65),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                )
                .merge(AppTypography.body1),
          ),
        ),
      );
    });
  }
}

Widget cardWrap(Widget child) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: child,
  );
}
