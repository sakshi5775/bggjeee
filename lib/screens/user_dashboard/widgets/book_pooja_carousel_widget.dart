import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
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
          // Carousel Section: cards + dots below the white card
          // Height is driven by the image aspect ratio (~16:9 → portrait
          // puja images are typically square-ish).  Use 200 logical pixels
          // so the full image is visible without cropping.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Get.width > 600 ? 220.h : 200.h,
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

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: PageView.builder(
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
                    ),
                  ),
                  Spacing.h(8),
                  _buildPaginationDots(),
                  Spacing.h(4),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  double? _getMinPrice(PujaModel puja) {
    if (puja.packages == null || puja.packages!.isEmpty) return null;
    final pkg = puja.packages!.firstWhere(
      (p) => p.isRecommended == true,
      orElse: () => puja.packages!.first,
    );
    final price = pkg.price;
    return (price != null && price > 0) ? price : null;
  }

  String _getDuration(PujaModel puja) {
    if (puja.timing != null && puja.timing!.isNotEmpty) return puja.timing!;
    return '30 mins';
  }

  Widget _buildPoojaCard(PujaModel puja) {
    final minPrice = _getMinPrice(puja);
    final duration = _getDuration(puja);
    final totalBookings = puja.stats?.totalBookings;
    final rating = puja.stats?.averageRating;

    return GestureDetector(
      onTap: () {
        if (puja.id != null && puja.id!.isNotEmpty) {
          UserMainController.pushInCurrentTab(
            AppRoutes.pujaDetail,
            arguments: puja.id,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B1925).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth;
              final cardHeight = constraints.maxHeight;
              final imageWidth = cardWidth * 0.48;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image: full height, left side – card designed around image
                  SizedBox(
                    width: imageWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: const Color(0xFF1A1A2E)),
                          if (puja.image != null && puja.image!.isNotEmpty)
                            Center(
                              child: NetworkImageWithLoader(
                                url: puja.image!,
                                fit: BoxFit.contain,
                                width: imageWidth,
                                height: cardHeight,
                              ),
                            )
                          else
                            Container(
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
                                size: 32.w,
                              ),
                            ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.15),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                          if (puja.isFeatured == true)
                            Positioned(
                              top: 4.h,
                              left: 6.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE3B341),
                                      Color(0xFFD4A017),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 10.r,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Featured',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (puja.isPopular == true)
                            Positioned(
                              top: puja.isFeatured == true ? 24.h : 4.h,
                              left: 6.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      size: 10.r,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Popular',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (rating != null && rating > 0)
                            Positioned(
                              top: 4.h,
                              right: 6.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 10.r,
                                      color: const Color(0xFFFFC107),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: const Color(0xFF3E2723),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (puja.temple?.name != null)
                            Positioned(
                              bottom: 4.h,
                              left: 6.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.temple_hindu_rounded,
                                      size: 10.r,
                                      color: const Color(0xFF8B1925),
                                    ),
                                    SizedBox(width: 2.w),
                                    Flexible(
                                      child: Text(
                                        puja.temple!.name!,
                                        style: TextStyle(
                                          color: const Color(0xFF8B1925),
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Content beside image
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 10.w, 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            puja.title ?? 'Pooja',
                            style: TextStyle(
                              color: const Color(0xFF2D1810),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          AutoTranslateText(
                            puja.subheading ??
                                puja.longDescription ??
                                'Divine blessings & spiritual fulfillment',
                            style: TextStyle(
                              color: const Color(0xFF8A8A8A),
                              fontSize: 9.sp,
                              height: 1.25,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPujaChip(
                                icon: Icons.schedule_rounded,
                                label: duration,
                                color: const Color(0xFF5C6BC0),
                              ),
                              if (totalBookings != null &&
                                  totalBookings > 0) ...[
                                SizedBox(width: 6.w),
                                _buildPujaChip(
                                  icon: Icons.people_alt_rounded,
                                  label: '$totalBookings+ booked',
                                  color: const Color(0xFF26A69A),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 44.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Starts from',
                                    style: TextStyle(
                                      color: const Color(0xFFAAAAAA),
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    minPrice != null
                                        ? '₹${minPrice.toInt()}'
                                        : 'Free',
                                    style: TextStyle(
                                      color: const Color(0xFF2D1810),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (puja.id != null &&
                                      puja.id!.isNotEmpty) {
                                    UserMainController.pushInCurrentTab(
                                      AppRoutes.pujaDetail,
                                      arguments: puja.id,
                                    );
                                  } else {
                                    UserMainController.pushInCurrentTab(
                                      AppRoutes.bookPuja,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 8.h,
                                  ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.orangeGradient
                                          .colors.first
                                          .withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AutoTranslateText(
                                      'Book Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 13.r,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
    );
  }

  Widget _buildPujaChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r, color: color),
          SizedBox(width: 2.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
