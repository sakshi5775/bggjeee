import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_banner_slider.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_grid_section.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_search_bar.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedy_categories_section.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../user_dashboard/view/user_dashboard_view.dart';

class RemediesView extends BasePage<RemediesController> {
  const RemediesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            // Standard Sticky Header + Search Bar
            Padding(
              padding: EdgeInsets.only(
                top:
                    (MediaQuery.of(context).padding.top > 0
                            ? MediaQuery.of(context).padding.top * 0.5
                            : 0.0)
                        .clamp(6.0, 24.0)
                        .toDouble(),
              ),
              child: Column(
                children: [
                  const CommonHeader(
                    title: 'Remedies & Store',
                    showSearch: false, // We have a custom search bar below
                  ),
                  RemediesSearchBar(
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
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

                      SizedBox(height: 24.h),

                      // 3. Main Remedies Grid Header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            AutoTranslateText(
                              "Popular Remedies",
                              style: AppTypography.h2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF3E1212),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: AutoTranslateText(
                                "View All",
                                style: AppTypography.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const RemediesGridSection(),

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
