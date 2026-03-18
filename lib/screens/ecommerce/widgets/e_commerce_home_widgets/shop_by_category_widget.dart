import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Shop by Category',
                      style: AppTypography.h2.copyWith(color: '#68171E'.toColor()),
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
                  onTap: () => UserMainController.pushInCurrentTab(
                    AppRoutes.productList,
                    arguments: {
                      'title': 'All Categories',
                      'showCategoriesFirst': true,
                    },
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'View All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.88,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.w(5.52),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.71.h,
                        color: '#68171E'.toColor(),
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
                height: 130.h,
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
                // Tighter card height: image + padding + spacing + text (less bottom)
                final double baseCardHeight = 90.h + 5.h + 7.h + 22.h + 2.h;

                // Clamp to reduced bounds so white cards don't look too big
                final double minHeight = 110.h;
                final double maxHeight = 128.h;
                final double dynamicHeight = baseCardHeight.clamp(
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
                        bottom: 4.h,
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
        padding: EdgeInsets.only(top: 4.h, bottom: 2.h, left: 4.w, right: 4.w),
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
              width: 86.w,
              height: 86.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: category.image != null && category.image!.isNotEmpty
                    ? NetworkImageWithLoader(
                        url: category.image!,
                        width: 86.w,
                        height: 86.h,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.category,
                          size: 40.w,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            Spacing.h(4),
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
                Spacing.h(3),
                if ((category.productCount ?? 0) > 0)
                  AutoTranslateText(
                    '${category.productCount} items',
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
