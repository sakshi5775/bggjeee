import 'package:astrobharataiuser/app_manager/my_appbar.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Scaffold(
      appBar: MyAppbar(
        title: 'Product Details',
        showLeading: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.product.value == null) {
          return Center(child: CircularProgressIndicator(color: AppColors.saffron));
        }

        final product = controller.product.value;
        if (product == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.textSecondary),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              _buildImageCarousel(context, controller, product),
              // Product Info
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.categoryObj?.name != null)
                      AutoTranslateText(
                        'Category: ${product.categoryObj!.name!}',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (product.productType != null && product.productType!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        'Type: ${product.productType!}',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    // Product Name
                    AutoTranslateText(
                      product.name ?? '',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Rating and Reviews
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final rating = product.averageRating ?? 0.0;
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 16,
                            color: AppColors.saffron,
                          );
                        }),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          '(${product.reviewCount ?? 0} reviews)',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Price
                    _buildPriceSection(product),
                    SizedBox(height: 16.h),
                    // Short Description
                    if (product.shortDescription != null && product.shortDescription!.isNotEmpty)
                      AutoTranslateText(
                        product.shortDescription!,
                        style: AppTypography.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    SizedBox(height: 16.h),
                    // Badges
                    _buildBadges(product, controller),
                    SizedBox(height: 24.h),
                    // Quantity Selector
                    _buildQuantitySelector(controller),
                    SizedBox(height: 24.h),
                    // Action Buttons
                    _buildActionButtons(context, controller),
                    SizedBox(height: 16.h),
                    _buildSecondaryActions(controller),
                    SizedBox(height: 20.h),
                    _buildAssuranceRow(),
                    SizedBox(height: 24.h),
                    // Recently Viewed
                    _buildRecentlyViewed(context, controller),
                    if (controller.inventoryItems.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      _buildInventorySection(controller),
                    ],
                    SizedBox(height: 24.h),
                    // Description
                    _buildDescription(product),
                    SizedBox(height: 24.h),
                    // Specifications
                    if (product.specifications != null) _buildSpecifications(product),
                    SizedBox(height: 24.h),
                    // Spiritual Benefits
                    if (product.spiritualBenefits != null && product.spiritualBenefits!.isNotEmpty)
                      _buildSpiritualBenefits(product),
                    if (product.usageInstructions != null && product.usageInstructions!.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      _buildUsageSection(product),
                    ],
                    if (product.authenticityGuarantee != null && product.authenticityGuarantee!.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      _buildAuthenticitySection(product),
                    ],
                    if (product.certification != null) ...[
                      SizedBox(height: 24.h),
                      _buildCertificationSection(product),
                    ],
                    // Variants
                    if (controller.variants.isNotEmpty) ...[
                      _buildVariants(context, controller),
                      SizedBox(height: 24.h),
                    ],
                    if (controller.isLoadingFrequentlyBought.value &&
                        controller.frequentlyBoughtTogether.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: CircularProgressIndicator(color: AppColors.saffron),
                        ),
                      ),
                    // Frequently Bought Together / Related Products
                    if (controller.frequentlyBoughtTogether.isNotEmpty) ...[
                      _buildFrequentlyBoughtTogether(context, controller),
                      SizedBox(height: 24.h),
                    ] else if (controller.relatedProducts.isNotEmpty) ...[
                      _buildRelatedProducts(context, controller),
                      SizedBox(height: 24.h),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageCarousel(BuildContext context, ProductDetailController controller, ProductModel product) {
    final images = product.images ?? [];
    final heroTag = controller.heroTag ?? 'product_image_${product.id ?? product.slug ?? ''}';
    
    if (images.isEmpty) {
      return Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 300.h,
            color: AppColors.textSecondary.withOpacity(0.1),
            child: Center(
              child: Icon(Icons.image, size: 64, color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    // Get the first image URL for Hero animation
    String? firstImageUrl = images.first.url;
    if (firstImageUrl != null && firstImageUrl.startsWith('/')) {
      firstImageUrl = 'http://65.1.131.197:8000$firstImageUrl';
    }

    return Column(
      children: [
        Hero(
          tag: heroTag,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 300.h,
              child: PageView.builder(
                controller: PageController(initialPage: controller.currentImageIndex.value),
                onPageChanged: controller.changeImageIndex,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  String? imageUrl = images[index].url;
                  if (imageUrl != null && imageUrl.startsWith('/')) {
                    imageUrl = 'http://65.1.131.197:8000$imageUrl';
                  }
                  return imageUrl != null
                      ? NetworkImageWithLoader(url: imageUrl, height: 300.h, width: double.infinity)
                      : Container(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          child: Center(
                            child: Icon(Icons.image, size: 64, color: AppColors.textSecondary),
                          ),
                        );
                },
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Obx(() => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.currentImageIndex.value == index
                            ? AppColors.saffron
                            : AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ));
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceSection(ProductModel product) {
    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final currentPrice = product.currentPrice ?? product.discountedPrice ?? product.basePrice ?? 0.0;
    final basePrice = product.basePrice ?? 0.0;
    final discount = product.discountPercentage ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AutoTranslateText(
              priceFormat.format(currentPrice),
              style: AppTypography.h1.copyWith(
                color: AppColors.saffron,
              ),
            ),
            if (basePrice > currentPrice) ...[
              SizedBox(width: 12.w),
              AutoTranslateText(
                priceFormat.format(basePrice),
                style: AppTypography.h2.copyWith(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  'Save ${discount.toStringAsFixed(0)}%',
                  style: AppTypography.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4.h),
        AutoTranslateText(
          'Inclusive of all taxes',
          style: AppTypography.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBadges(ProductModel product, ProductDetailController controller) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (product.categoryObj?.name != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.category_outlined, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                AutoTranslateText(
                  product.categoryObj!.name!,
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        if (product.productType != null && product.productType!.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_fix_high_outlined, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                AutoTranslateText(
                  product.productType!,
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        if (product.certification?.isCertified == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.saffron.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.saffron),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 16, color: AppColors.saffron),
                SizedBox(width: 4.w),
                AutoTranslateText(
                  'Certified',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (product.isEnergized == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.saffron.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.saffron),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 16, color: AppColors.saffron),
                SizedBox(width: 4.w),
                AutoTranslateText(
                  'Energized',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        Obx(() {
          // Calculate available quantity directly from inventoryItems to make it observable
          // Access .length explicitly to ensure GetX tracks the observable list
          final inventoryItems = controller.inventoryItems;
          final itemCount = inventoryItems.length; // Explicitly access length for GetX tracking
          int available;
          if (itemCount == 0) {
            available = CartController.maxQuantity;
          } else {
            final first = inventoryItems.first;
            final qty = first.quantityAvailable ?? first.totalStock ?? CartController.maxQuantity;
            available = qty > 0 ? qty : 0;
          }
          if (available > 0) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  SizedBox(width: 4.w),
                  AutoTranslateText(
                    'In Stock',
                    style: AppTypography.body2.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, size: 16, color: Colors.red),
                  SizedBox(width: 4.w),
                  AutoTranslateText(
                    'Out of Stock',
                    style: AppTypography.body2.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }

  Widget _buildQuantitySelector(ProductDetailController controller) {
    return Obx(() {
      final quantity = controller.quantity.value;
      final available = controller.availableQuantity;
      final maxAllowed = available > 0
          ? (available < CartController.maxQuantity ? available : CartController.maxQuantity)
          : CartController.minQuantity;
      final canDecrease = quantity > CartController.minQuantity;
      final canIncrease = quantity < maxAllowed && available > 0;

      return Row(
        children: [
          AutoTranslateText(
            'Quantity:',
            style: AppTypography.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 16.w),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 20),
                  onPressed: canDecrease ? controller.decrementQuantity : null,
                  color: canDecrease ? AppColors.saffron : AppColors.textSecondary.withOpacity(0.4),
                ),
                Container(
                  width: 40.w,
                  alignment: Alignment.center,
                  child: AutoTranslateText(
                    '$quantity',
                    style: AppTypography.h2.copyWith(
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 20),
                  onPressed: canIncrease ? controller.incrementQuantity : null,
                  color: canIncrease ? AppColors.saffron : AppColors.textSecondary.withOpacity(0.4),
                ),
              ],
            ),
          ),
          if (available > 0)
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: AutoTranslateText(
                '$available available',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: AutoTranslateText(
                'Out of stock',
                style: AppTypography.body2.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildActionButtons(BuildContext context, ProductDetailController controller) {
    return Obx(() {
      final currentProduct = controller.product.value;
      final isProcessing = currentProduct != null
          ? controller.cartController.isProductUpdating(currentProduct)
          : false;
      final cartQuantity = currentProduct != null
          ? controller.cartController.quantityForProduct(currentProduct)
          : 0;

      if (currentProduct != null && cartQuantity > 0) {
        final canIncreaseCart = cartQuantity < CartController.maxQuantity;
        return Row(
          children: [
            Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(color: AppColors.saffron),
                color: AppColors.saffron.withOpacity(0.08),
              ),
              child: isProcessing
                  ? Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.saffron,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => controller.cartController.decrementProduct(currentProduct),
                          borderRadius: BorderRadius.circular(18.r),
                          child: SizedBox(
                            width: 36.w,
                            height: double.infinity,
                            child: Icon(
                              Icons.remove,
                              size: 18.sp,
                              color: AppColors.saffron,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        AutoTranslateText(
                          cartQuantity.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        InkWell(
                          onTap: canIncreaseCart
                              ? () => controller.cartController.incrementProduct(currentProduct)
                              : null,
                          borderRadius: BorderRadius.circular(18.r),
                          child: SizedBox(
                            width: 36.w,
                            height: double.infinity,
                            child: Icon(
                              Icons.add,
                              size: 18.sp,
                              color: canIncreaseCart
                                  ? AppColors.saffron
                                  : AppColors.textSecondary.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: isProcessing ? null : () => Get.toNamed(AppRoutes.cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: AutoTranslateText(
                  'View Cart',
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      }

      final outOfStock = controller.isOutOfStock;
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isProcessing || currentProduct == null || outOfStock
                  ? null
                  : () => controller.addToCart(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffron,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
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
                        Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          outOfStock ? 'Out of Stock' : 'Add to Cart',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton(
              onPressed: isProcessing || currentProduct == null || outOfStock
                  ? null
                  : () => controller.buyNow(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: AppColors.saffron, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: AutoTranslateText(
                'Buy Now',
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.saffron,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSecondaryActions(ProductDetailController controller) {
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());

    return Obx(() {
      final product = controller.product.value;
      final isWishlisted = product != null && wishlistController.isInWishlist(product);
      final isUpdating = wishlistController.isUpdating.value;

      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: product == null || isUpdating
                  ? null
                  : () => wishlistController.toggleWishlist(product),
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? AppColors.sacredRed : AppColors.textPrimary,
                size: 18.sp,
              ),
              label: isUpdating
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.saffron,
                      ),
                    )
                  : AutoTranslateText(
                      isWishlisted ? 'Wishlist (Saved)' : 'Add to Wishlist',
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isWishlisted ? AppColors.sacredRed : AppColors.textPrimary,
                      ),
                    ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                side: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => controller.showErrorMessage(
                title: 'Coming soon',
                message: 'Share feature will be available shortly.',
              ),
              icon: Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 18.sp),
              label: AutoTranslateText(
                'Share',
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                side: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDescription(ProductModel product) {
    if (product.description == null || product.description!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        AutoTranslateText(
          product.description!,
          style: AppTypography.body1.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAssuranceRow() {
    Widget buildCard(IconData icon, String title, String subtitle) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.saffron, size: 22),
              SizedBox(height: 8.h),
              AutoTranslateText(
                title,
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              AutoTranslateText(
                subtitle,
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        buildCard(Icons.local_shipping_outlined, 'Free Delivery', 'Orders above ₹500'),
        buildCard(Icons.verified_user_outlined, '100% Authentic', 'Certified products'),
      ],
    );
  }

  Widget _buildSpecifications(ProductModel product) {
    final specs = product.specifications!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Specifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              if (specs.origin != null) _buildSpecRow('Origin', specs.origin!),
              if (specs.material != null) _buildSpecRow('Material', specs.material!),
              if (specs.size != null) _buildSpecRow('Size', specs.size!),
              if (specs.mukhiCount != null) _buildSpecRow('Mukhi Count', specs.mukhiCount.toString()),
              if (specs.quality != null) _buildSpecRow('Quality', specs.quality!),
              if (specs.weight?.value != null)
                _buildSpecRow('Weight', '${specs.weight!.value} ${specs.weight!.unit ?? 'g'}'),
              if (specs.dimensions != null &&
                  (specs.dimensions!.length != null ||
                      specs.dimensions!.width != null ||
                      specs.dimensions!.height != null))
                _buildSpecRow(
                  'Dimensions',
                  [
                    if (specs.dimensions!.length != null) 'L ${specs.dimensions!.length}',
                    if (specs.dimensions!.width != null) 'W ${specs.dimensions!.width}',
                    if (specs.dimensions!.height != null) 'H ${specs.dimensions!.height}',
                  ].join(' × ') +
                      ' ${specs.dimensions!.unit ?? ''}',
                ),
              if (specs.beadCount != null) _buildSpecRow('Bead Count', specs.beadCount.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: AppTypography.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: AppTypography.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualBenefits(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Spiritual Benefits',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...product.spiritualBenefits!.map((benefit) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 20, color: AppColors.saffron),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AutoTranslateText(
                      benefit,
                      style: AppTypography.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildUsageSection(ProductModel product) {
    if (product.usageInstructions == null || product.usageInstructions!.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildInfoCard(
      title: 'Usage Instructions',
      icon: Icons.self_improvement,
      child: AutoTranslateText(
        product.usageInstructions!,
        style: AppTypography.body1.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildAuthenticitySection(ProductModel product) {
    if (product.authenticityGuarantee == null || product.authenticityGuarantee!.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildInfoCard(
      title: 'Authenticity Guarantee',
      icon: Icons.verified_user_outlined,
      child: AutoTranslateText(
        product.authenticityGuarantee!,
        style: AppTypography.body1.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCertificationSection(ProductModel product) {
    final certification = product.certification;
    if (certification == null) return SizedBox.shrink();

    final details = <MapEntry<String, String>>[];
    if (certification.isCertified != null) {
      details.add(MapEntry('Certified', certification.isCertified! ? 'Yes' : 'No'));
    }
    if (certification.certifyingAuthority != null && certification.certifyingAuthority!.isNotEmpty) {
      details.add(MapEntry('Authority', certification.certifyingAuthority!));
    }
    if (certification.certificateNumber != null && certification.certificateNumber!.isNotEmpty) {
      details.add(MapEntry('Certificate No.', certification.certificateNumber!));
    }
    if (certification.certificationDate != null) {
      try {
        final date = DateTime.parse(certification.certificationDate!).toLocal();
        details.add(MapEntry('Certification Date', DateFormat('dd MMM yyyy').format(date)));
      } catch (_) {
        details.add(MapEntry('Certification Date', certification.certificationDate!));
      }
    }
    if (details.isEmpty && (certification.certificateUrl == null || certification.certificateUrl!.isEmpty)) {
      return SizedBox.shrink();
    }

    return _buildInfoCard(
      title: 'Certification',
      icon: Icons.workspace_premium_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...details.map((entry) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120.w,
                      child: AutoTranslateText(
                        entry.key,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AutoTranslateText(
                        entry.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          if (certification.certificateUrl != null && certification.certificateUrl!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: AutoTranslateText(
                'Certificate URL: ${certification.certificateUrl}',
                style: AppTypography.body2.copyWith(
                  color: AppColors.peacockBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildInventorySection(ProductDetailController controller) {
    if (controller.inventoryItems.isEmpty) {
      return SizedBox.shrink();
    }
    final inventory = controller.inventoryItems.first;
    final available = inventory.quantityAvailable ?? inventory.totalStock ?? 0;

    return _buildInfoCard(
      title: 'Availability',
      icon: Icons.inventory_2_outlined,
      child: Row(
        children: [
          Icon(
            available > 0 ? Icons.check_circle : Icons.error_outline,
            color: available > 0 ? AppColors.success : AppColors.error,
            size: 18,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AutoTranslateText(
              available > 0
                  ? '$available pieces available • ${inventory.totalStock ?? available} total stock'
                  : 'Currently out of stock',
              style: AppTypography.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.saffron),
              SizedBox(width: 8.w),
              AutoTranslateText(
                title,
                style: AppTypography.h2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildVariants(BuildContext context, ProductDetailController controller) {
    return Obx(() {
      if (controller.variants.isEmpty) return SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Available Variants',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.variants.map((variant) {
              final isSelected = controller.selectedVariant.value?.id == variant.id;
              return GestureDetector(
                onTap: () => controller.selectVariant(variant),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.saffron : Colors.white,
                    border: Border.all(
                      color: isSelected ? AppColors.saffron : AppColors.textSecondary.withOpacity(0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        variant.name ?? 'Variant',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      if (variant.price != null) ...[
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          '₹${variant.price!.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : AppColors.saffron,
                          ),
                        ),
                      ],
                      if (variant.stock != null) ...[
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Stock: ${variant.stock}',
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildFrequentlyBoughtTogether(
    BuildContext context,
    ProductDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoTranslateText(
              'Frequently Bought Together',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to product list filtered by frequently bought together
                final currentProduct = controller.product.value;
                if (currentProduct?.id != null) {
                  Get.toNamed(
                    AppRoutes.productList,
                    arguments: {
                      'title': 'Frequently Bought Together',
                      'filterType': 'frequentlyBoughtTogether',
                      'productId': currentProduct!.id,
                    },
                  );
                }
              },
              child: AutoTranslateText(
                'View All',
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.saffron,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 240.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: 8.w),
            itemCount: controller.frequentlyBoughtTogether.length,
            itemBuilder: (context, index) {
              final product = controller.frequentlyBoughtTogether[index];
              final heroTag = 'fbt_${index}_${product.id ?? product.slug ?? index}';
              return _RecommendationCard(
                product: product,
                heroTag: heroTag,
                onTap: () {
                  print('Frequently bought together tapped - Product ID: ${product.id}, Slug: ${product.slug}');
                  
                  // Prevent multiple taps
                  if (Get.isRegistered<ProductDetailController>()) {
                    final currentController = Get.find<ProductDetailController>();
                    if (currentController.isLoading.value) {
                      print('Already loading, ignoring tap');
                      return;
                    }
                  }
                  
                  try {
                    final isOnProductDetail = Get.currentRoute == AppRoutes.productDetail;
                    
                    if (product.id != null && product.id!.isNotEmpty) {
                      print('Navigating with productId: ${product.id}');
                      final args = {
                        'productId': product.id.toString(),
                        'heroTag': heroTag,
                      };
                      
                      if (isOnProductDetail) {
                        // Delete controller and navigate immediately
                        if (Get.isRegistered<ProductDetailController>()) {
                          Get.delete<ProductDetailController>(force: true);
                        }
                        // Use offNamedUntil to replace current route but keep root
                        Get.offNamedUntil(
                          AppRoutes.productDetail,
                          (route) => route.settings.name == AppRoutes.userDashboard || route.settings.name == AppRoutes.root,
                          arguments: args,
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.productDetail,
                          arguments: args,
                        );
                      }
                    } else if (product.slug != null && product.slug!.isNotEmpty) {
                      print('Navigating with productSlug: ${product.slug}');
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
                          (route) => route.settings.name == AppRoutes.userDashboard || route.settings.name == AppRoutes.root,
                          arguments: args,
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.productDetail,
                          arguments: args,
                        );
                      }
                    } else {
                      print('Navigating with product object');
                      final args = {
                        'product': product,
                        'heroTag': heroTag,
                      };
                      
                      if (isOnProductDetail) {
                        if (Get.isRegistered<ProductDetailController>()) {
                          Get.delete<ProductDetailController>(force: true);
                        }
                        Get.offNamedUntil(
                          AppRoutes.productDetail,
                          (route) => route.settings.name == AppRoutes.userDashboard || route.settings.name == AppRoutes.root,
                          arguments: args,
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.productDetail,
                          arguments: args,
                        );
                      }
                    }
                  } catch (e) {
                    print('Error during navigation: $e');
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedProducts(BuildContext context, ProductDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoTranslateText(
              'Related Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to product list filtered by related products
                final currentProduct = controller.product.value;
                if (currentProduct?.id != null) {
                  Get.toNamed(
                    AppRoutes.productList,
                    arguments: {
                      'title': 'Related Products',
                      'filterType': 'related',
                      'productId': currentProduct!.id,
                    },
                  );
                }
              },
              child: AutoTranslateText(
                'View All',
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.saffron,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 240.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: 8.w),
            itemCount: controller.relatedProducts.length,
            itemBuilder: (context, index) {
              final product = controller.relatedProducts[index];
              final heroTag = 'related_${index}_${product.id ?? product.slug ?? index}';
              return _RecommendationCard(
                product: product,
                heroTag: heroTag,
                onTap: () {
                  final isOnProductDetail = Get.currentRoute == AppRoutes.productDetail;
                  
                  // Delete controller to ensure fresh instance when navigating to same route
                  if (isOnProductDetail && Get.isRegistered<ProductDetailController>()) {
                    Get.delete<ProductDetailController>();
                  }
                  
                  if (product.id != null && product.id!.isNotEmpty) {
                    if (isOnProductDetail) {
                      Get.offNamed(
                        AppRoutes.productDetail,
                        arguments: {'productId': product.id.toString(), 'heroTag': heroTag},
                      );
                    } else {
                      Get.toNamed(
                        AppRoutes.productDetail,
                        arguments: {'productId': product.id.toString(), 'heroTag': heroTag},
                      );
                    }
                  } else if (product.slug != null && product.slug!.isNotEmpty) {
                    if (isOnProductDetail) {
                      Get.offNamed(
                        AppRoutes.productDetail,
                        arguments: {'productSlug': product.slug.toString(), 'heroTag': heroTag},
                      );
                    } else {
                      Get.toNamed(
                        AppRoutes.productDetail,
                        arguments: {'productSlug': product.slug.toString(), 'heroTag': heroTag},
                      );
                    }
                  } else {
                    if (isOnProductDetail) {
                      Get.offNamed(
                        AppRoutes.productDetail,
                        arguments: {'product': product, 'heroTag': heroTag},
                      );
                    } else {
                      Get.toNamed(
                        AppRoutes.productDetail,
                        arguments: {'product': product, 'heroTag': heroTag},
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyViewed(BuildContext context, ProductDetailController controller) {
    return Obx(() {
      if (controller.isLoadingRecentlyViewed.value && controller.recentlyViewed.isEmpty) {
        return SizedBox.shrink();
      }

      if (controller.recentlyViewed.isEmpty) {
        return SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Recently Viewed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.productList,
                    arguments: {
                      'title': 'Recently Viewed',
                      'filterType': 'recentlyViewed',
                    },
                  );
                },
                child: AutoTranslateText(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.saffron,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 240.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: 8.w),
              itemCount: controller.recentlyViewed.length,
              itemBuilder: (context, index) {
                final product = controller.recentlyViewed[index];
                final heroTag = 'recent_${index}_${product.id ?? product.slug ?? index}';
                return _RecommendationCard(
                  product: product,
                  heroTag: heroTag,
                  onTap: () {
                    final isOnProductDetail = Get.currentRoute == AppRoutes.productDetail;
                    
                    // Delete controller to ensure fresh instance when navigating to same route
                    if (isOnProductDetail && Get.isRegistered<ProductDetailController>()) {
                      Get.delete<ProductDetailController>();
                    }
                    
                    if (product.id != null && product.id!.isNotEmpty) {
                      if (isOnProductDetail) {
                        Get.offNamed(
                          AppRoutes.productDetail,
                          arguments: {'productId': product.id.toString(), 'heroTag': heroTag},
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.productDetail,
                          arguments: {'productId': product.id.toString(), 'heroTag': heroTag},
                        );
                      }
                    } else if (product.slug != null && product.slug!.isNotEmpty) {
                      if (isOnProductDetail) {
                        Get.offNamed(
                          AppRoutes.productDetail,
                          arguments: {'productSlug': product.slug.toString(), 'heroTag': heroTag},
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.productDetail,
                          arguments: {'productSlug': product.slug.toString(), 'heroTag': heroTag},
                        );
                      }
                    } else {
                      if (isOnProductDetail) {
                        Get.offNamed(
                          AppRoutes.productDetail,
                          arguments: {'product': product, 'heroTag': heroTag},
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.productDetail,
                          arguments: {'product': product, 'heroTag': heroTag},
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.product,
    required this.heroTag,
    required this.onTap,
  });

  final ProductModel product;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
    final price = product.currentPrice ?? product.discountedPrice ?? product.basePrice;
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 170.w,
        height: 240.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Hero(
                  tag: heroTag,
                  child: imageUrl != null
                      ? SizedBox.expand(
                          child: NetworkImageWithLoader(
                            url: imageUrl,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        )
                      : Container(
                          color: AppColors.lightBackground,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AutoTranslateText(
                        product.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (price != null)
                      AutoTranslateText(
                        formatter.format(price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffron,
                        ),
                      ),
                    if (product.discountPercentage != null &&
                        (product.discountPercentage ?? 0) > 0) ...[
                      SizedBox(height: 3.h),
                      Wrap(
                        spacing: 5.w,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (product.basePrice != null)
                            AutoTranslateText(
                              formatter.format(product.basePrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppColors.saffron.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: AutoTranslateText(
                              '-${product.discountPercentage!.toStringAsFixed(0)}%',
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.saffron,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
