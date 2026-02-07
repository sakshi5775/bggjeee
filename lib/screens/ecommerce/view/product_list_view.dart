import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_list_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<ProductListController>();
    _searchController = TextEditingController(
      text: controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductListController>();
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header with CommonHeader
            Obx(() {
              final category = controller.selectedCategory.value;
              final productCount = controller.products.length;
              return CommonHeader(
                title: category?.name ?? 'Products',
                subtitle: AutoTranslateText(
                  'Showing $productCount Premium items',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    color: '#6F221E'.toColor().withOpacity(0.6),
                    height: 1.33,
                  ),
                ),
                customActions: [
                  // Cart Icon with Badge
                  Obx(() {
                    final cartItemCount = cartController.itemCount;
                    return IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.cart);
                      },
                      icon: Badge.count(
                        count: cartItemCount,
                        child: Icon(
                          Icons.shopping_cart,
                          size: 22.w,
                          color: '#6F221E'.toColor(),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingProducts.value &&
                    controller.products.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.saffron),
                  );
                }

                if (controller.products.isEmpty &&
                    !controller.isLoadingProducts.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          'No products found',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: 10.14.h),
                    // Search and Filter Bar
                    _buildSearchAndFilterBar(context, controller),
                    SizedBox(height: 14.71.h),
                    // Category Filters (Horizontal Scroll)

                    // Products Grid
                    Expanded(child: _buildGridView(context, controller)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar(
    BuildContext context,
    ProductListController controller,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 24.w, color: '#DD2914'.toColor()),
          SizedBox(width: 8.w),
          Expanded(
            child: Obx(() {
              // Sync controller with searchQuery value
              if (_searchController.text != controller.searchQuery.value) {
                _searchController.text = controller.searchQuery.value;
              }
              return TextField(
                controller: _searchController,
                onChanged: (value) {
                  controller.searchQuery.value = value;
                  if (value.isEmpty) {
                    controller.onSearch('');
                  }
                },
                onSubmitted: controller.onSearch,
                decoration: InputDecoration(
                  hintText: 'Search Product......',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: '#99A1AF'.toColor(),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              // Show filter options
              _showFilterOptions(context, controller);
            },
            child: Icon(Icons.tune, size: 24.w, color: '#DD2914'.toColor()),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(
    BuildContext context,
    ProductListController controller,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              'Sort By',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: '#3D0C11'.toColor(),
              ),
            ),
            SizedBox(height: 16.h),
            ...['popular', 'newest', 'lowToHigh', 'highToLow'].map((sortValue) {
              final isSelected = controller.sortBy.value == sortValue;
              return ListTile(
                title: AutoTranslateText(
                  sortValue == 'popular'
                      ? 'Popular'
                      : sortValue == 'newest'
                      ? 'Newest'
                      : sortValue == 'lowToHigh'
                      ? 'Price: Low to High'
                      : 'Price: High to Low',
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.saffron
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.saffron)
                    : null,
                onTap: () {
                  controller.onSortChanged(sortValue);
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(
    BuildContext context,
    ProductListController controller,
  ) {
    return Obx(() {
      final categories = controller.categoryTree;
      if (categories.isEmpty) return SizedBox.shrink();

      return SizedBox(
        height: 122.31.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemCount: categories.length,
          separatorBuilder: (context, index) => SizedBox(width: 11.96.w),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected =
                controller.selectedCategory.value?.id == category.id;
            return _buildCategoryCard(category, controller, isSelected);
          },
        ),
      );
    });
  }

  Widget _buildCategoryCard(
    CategoryModel category,
    ProductListController controller,
    bool isSelected,
  ) {
    String? imageUrl;
    if (category.image != null && category.image!.isNotEmpty) {
      imageUrl = category.image;
      if (imageUrl!.startsWith('/')) {
        imageUrl = 'http://65.1.131.197:8000$imageUrl';
      }
    }

    return GestureDetector(
      onTap: () => controller.onCategorySelected(category),
      child: Container(
        width: 102.w,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? '#F38B3B'.toColor() : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Image
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.71.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.71.r),
                child: imageUrl != null
                    ? NetworkImageWithLoader(
                        url: imageUrl,
                        width: 90.w,
                        height: 90.w,
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.category_outlined,
                          size: 40.w,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 7.36.h),
            // Category Name
            AutoTranslateText(
              category.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12.88.sp,
                color: '#3D0C11'.toColor(),
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.52.h),
            // Item Count
            AutoTranslateText(
              '${category.productCount ?? 0} items',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 11.04.sp,
                color: '#6A7282'.toColor(),
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    ProductListController controller,
  ) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.14.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 20.14.w,
        mainAxisSpacing: 10.14.h,
      ),
      itemCount:
          controller.products.length +
          (controller.hasMoreProducts.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.products.length) {
          return _buildLoadMoreButton(controller);
        }
        final product = controller.products[index];
        return _buildProductCard(context, product, controller);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel product,
    ProductListController controller,
  ) {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

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

    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final currentPrice =
        product.currentPrice ??
        product.discountedPrice ??
        product.basePrice ??
        0.0;
    final basePrice = product.basePrice ?? 0.0;
    final discountPercent = basePrice > 0 && basePrice > currentPrice
        ? ((basePrice - currentPrice) / basePrice * 100).round()
        : 0;

    return GestureDetector(
      onTap: () => controller.navigateToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.28.r),
                child: imageUrl != null
                    ? NetworkImageWithLoader(
                        url: imageUrl,
                        width: double.infinity,
                        height: 124.76.h,
                      )
                    : Container(
                        width: double.infinity,
                        height: 124.76.h,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_outlined,
                          size: 40.w,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 7.34.h),
            // Product Details
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AutoTranslateText(
                            product.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Baloo 2',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.23.sp,
                              color: '#3D0C11'.toColor(),
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.48.w),
                        // Rating Badge
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 8.58.w,
                              color: '#FEC62B'.toColor(),
                            ),
                            SizedBox(width: 3.04.w),
                            AutoTranslateText(
                              product.averageRating?.toStringAsFixed(1) ??
                                  '4.9',
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
                    SizedBox(height: 4.06.h),
                    // Price Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      spacing: 6.06.w,
                      children: [
                        AutoTranslateText(
                          priceFormat.format(currentPrice),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 12.17.sp,
                            color: '#3D0C11'.toColor(),
                            height: 1,
                          ),
                        ),
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
                      ],
                    ),
                    SizedBox(height: 8.11.h),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Buy Now Button
                        Expanded(
                          child: Obx(() {
                            final isProcessing = cartController
                                .isProductUpdating(product);
                            return GestureDetector(
                              onTap: isProcessing
                                  ? null
                                  : () async {
                                      await cartController.addItem(
                                        product: product,
                                        quantity: 1,
                                      );
                                      Get.toNamed(AppRoutes.cart);
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.07.h,
                                  horizontal: 10.14.w,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(10.14.r),
                                ),
                                child: isProcessing
                                    ? Center(
                                        child: SizedBox(
                                          width: 12.w,
                                          height: 12.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : AutoTranslateText(
                                        'Buy Now',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.17.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(width: 5.07.w),
                        // Add to Cart Icon
                        Obx(() {
                          final quantity = cartController.quantityForProduct(
                            product,
                          );
                          final isProcessing = cartController.isProductUpdating(
                            product,
                          );
                          return GestureDetector(
                            onTap: isProcessing
                                ? null
                                : () async {
                                    if (quantity > 0) {
                                      await cartController.incrementProduct(
                                        product,
                                      );
                                    } else {
                                      await cartController.addItem(
                                        product: product,
                                        quantity: 1,
                                      );
                                    }
                                  },
                            child: Container(
                              width: 24.06.w,
                              height: 24.06.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.14.r),
                                border: Border.all(
                                  color: '#DD2914'.toColor(),
                                  width: 0.39,
                                ),
                              ),
                              child: isProcessing
                                  ? Center(
                                      child: SizedBox(
                                        width: 12.w,
                                        height: 12.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: '#DD2914'.toColor(),
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 18.w,
                                      color: '#DD2914'.toColor(),
                                    ),
                            ),
                          );
                        }),
                      ],
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

  Widget _buildLoadMoreButton(ProductListController controller) {
    return Obx(() {
      if (controller.isLoadingProducts.value) {
        return Container(
          padding: EdgeInsets.all(16.h),
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: AppColors.saffron),
        );
      }
      return Container(
        padding: EdgeInsets.all(16.h),
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: controller.loadMore,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: Colors.white,
          ),
          child: AutoTranslateText('Load More'),
        ),
      );
    });
  }
}
