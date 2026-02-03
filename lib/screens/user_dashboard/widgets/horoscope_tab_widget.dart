import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/screens/horoscope/view/horoscope_sign_selection_view.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/daily_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/weekly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/monthly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/horoscope/widgets/yearly_prediction_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Horoscope tab: category selection -> zodiac selection -> data display.
class HoroscopeTabWidget extends StatefulWidget {
  const HoroscopeTabWidget({super.key});

  @override
  State<HoroscopeTabWidget> createState() => _HoroscopeTabWidgetState();
}

class _HoroscopeTabWidgetState extends State<HoroscopeTabWidget> {
  final BannerService _bannerService = BannerService();
  final List<BannerItem> _banners = [];
  bool _loadingBanners = true;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    if (!mounted) return;
    setState(() => _loadingBanners = true);
    try {
      var list = await _bannerService.getBannersByCategory('general');
      if (list.isEmpty) {
        list = await _bannerService.getHomeBanners();
      }
      if (mounted) {
        setState(() {
          _banners
            ..clear()
            ..addAll(list);
        });
      }
    } catch (_) {
      if (mounted) setState(() => _banners.clear());
    } finally {
      if (mounted) setState(() => _loadingBanners = false);
    }
  }

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
    final controller = Get.put(
      HoroscopeMainController(),
      tag: 'horoscope_tab',
      permanent: false,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
          _buildBannersSection(),
          SizedBox(height: 8),
          _buildGrid(controller),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildBannersSection() {
    if (_loadingBanners && _banners.isEmpty) {
      return SizedBox(
        height: 110.h,
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              color: AppColors.deepOrange,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    if (_banners.isEmpty) return const SizedBox.shrink();
    return BannerCarouselWidget(
      key: ValueKey(_banners.length),
      banners: _banners.toList(),
    );
  }

  Widget _buildGrid(HoroscopeMainController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
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

  Widget _buildCategoryCard(
    HoroscopeMainController controller,
    String label,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => controller.selectedCategory.value = label,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.deepOrange.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.08),
              blurRadius: 8,
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
                gradient: AppColors.orangeGradient.scale(0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.w, color: AppColors.deepOrange),
            ),
            SizedBox(height: 6.h),
            AutoTranslateText(
              label,
              style: AppTypography.body2.copyWith(
                color: AppColors.textPrimary,
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
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AutoTranslateText(
                  'Select Your Sign',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
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
              return _buildZodiacCard(
                controller,
                sign['name']!,
                sign['image']!,
              );
            },
          ),
          SizedBox(height: 54.h),
        ],
      ),
    );
  }

  Widget _buildZodiacCard(
    HoroscopeMainController controller,
    String name,
    String imagePath,
  ) {
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
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.deepOrange.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepOrange.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child:
                      (imagePath.startsWith('http://') ||
                          imagePath.startsWith('https://'))
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.deepOrange,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.star,
                              size: 40.w,
                              color: AppColors.deepOrange,
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.star,
                              size: 40.w,
                              color: AppColors.deepOrange,
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
            style: MyTextTheme.smallBCB
                .copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                )
                .merge(AppTypography.body2),
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
              child: Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AutoTranslateText(
                '$category - $zodiac',
                style: AppTypography.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Expanded(child: _buildCategoryContent(controller, category)),
      ],
    );
  }

  Widget _buildCategoryContent(
    HoroscopeMainController controller,
    String category,
  ) {
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
            style: AppTypography.body1.copyWith(color: AppColors.textPrimary),
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
