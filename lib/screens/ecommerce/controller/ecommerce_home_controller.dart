import 'dart:async';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/widgets/inline_search_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EcommerceHomeController extends BaseController {
  final EcommerceService _ecommerceService = EcommerceService();
  final BannerService _bannerService = BannerService(); // Added BannerService

  // Categories
  final categories = <CategoryModel>[].obs;
  final categoryTree = <CategoryModel>[].obs;
  final allCategories =
      <CategoryModel>[].obs; // All categories including subcategories
  final selectedCategory = Rxn<CategoryModel>();
  final selectedSubcategory = Rxn<CategoryModel>();
  final isLoadingCategories = false.obs;

  // Get subcategories for selected category
  List<CategoryModel> get subcategories {
    if (selectedCategory.value == null) return [];
    final categoryId = selectedCategory.value!.id;
    if (categoryId == null) return [];

    // First, try to find subcategories from category tree (children property)
    final parentCategory = categoryTree.firstWhereOrNull(
      (cat) => cat.id == categoryId,
    );

    if (parentCategory?.children != null &&
        parentCategory!.children!.isNotEmpty) {
      return parentCategory.children!;
    }

    // Also check if any category in tree has this as parent
    final subcatsFromTree = categoryTree
        .where((cat) => cat.parent?.id == categoryId)
        .toList();

    if (subcatsFromTree.isNotEmpty) {
      return subcatsFromTree;
    }

    // Check allCategories list (includes all categories, not just featured)
    final subcatsFromAll = allCategories
        .where((cat) => cat.parent?.id == categoryId)
        .toList();

    if (subcatsFromAll.isNotEmpty) {
      return subcatsFromAll;
    }

    // Fallback: check categories list (featured categories)
    final subcatsFromFeatured = categories
        .where((cat) => cat.parent?.id == categoryId)
        .toList();

    return subcatsFromFeatured;
  }

  void selectSubcategory(CategoryModel? subcategory) {
    selectedSubcategory.value = subcategory;
    if (subcategory != null && selectedCategory.value != null) {
      UserMainController.pushInCurrentTab(
        '/product-list',
        arguments: {
          'category': selectedCategory.value,
          'subcategory': subcategory,
        },
      );
    }
  }

  // Products
  final featuredProducts = <ProductModel>[].obs;
  final topSellingProducts = <ProductModel>[].obs;
  final recommendedProducts = <ProductModel>[].obs;
  final recentlyViewedProducts = <ProductModel>[].obs;
  final isLoadingFeatured = false.obs;
  final isLoadingTopSelling = false.obs;
  final isLoadingRecommendations = false.obs;
  final isLoadingRecentlyViewed = false.obs;

  // Purposes for Shop by Purpose section
  final purposes = <Map<String, String>>[].obs;
  final isLoadingPurposes = false.obs;

  // Category sections: Rudraksha, Kits, Pyramids, Rashi (Product based on zodiac)
  final rudrakshaProducts = <ProductModel>[].obs;
  final kitsProducts = <ProductModel>[].obs;
  final pyramidsProducts = <ProductModel>[].obs;
  final rashiProducts = <ProductModel>[].obs;
  final rudrakshaCategory = Rxn<CategoryModel>();
  final kitsCategory = Rxn<CategoryModel>();
  final pyramidsCategory = Rxn<CategoryModel>();
  final rashiCategory = Rxn<CategoryModel>();
  final isLoadingRudraksha = false.obs;
  final isLoadingKits = false.obs;
  final isLoadingPyramids = false.obs;
  final isLoadingRashi = false.obs;

  // Labh Kit section
  final labhKitProducts = <ProductModel>[].obs;
  final labhKitCategory = Rxn<CategoryModel>();
  final isLoadingLabhKit = false.obs;

  // Testimonials: products from all categories that have reviews
  final testimonialProducts = <ProductModel>[].obs;
  final isLoadingTestimonials = false.obs;

  // Offer products: all products that have a discount/offer price (for marquee & big sale banner)
  final offerProducts = <ProductModel>[].obs;

  // Banners
  final RxList<BannerItem> ecommerceBanners = <BannerItem>[].obs;
  final RxBool isLoadingBanners = false.obs;

  // Blogs (top 5 for Digital Mart section)
  final BlogService _blogService = BlogService();
  final RxList<Blog> blogs = <Blog>[].obs;
  final RxBool isLoadingBlogs = false.obs;

  // Banner carousel
  final PageController bannerPageController = PageController();
  final currentBannerIndex = 0.obs;
  Timer? _bannerTimer;

  // Promotional banner scroll
  final ScrollController promotionalBannerScrollController = ScrollController();
  Timer? _promotionalBannerTimer;
  final RxDouble promotionalBannerScrollPosition = 0.0.obs;
  bool promotionalBannerInitialized = false;

  // Testimonials auto-scroll (card ~220.w + separator 10.w)
  final ScrollController testimonialScrollController = ScrollController();
  Timer? _testimonialScrollTimer;

  // Make timer accessible for checking if it's active
  Timer? get promotionalBannerTimer => _promotionalBannerTimer;

  @override
  void onInit() {
    super.onInit();
    loadBanners(); // Load banners
    loadInitialData();
    _startBannerAutoScroll();
  }

  @override
  void onReady() {
    super.onReady();
    // Scroll initialization is handled in the widget's build method
    // via post-frame callback to ensure the ListView is attached
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    _promotionalBannerTimer?.cancel();
    _testimonialScrollTimer?.cancel();
    bannerPageController.dispose();
    promotionalBannerScrollController.dispose();
    testimonialScrollController.dispose();
    super.onClose();
  }

  void _startTestimonialAutoScroll() {
    _testimonialScrollTimer?.cancel();
    _testimonialScrollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (testimonialProducts.isEmpty || !testimonialScrollController.hasClients) {
          return;
        }
        try {
          final position = testimonialScrollController.position;
          if (!position.hasContentDimensions || position.maxScrollExtent <= 0) return;
          final maxScroll = position.maxScrollExtent;
          final current = position.pixels;
          // One card width + separator (~230 logical px at design width 393)
          final step = 230.0 * (Get.mediaQuery.size.width / 393);
          final next = current + step;
          if (next >= maxScroll - 1) {
            testimonialScrollController.jumpTo(0);
          } else {
            testimonialScrollController.animateTo(
              next,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        } catch (_) {}
      },
    );
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (featuredProducts.isEmpty) return;
      final featuredCount =
          featuredProducts.length > 3 ? 3 : featuredProducts.length;
      if (featuredCount <= 1) return;
      // Only animate when exactly one PageView is attached (view is visible)
      if (bannerPageController.positions.length != 1) return;
      final nextIndex = (currentBannerIndex.value + 1) % featuredCount;
      bannerPageController.animateToPage(
        nextIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
    // Pause auto-scroll when user manually swipes, then resume after 5 seconds
    _bannerTimer?.cancel();
    Future.delayed(Duration(seconds: 5), () {
      _startBannerAutoScroll();
    });
  }

  void startPromotionalBannerAutoScroll() {
    if (_promotionalBannerTimer?.isActive == true) {
      return; // Already running
    }

    if (!promotionalBannerScrollController.hasClients) {
      // If controller doesn't have clients yet, try again after a delay
      Future.delayed(Duration(milliseconds: 100), () {
        if (promotionalBannerScrollController.hasClients) {
          startPromotionalBannerAutoScroll();
        }
      });
      return;
    }

    _promotionalBannerTimer?.cancel();
    _promotionalBannerTimer = Timer.periodic(Duration(milliseconds: 10), (
      timer,
    ) {
      if (!promotionalBannerScrollController.hasClients) {
        timer.cancel();
        return;
      }

      try {
        final position = promotionalBannerScrollController.position;
        if (position.hasContentDimensions && position.maxScrollExtent > 0) {
          final maxScroll = position.maxScrollExtent;
          final currentScroll = position.pixels;

          final newPosition = currentScroll + 0.8; // Adjust scroll speed here

          if (newPosition >= maxScroll) {
            // Reset to start for seamless loop (news ticker effect)
            promotionalBannerScrollController.jumpTo(0.0);
            promotionalBannerScrollPosition.value = 0.0;
          } else {
            promotionalBannerScrollController.jumpTo(newPosition);
            promotionalBannerScrollPosition.value = newPosition;
          }
        }
      } catch (e) {
        // Handle any scroll errors gracefully - scroll controller might be disposed
        timer.cancel();
      }
    });
  }

  Future<void> loadInitialData() async {
    final isGuest = LoginGuard.isGuest;

    await Future.wait([
      loadCategoryTree(),
      loadFeaturedProducts(),
      loadTopSellingProducts(),
      if (!isGuest) ...[loadRecommendations(), loadRecentlyViewedProducts()],
      loadPurposes(),
      loadBlogs(),
    ]);
    // Load Rudraksha, Kits, Pyramids, Rashi after categories are available
    await loadCategorySectionProducts();
    await loadTestimonialProducts();
  }

  /// Load products from all categories for the testimonial section.
  /// Shows products from featured, top selling, and category sections (no filter by reviewCount,
  /// since list APIs often don't return reviewCount; product detail page shows actual reviews).
  /// Returns true if a product has an offer/discount price set.
  static bool productHasOffer(ProductModel p) {
    if (p.discountPercentage != null && p.discountPercentage! > 0) return true;
    if (p.discountedPrice != null &&
        p.basePrice != null &&
        p.discountedPrice! < p.basePrice!) return true;
    return false;
  }

  /// Refreshes [offerProducts] by scanning all loaded product lists for discounted items.
  void _updateOfferProducts() {
    final seen = <String>{};
    final result = <ProductModel>[];
    for (final list in [
      featuredProducts,
      topSellingProducts,
      recommendedProducts,
      rudrakshaProducts,
      kitsProducts,
      pyramidsProducts,
      labhKitProducts,
    ]) {
      for (final p in list) {
        if (!productHasOffer(p)) continue;
        final key = p.id ?? p.slug ?? '';
        if (key.isNotEmpty && seen.contains(key)) continue;
        if (key.isNotEmpty) seen.add(key);
        result.add(p);
      }
    }
    offerProducts.value = result;
  }

  Future<void> loadTestimonialProducts() async {
    try {
      isLoadingTestimonials.value = true;
      testimonialProducts.clear();
      final seenIds = <String>{};
      final List<ProductModel> combined = [];

      void addFrom(List<ProductModel> list) {
        for (final p in list) {
          final id = p.id ?? p.slug ?? '';
          if (id.isEmpty || seenIds.contains(id)) continue;
          seenIds.add(id);
          combined.add(p);
        }
      }

      addFrom(featuredProducts);
      addFrom(topSellingProducts);
      addFrom(rudrakshaProducts);
      addFrom(kitsProducts);
      addFrom(pyramidsProducts);
      addFrom(rashiProducts);

      testimonialProducts.addAll(combined.take(20));
      if (testimonialProducts.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), _startTestimonialAutoScroll);
      }
      _updateOfferProducts();
    } catch (e) {
      print('Error loading testimonial products: $e');
    } finally {
      isLoadingTestimonials.value = false;
    }
  }

  Future<void> loadBlogs() async {
    try {
      isLoadingBlogs.value = true;
      final response = await _blogService.getBlogs(
        page: 1,
        useAuthHeader: false,
      );
      if (response != null && response.data != null) {
        blogs.value = response.data!
            .where(
              (blog) =>
                  blog.status == 'published' && !(blog.isDeleted ?? false),
            )
            .take(5)
            .toList();
      }
    } catch (_) {}
    isLoadingBlogs.value = false;
  }

  Future<void> loadCategorySectionProducts() async {
    await Future.wait([
      _loadProductsForCategorySection(
        nameOrSlug: 'rudraksha',
        nameVariants: ['rudraksha', 'Rudraksha'],
        products: rudrakshaProducts,
        isLoading: isLoadingRudraksha,
        categoryOut: rudrakshaCategory,
      ),
      _loadProductsForCategorySection(
        // Map Kits section to Dosh Kits root category
        nameOrSlug: 'dosh-kits',
        nameVariants: ['Dosh Kits', 'dosh-kits'],
        products: kitsProducts,
        isLoading: isLoadingKits,
        categoryOut: kitsCategory,
      ),
      _loadProductsForCategorySection(
        // Pyramid root category
        nameOrSlug: 'pyramid',
        nameVariants: ['Pyramid', 'pyramid'],
        products: pyramidsProducts,
        isLoading: isLoadingPyramids,
        categoryOut: pyramidsCategory,
      ),
      _loadProductsForCategorySection(
        nameOrSlug: 'rashi',
        nameVariants: ['rashi', 'Rashi'],
        products: rashiProducts,
        isLoading: isLoadingRashi,
        categoryOut: rashiCategory,
      ),
      _loadProductsForCategorySection(
        // Labh Kit root category
        nameOrSlug: 'labh-ki',
        nameVariants: ['Labh Kit', 'labh kit', 'labh-ki'],
        products: labhKitProducts,
        isLoading: isLoadingLabhKit,
        categoryOut: labhKitCategory,
      ),
    ]);
  }

  List<CategoryModel> _flattenCategoryTree(List<CategoryModel> categories) {
    final list = <CategoryModel>[];
    for (final c in categories) {
      list.add(c);
      if (c.children != null && c.children!.isNotEmpty) {
        list.addAll(_flattenCategoryTree(c.children!));
      }
    }
    return list;
  }

  Future<void> _loadProductsForCategorySection({
    required String nameOrSlug,
    required List<String> nameVariants,
    required RxList<ProductModel> products,
    required RxBool isLoading,
    Rxn<CategoryModel>? categoryOut,
  }) async {
    try {
      isLoading.value = true;
      products.clear();
      categoryOut?.value = null;
      CategoryModel? category;
      final flatTree = _flattenCategoryTree(categoryTree);
      final allCats = [
        ...flatTree,
        ...allCategories.where(
            (c) => flatTree.every((t) => t.id != c.id)),
      ];
      // Prefer exact slug/name match so we get main category (e.g. "Kits") not subcategory (e.g. "Dosh Kit")
      for (final variant in nameVariants) {
        final slug = variant.toLowerCase().replaceAll(' ', '-');
        final variantLower = variant.toLowerCase();
        category = allCats.firstWhereOrNull(
          (c) {
            final name = c.name?.toLowerCase() ?? '';
            final catSlug = c.slug?.toLowerCase() ?? '';
            return catSlug == slug || name == variantLower;
          },
        );
        if (category != null) break;
      }
      if (category == null) {
        for (final variant in nameVariants) {
          final slug = variant.toLowerCase().replaceAll(' ', '-');
          final variantLower = variant.toLowerCase();
          category = allCats.firstWhereOrNull(
            (c) {
              final name = c.name?.toLowerCase() ?? '';
              final catSlug = c.slug?.toLowerCase() ?? '';
              return catSlug.contains(slug) || name.contains(variantLower);
            },
          );
          if (category != null) break;
        }
      }
      if (category != null) {
        categoryOut?.value = category;
        if (category.slug != null && category.slug!.isNotEmpty) {
          final result = await _ecommerceService.getProductsByCategorySlug(
            category.slug!,
            page: 1,
            limit: 50,
          );
          if (result?.items != null && result!.items!.isNotEmpty) {
            products.addAll(result.items!);
          }
        }
      }
    } catch (e) {
      print('Error loading $nameOrSlug products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategoryTree() async {
    await runWithLoading(
          () async {
            isLoadingCategories.value = true;

            // Load all categories (not just featured) to get subcategories
            final allCategoryData = await _ecommerceService.getCategories(
              page: 1,
              limit:
                  200, // Load more to get all categories including subcategories
              isActive: true,
            );

            if (allCategoryData != null && allCategoryData.items != null) {
              allCategories.value = allCategoryData.items!;
            }

            // First try to get featured categories using getCategories API
            final categoryData = await _ecommerceService.getCategories(
              page: 1,
              limit: 50,
              isActive: true,
              isFeatured: true,
            );

            if (categoryData != null &&
                categoryData.items != null &&
                categoryData.items!.isNotEmpty) {
              // Use getCategories for featured categories
              categories.value = categoryData.items!
                  .where((cat) => cat.parent == null)
                  .take(8)
                  .toList();
            }

            // Always load category tree for hierarchical structure
            final result = await _ecommerceService.getCategoryTree();
            if (result != null) {
              categoryTree.value = result;
              // If getCategories didn't return featured categories, extract from tree
              if (categories.isEmpty) {
                categories.value = result
                    .where(
                      (cat) => cat.isFeatured == true && cat.parent == null,
                    )
                    .take(8)
                    .toList();
              }
            }
          },
          showBusy: false,
          showError: false,
          silent401ForGuest: true,
        )
        .catchError((e) {
          print('Error loading categories: $e');
          return null;
        })
        .whenComplete(() {
          isLoadingCategories.value = false;
        });
  }

  Future<void> loadRecommendations() async {
    await runWithLoading(
          () async {
            isLoadingRecommendations.value = true;
            final result = await _ecommerceService.getRecommendations(
              limit: 10,
            );
            recommendedProducts
              ..clear()
              ..addAll(result);
          },
          showBusy: false,
          showError: false,
          silent401ForGuest: true,
        )
        .catchError((e) {
          print('Error loading recommendations: $e');
          return null;
        })
        .whenComplete(() => isLoadingRecommendations.value = false);
  }

  Future<void> loadRecentlyViewedProducts() async {
    await runWithLoading(
          () async {
            isLoadingRecentlyViewed.value = true;
            final result = await _ecommerceService.getRecentlyViewed(limit: 10);
            recentlyViewedProducts
              ..clear()
              ..addAll(result);
          },
          showBusy: false,
          showError: false,
          silent401ForGuest: true,
        )
        .catchError((e) {
          print('Error loading recently viewed products: $e');
          return null;
        })
        .whenComplete(() => isLoadingRecentlyViewed.value = false);
  }

  Future<void> loadFeaturedProducts() async {
    await runWithLoading(
          () async {
            isLoadingFeatured.value = true;
            final result = await _ecommerceService.getFeaturedProducts(
              limit: 10,
            );
            if (result != null) {
              featuredProducts.value = result;
              _startBannerAutoScroll();
              _updateOfferProducts();
            }
          },
          showBusy: false,
          showError: false,
          silent401ForGuest: true,
        )
        .catchError((e) {
          print('Error loading featured products: $e');
          return null;
        })
        .whenComplete(() => isLoadingFeatured.value = false);
  }

  Future<void> loadTopSellingProducts() async {
    await runWithLoading(
          () async {
            isLoadingTopSelling.value = true;
            final result = await _ecommerceService.getTopSellingProducts(
              limit: 10,
            );
            if (result != null) {
              topSellingProducts.value = result;
            }
          },
          showBusy: false,
          showError: false,
          silent401ForGuest: true,
        )
        .catchError((e) {
          print('Error loading top selling products: $e');
          return null;
        })
        .whenComplete(() => isLoadingTopSelling.value = false);
  }

  Future<void> loadPurposes() async {
    await runWithLoading(
          () async {
            isLoadingPurposes.value = true;
            final purposeList = await _ecommerceService.getPurposes();

            // Filter to only include the 5 allowed purposes
            final allowedPurposes = [
              'Money',
              'Love',
              'Health',
              'Rashi',
              'Protection',
            ];
            final filteredPurposeList = purposeList
                .where((p) => allowedPurposes.contains(p))
                .toList();

            // Map purposes to the format expected by the widget
            final purposesList = filteredPurposeList.map((purpose) {
              return {'title': purpose, 'image': ''};
            }).toList();

            // Try to get images for each purpose by fetching a sample product
            for (var purposeMap in purposesList) {
              try {
                final purposeName = purposeMap['title']!;
                final productData = await _ecommerceService.getProducts(
                  limit: 1,
                  purpose: purposeName,
                );

                if (productData?.items != null &&
                    productData!.items!.isNotEmpty) {
                  final product = productData.items!.first;
                  if (product.images != null && product.images!.isNotEmpty) {
                    purposeMap['image'] = product.images!.first.url ?? '';
                  }
                }
              } catch (e) {
                print(
                  'Error loading image for purpose ${purposeMap['title']}: $e',
                );
              }
            }

            purposes.value = purposesList;
          },
          showBusy: false,
          showError: false,
          silent401ForGuest: true,
        )
        .catchError((e) {
          print('Error loading purposes: $e');
          purposes.value = [
            {'title': 'Money', 'image': ''},
            {'title': 'Love', 'image': ''},
            {'title': 'Health', 'image': ''},
            {'title': 'Rashi', 'image': ''},
            {'title': 'Protection', 'image': ''},
          ];
          return null;
        })
        .whenComplete(() => isLoadingPurposes.value = false);
  }

  void selectCategory(CategoryModel? category) {
    selectedCategory.value = category;
    selectedSubcategory.value = null; // Reset subcategory when category changes

    // Always navigate to product list when a category is selected (e.g. from Shop by Category)
    // so the product list page is shown even when category has 0 items or subcategories
    if (category != null) {
      if (category.id != null) {
        UserMainController.pushInCurrentTab(AppRoutes.productList, arguments: {'category': category});
      } else if (category.slug != null) {
        UserMainController.pushInCurrentTab(
          AppRoutes.productList,
          arguments: {'categorySlug': category.slug},
        );
      }
    }
  }

  Future<void> loadCategoryBySlug(String slug) async {
    try {
      final category = await _ecommerceService.getCategoryBySlug(slug);
      if (category != null) {
        selectedCategory.value = category;
        UserMainController.pushInCurrentTab('/product-list', arguments: {'category': category});
      }
    } catch (e) {
      print('Error loading category by slug: $e');
    }
  }

  Future<void> loadCategoryById(String id) async {
    try {
      final category = await _ecommerceService.getCategoryById(id);
      if (category != null) {
        selectedCategory.value = category;
        UserMainController.pushInCurrentTab('/product-list', arguments: {'category': category});
      }
    } catch (e) {
      print('Error loading category by ID: $e');
    }
  }

  void navigateToProductDetail(ProductModel product, {String? heroTag}) {
    UserMainController.pushInCurrentTab(
      '/product-detail',
      arguments: {'product': product, if (heroTag != null) 'heroTag': heroTag},
    );
  }

  void navigateToProductList({String? searchQuery}) {
    UserMainController.pushInCurrentTab('/product-list', arguments: {'search': searchQuery});
  }

  void navigateToSearch({String? initialQuery}) {
    InlineSearchOverlay.showWithContext(
      initialQuery: initialQuery,
    );
  }

  Future<void> loadBanners() async {
    await runWithLoading(
      () async {
        isLoadingBanners.value = true;
        final list = await _bannerService.getBannersWithFallback(['appecommerce', 'ecommerce']);
        ecommerceBanners.assignAll(list);
      },
      showBusy: false,
      showError: false,
      silent401ForGuest: true,
    ).whenComplete(() {
      isLoadingBanners.value = false;
    });
  }
}
