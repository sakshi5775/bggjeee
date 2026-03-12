import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/wishlist_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/featured_products_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

class WishlistView extends GetView<WishlistController> {
  final bool showBackButton;
  const WishlistView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(
              title: 'My Wishlist',
              showBackButton: showBackButton,
              subtitle: Obx(() {
                final count = controller.items.length;
                return AutoTranslateText(
                  count > 0
                      ? '$count ${count == 1 ? 'item' : 'items'} saved'
                      : 'Save products you love',
                  style: TextStyle(
                    color: '#6F221E'.toColor().withValues(alpha: 0.7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              customActions: [
                Obx(() {
                  final hasItems = controller.items.isNotEmpty;
                  final isBusy = controller.isUpdating.value;
                  if (!hasItems) return const SizedBox.shrink();
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: hasItems && !isBusy
                          ? controller.clearWishlist
                          : null,
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: '#6F221E'.toColor().withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: hasItems && !isBusy
                              ? '#6F221E'.toColor()
                              : '#6F221E'.toColor().withValues(alpha: 0.5),
                          size: 20.sp,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.saffron),
                  );
                }

                final items = controller.items;
                if (items.isEmpty) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _EmptyWishlist(
                          onShopNow: () {
                            Get.find<UserMainController>().changeTab(3);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: _YouMayAlsoLikeSection(controller: controller),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (_, index) {
                    if (index == items.length) {
                      return _YouMayAlsoLikeSection(controller: controller);
                    }
                    return _WishlistItemCard(
                      item: items[index],
                      controller: controller,
                      cartController: cartController,
                      currencyFormat: currencyFormat,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistItemCard extends StatelessWidget {
  const _WishlistItemCard({
    required this.item,
    required this.controller,
    required this.cartController,
    required this.currencyFormat,
  });

  final WishlistItem item;
  final WishlistController controller;
  final CartController cartController;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final name = product?.name ?? 'Product';
    final price =
        product?.currentPrice ??
        product?.discountedPrice ??
        product?.basePrice ??
        0;
    final originalPrice = product?.basePrice;
    final hasDiscount = originalPrice != null && originalPrice > price;

    String? imageUrl;
    if (product?.images != null && product!.images!.isNotEmpty) {
      final primary = product.images!.firstWhere(
        (img) => img.isPrimary == true,
        orElse: () => product.images!.first,
      );
      imageUrl = primary.url;
    }
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'http://65.1.131.197:8000$imageUrl';
    }

    final itemPending =
        controller.isItemProcessing(item) ||
        cartController.isWishlistItemProcessing(item);
    final disableActions = controller.isUpdating.value || itemPending;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white,
            '#FEF6C3'.toColor().withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: product != null && !disableActions
              ? () => UserMainController.pushInCurrentTab(
                  AppRoutes.productDetail,
                  arguments: {'product': product},
                )
              : null,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Stack(
                  children: [
                    Container(
                      width: 110.w,
                      height: 110.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: imageUrl != null
                            ? NetworkImageWithLoader(
                                url: imageUrl,
                                height: 110.h,
                                width: 110.w,
                              )
                            : Container(
                                height: 110.h,
                                width: 110.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.textSecondary.withValues(
                                        alpha: 0.1,
                                      ),
                                      AppColors.textSecondary.withValues(
                                        alpha: 0.05,
                                      ),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 40.sp,
                                  color: AppColors.textSecondary.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    // Discount Badge
                    if (hasDiscount)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: '#F38B3B'.toColor().withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AutoTranslateText(
                            '${((originalPrice - price) / originalPrice * 100).toStringAsFixed(0)}% OFF',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    // Favorite Icon Badge
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: '#68171E'.toColor().withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 16.sp,
                          color: '#E3B341'.toColor(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      AutoTranslateText(
                        name,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: '#68171E'.toColor(),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AutoTranslateText(
                              currencyFormat.format(price),
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                                color: '#68171E'.toColor(),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasDiscount) ...[
                            SizedBox(width: 8.w),
                            Flexible(
                              child: AutoTranslateText(
                                currencyFormat.format(originalPrice),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Action Buttons
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: '#F38B3B'.toColor().withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: disableActions
                                      ? null
                                      : () => cartController
                                            .moveWishlistItemToCart(item),
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                      horizontal: 8.w,
                                    ),
                                    alignment: Alignment.center,
                                    child: itemPending
                                        ? SizedBox(
                                            width: 18.w,
                                            height: 18.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.shopping_cart_rounded,
                                                size: 18.sp,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 6.w),
                                              Flexible(
                                                child: AutoTranslateText(
                                                  'Move to Cart',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13.sp,
                                                    color: Colors.white,
                                                    letterSpacing: 0.5,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.sacredRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.sacredRed.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: disableActions || product == null
                                    ? null
                                    : () => controller.removeFromWishlist(
                                        product,
                                      ),
                                borderRadius: BorderRadius.circular(16.r),
                                child: Container(
                                  width: 48.w,
                                  height: 48.w,
                                  alignment: Alignment.center,
                                  child: itemPending
                                      ? SizedBox(
                                          width: 18.w,
                                          height: 18.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.sacredRed,
                                          ),
                                        )
                                      : Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.sacredRed,
                                          size: 22.sp,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist({required this.onShopNow});

  final VoidCallback onShopNow;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: '#68171E'.toColor().withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 64.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            AutoTranslateText(
              'Your wishlist is empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                color: '#68171E'.toColor(),
              ),
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Save products you love and move them to cart anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: '#F38B3B'.toColor().withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onShopNow,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 14.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          'Continue Shopping',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YouMayAlsoLikeSection extends StatelessWidget {
  const _YouMayAlsoLikeSection({required this.controller});

  final WishlistController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYouMayAlsoLike.value &&
          controller.youMayAlsoLikeProducts.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                color: AppColors.saffron,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }
      if (controller.youMayAlsoLikeProducts.isEmpty) return SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
            child: AutoTranslateText(
              'You may also like',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: '#68171E'.toColor(),
              ),
            ),
          ),
          SizedBox(
            height: 300.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.youMayAlsoLikeProducts.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final product = controller.youMayAlsoLikeProducts[index];
                return FeaturedProductsWidget.buildFeaturedStyleCard(
                  product,
                  () => UserMainController.pushInCurrentTab(
                    AppRoutes.productDetail,
                    arguments: {'product': product},
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
