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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HoroscopeMainController());
    
    return Scaffold(
      backgroundColor: "#FFFCF3".toColor(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: "#6F221E".toColor(),
            size: 24.w,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => AutoTranslateText(
          controller.selectedSign.value ?? 'Horoscope',
          style: MyTextTheme.largeBCB.copyWith(
            color: "#6F221E".toColor(),
          ),
        )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab Slider
          _buildTabSlider(controller),
          
          // Tab Content
          Expanded(
            child: Obx(() => _buildTabContent(controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSlider(HoroscopeMainController controller) {
    return Container(
      height: 50.h,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: controller.tabs.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.onTabChanged(index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            "#ed6f30".toColor(),
                            "#ed6f30".toColor().withOpacity(0.8),
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? "#ed6f30".toColor()
                        : "#6F221E".toColor().withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: AutoTranslateText(
                    controller.tabs[index],
                    style: MyTextTheme.smallBCB.copyWith(
                      color: isSelected
                          ? Colors.white
                          : "#6F221E".toColor().withOpacity(0.7),
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

  Widget _buildTabContent(HoroscopeMainController controller) {
    final index = controller.selectedTabIndex.value;
    
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

