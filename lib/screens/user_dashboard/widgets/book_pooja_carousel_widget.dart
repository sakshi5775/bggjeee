import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

import '../controller/user_dashboard_controller.dart';

class BookPoojaCarouselWidget extends BasePage<UserDashboardController> {
  const BookPoojaCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: AppPaddings.symmetric(h: 8),
            child: Row(
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
                    UserMainController.pushInCurrentTab(AppRoutes.bookPuja);
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
          ),
          // Spacing.h(2),
          // Carousel Section
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Get.width > 600 ? 165.h : 160.h,
            ),
            child: Obx(() {
              if (controller.isLoadingPujas.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.pujas.isEmpty) {
                return const Center(
                  child: AutoTranslateText('No pujas available'),
                );
              }

              return PageView.builder(
                key: const ValueKey('book_pooja_pageview'),
                controller: controller.bookPoojaPageController.value,

                onPageChanged: (index) {
                  controller.bookPoojaCurrentPage.value = index;
                },
                itemCount: controller.pujas.length,
                itemBuilder: (context, index) {
                  final puja = controller.pujas[index];
                  return _buildPoojaCard(puja);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPoojaCard(PujaModel puja) {
    final isTablet = Get.width > 600;

    // Get the first package (or recommended package) for price
    final package =
        puja.packages?.firstWhere(
          (p) => p.isRecommended == true,
          orElse: () => puja.packages?.first ?? PujaPackage(),
        ) ??
        PujaPackage();

    // Format price
    final priceText = package.price != null
        ? '₹${package.price!.toStringAsFixed(0)}'
        : 'Price on request';

    // Format timing
    String timingText = '';
    if (puja.timing != null && puja.timing!.isNotEmpty) {
      try {
        // Try to parse as DateTime first
        final dateTime = DateTime.tryParse(puja.timing!);
        if (dateTime != null) {
          timingText = DateFormat('MMM dd, hh:mm a').format(dateTime);
        } else {
          // If not a full date, use as is (might be just time like "14:21")
          timingText = puja.timing!;
        }
      } catch (e) {
        timingText = puja.timing!;
      }
    }

    return GestureDetector(
      onTap: () {
        if (puja.id != null && puja.id!.isNotEmpty) {
          UserMainController.pushInCurrentTab(AppRoutes.pujaDetail, arguments: puja.id);
        }
      },
      child: Card(
        elevation: 2,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: isTablet ? 165.h : 150.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: AppPaddings.symmetric(
                    h: isTablet ? 20 : 15,
                    v: isTablet ? 10 : 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pooja Image
                      Container(
                        width: isTablet ? 60.w : null,
                        height: isTablet ? 60.w : null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: '#F5D7B8'.toColor(),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: puja.image != null && puja.image!.isNotEmpty
                              ? Image.network(
                                  puja.image!,
                                  width: isTablet ? 60.w : 100,
                                  height: isTablet ? 60.w : 100,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: isTablet ? 60.w : 60,
                                      height: isTablet ? 60.w : 42.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            "#FFF8F0".toColor(),
                                            "#FFE8D0".toColor(),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.auto_awesome,
                                        color: AppColors.deepOrange,
                                        size: isTablet ? 32.w : 24.w,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: isTablet ? 60.w : 42.w,
                                  height: isTablet ? 60.w : 42.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        "#FFF8F0".toColor(),
                                        "#FFE8D0".toColor(),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.deepOrange,
                                    size: isTablet ? 28.w : 20.w,
                                  ),
                                ),
                        ),
                      ),
                      Spacing.w(isTablet ? 24 : 16),
                      // Content Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            AutoTranslateText(
                              puja.title ?? 'Pooja',
                              style: MyTextTheme.largeBCB
                                  .copyWith(
                                    color: "#5D1C21".toColor(),
                                    fontWeight: FontWeight.w500,
                                    fontSize: isTablet ? 20.sp : null,
                                  )
                                  .merge(AppTypography.h2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacing.h(isTablet ? 4 : 2),
                            // Description (subheading)
                            AutoTranslateText(
                              puja.subheading ??
                                  puja.title ??
                                  'Divine blessings',
                              style: MyTextTheme.smallBCN
                                  .copyWith(
                                    color: "#666666".toColor(),
                                    fontSize: isTablet ? 12.sp : 9.sp,
                                  )
                                  .merge(AppTypography.body2),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacing.h(isTablet ? 3 : 3),
                            // Price, Timing and Button Row
                            Row(
                              children: [
                                if (isTablet) ...[
                                  // Tablet: Horizontal Layout (Price - Space - Time - Spacer)
                                  Flexible(
                                    child: AutoTranslateText(
                                      priceText,
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(
                                            color: AppColors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                          )
                                          .merge(AppTypography.h3),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (timingText.isNotEmpty) ...[
                                    Spacing.w(12),
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12.w,
                                            color: "#666666".toColor(),
                                          ),
                                          Spacing.w(3),
                                          Flexible(
                                            child: AutoTranslateText(
                                              timingText,
                                              style: MyTextTheme.smallBCN
                                                  .copyWith(
                                                    color: "#666666".toColor(),
                                                    fontSize: 12.sp,
                                                  )
                                                  .merge(AppTypography.body2),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const Spacer(),
                                ] else ...[
                                  // Mobile: Vertical Layout (Price over Time)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoTranslateText(
                                          priceText,
                                          style: MyTextTheme.mediumBCB
                                              .copyWith(
                                                color: AppColors.deepOrange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              )
                                              .merge(AppTypography.h3),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (timingText.isNotEmpty) ...[
                                          Spacing.h(2),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 10.w,
                                                color: "#666666".toColor(),
                                              ),
                                              Spacing.w(3),
                                              Flexible(
                                                child: AutoTranslateText(
                                                  timingText,
                                                  style: MyTextTheme.smallBCN
                                                      .copyWith(
                                                        color: "#666666"
                                                            .toColor(),
                                                        fontSize: 9.sp,
                                                      )
                                                      .merge(
                                                        AppTypography.body2,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                                // Book Now Button - Consistent across both
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to puja detail page
                                    if (puja.id != null &&
                                        puja.id!.isNotEmpty) {
                                      UserMainController.pushInCurrentTab(
                                        AppRoutes.pujaDetail,
                                        arguments: puja.id,
                                      );
                                    } else {
                                      // Fallback to book puja page
                                      UserMainController.pushInCurrentTab(AppRoutes.bookPuja);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 24.w : 12.w,
                                      vertical: isTablet ? 10.h : 6.h,
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
                                            fontSize: isTablet ? 12.sp : 10.sp,
                                          )
                                          .merge(AppTypography.body2),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
              ),
              Spacing.h(isTablet ? 4 : 2),
              // Pagination Dots
              _buildPaginationDots(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.pujas.length, (index) {
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
      ),
    );
  }
}
