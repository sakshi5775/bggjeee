import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class ProductListController extends BaseController {
  final EcommerceService _ecommerceService = EcommerceService();

  // Category
  final selectedCategory = Rxn<CategoryModel>();

  // Products
  final products = <ProductModel>[].obs;
  final isLoadingProducts = false.obs;
  final hasMoreProducts = true.obs;
  int currentPage = 1;
  final int limit = 20;

  // Filters
  final searchQuery = ''.obs;
  final selectedSubcategory = Rxn<CategoryModel>();
  final selectedPurpose = Rxn<String>();
  final sortBy = 'popular'.obs;
  final isGridView = true.obs;
  final isFeatured = false.obs;

  // Available categories for filter
  final availableCategories = <CategoryModel>[].obs;
  final categoryTree = <CategoryModel>[].obs; // Category tree structure
  final isLoadingCategories = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['category'] != null) {
        selectedCategory.value = args['category'];
      } else if (args['categoryId'] != null) {
        loadCategoryById(args['categoryId']);
      } else if (args['categorySlug'] != null) {
        loadCategoryBySlug(args['categorySlug']);
      }
      if (args['subcategory'] != null) {
        selectedSubcategory.value = args['subcategory'];
      }
      if (args['search'] != null) {
        searchQuery.value = args['search'];
      }
      if (args['purpose'] != null) {
        selectedPurpose.value = args['purpose'] as String;
      }
      if (args['isFeatured'] != null) {
        isFeatured.value = args['isFeatured'] as bool;
      }
    }
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadCategories(), loadProducts(reset: true)]);
  }

  // Helper function to recursively flatten category tree
  List<CategoryModel> _flattenCategoryTree(List<CategoryModel> categories) {
    final allCats = <CategoryModel>[];
    for (final cat in categories) {
      allCats.add(cat);
      if (cat.children != null && cat.children!.isNotEmpty) {
        allCats.addAll(_flattenCategoryTree(cat.children!));
      }
    }
    return allCats;
  }

  Future<void> loadCategories() async {
    try {
      isLoadingCategories.value = true;
      final results = await Future.wait([
        _ecommerceService.getCategoryTree(),
        _ecommerceService.getCategories(page: 1, limit: 200, isActive: true),
      ]);

      final treeResult = results[0] as List<CategoryModel>?;
      final categoryData = results[1] as CategoryData?;

      if (treeResult != null && treeResult.isNotEmpty) {
        categoryTree.value = treeResult;
      }

      final allCats = <CategoryModel>[];
      if (treeResult != null && treeResult.isNotEmpty) {
        allCats.addAll(_flattenCategoryTree(treeResult));
      }

      if (categoryData != null && categoryData.items != null) {
        for (final cat in categoryData.items!) {
          final exists = allCats.any(
            (existing) =>
                existing.id == cat.id ||
                (existing.slug != null &&
                    cat.slug != null &&
                    existing.slug == cat.slug),
          );
          if (!exists) {
            allCats.add(cat);
          }
        }
      }
      availableCategories.value = allCats;
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> loadCategoryById(String categoryId) async {
    try {
      isLoadingCategories.value = true;
      final category = await _ecommerceService.getCategoryById(categoryId);
      if (category != null) {
        selectedCategory.value = category;
      }
    } catch (e) {
      print('Error loading category by ID: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> loadCategoryBySlug(String categorySlug) async {
    try {
      isLoadingCategories.value = true;
      final category = await _ecommerceService.getCategoryBySlug(categorySlug);
      if (category != null) {
        selectedCategory.value = category;
      }
    } catch (e) {
      print('Error loading category by slug: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> loadProducts({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      products.clear();
      hasMoreProducts.value = true;
    }

    if (!hasMoreProducts.value || isLoadingProducts.value) return;

    try {
      isLoadingProducts.value = true;
      ProductData? result;
      final category = selectedCategory.value;
      final subcategory = selectedSubcategory.value;

      if (subcategory != null && subcategory.id != null) {
        result = await _ecommerceService.getProducts(
          page: currentPage,
          limit: limit,
          search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
          category: category?.id,
          subcategory: subcategory.id,
          purpose: selectedPurpose.value,
          sortBy: sortBy.value,
          isFeatured: isFeatured.value ? true : null,
        );
      } else if (category != null) {
        if (category.slug != null && category.slug!.isNotEmpty) {
          result = await _ecommerceService.getProductsByCategorySlug(
            category.slug!,
            page: currentPage,
            limit: limit,
            sortBy: sortBy.value,
          );
        } else if (category.id != null) {
          result = await _ecommerceService.getProductsByCategory(
            category.id!,
            page: currentPage,
            limit: limit,
            includeSubcategories: subcategory == null,
            sortBy: sortBy.value,
          );
        }
      } else {
        result = await _ecommerceService.getProducts(
          page: currentPage,
          limit: limit,
          search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
          category: selectedCategory.value?.id,
          subcategory: selectedSubcategory.value?.id,
          purpose: selectedPurpose.value,
          sortBy: sortBy.value,
          isFeatured: isFeatured.value ? true : null,
        );
      }

      if (result != null) {
        if (result.items != null && result.items!.isNotEmpty) {
          products.addAll(result.items!);
          currentPage++;
          hasMoreProducts.value = result.pagination?.hasNextPage ?? false;
        } else {
          hasMoreProducts.value = false;
        }
      }
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    loadProducts(reset: true);
  }

  void onCategorySelected(CategoryModel? category) {
    selectedCategory.value = category;
    selectedSubcategory.value = null;
    loadProducts(reset: true);
  }

  void onSubcategorySelected(CategoryModel? subcategory) {
    selectedSubcategory.value = subcategory;
    loadProducts(reset: true);
  }

  List<CategoryModel> get getSubcategories {
    if (selectedCategory.value == null) return [];
    final category = selectedCategory.value!;
    final categoryId = category.id;
    final categorySlug = category.slug;

    bool idsMatch(String? id1, String? id2) =>
        id1 != null && id2 != null && id1 == id2;
    bool slugsMatch(String? slug1, String? slug2) =>
        slug1 != null &&
        slug2 != null &&
        slug1.toLowerCase() == slug2.toLowerCase();
    bool categoryMatches(CategoryModel cat) =>
        (categoryId != null && idsMatch(cat.id, categoryId)) ||
        (categorySlug != null && slugsMatch(cat.slug, categorySlug));
    bool parentMatches(CategoryModel cat) =>
        cat.parent != null &&
        ((categoryId != null && idsMatch(cat.parent!.id, categoryId)) ||
            (categorySlug != null &&
                slugsMatch(cat.parent!.slug, categorySlug)));

    final tree = categoryTree;
    final available = availableCategories;

    CategoryModel? _findCategoryInTree(List<CategoryModel> categories) {
      for (final cat in categories) {
        if (categoryMatches(cat)) return cat;
        if (cat.children != null && cat.children!.isNotEmpty) {
          final found = _findCategoryInTree(cat.children!);
          if (found != null) return found;
        }
      }
      return null;
    }

    if (tree.isNotEmpty) {
      final parentCategory = _findCategoryInTree(tree);
      if (parentCategory != null &&
          parentCategory.children != null &&
          parentCategory.children!.isNotEmpty) {
        return parentCategory.children!;
      }
    }

    return available.where((cat) => parentMatches(cat)).toList();
  }

  void onSortChanged(String sort) {
    sortBy.value = sort;
    loadProducts(reset: true);
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  void navigateToProductDetail(ProductModel product, {String? heroTag}) {
    UserMainController.pushInCurrentTab(
      '/product-detail',
      arguments: {'product': product, if (heroTag != null) 'heroTag': heroTag},
    );
  }

  void loadMore() {
    if (hasMoreProducts.value && !isLoadingProducts.value) {
      loadProducts();
    }
  }
}
