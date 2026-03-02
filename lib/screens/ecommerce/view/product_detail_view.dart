import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/product_details_widgets/product_main_details.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/product_details_widgets/product_description_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/product_details_widgets/product_specifications_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/product_details_widgets/product_reviews_widget.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

import '../widgets/product_details_widgets/image_carousel.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            CommonHeader(
              title: 'Product Details',
              customActions: [
                Obx(
                  () => IconButton(
                    onPressed: () => controller.toggleWishlist(),
                    icon: Icon(
                      controller.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: controller.isFavorite
                          ? AppColors.sacredRed
                          : '#6F221E'.toColor(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => controller.shareProduct(),
                  icon: Icon(Icons.share_outlined, color: '#6F221E'.toColor()),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.product.value == null) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.saffron),
                  );
                }

                final product = controller.product.value;
                if (product == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          'Product not found',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Images
                      ImageCarousel(controller: controller, product: product),

                      Spacing.h(15),
                      Padding(
                        padding: AppPaddings.symmetric(h: 8),
                        child: ProductMainDetails(productModel: product),
                      ),
                      SizedBox(height: 24.h),
                      // Product Info
                      Padding(
                        padding: AppPaddings.symmetric(h: 16),
                        child: ProductDescriptionWidget(),
                      ),
                      SizedBox(height: 24.h),
                      // Specifications
                      Padding(
                        padding: AppPaddings.symmetric(h: 16),
                        child: ProductSpecificationsWidget(),
                      ),
                      // SizedBox(height: 24.h),
                      // // Customer Reviews
                      // Padding(
                      //   padding: AppPaddings.symmetric(h: 16),
                      //   child: ProductReviewsWidget(),
                      // ),
                      SizedBox(height: 24.h),
                      // You May Also Like Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildYouMayAlsoLike(context, controller),
                      ),
                      SizedBox(height: 100.h), // Space for bottom bar
                    ],
                  ),
                );
              }),
            ),
            // Fixed Bottom Bar with Quantity and Action Buttons
            _buildBottomActionBar(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    ProductDetailController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: '#820B17'.toColor(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 25,
            offset: Offset(0, -12),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final outOfStock = controller.isOutOfStock;

          if (outOfStock) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null, // Disabled when out of stock
                style: ElevatedButton.styleFrom(
                  backgroundColor: '#E3B341'.toColor(),
                  foregroundColor: '#3D0C11'.toColor(),
                  disabledBackgroundColor: '#E3B341'.toColor().withValues(
                    alpha: 0.5,
                  ),
                  disabledForegroundColor: '#3D0C11'.toColor().withValues(
                    alpha: 0.5,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
                child: AutoTranslateText(
                  'Out of Stock',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          return Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      final quantity = controller.quantity.value;
                      final available = controller.availableQuantity;
                      final maxAllowed = available > 0
                          ? (available < CartController.maxQuantity
                                ? available
                                : CartController.maxQuantity)
                          : CartController.minQuantity;
                      final canDecrease = quantity > CartController.minQuantity;
                      final canIncrease =
                          quantity < maxAllowed && available > 0;

                      return Row(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: '#E3B341'.toColor(),
                            ),
                            icon: Icon(Icons.remove, size: 20.h),
                            onPressed: canDecrease
                                ? controller.decrementQuantity
                                : null,
                            color: canDecrease
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            padding: EdgeInsets.all(8.w),
                            constraints: BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Container(
                            width: 29.w,
                            alignment: Alignment.center,
                            child: AutoTranslateText(
                              '$quantity',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: '#E3B341'.toColor(),
                            ),
                            icon: Icon(Icons.add, size: 20),
                            onPressed: canIncrease
                                ? controller.incrementQuantity
                                : null,
                            color: canIncrease
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            padding: EdgeInsets.all(8.w),
                            constraints: BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Add Button
              Expanded(
                child: Obx(() {
                  final currentProduct = controller.product.value;
                  final isProcessing = currentProduct != null
                      ? controller.cartController.isProductUpdating(
                          currentProduct,
                        )
                      : false;

                  return ElevatedButton(
                    onPressed: isProcessing || currentProduct == null
                        ? null
                        : () => controller.addToCart(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        side: BorderSide(
                          color: '#E3B341'.toColor(),
                          width: 0.68,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: isProcessing
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 18.h),
                              SizedBox(width: 8.w),
                              AutoTranslateText(
                                'Add',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  );
                }),
              ),
              SizedBox(width: 8.w),
              // Buy Now Button
              Expanded(
                child: Obx(() {
                  final currentProduct = controller.product.value;
                  final isProcessing = currentProduct != null
                      ? controller.cartController.isProductUpdating(
                          currentProduct,
                        )
                      : false;

                  return ElevatedButton(
                    onPressed: isProcessing || currentProduct == null
                        ? null
                        : () => controller.buyNow(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: '#E3B341'.toColor(),
                      foregroundColor: '#3D0C11'.toColor(),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: isProcessing
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: '#3D0C11'.toColor(),
                            ),
                          )
                        : AutoTranslateText(
                            'Buy Now',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: '#3D0C11'.toColor(),
                            ),
                          ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildYouMayAlsoLike(
    BuildContext context,
    ProductDetailController controller,
  ) {
    return Obx(() {
      if (controller.isLoadingFrequentlyBought.value &&
          controller.frequentlyBoughtTogether.isEmpty &&
          controller.relatedProducts.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: CircularProgressIndicator(color: AppColors.saffron),
          ),
        );
      }

      final products = controller.frequentlyBoughtTogether.isNotEmpty
          ? controller.frequentlyBoughtTogether
          : controller.relatedProducts;

      if (products.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.saffron.withValues(alpha: 0.2),
            width: 0.68,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'You May Also Like',
              style: TextStyle(
                fontFamily: 'Baloo Bhai 2',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: '#820B17'.toColor(),
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              children: products.take(2).map((product) {
                final index = products.indexOf(product);
                return Padding(
                  padding: EdgeInsets.only(bottom: index < 1 ? 16.h : 0),
                  child: _buildYouMayAlsoLikeCard(product, controller),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildYouMayAlsoLikeCard(
    ProductModel product,
    ProductDetailController controller,
  ) {
    ProductImage? primaryImage;
    if (product.images != null && product.images!.isNotEmpty) {
      try {
        primaryImage = product.images!.firstWhere(
          (img) => img.isPrimary == true,
          orElse: () => product.images!.first,
        );
      } catch (_) {
        primaryImage = product.images!.first;
      }
    }

    String? imageUrl = primaryImage?.url;
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'http://65.1.131.197:8000$imageUrl';
    }
    final price =
        product.currentPrice ?? product.discountedPrice ?? product.basePrice;
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        final isOnProductDetail = Get.currentRoute == AppRoutes.productDetail;
        final heroTag =
            'you_may_like_${product.id ?? product.slug ?? DateTime.now().millisecondsSinceEpoch}';

        if (product.id != null && product.id!.isNotEmpty) {
          final args = {'productId': product.id.toString(), 'heroTag': heroTag};

          if (isOnProductDetail) {
            if (Get.isRegistered<ProductDetailController>()) {
              Get.delete<ProductDetailController>(force: true);
            }
            Get.offNamedUntil(
              AppRoutes.productDetail,
              (route) =>
                  route.settings.name == AppRoutes.userDashboard ||
                  route.settings.name == AppRoutes.root,
              arguments: args,
            );
          } else {
            UserMainController.pushInCurrentTab(AppRoutes.productDetail, arguments: args);
          }
        } else if (product.slug != null && product.slug!.isNotEmpty) {
          final args = {
            'productSlug': product.slug.toString(),
            'heroTag': heroTag,
          };

          if (isOnProductDetail) {
            if (Get.isRegistered<ProductDetailController>()) {
              Get.delete<ProductDetailController>(force: true);
            }
            Get.offNamedUntil(
              AppRoutes.productDetail,
              (route) =>
                  route.settings.name == AppRoutes.userDashboard ||
                  route.settings.name == AppRoutes.root,
              arguments: args,
            );
          } else {
            UserMainController.pushInCurrentTab(AppRoutes.productDetail, arguments: args);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.saffron.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: imageUrl != null
                  ? NetworkImageWithLoader(
                      url: imageUrl,
                      width: 80.w,
                      height: 80.w,
                    )
                  : Container(
                      width: 80.w,
                      height: 80.w,
                      color: AppColors.lightBackground,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            SizedBox(width: 16.w),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    product.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Baloo Bhai 2',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: '#820B17'.toColor(),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16.w, color: AppColors.saffron),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        '${product.averageRating ?? 4.9}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: '#3D0C11'.toColor(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  if (price != null)
                    AutoTranslateText(
                      formatter.format(price),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: '#820B17'.toColor(),
                      ),
                    ),
                ],
              ),
            ),
            // Chevron Icon
            Icon(Icons.chevron_right, color: '#3D0C11'.toColor(), size: 24.w),
          ],
        ),
      ),
    );
  }
}
