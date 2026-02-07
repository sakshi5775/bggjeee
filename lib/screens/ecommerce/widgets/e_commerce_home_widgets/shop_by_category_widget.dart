import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShopByCategoryWidget extends StatelessWidget {
  final EcommerceHomeController controller;

  const ShopByCategoryWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Shop by Category',
                      style: TextStyle(
                        fontFamily: 'Baloo 2',
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: '#8B1925'.toColor(),
                      ),
                    ),
                    Spacing.h(3.68),
                    AutoTranslateText(
                      'Explore our divine collections',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.88,
                        color: '#6A7282'.toColor(),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => controller.navigateToProductList(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'View All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.88,
                          color: '#8B1925'.toColor(),
                        ),
                      ),
                      Spacing.w(5.52),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.71.h,
                        color: '#8B1925'.toColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(12),
          Obx(() {
            if (controller.isLoadingCategories.value) {
              return SizedBox(
                height: 143.h,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            final categories = controller.categoryTree
                .where((cat) => cat.isFeatured == true && cat.parent == null)
                .toList();

            if (categories.isEmpty) {
              return SizedBox.shrink();
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Use MediaQuery to get screen height for responsive calculation
                final screenHeight = MediaQuery.of(context).size.height;

                // Calculate card height based on actual card components
                // Image: 90.h, padding: 10.h (5 top + 5 bottom), spacing: ~13.h (7.36 + 5.52)
                // Text area: ~30.h (category name ~15.h + item count ~15.h with buffers)
                // Shadow padding: 8.h
                final double baseCardHeight = 90.h + 10.h + 13.h + 30.h + 8.h;

                // Alternative: Use percentage of screen height as fallback
                // This ensures it scales properly on all devices
                final double screenBasedHeight =
                    screenHeight * 0.18; // ~18% of screen height

                // Use the larger of the two to prevent overflow
                final double calculatedHeight =
                    baseCardHeight > screenBasedHeight
                    ? baseCardHeight
                    : screenBasedHeight;

                // Clamp to reasonable bounds (minimum 150.h, maximum 220.h)
                // These bounds ensure it works on both small and large screens
                final double minHeight = 150.h;
                final double maxHeight = 220.h;
                final double dynamicHeight = calculatedHeight.clamp(
                  minHeight,
                  maxHeight,
                );

                return SizedBox(
                  height: dynamicHeight,
                  child: ClipRect(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 8.h, // Padding for shadow
                      ),
                      itemCount: categories.length,
                      separatorBuilder: (context, index) => Spacing.w(12.w),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return _buildCategoryCard(category);
                      },
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        controller.selectCategory(category);
      },
      child: Container(
        width: 102.w,
        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              height: 90.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.71.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.71.r),
                child: category.image != null && category.image!.isNotEmpty
                    ? NetworkImageWithLoader(
                        url: category.image!,
                        width: 90.w,
                        height: 90.h,
                      )
                    : Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: Icon(
                          Icons.category,
                          size: 40.w,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            Spacing.h(7.36),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoTranslateText(
                  category.name ?? '',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.88,
                    color: '#3D0C11'.toColor(),
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacing.h(5.52),
                AutoTranslateText(
                  '${category.productCount ?? 0} items',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 11.04,
                    color: '#6A7282'.toColor(),
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
