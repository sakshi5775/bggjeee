import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/ascendant_sign_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/current_sade_sati_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/daily_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/friendship_table_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/gem_suggestion_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/key_points_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/monthly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/moon_sign_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/planet_kp_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/rudraksh_suggestion_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/sun_sign_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/weekly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/yearly_prediction_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeMainView extends StatelessWidget {
  const HoroscopeMainView({super.key});

  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HoroscopeMainController());
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFFDFB343),
                          size: 24.w,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      // Title
                      Expanded(
                        child: Obx(() => AutoTranslateText(
                          controller.selectedSign.value ?? 'Horoscope',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: const Color(0xFFDFB343),
                            fontWeight: FontWeight.bold,
                          ).merge(AppTypography.h2),
                          textAlign: TextAlign.center,
                        )),
                      ),
                      // Spacer to balance the back button
                      SizedBox(width: 48.w),
                    ],
                  ),
                ),
              ),
              // Tab Slider
              _buildTabSlider(controller),
              
              // Tab Content with PageView for swipe
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.tabs.length,
                  itemBuilder: (context, index) {
                    return _buildTabContent(controller, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSlider(HoroscopeMainController controller) {
    return Container(
      height: 60.h,
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
      child: ListView.builder(
        controller: controller.tabScrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: controller.tabs.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.onTabChanged(index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: isSelected ? orangeGradient : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : "#6F221E".toColor().withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: "#F38B3B".toColor().withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AutoTranslateText(
                    controller.tabs[index],
                    style: MyTextTheme.smallBCB.copyWith(
                      color: isSelected
                          ? Colors.white
                          : "#6F221E".toColor().withOpacity(0.7),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
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
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
    }
  }
}

