import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(
          () => CustomScrollView(
            slivers: [
              // Header
              // Header
              if (!hideHeader)
                SliverToBoxAdapter(
                  child: CommonHeader(
                    title: 'Digital Mart',
                    showBackButton: showBackButton,

                    customActions: [
                      // Wishlist Icon
                      GestureDetector(
                        onTap: () => UserMainController.pushInCurrentTab(
                          AppRoutes.wishlist,
                        ),
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
              // Rudraksha Section (heading + products below, same design as Featured)
              _buildCategorySection(
                context,
                title: 'Rudraksha',
                products: controller.rudrakshaProducts,
                isLoading: controller.isLoadingRudraksha,
                categoryRx: controller.rudrakshaCategory,
              ),
              // Kits Section
              _buildCategorySection(
                context,
                title: 'Kits',
                products: controller.kitsProducts,
                isLoading: controller.isLoadingKits,
                categoryRx: controller.kitsCategory,
              ),
              // Pyramids Section
              _buildCategorySection(
                context,
                title: 'Pyramids',
                products: controller.pyramidsProducts,
                isLoading: controller.isLoadingPyramids,
                categoryRx: controller.pyramidsCategory,
              ),
              SliverToBoxAdapter(child: Spacing.h(15.h)),
              // Best Sellers Section
              if (controller.topSellingProducts.isNotEmpty)
                _buildBestSellersSection(context),

              // Recommended for you (same card design as Featured)
              if (controller.isLoadingRecommendations.value ||
                  controller.recommendedProducts.isNotEmpty)
                _buildRecommendedSection(context),
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

              // 1. Why AstroBharat AI (FAQ) Section
              WhyShopWithUsWidget(),

              // 2. Testimonials section – to be added here later
              // (no widget yet; add testimonials sliver when ready)

              // 3. Top 10 Categories Section
              _buildTop10CategoriesSliver(),

              SliverToBoxAdapter(child: Spacing.h(6.h)),
              // 4. Blogs & News Section (top 5 + View All)
              _buildBlogsSliver(),

              SliverToBoxAdapter(child: Spacing.h(6.h)),
              // 5. Contact Support Section
              _buildContactSupportSliver(),

              SliverToBoxAdapter(child: Spacing.h(6.h)),
              // 6. Social Media Section
              _buildSocialMediaSliver(),

              SliverToBoxAdapter(child: Spacing.h(6.h)),
              // 7. Refund Policy Section
              _buildRefundPolicySliver(),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: hideHeader ? 80.h : 20.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const Color _top10Maroon = Color(0xFF68171E);
  static const int _top10Count = 10;

  Widget _buildTop10CategoriesSliver() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              'Top 10 Categories',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                color: _top10Maroon,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Obx(() {
            try {
              if (controller.isLoadingCategories.value) {
                return SizedBox(
                  height: 180.h,
                  child: Center(
                    child: SizedBox(
                      width: 28.w,
                      height: 28.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _top10Maroon,
                      ),
                    ),
                  ),
                );
              }
              final tree = List<CategoryModel>.from(controller.categoryTree);
              final allCategories = tree
                  .where((cat) => cat.isFeatured == true && cat.parent == null)
                  .toList();
              List<CategoryModel> list;
              if (allCategories.isNotEmpty) {
                list = allCategories.take(_top10Count).toList();
              } else {
                final featured = List<CategoryModel>.from(
                  controller.categories,
                );
                list = featured.take(_top10Count).toList();
              }
              if (list.isEmpty) return SizedBox.shrink();
              return SizedBox(
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 8.h,
                    bottom: 8.h,
                  ),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final category = list[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        AppRoutes.productList,
                        arguments: {'category': category},
                      ),
                      child: Container(
                        width: 150.w,
                        height: 180.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (category.image != null &&
                                  category.image!.isNotEmpty)
                                NetworkImageWithLoader(
                                  url: category.image!,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              else
                                Container(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  child: Center(
                                    child: Icon(
                                      Icons.category_outlined,
                                      size: 48.w,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 12.w,
                                right: 12.w,
                                bottom: 16.h,
                                child: Center(
                                  child: Text(
                                    category.name ?? '',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } catch (_) {
              return SizedBox.shrink();
            }
          }),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildBlogsSliver() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Blogs & News',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.sp,
                    color: _top10Maroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      UserMainController.pushInCurrentTab(AppRoutes.allBlogs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: _top10Maroon,
                        ),
                      ),
                      Spacing.w(4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.sp,
                        color: _top10Maroon,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isLoadingBlogs.value && controller.blogs.isEmpty) {
              return SizedBox(
                height: 140.h,
                child: Center(
                  child: SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _top10Maroon,
                    ),
                  ),
                ),
              );
            }
            if (controller.blogs.isEmpty) {
              return SizedBox(height: 16.h);
            }
            final list = controller.blogs;
            return SizedBox(
              height: 140.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  return _buildEcommerceBlogCard(list[index]);
                },
              ),
            );
          }),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  static bool _isVideoUrl(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm') ||
        lower.contains('video');
  }

  Widget _buildEcommerceBlogCard(Blog blog) {
    const double cardWidth = 150;
    const double thumbHeight = 94;
    final img = blog.featuredImage ?? '';
    final useImage = img.isNotEmpty && !_isVideoUrl(img);

    return GestureDetector(
      onTap: () => UserMainController.pushInCurrentTab(
        AppRoutes.blogDetail,
        arguments: blog,
      ),
      child: SizedBox(
        width: cardWidth.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: cardWidth.w,
              height: thumbHeight.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: useImage
                    ? NetworkImageWithLoader(
                        url: img,
                        width: cardWidth.w,
                        height: thumbHeight.h,
                      )
                    : Container(
                        width: cardWidth.w,
                        height: thumbHeight.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: LinearGradient(
                            colors: [
                              '#FCE5AA'.toColor(),
                              AppColors.deepOrange.withValues(alpha: 0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.article_outlined,
                            size: 32.w,
                            color: _top10Maroon.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
              ),
            ),
            Spacing.h(6),
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: Text(
                blog.title ?? 'Untitled',
                style: AppTypography.body2.copyWith(
                  color: '#3D0C11'.toColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupportSliver() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Text(
              'Contact Support',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                color: _top10Maroon,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 6.h),
            child: Text(
              'Have a question or need help? Our support team is here for you. Open a ticket or view your existing ones.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () =>
                  UserMainController.pushInCurrentTab(AppRoutes.supportTickets),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  color: _top10Maroon,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 22.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Contact Support',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  static const List<({String label, String url, String iconUrl})>
  _socialLinks = [
    (
      label: 'Facebook',
      url: 'https://www.facebook.com/astrobharatai/',
      iconUrl:
          'https://d3c2un7ipdye89.cloudfront.net/Social+Media+Icons/icons8-facebook-48.png',
    ),
    (
      label: 'Instagram',
      url: 'https://www.instagram.com/astrobharatai/',
      iconUrl:
          'https://d3c2un7ipdye89.cloudfront.net/Social+Media+Icons/icons8-instagram-48.png',
    ),
    (
      label: 'LinkedIn',
      url: 'https://www.linkedin.com/company/astrobharatai/',
      iconUrl:
          'https://d3c2un7ipdye89.cloudfront.net/Social+Media+Icons/icons8-linkedin-48.png',
    ),
    (
      label: 'X',
      url: 'https://x.com/AstroBharatAI',
      iconUrl:
          'https://d3c2un7ipdye89.cloudfront.net/Social+Media+Icons/icons8-twitter-50.png',
    ),
    (
      label: 'YouTube',
      url: 'https://www.youtube.com/@AstroBharatAI',
      iconUrl:
          'https://d3c2un7ipdye89.cloudfront.net/Social+Media+Icons/icons8-youtube-48.png',
    ),
  ];

  Widget _buildSocialMediaSliver() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'Follow Us',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                color: _top10Maroon,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _socialLinks
                  .map(
                    (e) => _buildSocialIcon(
                      label: e.label,
                      url: e.url,
                      iconUrl: e.iconUrl,
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildRefundPolicySliver() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Text(
              'Refund Policy',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                color: _top10Maroon,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
            child: Text(
              'Our refund, cancellation & satisfaction guarantee. Clear pricing, fair solutions, and human support when you need it.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () =>
                  UserMainController.pushInCurrentTab(AppRoutes.refundPolicy),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _top10Maroon.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  color: _top10Maroon.withValues(alpha: 0.06),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.policy_outlined,
                      color: _top10Maroon,
                      size: 22.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'View Refund Policy',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: _top10Maroon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required String label,
    required String url,
    required String iconUrl,
  }) {
    return GestureDetector(
      onTap: () => _launchSocialUrl(url),
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(8.w),
        child: NetworkImageWithLoader(url: iconUrl, width: 32.w, height: 32.w),
      ),
    );
  }

  Future<void> _launchSocialUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.3,
                                ),
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
                        UserMainController.pushInCurrentTab(
                          '/product-list',
                          arguments: {'category': category},
                        );
                      } else if (category.slug != null) {
                        UserMainController.pushInCurrentTab(
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
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.3,
                            ),
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

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required RxList<ProductModel> products,
    required RxBool isLoading,
    Rxn<CategoryModel>? categoryRx,
  }) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final category = categoryRx?.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading - always visible
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    title,
                    style: AppTypography.h2.copyWith(
                      color: '#68171E'.toColor(),
                    ),
                  ),
                  if (category != null)
                    GestureDetector(
                      onTap: () => UserMainController.pushInCurrentTab(
                        AppRoutes.productList,
                        arguments: {'category': category},
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
                          SizedBox(width: 4.w),
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
            // Content below heading: loading, products, or empty
            if (isLoading.value && products.isEmpty)
              Container(
                height: 200.h,
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: AppColors.saffron),
              )
            else if (products.isNotEmpty)
              SizedBox(
                height: 320.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 4.h,
                  ),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return FeaturedProductsWidget.buildFeaturedStyleCard(
                      product,
                      () => controller.navigateToProductDetail(product),
                    );
                  },
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Center(
                  child: AutoTranslateText(
                    'No products in this category yet',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            Spacing.h(15.h),
          ],
        );
      }),
    );
  }

  Widget _buildBestSellersSection(BuildContext context) {
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
                  'Best Sellers',
                  style: AppTypography.h2.copyWith(color: '#68171E'.toColor()),
                ),
                GestureDetector(
                  onTap: () => UserMainController.pushInCurrentTab(
                    AppRoutes.productList,
                    arguments: {
                      'title': 'Best Sellers',
                      'filterType': 'bestSellers',
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
                      SizedBox(width: 4.w),
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.topSellingProducts.take(5).length,
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

  Widget _buildRecommendedSection(BuildContext context) {
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
                  'Recommended for you',
                  style: AppTypography.h2.copyWith(color: '#68171E'.toColor()),
                ),
                GestureDetector(
                  onTap: () {
                    UserMainController.pushInCurrentTab(
                      AppRoutes.productList,
                      arguments: {
                        'title': 'Recommended for you',
                        'filterType': 'recommended',
                      },
                    );
                  },
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
                      SizedBox(width: 4.w),
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
          if (controller.isLoadingRecommendations.value &&
              controller.recommendedProducts.isEmpty)
            Container(
              height: 320.h,
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: AppColors.saffron),
            )
          else if (controller.recommendedProducts.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: AutoTranslateText(
                'No recommendations at the moment.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            SizedBox(
              height: 320.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 4.h),
                itemCount: controller.recommendedProducts.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final product = controller.recommendedProducts[index];
                  return FeaturedProductsWidget.buildFeaturedStyleCard(
                    product,
                    () => controller.navigateToProductDetail(product),
                  );
                },
              ),
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
                  style: AppTypography.h2.copyWith(color: '#68171E'.toColor()),
                ),
                if (title.toLowerCase().contains('recommended') ||
                    title.toLowerCase().contains('recently'))
                  GestureDetector(
                    onTap: () {
                      UserMainController.pushInCurrentTab(
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
                        SizedBox(width: 4.w),
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
            UserMainController.pushInCurrentTab(
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
              color: Colors.black.withValues(alpha: 0.05),
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
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: isHorizontal ? 100.h : 120.h,
                              width: double.infinity,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.1,
                              ),
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
                          color: Colors.white.withValues(alpha: 0.9),
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
                              color: Colors.white.withValues(alpha: 0.7),
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
              color: Colors.black.withValues(alpha: 0.05),
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
                        color: AppColors.saffron.withValues(alpha: 0.2),
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
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
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
            UserMainController.pushInCurrentTab(
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            SizedBox(
              width: 90.w,
              height: 90.h,
              child: Hero(
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
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.1,
                            ),
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
            // Add to Cart + Wishlist below (same icon style)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  final quantity = cartController.quantityForProduct(product);
                  final isProcessing = cartController.isProductUpdating(
                    product,
                  );

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
                        color: Colors.white.withValues(alpha: 0.7),
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
                      color: AppColors.saffron.withValues(alpha: 0.08),
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
                SizedBox(height: 8.h),
                if (wishlistController != null)
                  Obx(() {
                    final wc = wishlistController;
                    final isUpdating = wc.isUpdating.value;
                    final isWishlisted = wc.isInWishlist(product);
                    return GestureDetector(
                      onTap: isUpdating
                          ? null
                          : () => wc.toggleWishlist(product),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                        ),
                        child: isUpdating
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
                            : Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    );
                  }),
              ],
            ),
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
              : AppColors.textSecondary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
