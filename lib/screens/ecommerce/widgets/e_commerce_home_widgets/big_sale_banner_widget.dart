import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BigSaleBannerWidget extends StatelessWidget {
  final EcommerceHomeController controller;

  const BigSaleBannerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        // Prefer products that have an offer/discount
        final offerList = controller.offerProducts.take(5).toList();
        final displayProducts = offerList.isNotEmpty
            ? offerList
            : controller.featuredProducts.take(3).toList();

        if (displayProducts.isEmpty) {
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
                itemCount: displayProducts.length,
                itemBuilder: (context, index) {
                  return _buildBannerContent(displayProducts[index]);
                },
              ),
            ),
            Spacing.h(10.h),
            if (displayProducts.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(displayProducts.length, (index) {
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
        if (product.images!.isNotEmpty) primaryImage = product.images!.first;
      }
    }

    String? imageUrl = primaryImage?.url;
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'http://65.1.131.197:8000$imageUrl';
    }

    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final basePrice = product.basePrice ?? 0.0;
    final currentPrice =
        product.currentPrice ?? product.discountedPrice ?? basePrice;
    final discountPct = product.discountPercentage ??
        (basePrice > 0 && basePrice > currentPrice
            ? (basePrice - currentPrice) / basePrice * 100
            : 0.0);
    final hasDiscount = discountPct > 0;

    return GestureDetector(
      onTap: () => controller.navigateToProductDetail(product),
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imageUrl != null
                ? NetworkImageWithLoader(
                    url: imageUrl,
                    height: 171.04.h,
                    width: 382.w,
                    fit: BoxFit.cover,
                  )
                : _buildPlaceholderImage(),
          ),
          // Dark gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.15),
                ],
              ),
            ),
          ),
          // Text content (left side)
          Positioned(
            left: 16.w,
            top: 14.h,
            bottom: 14.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoTranslateText(
                  'Big Sale',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 28.sp,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                if (hasDiscount) ...[
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          '#FF8C42'.toColor(),
                          '#E63946'.toColor(),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: AutoTranslateText(
                      '${discountPct.toStringAsFixed(0)}% OFF',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 6.h),
                // Product name
                SizedBox(
                  width: 180.w,
                  child: AutoTranslateText(
                    product.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Price row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoTranslateText(
                      priceFormat.format(currentPrice),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: '#FFD700'.toColor(),
                        height: 1.2,
                      ),
                    ),
                    if (hasDiscount && basePrice > currentPrice) ...[
                      SizedBox(width: 6.w),
                      AutoTranslateText(
                        priceFormat.format(basePrice),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.6),
                          decoration: TextDecoration.lineThrough,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
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
        child: AutoTranslateText(
          'Big Sale',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 33.07.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.withValues(alpha: 0.3),
      child: Center(
        child: Icon(Icons.image, size: 50.w, color: Colors.grey),
      ),
    );
  }
}
