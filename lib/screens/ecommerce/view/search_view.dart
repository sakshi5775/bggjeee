import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/data_model/search_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/search_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EcommerceSearchView extends StatelessWidget {
  const EcommerceSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EcommerceSearchController>();
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              CommonHeader(
                title: 'Search Products',
              ),
              _buildSearchBar(controller),
              _buildSearchEntireApp(controller),
              Expanded(
                child: Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 120 &&
                          !controller.isLoadingMore.value &&
                          controller.hasMoreResults.value) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: _buildBody(context, controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchEntireApp(EcommerceSearchController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.public, size: 16.sp, color: AppColors.textSecondary),
          SizedBox(width: 6.w),
          TextButton(
            onPressed: () {
              final q = controller.query.value.trim();
              UserMainController.pushInCurrentTab(
                AppRoutes.globalSearch,
                arguments: q.isEmpty ? null : <String, dynamic>{'initialQuery': q},
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: AutoTranslateText(
              'Search entire app (astrologers, kundli, courses, etc.)',
              style: AppTypography.body2.copyWith(
                color: AppColors.deepOrangemix,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(EcommerceSearchController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Obx(() {
        final hasText = controller.query.value.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40.w,
                child: Icon(Icons.search, color: AppColors.textSecondary),
              ),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  onChanged: controller.onQueryChanged,
                  onSubmitted: (_) => controller.performSearch(reset: true),
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search for products, categories...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (hasText)
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.onQueryChanged('');
                    controller.searchResults.clear();
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBody(
    BuildContext context,
    EcommerceSearchController controller,
  ) {
    final hasResults = controller.searchResults.isNotEmpty;
    final isLoadingInitial = controller.isLoading.value && !hasResults;

    if (isLoadingInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      children: [
        if (controller.query.value.isNotEmpty)
          _buildSuggestionSection(controller, controller.suggestions.value),
        if (hasResults) ...[
          _buildResultSummary(controller),
          SizedBox(height: 12.h),
          ...controller.searchResults
              .map(
                (product) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _SearchResultCard(
                    product: product,
                    onTap: () =>
                        controller.onSuggestionProductSelected(product),
                  ),
                ),
              )
              .toList(),
        ] else if (controller.query.value.isNotEmpty &&
            !controller.isLoadingSuggestions.value) ...[
          SizedBox(height: 60.h),
          _buildEmptyState(),
        ],
        if (controller.isLoadingMore.value)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildResultSummary(EcommerceSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Results for "${controller.query.value}"',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        AutoTranslateText(
          controller.buildResultSummary(),
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSuggestionSection(
    EcommerceSearchController controller,
    SearchSuggestions suggestionData,
  ) {
    final hasSuggestions =
        suggestionData.products.isNotEmpty ||
        suggestionData.categories.isNotEmpty ||
        controller.categorySearchResults.isNotEmpty;

    if (!hasSuggestions && controller.isLoadingSuggestions.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!hasSuggestions) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (suggestionData.products.isNotEmpty) ...[
          AutoTranslateText(
            'Products',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          ...suggestionData.products
              .take(3)
              .map(
                (product) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _SuggestionThumbnail(product: product),
                  title: AutoTranslateText(
                    product.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoTranslateText(
                    product.categoryObj?.name ?? product.productType ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => controller.onSuggestionProductSelected(product),
                ),
              ),
          SizedBox(height: 12.h),
        ],
        if (suggestionData.categories.isNotEmpty) ...[
          AutoTranslateText(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          ...suggestionData.categories.map(
            (category) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.category_outlined),
              title: AutoTranslateText(
                category.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => controller.onSuggestionCategorySelected(category),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        if (controller.categorySearchResults.isNotEmpty) ...[
          AutoTranslateText(
            'Categories (search)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          ...controller.categorySearchResults.map(
            (CategoryModel cat) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.category_outlined),
              title: AutoTranslateText(
                cat.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: AutoTranslateText(
                [
                  if (cat.level != null && cat.level!.isNotEmpty) cat.level!,
                  if (cat.productCount != null) '${cat.productCount} products',
                ].join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => controller.onCategorySearchResultSelected(cat),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        SizedBox(height: 12.h),
        Divider(color: AppColors.textSecondary.withValues(alpha: 0.1)),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(Icons.search_off, size: 48.sp, color: AppColors.textSecondary),
        SizedBox(height: 12.h),
        AutoTranslateText(
          'No results found',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        AutoTranslateText(
          'Try a different search term or explore popular categories.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
          ).merge(AppTypography.body2),
        ),
      ],
    );
  }
}

class _SuggestionThumbnail extends StatelessWidget {
  const _SuggestionThumbnail({required this.product});

  final ProductModel product;

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 48.w,
        height: 48.w,
        child: imageUrl != null
            ? NetworkImageWithLoader(url: imageUrl, height: 48.w, width: 48.w)
            : Container(
                color: AppColors.lightBackground,
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.product, required this.onTap});

  final ProductModel product;
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

    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final price =
        product.currentPrice ?? product.discountedPrice ?? product.basePrice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: 110.w,
                height: 110.w,
                child: imageUrl != null
                    ? NetworkImageWithLoader(
                        url: imageUrl,
                        height: 110.w,
                        width: 110.w,
                      )
                    : Container(
                        color: AppColors.lightBackground,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    AutoTranslateText(
                      product.shortDescription ?? product.productType ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    if (price != null)
                      AutoTranslateText(
                        formatter.format(price),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffron,
                        ).merge(AppTypography.body1),
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
}
