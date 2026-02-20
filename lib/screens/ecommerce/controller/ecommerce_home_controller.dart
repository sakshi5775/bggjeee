import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';

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
      Get.toNamed(
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

  // Banners
  final RxList<BannerItem> ecommerceBanners = <BannerItem>[].obs;
  final RxBool isLoadingBanners = false.obs;

  // Banner carousel
  final PageController bannerPageController = PageController();
  final currentBannerIndex = 0.obs;
  Timer? _bannerTimer;

  // Promotional banner scroll
  final ScrollController promotionalBannerScrollController = ScrollController();
  Timer? _promotionalBannerTimer;
  final RxDouble promotionalBannerScrollPosition = 0.0.obs;
  bool promotionalBannerInitialized = false;

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
    bannerPageController.dispose();
    promotionalBannerScrollController.dispose();
    super.onClose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (featuredProducts.isNotEmpty) {
        final featuredCount = featuredProducts.length > 3
            ? 3
            : featuredProducts.length;
        if (featuredCount > 1) {
          final nextIndex = (currentBannerIndex.value + 1) % featuredCount;
          if (bannerPageController.hasClients) {
            bannerPageController.animateToPage(
              nextIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      }
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
    ]);
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
              // Restart auto-scroll after products are loaded
              _startBannerAutoScroll();
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

    // Don't navigate immediately - let user see subcategories first
    // Navigation will happen when subcategory is selected or user clicks on category again
    if (category != null) {
      // If category has no subcategories, navigate directly
      final subs = subcategories;
      if (subs.isEmpty) {
        if (category.id != null) {
          Get.toNamed('/product-list', arguments: {'category': category});
        } else if (category.slug != null) {
          Get.toNamed(
            '/product-list',
            arguments: {'categorySlug': category.slug},
          );
        }
      }
      // If category has subcategories, stay on home page to show subcategory filter
    }
  }

  Future<void> loadCategoryBySlug(String slug) async {
    try {
      final category = await _ecommerceService.getCategoryBySlug(slug);
      if (category != null) {
        selectedCategory.value = category;
        Get.toNamed('/product-list', arguments: {'category': category});
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
        Get.toNamed('/product-list', arguments: {'category': category});
      }
    } catch (e) {
      print('Error loading category by ID: $e');
    }
  }

  void navigateToProductDetail(ProductModel product, {String? heroTag}) {
    Get.toNamed(
      '/product-detail',
      arguments: {'product': product, if (heroTag != null) 'heroTag': heroTag},
    );
  }

  void navigateToProductList({String? searchQuery}) {
    Get.toNamed('/product-list', arguments: {'search': searchQuery});
  }

  void navigateToSearch({String? initialQuery}) {
    Get.toNamed(
      AppRoutes.search,
      arguments: {
        if (initialQuery != null && initialQuery.isNotEmpty)
          'initialQuery': initialQuery,
      },
    );
  }

  Future<void> loadBanners() async {
    await runWithLoading(
      () async {
        isLoadingBanners.value = true;
        var list = await _bannerService.getBannersByCategory('appecommerce');
        if (list.isEmpty) {
          list = await _bannerService.getBannersByCategory('ecommerce');
        }
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
