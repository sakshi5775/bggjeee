import 'package:astrobharataiuser/app_manager/common/global_header/global_header_view.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_banner_slider.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_grid_section.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedies_search_bar.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/widgets/remedy_categories_section.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../kundli/widgets/kundli_header.dart';
import '../../../user_dashboard/view/user_dashboard_view.dart';

class RemediesView extends BasePage<RemediesController> {
  const RemediesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: UserDashboardView.buildDrawer(context),
      body: Column(
        children: [
          // Fixed Header
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                GlobalHeaderView(title: 'Remedies & Store'),
                SizedBox(height: 16.h),
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
                    // 1. Search Bar
                    RemediesSearchBar(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                    ),

                    // 2. Banner Slider
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
    );
  }
}
