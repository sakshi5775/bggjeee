import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app_manager/my_text_theme.dart';
import '../../../../theme/app_typography.dart';

class FeaturedProductsWidget extends StatelessWidget {
  final EcommerceHomeController controller;

  const FeaturedProductsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.featuredProducts.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
              child: AutoTranslateText(
                'Featured Products',
                style: MyTextTheme.largeBCB
                    .merge(AppTypography.h2)
                    .copyWith(color: "#68171E".toColor()),
              ),
            ),
            SizedBox(
              height: 280.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 4.h, // Add bottom padding for shadow
                ),
                itemCount: controller.featuredProducts.length,
                separatorBuilder: (context, index) => Spacing.w(10.14.w),
                itemBuilder: (context, index) {
                  final product = controller.featuredProducts[index];
                  return _buildProductCard(product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());

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

    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final currentPrice =
        product.currentPrice ??
        product.discountedPrice ??
        product.basePrice ??
        0.0;
    final basePrice = product.basePrice ?? 0.0;
    final discountPercent = product.discountPercentage ?? 0.0;

    return GestureDetector(
      onTap: () => controller.navigateToProductDetail(product),
      child: Container(
        width: 185.8.w,
        padding: EdgeInsets.all(10.14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  width: 165.65.w,
                  height: 124.76.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: imageUrl != null
                        ? NetworkImageWithLoader(
                            url: imageUrl,
                            width: 165.65.w,
                            height: 124.76.h,
                          )
                        : Container(
                            color: Colors.grey.withValues(alpha: 0.2),
                            child: Icon(
                              Icons.image,
                              size: 40.w,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Obx(() {
                    final isFavorite = wishlistController.isInWishlist(product);
                    return GestureDetector(
                      onTap: () => wishlistController.toggleWishlist(product),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 16.sp,
                          color: isFavorite
                              ? AppColors.sacredRed
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Spacing.h(7.34),
            // Product Name and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AutoTranslateText(
                    product.name ?? '',
                    style: TextStyle(
                      fontFamily: 'Baloo 2',
                      fontWeight: FontWeight.w700,
                      fontSize: 16.23,
                      color: '#3D0C11'.toColor(),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacing.w(10.48),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 8.58.sp, color: '#FEC62B'.toColor()),
                    Spacing.w(3.04),
                    AutoTranslateText(
                      product.averageRating?.toStringAsFixed(1) ?? '4.9',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.48.sp,
                        color: '#FEC62B'.toColor(),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacing.h(8.11),
            // Price Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AutoTranslateText(
                      priceFormat.format(currentPrice),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.17.sp,
                        color: '#3D0C11'.toColor(),
                        height: 1.0,
                      ),
                    ),
                    if (basePrice > currentPrice) ...[
                      Spacing.w(4.06),
                      AutoTranslateText(
                        priceFormat.format(basePrice),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 8.11.sp,
                          color: '#99A1AF'.toColor(),
                          height: 2.5,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Spacing.w(4.06),
                      AutoTranslateText(
                        '${discountPercent.toStringAsFixed(0)}% Off',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 8.11.sp,
                          color: '#8B1925'.toColor(),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
                Spacing.h(4.06),
                Row(
                  children: [
                    AutoTranslateText(
                      'Free Delivery',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 8.11.sp,
                        color: AppColors.success,
                        height: 1.2,
                      ),
                    ),
                    AutoTranslateText(
                      '(COD Available)',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 8.11.sp,
                        color: '#99A1AF'.toColor(),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() {
                    final quantity = cartController.quantityForProduct(product);
                    final isProcessing = cartController.isProductUpdating(
                      product,
                    );

                    if (quantity <= 0) {
                      return GestureDetector(
                        onTap: isProcessing
                            ? null
                            : () async {
                                await cartController.addItem(
                                  product: product,
                                  quantity: 1,
                                );
                              },
                        child: Container(
                          height: 25.35.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                '#FF8C42'.toColor(),
                                '#E63946'.toColor(),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.14.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2.56,
                                offset: Offset(0, 1.28),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isProcessing
                                ? SizedBox(
                                    width: 16.w,
                                    height: 16.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : AutoTranslateText(
                                    'Buy Now',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.14.sp,
                                      color: Colors.white,
                                      height: 1.26,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: 25.35.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],
                        ),
                        borderRadius: BorderRadius.circular(10.14.r),
                      ),
                      child: Center(
                        child: AutoTranslateText(
                          quantity.toString(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 10.14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Spacing.w(5.07),
                GestureDetector(
                  onTap: () async {
                    final cartController = Get.find<CartController>();
                    await cartController.addItem(product: product, quantity: 1);
                  },
                  child: Container(
                    width: 24.06.w,
                    height: 24.06.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: '#FF8C42'.toColor(),
                        width: 0.39,
                      ),
                      borderRadius: BorderRadius.circular(10.14.r),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16.w,
                      color: '#FF8C42'.toColor(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

