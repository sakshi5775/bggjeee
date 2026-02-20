import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app_manager/network_image.dart';
import '../../../../data_model/product_model.dart';
import '../../../../theme/app_typography.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/auto_translate_text.dart';
import '../../controller/product_detail_controller.dart';

class ImageCarousel extends StatelessWidget {
  final ProductDetailController controller;
  final ProductModel product;
  const ImageCarousel({
    super.key,
    required this.controller,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageCarousel(context, controller, product);
  }

  Widget _buildImageCarousel(
    BuildContext context,
    ProductDetailController controller,
    ProductModel product,
  ) {
    final images = product.images ?? [];
    final heroTag =
        controller.heroTag ??
        'product_image_${product.id ?? product.slug ?? ''}';

    if (images.isEmpty) {
      return Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 300.h,
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            child: Center(
              child: Icon(
                Icons.image,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    final discount = product.discountPercentage ?? 0;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              // Main Image Viewer
              Hero(
                tag: heroTag,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 350.h,
                    child: PageView.builder(
                      controller: controller.pageController.value,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        controller.currentImageIndex.value = index;
                      },
                      itemBuilder: (context, index) {
                        String? imageUrl = images[index].url;
                        if (imageUrl != null && imageUrl.startsWith('/')) {
                          imageUrl = 'http://65.1.131.197:8000$imageUrl';
                        }

                        return imageUrl != null
                            ? NetworkImageWithLoader(
                                url: imageUrl,
                                height: 350.h,
                                width: double.infinity,
                              )
                            : Container(
                                color: AppColors.textSecondary.withValues(alpha: 0.1),
                                child: const Center(
                                  child: Icon(Icons.image, size: 64),
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
              // Discount Banner
              if (discount > 0)
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5733), Color(0xFFFF8D33)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: AutoTranslateText(
                      '${discount.toStringAsFixed(0)}% OFF',
                      style: AppTypography.body2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Certified Badge
              if (product.certification?.isCertified == true)
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3B341),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14.sp, color: Colors.black),
                        SizedBox(width: 4.w),
                        AutoTranslateText(
                          'Certified',
                          style: AppTypography.label.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          // Thumbnail Gallery
          Container(
            height: 100.h,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: images.length,
              itemBuilder: (context, index) {
                String? thumbUrl = images[index].url;
                if (thumbUrl != null && thumbUrl.startsWith('/')) {
                  thumbUrl = 'http://65.1.131.197:8000$thumbUrl';
                }
                return Obx(() {
                  final isSelected =
                      controller.currentImageIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.changeImageIndex(index),
                    child: Container(
                      width: 70.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.templeGold
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.templeGold.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: thumbUrl != null
                            ? NetworkImageWithLoader(
                                url: thumbUrl,
                                height: 70.h,
                                width: 70.w,
                              )
                            : Container(color: Colors.grey[300]),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

