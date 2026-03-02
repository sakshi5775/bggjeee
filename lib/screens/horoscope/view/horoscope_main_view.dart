import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/ascendant_sign_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/current_sade_sati_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/daily_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/friendship_table_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/gem_suggestion_widget.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/key_points_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/monthly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/moon_sign_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/planet_kp_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/rudraksh_suggestion_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/sun_sign_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/weekly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/yearly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeMainView extends StatelessWidget {
  const HoroscopeMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HoroscopeMainController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            // Shared Header
            Obx(
              () => CommonHeader(
                title: controller.selectedSign.value ?? 'Horoscope',
                showDrawer: true,
              ),
            ),
            // Tab Slider
            _buildTabs(controller),

            // Tab Content with PageView for swipe
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.tabs.length,
                itemBuilder: (context, index) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.onTabChanged(index);
                    },
                    child: _buildTabContent(controller, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(HoroscopeMainController controller) {
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
            // Teaser Indicator
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: CachedNetworkImage(
                        imageUrl: AppConstant.horoscope,
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
                          Icons.insights_rounded,
                          size: 14.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Horoscope Result',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Tabs
            Expanded(
              child: SingleChildScrollView(
                controller: controller.tabScrollController,
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

                      if (!controller.tabKeys.containsKey(index)) {
                        controller.tabKeys[index] = GlobalKey();
                      }
                      final tabKey = controller.tabKeys[index]!;

                      return Padding(
                        key: tabKey,
                        padding: EdgeInsets.only(right: 6.w),
                        child: GestureDetector(
                          onTap: () => controller.onTabChanged(index),
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
                            ),
                            child: Center(
                              child: AutoTranslateText(
                                tab,
                                textAlign: TextAlign.center,
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: isSelected ? Colors.white : maroon,
                                  // fontWeight: isSelected
                                  //     ? FontWeight.w700
                                  //     : FontWeight.w500,
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

  Widget _buildTabContent(HoroscopeMainController controller, int index) {
    switch (index) {
      case 0:
        return KeyPointsWidget(controller: controller);
      case 1:
        return DailyPredictionWidget(controller: controller);
      case 2:
        return WeeklyPredictionWidget(controller: controller);
      case 3:
        return MonthlyPredictionWidget(controller: controller);
      case 4:
        return YearlyPredictionWidget(controller: controller);
      case 5:
        return MoonSignWidget(controller: controller);
      case 6:
        return SunSignWidget(controller: controller);
      case 7:
        return AscendantSignWidget(controller: controller);
      case 8:
        return CurrentSadeSatiWidget(controller: controller);
      case 9:
        return GemSuggestionWidget(controller: controller);
      case 10:
        return RudrakshSuggestionWidget(controller: controller);
      case 11:
        return FriendshipTableWidget(controller: controller);
      case 12:
        return PlanetKpWidget(controller: controller);
      default:
        return Center(
          child: AutoTranslateText(
            'Content not available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
    }
  }
}
