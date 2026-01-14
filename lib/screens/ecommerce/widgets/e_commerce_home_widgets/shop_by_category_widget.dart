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
                        fontSize: 24.sp,
                        color: '#8B1925'.toColor(),
                        height: 1.0,
                      ),
                    ),
                    Spacing.h(3.68),
                    AutoTranslateText(
                      'Explore our divine collections',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.88.sp,
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
                          fontSize: 12.88.sp,
                          color: '#8B1925'.toColor(),
                          height: 1.43,
                        ),
                      ),
                      Spacing.w(5.52),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.71.sp,
                        color: '#8B1925'.toColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(12),
          SizedBox(
            height: 143.h,
            child: Obx(() {
              if (controller.isLoadingCategories.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final categories = controller.categoryTree
                  .where((cat) => cat.isFeatured == true && cat.parent == null)
                  .take(6)
                  .toList();

              if (categories.isEmpty) {
                return SizedBox.shrink();
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 4.h, // Add bottom padding for shadow
                ),
                itemCount: categories.length,
                separatorBuilder: (context, index) => Spacing.w(12.w),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(category);
                },
              );
            }),
          ),
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
              children: [
                AutoTranslateText(
                  category.name ?? '',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.88.sp,
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
                    fontSize: 11.04.sp,
                    color: '#6A7282'.toColor(),
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
