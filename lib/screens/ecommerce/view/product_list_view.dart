import 'package:astrobharataiuser/app_manager/my_appbar.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_list_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/ecommerce_home_view.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductListController>();

    return Scaffold(
      appBar: MyAppbar(
        title: controller.selectedCategory.value?.name ?? 'Products',
        showLeading: true,
      ),
      body: Obx(() {
        if (controller.isLoadingProducts.value && controller.products.isEmpty) {
          return Center(child: CircularProgressIndicator(color: AppColors.saffron));
        }

        if (controller.products.isEmpty && !controller.isLoadingProducts.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  'No products found',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ).merge(AppTypography.h3),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Search and Filter Bar
            _buildSearchAndFilterBar(context, controller),
            // Subcategory Filters (only shown when a category is selected)
            Obx(() {
              // Access observables to ensure reactivity
              final category = controller.selectedCategory.value;
              final isLoading = controller.isLoadingCategories.value;
              final subcategories = controller.getSubcategories;
              
              // Show filter if category is selected and either:
              // 1. We have subcategories, OR
              // 2. Categories are still loading (to show once loaded)
              if (category != null) {
                if (subcategories.isNotEmpty) {
                  return _buildSubcategoryFilters(context, controller);
                } else if (isLoading) {
                  // Show empty space while loading to prevent layout shift
                  return SizedBox(height: 50.h);
                }
              }
              return SizedBox.shrink();
            }),
            // Products List
            Expanded(
              child: controller.isGridView.value
                  ? _buildGridView(context, controller)
                  : _buildListView(context, controller),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context, ProductListController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Expanded(
            child: TextField(
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.onSearch('');
                }
              },
              onSubmitted: controller.onSearch,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    controller.searchQuery.value = '';
                    controller.onSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.saffron),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Sort Button
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: AppColors.saffron),
            onSelected: controller.onSortChanged,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'popular', child: AutoTranslateText('Popular')),
              PopupMenuItem(value: 'newest', child: AutoTranslateText('Newest')),
              PopupMenuItem(value: 'lowToHigh', child: AutoTranslateText('Price: Low to High')),
              PopupMenuItem(value: 'highToLow', child: AutoTranslateText('Price: High to Low')),
            ],
          ),
          SizedBox(width: 8.w),
          // View Toggle
          IconButton(
            icon: Icon(
              controller.isGridView.value ? Icons.view_list : Icons.grid_view,
              color: AppColors.saffron,
            ),
            onPressed: controller.toggleView,
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, ProductListController controller) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: controller.products.length + (controller.hasMoreProducts.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.products.length) {
          return _buildLoadMoreButton(controller);
        }
        final product = controller.products[index];
        final heroTag = 'product_list_grid_${index}_${product.id ?? product.slug ?? index}';
        return EcommerceHomeView.buildProductCard(
          context,
          product,
          controller,
          heroTag: heroTag,
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, ProductListController controller) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.products.length + (controller.hasMoreProducts.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.products.length) {
          return _buildLoadMoreButton(controller);
        }
        final product = controller.products[index];
        final heroTag = 'product_list_list_${index}_${product.id ?? product.slug ?? index}';
        return EcommerceHomeView.buildProductListItem(
          context,
          product,
          controller,
          heroTag: heroTag,
        );
      },
    );
  }

  Widget _buildSubcategoryFilters(BuildContext context, ProductListController controller) {
    return Obx(() {
      final subcategories = controller.getSubcategories;
      if (subcategories.isEmpty) return SizedBox.shrink();
      
      return Container(
        height: 50.h,
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: subcategories.length + 1, // +1 for "All"
          itemBuilder: (context, index) {
            final isAll = index == 0;
            final isSelected = isAll && controller.selectedSubcategory.value == null ||
                !isAll && controller.selectedSubcategory.value?.id == subcategories[index - 1].id;
            
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  if (isAll) {
                    controller.onSubcategorySelected(null);
                  } else {
                    controller.onSubcategorySelected(subcategories[index - 1]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [AppColors.saffron, AppColors.deepOrange],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: isSelected ? null : Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: AutoTranslateText(
                    isAll ? 'All ${controller.selectedCategory.value?.name ?? ""}' : subcategories[index - 1].name ?? '',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ).merge(AppTypography.body1),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
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

