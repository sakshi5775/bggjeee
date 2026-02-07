import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/cart_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SavedItemsView extends GetView<CartController> {
  const SavedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Saved Items'),
            Expanded(
              child: Obx(() {
                final savedItems = controller.savedItems;

                if ((controller.isLoading.value ||
                        controller.isUpdatingCart.value) &&
                    savedItems.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.saffron),
                  );
                }

                if (savedItems.isEmpty) {
                  return _EmptySavedItems(onShopNow: () => Get.back());
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  itemCount: savedItems.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, index) => _SavedItemTile(
                    item: savedItems[index],
                    currencyFormat: currencyFormat,
                    controller: controller,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedItemTile extends StatelessWidget {
  const _SavedItemTile({
    required this.item,
    required this.currencyFormat,
    required this.controller,
  });

  final CartItem item;
  final NumberFormat currencyFormat;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final productRef =
        product ??
        ProductModel(
          id: item.productSnapshot?.productId,
          slug: item.productSnapshot?.sku,
          name: item.productSnapshot?.name,
        );

    final name = product?.name ?? item.productSnapshot?.name ?? 'Product';
    final subtitle = product?.shortDescription ?? item.productSnapshot?.sku;
    final price =
        item.discountedPrice ??
        item.price ??
        product?.currentPrice ??
        product?.discountedPrice ??
        product?.basePrice ??
        0;

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

    final isProcessing = controller.isProductUpdating(productRef);

    return Container(
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
                      child: Icon(
                        Icons.image,
                        size: 28.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    name,
                    style: AppTypography.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    AutoTranslateText(
                      subtitle,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  AutoTranslateText(
                    currencyFormat.format(price),
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isProcessing
                              ? null
                              : () => controller.moveSavedItemToCart(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.saffron,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isProcessing
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
                                  style: AppTypography.body1.copyWith(
                                    fontWeight: FontWeight.w600,
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
    );
  }
}

class _EmptySavedItems extends StatelessWidget {
  const _EmptySavedItems({required this.onShopNow});

  final VoidCallback onShopNow;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 72.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            AutoTranslateText(
              'No saved items yet',
              style: AppTypography.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              'Items you save for later will appear here.',
              textAlign: TextAlign.center,
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
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
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
