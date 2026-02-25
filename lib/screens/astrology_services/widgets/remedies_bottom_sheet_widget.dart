import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrology_services_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import '../../../utils/app_colors.dart';

class RemediesBottomSheetWidget extends StatelessWidget {
  final AstrologyServicesController controller;

  const RemediesBottomSheetWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF3D0C11),
                              const Color(0xFF5D1C21),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Astro Remedies',
                        style: MyTextTheme.largeBCB.copyWith(
                          color: const Color(0xFF5F2221),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: const Color(0xFF5F2221),
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),
            // Categories Content
            Expanded(
              child: Obx(() {
                if (controller.isLoadingRemedyCategories.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFFDFB343),
                    ),
                  );
                }

                if (controller.remedyCategories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64.w,
                          color: const Color(0xFF999999),
                        ),
                        Spacing.h(16),
                        AutoTranslateText(
                          'No remedies available',
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: const Color(0xFF5F2221),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    // Categories Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: controller.remedyCategories.length,
                      itemBuilder: (context, index) {
                        final category = controller.remedyCategories[index];
                        return _buildRemedyCategoryCard(category);
                      },
                    ),
                    Spacing.h(24),
                    // View All Button
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          UserMainController.pushInCurrentTab(
                            '/user-shop',
                            arguments: {'showBackButton': true},
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: AutoTranslateText(
                              'View All Remedies',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemedyCategoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        Get.back();
        // Navigate to product list with category filter
        if (category.id != null) {
          UserMainController.pushInCurrentTab('/product-list', arguments: {'category': category});
        } else if (category.slug != null) {
          UserMainController.pushInCurrentTab(
            '/product-list',
            arguments: {'categorySlug': category.slug},
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Image
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: category.image != null && category.image!.isNotEmpty
                      ? NetworkImageWithLoader(
                          url: category.image!,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Icon(Icons.category, color: Colors.white, size: 30.w),
                ),
              ),
            ),
            Spacing.h(6),
            // Category Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: AutoTranslateText(
                category.name ?? 'Category',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(4),
            // Item Count
            if (category.productCount != null && category.productCount! > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: AutoTranslateText(
                  '${category.productCount} items',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF999999),
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Spacing.h(6),
          ],
        ),
      ),
    );
  }
}
