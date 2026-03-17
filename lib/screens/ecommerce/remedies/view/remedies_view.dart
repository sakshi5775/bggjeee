import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_banner_slider.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/popular_remedies_slider.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_search_bar.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedy_categories_section.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedy_categories_slider.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemediesView extends BasePage<RemediesController> {
  const RemediesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            // Standard Sticky Header + Search Bar
            Column(
              children: [
                const CommonHeader(title: 'Remedies & Store'),
                RemediesSearchBar(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                ),
               // SizedBox(height: 8.h),
              ],
            ),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  Get.find<RemediesController>().onInit();
                },
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner Slider
                      const RemediesBannerSlider(),

                      SizedBox(height: 16.h),

                      // Remedy Categories Slider (image + heading below + Explore → remedy-services)
                      const RemedyCategoriesSlider(),

                      SizedBox(height: 20.h),

                      // 3. Main Remedies Grid Header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: AutoTranslateText(
                                "Popular Remedies",
                                style: AppTypography.h2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF3E1212),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                UserMainController.pushInCurrentTab(
                                  AppRoutes.myRemedyBookings,
                                );
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: AutoTranslateText(
                                "My Bookings",
                                style: AppTypography.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepOrange,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                UserMainController.pushInCurrentTab(
                                  AppRoutes.remediesPopular,
                                );
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: AutoTranslateText(
                                "View All",
                                style: AppTypography.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepOrange,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopularRemediesSlider(),

                      SizedBox(height: 24.h),

                      // 4. Category List (Store)
                      const RemedyCategoriesSection(),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
