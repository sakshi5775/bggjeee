import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/numerology_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/predictions_table_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/daily_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/weekly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/monthly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/yearly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/ascendant_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/moon_sign_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/nakshatra_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/panchang_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/rudraksha_prediction_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/lal_kitab_predictions_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PredictionsView extends BasePage<PredictionsController> {
  const PredictionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Predictions'),
            _buildTabs(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  PredictionsTableWidget(controller: controller),
                  NumerologyWidget(controller: controller),
                  DailyPredictionWidget(controller: controller),
                  WeeklyPredictionWidget(controller: controller),
                  MonthlyPredictionWidget(controller: controller),
                  YearlyPredictionWidget(controller: controller),
                  AscendantPredictionWidget(controller: controller),
                  MoonSignPredictionWidget(controller: controller),
                  NakshatraPredictionWidget(controller: controller),
                  PanchangPredictionWidget(controller: controller),
                  RudrakshaPredictionWidget(controller: controller),
                  LalKitabPredictionsWidget(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
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
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepOrange.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Predictions',
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
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
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.deepOrange.withOpacity(
                                          0.25,
                                        ),
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
