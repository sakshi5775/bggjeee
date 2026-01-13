import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/predictions_table_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/numerology_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/daily_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/weekly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/monthly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/yearly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ascendant_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/moon_sign_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/nakshatra_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/panchang_prediction_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PredictionsView extends BasePage<PredictionsController> {
  const PredictionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Tabs (always visible when not in table view)
            Obx(() {
              if (controller.selectedTabIndex.value == -1) {
                return SizedBox.shrink();
              }
              return _buildTabs();
            }),
            
            // Content
            Expanded(
              child: Obx(() {
                // Show table view if selectedTabIndex is -1
                if (controller.selectedTabIndex.value == -1) {
                  return PredictionsTableWidget(controller: controller);
                }
                // Otherwise show swipeable PageView for tabs
                return PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    NumerologyWidget(controller: controller),
                    DailyPredictionWidget(controller: controller),
                    WeeklyPredictionWidget(controller: controller),
                    MonthlyPredictionWidget(controller: controller),
                    YearlyPredictionWidget(controller: controller),
                    AscendantPredictionWidget(controller: controller),
                    MoonSignPredictionWidget(controller: controller),
                    NakshatraPredictionWidget(controller: controller),
                    PanchangPredictionWidget(controller: controller),
                  ],
                );
              }),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            '#FF6B35'.toColor(),
            '#FF8C42'.toColor(),
          ],
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
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
            onPressed: () => Get.back(),
          ),
          
          Spacing.w(8),
          
          // Title
          Expanded(
            child: AutoTranslateText(
              'Predictions',
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('NUMEROLOGY', 0),
            _buildTab('DAILY', 1),
            _buildTab('WEEKLY', 2),
            _buildTab('MONTHLY', 3),
            _buildTab('YEARLY', 4),
            _buildTab('ASCENDANT', 5),
            _buildTab('MOON SIGN', 6),
            _buildTab('NAKSHATRA', 7),
            _buildTab('PANCHANG', 8),
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
            color: isSelected ? '#FF6B35'.toColor().withOpacity(0.1) : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? '#FF6B35'.toColor() : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
                      color: isSelected ? '#FF6B35'.toColor() : '#3E2723'.toColor().withOpacity(0.6),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ).merge(AppTypography.body2),
          ),
        ),
      );
    });
  }
}

