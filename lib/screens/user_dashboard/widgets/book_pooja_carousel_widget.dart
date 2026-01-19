import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/user_dashboard_controller.dart';

class BookPoojaCarouselWidget extends BasePage<UserDashboardController> {
  const BookPoojaCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Book Pooja',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#3D0C11".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to view all poojas
                  // Get.toNamed(AppRoutes.allPoojas);
                },
                child: AutoTranslateText(
                  'View all',
                  style: MyTextTheme.mediumBCN
                      .copyWith(
                        color: "#666666".toColor(),
                        fontWeight: FontWeight.w400,
                      )
                      .merge(AppTypography.body1),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          // Carousel Section
          SizedBox(
            height: 180.h,
            child: Obx(() {
              return PageView.builder(
                key: const ValueKey('book_pooja_pageview'),
                controller: controller.bookPoojaPageController.value,
                onPageChanged: (index) {
                  controller.bookPoojaCurrentPage.value = index;
                },
                itemCount: controller.poojaCards.value.length,
                itemBuilder: (context, index) {
                  final card = controller.poojaCards.value[index];
                  return _buildPoojaCard(card);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPoojaCard(Map<String, dynamic> card) {
    return Card(
      elevation: 2,

      child: Column(
        children: [
          Padding(
            padding: AppPaddings.symmetric(h: 15, v: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with gradient circle
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ["#FFF8F0".toColor(), "#FFE8D0".toColor()],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    card['icon'] as IconData,
                    color: AppColors.deepOrange,
                    size: 24.w,
                  ),
                ),
                Spacing.w(16),
                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AutoTranslateText(
                        card['title'] as String,
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: "#5D1C21".toColor(),
                              fontWeight: FontWeight.w500,
                            )
                            .merge(AppTypography.h2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.h(6),
                      // Description
                      AutoTranslateText(
                        card['description'] as String,
                        style: MyTextTheme.smallBCN
                            .copyWith(
                              color: "#666666".toColor(),
                              fontSize: 12.sp,
                            )
                            .merge(AppTypography.body2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.h(12),
                      // Price, Duration and Button Row
                      Row(
                        children: [
                          // Price
                          AutoTranslateText(
                            card['price'] as String,
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: AppColors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                )
                                .merge(AppTypography.h3),
                          ),
                          Spacing.w(12),
                          // Duration with icon
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14.w,
                                color: "#666666".toColor(),
                              ),
                              Spacing.w(4),
                              AutoTranslateText(
                                card['duration'] as String,
                                style: MyTextTheme.smallBCN
                                    .copyWith(
                                      color: "#666666".toColor(),
                                      fontSize: 12.sp,
                                    )
                                    .merge(AppTypography.body2),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Book Now Button
                          GestureDetector(
                            onTap: () {
                              // Handle book now action
                              // Get.toNamed(AppRoutes.bookPooja, arguments: card);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: AutoTranslateText(
                                'Book Now',
                                style: MyTextTheme.smallBCB
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    )
                                    .merge(AppTypography.body2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(12),
          // Pagination Dots
          _buildPaginationDots(),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.poojaCards.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: controller.bookPoojaCurrentPage.value == index
                ? AppColors.deepOrange
                : AppColors.deepOrange.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
