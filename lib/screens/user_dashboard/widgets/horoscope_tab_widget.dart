import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/screens/horoscope/view/horoscope_sign_selection_view.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/daily_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/weekly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/monthly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/yearly_prediction_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Horoscope tab: category selection -> zodiac selection -> data display.
class HoroscopeTabWidget extends StatelessWidget {
  const HoroscopeTabWidget({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'Daily', 'icon': Icons.today_outlined},
    {'label': 'Weekly', 'icon': Icons.calendar_view_week_outlined},
    {'label': 'Weekly Love', 'icon': Icons.favorite_outline},
    {'label': 'Monthly', 'icon': Icons.calendar_month_outlined},
    {'label': 'Yearly', 'icon': Icons.calendar_today_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    // Use tag to separate tab controller from full-screen controller
    final controller = Get.put(HoroscopeMainController(), tag: 'horoscope_tab', permanent: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() {
        // Step 1: Category selection
        if (controller.selectedCategory.value == null) {
          return _buildCategorySelection(controller);
        }

        // Step 2: Zodiac selection (if category selected but no zodiac)
        if (controller.selectedZodiac.value == null) {
          return _buildZodiacSelection(controller);
        }

        // Step 3: Data display
        return _buildDataDisplay(controller);
      }),
    );
  }

  Widget _buildCategorySelection(HoroscopeMainController controller) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          SizedBox(height: 2.h),
          _buildGrid(controller),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#820B17'.toColor(), '#68171E'.toColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Astrology Reports',
            style: AppTypography.h2.copyWith(
              color: '#FCE5AA'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Get Detailed Insights',
            style: AppTypography.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          AutoTranslateText(
            'Discover your future with accurate predictions',
            style: AppTypography.body2.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              // Navigate to all reports or keep in tab
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AutoTranslateText(
                'View All Reports',
                style: AppTypography.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(HoroscopeMainController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryCard(
          controller,
          category['label'] as String,
          category['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildCategoryCard(HoroscopeMainController controller, String label, IconData icon) {
    return GestureDetector(
      onTap: () => controller.selectedCategory.value = label,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#DBCCA8'.toColor().withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: '#6F221E'.toColor().withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: '#FCE5AA'.toColor().withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.w, color: AppColors.deepOrange),
            ),
            SizedBox(height: 6.h),
            AutoTranslateText(
              label,
              style: AppTypography.body2.copyWith(
                color: '#3D0C11'.toColor(),
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZodiacSelection(HoroscopeMainController controller) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.selectedCategory.value = null;
                  controller.selectedZodiac.value = null;
                },
                child: Icon(Icons.arrow_back, color: '#3D0C11'.toColor(), size: 24.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AutoTranslateText(
                  'Select Your Sign',
                  style: AppTypography.h2.copyWith(
                    color: '#3D0C11'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          //SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.85,
            ),
            itemCount: HoroscopeSignSelectionView.zodiacSigns.length,
            itemBuilder: (context, index) {
              final sign = HoroscopeSignSelectionView.zodiacSigns[index];
              return _buildZodiacCard(controller, sign['name']!, sign['image']!);
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildZodiacCard(HoroscopeMainController controller, String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        controller.selectedZodiac.value = name;
        controller.selectedSign.value = name;
        _fetchDataForCategory(controller);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.star,
                        size: 40.w,
                        color: const Color(0xFFDFB343),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Spacing.h(4),
          AutoTranslateText(
            name,
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ).merge(AppTypography.body2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDataDisplay(HoroscopeMainController controller) {
    final category = controller.selectedCategory.value!;
    final zodiac = controller.selectedZodiac.value!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.selectedZodiac.value = null;
                // Clear data
                controller.dailyPredictionData.value = null;
                controller.weeklyPredictionData.value = null;
                controller.monthlyPredictionData.value = null;
                controller.yearlyPredictionData.value = null;
              },
              child: Icon(Icons.arrow_back, color: '#3D0C11'.toColor(), size: 24.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AutoTranslateText(
                '$category - $zodiac',
                style: AppTypography.h2.copyWith(
                  color: '#3D0C11'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: _buildCategoryContent(controller, category),
        ),
      ],
    );
  }

  Widget _buildCategoryContent(HoroscopeMainController controller, String category) {
    switch (category) {
      case 'Daily':
        return DailyPredictionWidget(controller: controller);
      case 'Weekly':
      case 'Weekly Love':
        return WeeklyPredictionWidget(controller: controller);
      case 'Monthly':
        return MonthlyPredictionWidget(controller: controller);
      case 'Yearly':
        return YearlyPredictionWidget(controller: controller);
      default:
        return Center(
          child: AutoTranslateText(
            'Category not supported',
            style: AppTypography.body1.copyWith(color: '#3D0C11'.toColor()),
          ),
        );
    }
  }

  void _fetchDataForCategory(HoroscopeMainController controller) {
    final category = controller.selectedCategory.value;
    if (category == null) return;

    switch (category) {
      case 'Daily':
        controller.fetchDailyPrediction();
        break;
      case 'Weekly':
      case 'Weekly Love':
        controller.fetchWeeklyPrediction();
        break;
      case 'Monthly':
        controller.fetchMonthlyPrediction();
        break;
      case 'Yearly':
        controller.fetchYearlyPrediction();
        break;
    }
  }
}
