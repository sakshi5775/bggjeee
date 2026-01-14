import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BigSaleBannerWidget extends StatelessWidget {
  final EcommerceHomeController controller;

  const BigSaleBannerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final featuredProducts = controller.featuredProducts.take(3).toList();

        if (featuredProducts.isEmpty) {
          return _buildPlaceholderBanner();
        }

        return Column(
          children: [
            Container(
              height: 171.04.h,
              width: 382.w,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: PageView.builder(
                controller: controller.bannerPageController,
                onPageChanged: controller.onBannerPageChanged,
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = featuredProducts[index];
                  return _buildBannerContent(product);
                },
              ),
            ),
            Spacing.h(10.h),
            if (featuredProducts.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(featuredProducts.length, (index) {
                  return Obx(
                    () => Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.85.w),
                      width: index == controller.currentBannerIndex.value
                          ? 22.81.w
                          : 6.w,
                      height: 5.7.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.85.r),
                        gradient: controller.currentBannerIndex.value == index
                            ? LinearGradient(
                                colors: [
                                  '#FF8C42'.toColor(),
                                  '#E63946'.toColor(),
                                ],
                              )
                            : null,
                        color: controller.currentBannerIndex.value == index
                            ? null
                            : '#FF8C42'.toColor().withValues(alpha: 0.3),
                      ),
                    ),
                  );
                }),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildBannerContent(ProductModel product) {
    ProductImage? primaryImage;
    if (product.images != null && product.images!.isNotEmpty) {
      try {
        primaryImage = product.images!.firstWhere(
          (img) => img.isPrimary == true,
          orElse: () => product.images!.first,
        );
      } catch (e) {
        if (product.images!.isNotEmpty) {
          primaryImage = product.images!.first;
        }
      }
    }

    String? imageUrl = primaryImage?.url;
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'http://65.1.131.197:8000$imageUrl';
    }

    return GestureDetector(
      onTap: () => controller.navigateToProductDetail(product),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imageUrl != null
                ? NetworkImageWithLoader(
                    url: imageUrl,
                    height: 171.04.h,
                    width: 382.w,
                  )
                : _buildPlaceholderImage(),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
          // Text content
          Positioned(
            left: 20.53.w,
            top: 13.68.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Big Sale',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 33.07.sp,
                    color: Colors.white,
                    height: 1.24,
                    letterSpacing: -0.01,
                  ),
                ),
                Spacing.h(8),
                AutoTranslateText(
                  'Up to 50%',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.68.sp,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                Spacing.h(20),
                AutoTranslateText(
                  'Happening Now',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    fontSize: 12.54.sp,
                    color: Colors.white,
                    height: 1.36,
                    letterSpacing: -0.01,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderBanner() {
    return Container(
      height: 171.04.h,
      width: 382.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoTranslateText(
              'Big Sale',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 33.07.sp,
                color: Colors.white,
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Up to 50%',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
                fontSize: 13.68.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: Center(
        child: Icon(Icons.image, size: 50.w, color: Colors.grey),
      ),
    );
  }
}
