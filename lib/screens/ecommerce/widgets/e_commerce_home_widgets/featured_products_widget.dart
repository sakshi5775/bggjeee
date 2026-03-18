import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Featured Products',
                    style: AppTypography.h2.copyWith(color: '#68171E'.toColor()),
                  ),
                  GestureDetector(
                    onTap: () => UserMainController.pushInCurrentTab(
                      AppRoutes.productList,
                      arguments: {
                        'title': 'Featured Products',
                        'filterType': 'featured',
                        'isFeatured': true,
                      },
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoTranslateText(
                          'View All',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: '#68171E'.toColor(),
                          ),
                        ),
                        Spacing.w(4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.sp,
                          color: '#68171E'.toColor(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 320.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 4.h,
                ),
                itemCount: controller.featuredProducts.length,
                separatorBuilder: (context, index) => Spacing.w(10.14.w),
                itemBuilder: (context, index) {
                  final product = controller.featuredProducts[index];
                  return FeaturedProductsWidget.buildFeaturedStyleCard(
                    product,
                    () => controller.navigateToProductDetail(product),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Same card design and size as featured list. Use for Recommended for you etc.
  static Widget buildFeaturedStyleCard(ProductModel product, VoidCallback onTap) {
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

    const double imageFraction = 0.78;
    const double infoFraction = 0.22;
    final double cardHeight = 300.h;
    final double cardWidth = 220.w;
    final double imageHeight = cardHeight * imageFraction;
    final double infoHeight = cardHeight * infoFraction;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 80% – Product Image with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: imageUrl != null
                        ? NetworkImageWithLoader(
                            url: imageUrl,
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
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
                if (discountPercent > 0)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: '#FEC62B'.toColor(),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: AutoTranslateText(
                        '${discountPercent.toStringAsFixed(0)}% Off',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // 20% – Information section (fits within infoHeight, no overflow)
            Container(
              height: infoHeight,
              padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    product.name ?? '',
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                      color: '#3D0C11'.toColor(),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 9.sp, color: '#FEC62B'.toColor()),
                      Spacing.w(2),
                      AutoTranslateText(
                        product.averageRating?.toStringAsFixed(1) ?? '4.9',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 9.sp,
                          color: '#FEC62B'.toColor(),
                        ),
                      ),
                      Spacing.w(4),
                      Expanded(
                        child: AutoTranslateText(
                          '${product.reviewCount ?? 0} reviews',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 8.sp,
                            color: '#99A1AF'.toColor(),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoTranslateText(
                        priceFormat.format(currentPrice),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: '#3D0C11'.toColor(),
                        ),
                      ),
                      if (basePrice > currentPrice) ...[
                        Spacing.w(4),
                        AutoTranslateText(
                          priceFormat.format(basePrice),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 9.sp,
                            color: '#99A1AF'.toColor(),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      Spacer(),
                      Obx(() {
                        final quantity = cartController.quantityForProduct(product);
                        final isProcessing = cartController.isProductUpdating(product);

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (quantity <= 0)
                              GestureDetector(
                                onTap: isProcessing
                                    ? null
                                    : () async {
                                        await cartController.addItem(
                                          product: product,
                                          quantity: 1,
                                        );
                                      },
                                child: Container(
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.orangeGradient,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Center(
                                    child: isProcessing
                                        ? SizedBox(
                                            width: 12.w,
                                            height: 12.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.add_shopping_cart,
                                                size: 12.sp,
                                                color: Colors.white,
                                              ),
                                              Spacing.w(4),
                                              AutoTranslateText(
                                                'Add',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                height: 30.h,
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: isProcessing
                                          ? null
                                          : () => cartController.decrementProduct(product),
                                      child: Container(
                                        width: 26.w,
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.remove, size: 13.sp, color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      width: 22.w,
                                      alignment: Alignment.center,
                                      child: AutoTranslateText(
                                        quantity.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: isProcessing
                                          ? null
                                          : () => cartController.incrementProduct(product),
                                      child: Container(
                                        width: 26.w,
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.add, size: 13.sp, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Spacing.w(6),
                            Obx(() {
                              final isFavorite = wishlistController.isInWishlist(product);
                              return GestureDetector(
                                onTap: () => wishlistController.toggleWishlist(product),
                                child: Container(
                                  width: 30.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.orangeGradient,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    size: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
