import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_list_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/big_sale_banner_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/featured_products_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/promotional_banner_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/shop_banner_carousel_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/shop_by_category_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/shop_by_purpose_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/why_shop_with_us_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EcommerceHomeView extends BasePage<EcommerceHomeController> {
  final bool showBackButton;
  final bool hideHeader;

  const EcommerceHomeView({
    super.key,
    this.showBackButton = true,
    this.hideHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WishlistController>()) {
      Get.lazyPut(() => WishlistController(), fenix: true);
    }
    return Scaffold(
      backgroundColor: hideHeader
          ? Colors.transparent
          : AppColors.lightBackground,
      body: SafeArea(
        // top: !hideHeader,
        child: Obx(
          () => CustomScrollView(
            slivers: [
              // Header
              // Header
              if (!hideHeader)
                SliverToBoxAdapter(
                  child: CommonHeader(
                    title: 'Digital Mart',

                    customActions: [
                      // Wishlist Icon
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.wishlist),
                        child: Obx(() {
                          final wishlistController =
                              Get.isRegistered<WishlistController>()
                              ? Get.find<WishlistController>()
                              : null;
                          final wishCount =
                              wishlistController?.items.length ?? 0;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                wishCount > 0
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: '#6F221E'.toColor(),
                                size: 22.w,
                              ),
                              if (wishCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),

              // Helper to map categories to slider
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoadingCategories.value) {
                    return const SizedBox.shrink();
                  }

                  final tabs = [
                    'All',
                    ...controller.allCategories.map((c) => c.name ?? 'Unknown'),
                  ];
                  // Determine selected index
                  int selectedIndex = 0;
                  if (controller.selectedCategory.value != null) {
                    final index = controller.allCategories.indexWhere(
                      (c) => c.id == controller.selectedCategory.value!.id,
                    );
                    if (index != -1) selectedIndex = index + 1;
                  }

                  return CommonTabSlider(
                    tabs: tabs,
                    selectedIndex: selectedIndex,
                    onTabSelected: (index) {
                      if (index == 0) {
                        controller.selectCategory(null);
                      } else {
                        controller.selectCategory(
                          controller.allCategories[index - 1],
                        );
                      }
                    },
                  );
                }),
              ),

              // Search Bar
              _buildSearchBar(context),

              // Shop Banner Carousel
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.ecommerceBanners.isNotEmpty) {
                    return BannerCarouselWidget(
                      banners: controller.ecommerceBanners,
                    );
                  }
                  return const ShopBannerCarouselWidget();
                }),
              ),
              // Promotional Banner (News ticker style)
              SliverToBoxAdapter(child: PromotionalBannerWidget()),

              SliverToBoxAdapter(child: Spacing.h(15.h)),
              // Shop by Category Section
              if (controller.categoryTree.isNotEmpty)
                ShopByCategoryWidget(controller: controller),
              SliverToBoxAdapter(child: Spacing.h(15.h)),
              // Big Sale Banner
              BigSaleBannerWidget(controller: controller),
              SliverToBoxAdapter(child: Spacing.h(15.h)),
              // Featured Products Section
              FeaturedProductsWidget(controller: controller),
              SliverToBoxAdapter(child: Spacing.h(15.h)),
              // Shop by Purpose Section
              ShopByPurposeWidget(controller: controller),
              SliverToBoxAdapter(child: Spacing.h(15.h)),
              // Best Sellers Section
              if (controller.topSellingProducts.isNotEmpty)
                _buildBestSellersSection(context),

              // Recommendations
              if (controller.isLoadingRecommendations.value ||
                  controller.recommendedProducts.isNotEmpty)
                _buildHorizontalProductRail(
                  context,
                  title: 'Recommended for you',
                  products: controller.recommendedProducts,
                  isLoading: controller.isLoadingRecommendations.value,
                ),
              SliverToBoxAdapter(child: Spacing.h(15.h)),

              // Recently viewed
              if (controller.recentlyViewedProducts.isNotEmpty)
                _buildHorizontalProductRail(
                  context,
                  title: 'Recently viewed',
                  products: controller.recentlyViewedProducts,
                  isLoading: controller.isLoadingRecentlyViewed.value,
                  emptyPlaceholder: 'Browse products to see them here.',
                )
              else if (controller.isLoadingRecentlyViewed.value)
                _buildHorizontalProductRail(
                  context,
                  title: 'Recently viewed',
                  products: controller.recentlyViewedProducts,
                  isLoading: controller.isLoadingRecentlyViewed.value,
                ),

              // Why Shop With Us Section
              WhyShopWithUsWidget(),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        child: GestureDetector(
          onTap: () {
            controller.navigateToSearch();
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(Icons.search, color: "#DD2914".toColor()),
                  Spacing.w(10.w),
                  AutoTranslateText(
                    'Search products...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  Spacer(),
                  Icon(Icons.tune, color: "#DD2914".toColor()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.categories.length + 1, // +1 for "All"
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final isSelected =
                    isAll && controller.selectedCategory.value == null ||
                    !isAll &&
                        controller.selectedCategory.value?.id ==
                            controller.categories[index - 1].id;

                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      if (isAll) {
                        controller.selectCategory(null);
                        controller.selectedSubcategory.value = null;
                      } else {
                        final category = controller.categories[index - 1];
                        controller.selectCategory(category);
                        controller.selectedSubcategory.value = null;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  AppColors.saffron,
                                  AppColors.deepOrange,
                                ],
                              )
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(25.r),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: AppColors.textSecondary.withOpacity(0.3),
                              ),
                      ),
                      alignment: Alignment.center,
                      child: AutoTranslateText(
                        isAll
                            ? 'All'
                            : controller.categories[index - 1].name ?? '',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildSubcategoryFilters(
    BuildContext context,
    EcommerceHomeController controller,
  ) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.subcategories.length + 1, // +1 for "All"
          itemBuilder: (context, index) {
            final isAll = index == 0;
            final isSelected =
                isAll && controller.selectedSubcategory.value == null ||
                !isAll &&
                    controller.selectedSubcategory.value?.id ==
                        controller.subcategories[index - 1].id;

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  if (isAll) {
                    controller.selectedSubcategory.value = null;
                    // Navigate to product list with just category (no subcategory filter)
                    final category = controller.selectedCategory.value;
                    if (category != null) {
                      if (category.id != null) {
                        Get.toNamed(
                          '/product-list',
                          arguments: {'category': category},
                        );
                      } else if (category.slug != null) {
                        Get.toNamed(
                          '/product-list',
                          arguments: {'categorySlug': category.slug},
                        );
                      }
                    }
                  } else {
                    controller.selectSubcategory(
                      controller.subcategories[index - 1],
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [AppColors.saffron, AppColors.deepOrange],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),
                  ),
                  alignment: Alignment.center,
                  child: AutoTranslateText(
                    isAll
                        ? 'All ${controller.selectedCategory.value?.name ?? ""}'
                        : controller.subcategories[index - 1].name ?? '',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBestSellersSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: AutoTranslateText(
              'Best Sellers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.topSellingProducts.length,
            itemBuilder: (context, index) {
              final product = controller.topSellingProducts[index];
              final heroTag =
                  'home_best_${index}_${product.id ?? product.slug ?? index}';
              return buildProductListItem(
                context,
                product,
                null,
                heroTag: heroTag,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalProductRail(
    BuildContext context, {
    required String title,
    required List<ProductModel> products,
    required bool isLoading,
    String? emptyPlaceholder,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (title.toLowerCase().contains('recommended') ||
                    title.toLowerCase().contains('recently'))
                  TextButton(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.productList,
                        arguments: {
                          'title': title,
                          'filterType':
                              title.toLowerCase().contains('recommended')
                              ? 'recommended'
                              : 'recentlyViewed',
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
          ),
          if (isLoading && products.isEmpty)
            Container(
              height: 160.h,
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: AppColors.saffron),
            )
          else if (products.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: AutoTranslateText(
                emptyPlaceholder ?? 'No items available at the moment.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final heroTag =
                      "${title.toLowerCase().replaceAll(' ', '_')}_${index}_${product.id ?? product.slug ?? index}";
                  return buildProductCard(
                    context,
                    product,
                    null,
                    isHorizontal: true,
                    heroTag: heroTag,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  static Widget buildProductCard(
    BuildContext context,
    ProductModel product,
    ProductListController? listController, {
    bool isHorizontal = false,
    String? heroTag,
  }) {
    ProductImage? primaryImage;
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : null;

    // Safely get primary image
    if (product.images != null && product.images!.isNotEmpty) {
      try {
        primaryImage = product.images!.firstWhere(
          (img) => img.isPrimary == true,
          orElse: () => product.images!.first,
        );
      } catch (e) {
        // If firstWhere fails, try to get first image
        if (product.images!.isNotEmpty) {
          primaryImage = product.images!.first;
        }
      }
    }

    // Get full image URL
    String? imageUrl;
    if (primaryImage?.url != null) {
      imageUrl = primaryImage!.url!;
      // Handle relative URLs
      if (imageUrl.startsWith('/')) {
        imageUrl = 'http://65.1.131.197:8000$imageUrl';
      }
    }

    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final currentPrice =
        product.currentPrice ??
        product.discountedPrice ??
        product.basePrice ??
        0.0;
    final basePrice = product.basePrice ?? 0.0;

    final heroIdentifier =
        heroTag ?? 'product_image_${product.id ?? product.slug ?? ''}';

    return GestureDetector(
      onTap: () {
        if (listController != null) {
          listController.navigateToProductDetail(
            product,
            heroTag: heroIdentifier,
          );
        } else {
          try {
            Get.find<EcommerceHomeController>().navigateToProductDetail(
              product,
              heroTag: heroIdentifier,
            );
          } catch (e) {
            // If controller not found, try to navigate directly
            Get.toNamed(
              '/product-detail',
              arguments: {'product': product, 'heroTag': heroIdentifier},
            );
          }
        }
      },
      child: Container(
        width: isHorizontal ? 160.w : null,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image
            Stack(
              children: [
                Hero(
                  tag: heroIdentifier,
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                      child: imageUrl != null
                          ? SizedBox(
                              height: isHorizontal ? 100.h : 120.h,
                              width: double.infinity,
                              child: NetworkImageWithLoader(
                                url: imageUrl,
                                height: isHorizontal ? 100.h : 120.h,
                                width: double.infinity,
                              ),
                            )
                          : Container(
                              height: isHorizontal ? 100.h : 120.h,
                              width: double.infinity,
                              color: AppColors.textSecondary.withOpacity(0.1),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                // Discount Badge
                if (product.discountPercentage != null &&
                    product.discountPercentage! > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sacredRed,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: AutoTranslateText(
                        '${product.discountPercentage!.toStringAsFixed(0)}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.label),
                      ),
                    ),
                  ),
                if (wishlistController != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final isUpdating = wishlistController.isUpdating.value;
                      final isWishlisted = wishlistController.isInWishlist(
                        product,
                      );

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 18.sp,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 34.w,
                            minHeight: 34.h,
                          ),
                          icon: isUpdating
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.saffron,
                                  ),
                                )
                              : Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isWishlisted
                                      ? AppColors.saffron
                                      : AppColors.textPrimary,
                                ),
                          onPressed: isUpdating
                              ? null
                              : () =>
                                    wishlistController.toggleWishlist(product),
                        ),
                      );
                    }),
                  ),
              ],
            ),
            // Product Details
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rating - Smaller (optional, hide if no space)
                    if (product.averageRating != null &&
                        product.averageRating! > 0)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(5, (index) {
                              final rating = product.averageRating ?? 0.0;
                              return Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                size: 7,
                                color: AppColors.saffron,
                              );
                            }),
                            SizedBox(width: 2.w),
                            Flexible(
                              child: AutoTranslateText(
                                '(${product.reviewCount ?? 0})',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Product Name - Only 1 line
                    AutoTranslateText(
                      product.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    // Price
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: AutoTranslateText(
                            priceFormat.format(currentPrice),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffron,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (basePrice > currentPrice) ...[
                          SizedBox(width: 3.w),
                          Flexible(
                            child: AutoTranslateText(
                              priceFormat.format(basePrice),
                              style: TextStyle(
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
                    Spacer(),
                    // Add to Cart Button - Smaller
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        final quantity = cartController.quantityForProduct(
                          product,
                        );
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
                              width: double.infinity,
                              height: 24.h,
                              decoration: BoxDecoration(
                                gradient: isProcessing
                                    ? null
                                    : AppColors.orangeGradient,
                                color: isProcessing ? Colors.grey[300] : null,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              alignment: Alignment.center,
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
                                      'Add to Cart',
                                      style: AppTypography.label.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          );
                        }

                        if (isProcessing) {
                          return Container(
                            height: 26.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: AppColors.saffron),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.saffron,
                              ),
                            ),
                          );
                        }

                        final canIncrement =
                            quantity < CartController.maxQuantity;
                        return Container(
                          height: 26.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: AppColors.saffron),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _QuantityIconButton(
                                icon: Icons.remove,
                                onTap: () =>
                                    cartController.decrementProduct(product),
                                dimension: 28.w,
                              ),
                              Expanded(
                                child: AutoTranslateText(
                                  quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              _QuantityIconButton(
                                icon: Icons.add,
                                onTap: canIncrement
                                    ? () => cartController.incrementProduct(
                                        product,
                                      )
                                    : null,
                                dimension: 28.w,
                                enabled: canIncrement,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Hero(
              tag: 'category_image_${category.id ?? category.slug ?? ''}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: category.image != null && category.image!.isNotEmpty
                    ? SizedBox.expand(
                        child: NetworkImageWithLoader(
                          url: category.image!,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      )
                    : Container(
                        color: AppColors.saffron.withOpacity(0.2),
                        child: Center(
                          child: Icon(
                            Icons.category,
                            size: 40,
                            color: AppColors.saffron,
                          ),
                        ),
                      ),
              ),
            ),
            // Gradient Overlay
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
            // Category Name
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: AutoTranslateText(
                  category.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildProductListItem(
    BuildContext context,
    ProductModel product,
    ProductListController? listController, {
    String? heroTag,
  }) {
    ProductImage? primaryImage;
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : null;

    // Safely get primary image
    if (product.images != null && product.images!.isNotEmpty) {
      try {
        primaryImage = product.images!.firstWhere(
          (img) => img.isPrimary == true,
          orElse: () => product.images!.first,
        );
      } catch (e) {
        // If firstWhere fails, try to get first image
        if (product.images!.isNotEmpty) {
          primaryImage = product.images!.first;
        }
      }
    }

    // Get full image URL
    String? imageUrl;
    if (primaryImage?.url != null) {
      imageUrl = primaryImage!.url!;
      // Handle relative URLs
      if (imageUrl.startsWith('/')) {
        imageUrl = 'http://65.1.131.197:8000$imageUrl';
      }
    }

    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final currentPrice =
        product.currentPrice ??
        product.discountedPrice ??
        product.basePrice ??
        0.0;

    final heroIdentifier =
        heroTag ?? 'product_image_${product.id ?? product.slug ?? ''}';

    return GestureDetector(
      onTap: () {
        if (listController != null) {
          listController.navigateToProductDetail(
            product,
            heroTag: heroIdentifier,
          );
        } else {
          try {
            Get.find<EcommerceHomeController>().navigateToProductDetail(
              product,
              heroTag: heroIdentifier,
            );
          } catch (e) {
            Get.toNamed(
              '/product-detail',
              arguments: {'product': product, 'heroTag': heroIdentifier},
            );
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image with wishlist
            SizedBox(
              width: 90.w,
              height: 90.h,
              child: Stack(
                children: [
                  Hero(
                    tag: heroIdentifier,
                    child: Material(
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: imageUrl != null
                            ? NetworkImageWithLoader(
                                url: imageUrl,
                                height: 90.h,
                                width: 90.w,
                              )
                            : Container(
                                height: 90.h,
                                width: 90.w,
                                color: AppColors.textSecondary.withOpacity(0.1),
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 30,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (wishlistController != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Obx(() {
                        final isUpdating = wishlistController.isUpdating.value;
                        final isWishlisted = wishlistController.isInWishlist(
                          product,
                        );

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isUpdating
                                ? null
                                : () => wishlistController.toggleWishlist(
                                    product,
                                  ),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isUpdating
                                    ? SizedBox(
                                        width: 16.w,
                                        height: 16.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.saffron,
                                        ),
                                      )
                                    : Icon(
                                        isWishlisted
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isWishlisted
                                            ? AppColors.saffron
                                            : AppColors.textPrimary,
                                        size: 18.sp,
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    product.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: "#68171E".toColor(),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (product.shortDescription != null &&
                      product.shortDescription!.isNotEmpty)
                    AutoTranslateText(
                      product.shortDescription!,
                      style: MyTextTheme.smallBCB.merge(AppTypography.label),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 8.h),
                  AutoTranslateText(
                    priceFormat.format(currentPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.saffron,
                    ),
                  ),
                ],
              ),
            ),
            // Add to Cart Button / Quantity Controls
            Obx(() {
              final quantity = cartController.quantityForProduct(product);
              final isProcessing = cartController.isProductUpdating(product);

              if (quantity <= 0) {
                return Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    shape: BoxShape.circle,
                  ),
                  child: isProcessing
                      ? Center(
                          child: SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            await cartController.addItem(
                              product: product,
                              quantity: 1,
                            );
                          },
                        ),
                );
              }

              if (isProcessing) {
                return Container(
                  height: 36.h,
                  width: 110.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.saffron),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.saffron,
                    ),
                  ),
                );
              }

              final canIncrement = quantity < CartController.maxQuantity;
              return Container(
                height: 36.h,
                width: 110.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.saffron),
                  color: AppColors.saffron.withOpacity(0.08),
                ),
                child: Row(
                  children: [
                    _QuantityIconButton(
                      icon: Icons.remove,
                      onTap: () => cartController.decrementProduct(product),
                      dimension: 36.w,
                    ),
                    Expanded(
                      child: AutoTranslateText(
                        quantity.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _QuantityIconButton(
                      icon: Icons.add,
                      onTap: canIncrement
                          ? () => cartController.incrementProduct(product)
                          : null,
                      enabled: canIncrement,
                      dimension: 36.w,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _QuantityIconButton extends StatelessWidget {
  const _QuantityIconButton({
    required this.icon,
    required this.onTap,
    this.dimension,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double? dimension;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final buttonSize = dimension ?? 28.w;
    final iconSize = (buttonSize * 0.45).clamp(14.0, 18.w);

    return InkWell(
      onTap: enabled && onTap != null ? onTap : null,
      borderRadius: BorderRadius.circular(buttonSize / 2),
      child: SizedBox(
        width: buttonSize,
        height: double.infinity,
        child: Icon(
          icon,
          size: iconSize,
          color: enabled
              ? AppColors.saffron
              : AppColors.textSecondary.withOpacity(0.4),
        ),
      ),
    );
  }
}
