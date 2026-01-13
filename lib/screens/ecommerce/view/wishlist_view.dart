import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/wishlist_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: AutoTranslateText(
          'My Wishlist',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ).merge(AppTypography.h2),
        ),
        actions: [
          Obx(() {
            final hasItems = controller.items.isNotEmpty;
            final isBusy = controller.isUpdating.value;
            return IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: hasItems && !isBusy ? AppColors.sacredRed : AppColors.textSecondary,
                size: 22.sp,
              ),
              tooltip: 'Clear wishlist',
              onPressed: hasItems && !isBusy ? controller.clearWishlist : null,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return Center(child: CircularProgressIndicator(color: AppColors.saffron));
        }

        final items = controller.items;
        if (items.isEmpty) {
          return _EmptyWishlist(onShopNow: () => Get.back());
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, index) => _WishlistItemTile(
            item: items[index],
            controller: controller,
            cartController: cartController,
            currencyFormat: currencyFormat,
          ),
        );
      }),
    );
  }
}

class _WishlistItemTile extends StatelessWidget {
  const _WishlistItemTile({
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
    final price = product?.currentPrice ?? product?.discountedPrice ?? product?.basePrice ?? 0;

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

    final itemPending = controller.isItemProcessing(item) || cartController.isWishlistItemProcessing(item);
    final disableActions = controller.isUpdating.value || itemPending;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: product != null && !disableActions
          ? () => Get.toNamed(
                AppRoutes.productDetail,
                arguments: {'product': product},
              )
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageUrl != null
                    ? NetworkImageWithLoader(
                        url: imageUrl,
                        height: 80.h,
                        width: 80.w,
                      )
                    : Container(
                        height: 80.h,
                        width: 80.w,
                        color: AppColors.textSecondary.withOpacity(0.08),
                        child: Icon(Icons.image, size: 28.sp, color: AppColors.textSecondary),
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ).merge(AppTypography.h3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    AutoTranslateText(
                      currencyFormat.format(price),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ).merge(AppTypography.body1),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: disableActions ? null : () => cartController.moveWishlistItemToCart(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.saffron,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: itemPending
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : AutoTranslateText(
                                    'Move to Cart',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ).merge(AppTypography.body2),
                                  ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        IconButton(
                          onPressed: disableActions || product == null
                              ? null
                              : () => controller.removeFromWishlist(product),
                          icon: Icon(Icons.delete_outline, color: AppColors.sacredRed, size: 22.sp),
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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 72.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            AutoTranslateText(
              'Your wishlist is empty',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ).merge(AppTypography.h3),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              'Save products you love and move them to cart anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ).merge(AppTypography.body2),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onShopNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffron,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: AutoTranslateText(
                'Continue Shopping',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ).merge(AppTypography.body1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

