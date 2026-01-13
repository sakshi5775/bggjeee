import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/shodashvarga_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/division_chart_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShodashvargaView extends BasePage<ShodashvargaController> {
  const ShodashvargaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Tabs Slider
            _buildTabs(),
            
            // Content - PageView for swipeable tabs
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.tabs.length,
                itemBuilder: (context, index) {
                  // Show table for SHODASHVARGA tab (index 0)
                  if (index == 0) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: _buildDivisionsTable(),
                    );
                  }
                  
                  // For other tabs, show chart
                  final division = controller.tabs[index];
                  final svgData = controller.getSvgDataForDivision(division);
                  
                  return DivisionChartWidget(
                    svgData: svgData,
                    divisionName: division,
                  );
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: "#6F221E".toColor(),
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
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
            onPressed: () => Get.back(),
          ),
          
          Spacing.w(8),
          
          // Title
          Expanded(
            child: AutoTranslateText(
              'Shodashvarga',
              style: MyTextTheme.largeBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
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
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: isSelected ? '#FF6B35'.toColor() : '#3E2723'.toColor().withOpacity(0.6),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ).merge(AppTypography.body1),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }


  Widget _buildDivisionsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: '#FF6B35'.toColor().withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Division',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: AutoTranslateText(
                    'Code',
                    textAlign: TextAlign.center,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Description',
                    textAlign: TextAlign.center,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table Rows
          ...controller.divisions.asMap().entries.map((entry) {
            final index = entry.key;
            final division = entry.value;
            final isLast = index == controller.divisions.length - 1;
            
            return GestureDetector(
              onTap: () => controller.onDivisionTap(division['code'] as String),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isLast ? Colors.transparent : '#FF6B35'.toColor().withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AutoTranslateText(
                        division['name'] as String,
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.w500,
                        ).merge(AppTypography.body1),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AutoTranslateText(
                        division['code'] as String,
                        textAlign: TextAlign.center,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#FF6B35'.toColor(),
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.body1),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AutoTranslateText(
                        division['description'] as String,
                        textAlign: TextAlign.center,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: '#3E2723'.toColor().withOpacity(0.7),
                        ).merge(AppTypography.body2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
