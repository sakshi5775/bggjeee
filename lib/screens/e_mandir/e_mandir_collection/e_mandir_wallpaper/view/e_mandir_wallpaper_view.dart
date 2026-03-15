import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/all_astrologers_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_form_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import '../../../../horoscope/view/horoscope_form_view.dart';
import '../controller/e_mandir_wallpaper_controller.dart';
import '../widgets/wallpaper_filter_chip.dart';
import '../widgets/daily_thoughts_list_widget.dart';
import '../widgets/wallpaper_grid_widget.dart';
import '../widgets/festival_grid_widget.dart';
import 'package:astrobharataiuser/screens/panchang/view/panchang_view.dart';
import 'package:astrobharataiuser/screens/panchang/controller/panchang_controller.dart';

class EMandirWallpaperView extends BasePage<EMandirWallpaperController> {
  const EMandirWallpaperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            Obx(() => CommonHeader(title: controller.selectedFilter.value)),
            SizedBox(height: 4.h),
            // Filter chips
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                controller: controller.filterScrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  final filter = controller.filters[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedFilter.value == filter;
                    return WallpaperFilterChip(
                      label: filter,
                      isSelected: isSelected,
                      onTap: () => controller.onChangeFilter(filter),
                    );
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),
            // Body content
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) return;
                  final currentFilterIndex = controller.filters.indexOf(
                    controller.selectedFilter.value,
                  );

                  if (details.primaryVelocity! < -200) {
                    // Swipe left -> Next Filter
                    if (currentFilterIndex < controller.filters.length - 1) {
                      controller.onChangeFilter(
                        controller.filters[currentFilterIndex + 1],
                      );
                      controller.scrollToSelectedFilter();
                    }
                  } else if (details.primaryVelocity! > 200) {
                    // Swipe right -> Previous Filter
                    if (currentFilterIndex > 0) {
                      controller.onChangeFilter(
                        controller.filters[currentFilterIndex - 1],
                      );
                      controller.scrollToSelectedFilter();
                    }
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Sub-Filters (only visible if Greetings selected)
                    Obx(() {
                      if (controller.selectedFilter.value != 'Greetings') {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: SizedBox(
                          height: 36.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: controller.greetingFilters.length,
                            itemBuilder: (context, index) {
                              final filter = controller.greetingFilters[index];
                              return Obx(() {
                                final isSelected =
                                    controller.selectedGreetingFilter.value ==
                                    filter;
                                return WallpaperFilterChip(
                                  label: filter,
                                  isSelected: isSelected,
                                  onTap: () =>
                                      controller.onChangeGreetingFilter(filter),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 16.h),

                    // Wallpapers Grid or Daily Thoughts List
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.deepOrange,
                            ),
                          );
                        }

                        // Rendering Daily Thoughts format if 'Greetings' selected
                        if (controller.selectedFilter.value == 'Greetings') {
                          if (controller.dailyThoughts.isEmpty) {
                            return Center(
                              child: AutoTranslateText(
                                'No greetings found.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            );
                          }

                          return DailyThoughtsListWidget(
                            dailyThoughts: controller.dailyThoughts,
                          );
                        }

                        if (controller.selectedFilter.value == 'Today') {
                          if (controller.wallpapers.isEmpty) {
                            return Center(
                              child: AutoTranslateText(
                                'No wallpapers found.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            );
                          }

                          return WallpaperGridWidget(
                            wallpapers: controller.wallpapers,
                            currentCategory: controller.currentCategory,
                          );
                        }

                        if (controller.selectedFilter.value == 'Panchang') {
                          if (!Get.isRegistered<PanchangController>()) {
                            Get.put(PanchangController());
                          }
                          return const PanchangView(hideHeader: true);
                        }
                        if (controller.selectedFilter.value == 'Rashifal') {
                          if (!Get.isRegistered<HoroscopeFormController>()) {
                            Get.put(HoroscopeFormController());
                          }
                          return const HoroscopeFormView(hideHeader: true);
                        }

                        if (controller.selectedFilter.value == 'Astrology') {
                          if (!Get.isRegistered<AllAstrologersController>()) {
                            Get.put(AllAstrologersController());
                          }
                          return const AllAstrologersView(hideHeader: true);
                        }

                        if (controller.selectedFilter.value == 'Library') {
                          if (controller.festivals.isEmpty) {
                            return Center(
                              child: AutoTranslateText(
                                'No festivals found.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            );
                          }
                          return FestivalGridWidget(
                            festivals: controller.festivals,
                          );
                        }

                        // Default empty state for other unhandled filters
                        return const SizedBox.shrink();
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
