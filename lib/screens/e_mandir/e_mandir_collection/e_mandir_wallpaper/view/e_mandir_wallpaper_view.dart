import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import '../controller/e_mandir_wallpaper_controller.dart';
import '../widgets/wallpaper_filter_chip.dart';
import '../widgets/wallpaper_grid_card.dart';

class EMandirWallpaperView extends BasePage<EMandirWallpaperController> {
  const EMandirWallpaperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AutoTranslateText(
          'Divine Wallpapers',
          style: TextStyle(
            color: AppColors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          // Filter Chips
          SizedBox(
            height: 40.h,
            child: Obx(() {
              return ListView.builder(
                controller: controller.filterScrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  final filter = controller.filters[index];
                  final isSelected = controller.selectedFilter.value == filter;
                  return WallpaperFilterChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () => controller.onChangeFilter(filter),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 16.h),

          // Wallpapers Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.deepOrange),
                );
              }

              if (controller.wallpapers.isEmpty) {
                return Center(
                  child: AutoTranslateText(
                    'No wallpapers found.',
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.currentCategory != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 20.h,
                            color: AppColors.deepOrange,
                          ),
                          SizedBox(width: 8.w),
                          AutoTranslateText(
                            'Divine ${controller.currentCategory!.godName} Wallpapers ✨',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.65, // Portrait ratio
                      ),
                      itemCount: controller.wallpapers.length,
                      itemBuilder: (context, index) {
                        final wallpaper = controller.wallpapers[index];
                        return WallpaperGridCard(
                          wallpaper: wallpaper,
                          onTap: () {
                            // Navigate to story view. Pass starting index.
                            Get.toNamed(
                              AppRoutes.eMandirWallpaperStory,
                              arguments: {
                                'initialIndex': index,
                                'wallpapers': controller.wallpapers.toList(),
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
