import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

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
  final sortBy = 'popular'.obs;
  final isGridView = true.obs;

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
        // If only category ID is provided, fetch full category details
        loadCategoryById(args['categoryId']);
      } else if (args['categorySlug'] != null) {
        // If category slug is provided, fetch category by slug
        loadCategoryBySlug(args['categorySlug']);
      }
      if (args['subcategory'] != null) {
        selectedSubcategory.value = args['subcategory'];
      }
      if (args['search'] != null) {
        searchQuery.value = args['search'];
      }
    }
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadCategories(),
      loadProducts(reset: true),
    ]);
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
      
      // Load both category tree and flat list to get all categories including subcategories
      final results = await Future.wait([
        _ecommerceService.getCategoryTree(),
        _ecommerceService.getCategories(page: 1, limit: 200, isActive: true),
      ]);
      
      final treeResult = results[0] as List<CategoryModel>?;
      final categoryData = results[1] as CategoryData?;
      
      // Set category tree
      if (treeResult != null && treeResult.isNotEmpty) {
        categoryTree.value = treeResult;
      }
      
      // Combine tree categories and flat list categories
      final allCats = <CategoryModel>[];
      
      // Add categories from tree (flattened)
      if (treeResult != null && treeResult.isNotEmpty) {
        allCats.addAll(_flattenCategoryTree(treeResult));
      }
      
      // Add categories from flat list (may include subcategories with parent references)
      if (categoryData != null && categoryData.items != null) {
        for (final cat in categoryData.items!) {
          // Avoid duplicates by checking if category already exists
          final exists = allCats.any((existing) => 
            existing.id == cat.id || 
            (existing.slug != null && cat.slug != null && existing.slug == cat.slug)
          );
          if (!exists) {
            allCats.add(cat);
          }
        }
      }
      
      availableCategories.value = allCats;
      print('Loaded ${treeResult?.length ?? 0} top-level categories from tree, ${categoryData?.items?.length ?? 0} from flat list, ${allCats.length} total categories');
      
      // Debug: Print categories with parent info
      final categoriesWithParent = allCats.where((cat) => cat.parent != null).toList();
      if (categoriesWithParent.isNotEmpty) {
        print('Found ${categoriesWithParent.length} categories with parent references:');
        for (final cat in categoriesWithParent) {
          print('  - ${cat.name} (ID: ${cat.id}) - Parent: ${cat.parent!.name} (ID: ${cat.parent!.id}, Slug: ${cat.parent!.slug})');
        }
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Fallback to flat categories list on error
      try {
        final categoryData = await _ecommerceService.getCategories(
          page: 1,
          limit: 200,
          isActive: true,
        );
        if (categoryData != null && categoryData.items != null) {
          availableCategories.value = categoryData.items!;
          print('Loaded ${categoryData.items!.length} categories from flat list (fallback)');
        }
      } catch (e2) {
        print('Error loading categories fallback: $e2');
      }
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
      
      // If subcategory is selected, use getProducts with subcategory filter
      if (subcategory != null && subcategory.id != null) {
        result = await _ecommerceService.getProducts(
          page: currentPage,
          limit: limit,
          search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
          category: category?.id,
          subcategory: subcategory.id,
          sortBy: sortBy.value,
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
            includeSubcategories: subcategory == null, // Only include subcategories if no specific subcategory selected
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
          sortBy: sortBy.value,
        );
      }

      if (result != null) {
        if (result.items != null && result.items!.isNotEmpty) {
          products.addAll(result.items!);
          currentPage++;
          hasMoreProducts.value =
              result.pagination?.hasNextPage ?? false;
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
  
  // Get subcategories for selected category
  List<CategoryModel> get getSubcategories {
    if (selectedCategory.value == null) return [];
    final category = selectedCategory.value!;
    final categoryId = category.id;
    final categorySlug = category.slug;
    
    if (categoryId == null && categorySlug == null) return [];
    
    // Helper function to check if IDs match (handles both _id and id)
    bool idsMatch(String? id1, String? id2) {
      if (id1 == null || id2 == null) return false;
      return id1 == id2;
    }
    
    // Helper function to check if slugs match
    bool slugsMatch(String? slug1, String? slug2) {
      if (slug1 == null || slug2 == null) return false;
      return slug1.toLowerCase() == slug2.toLowerCase();
    }
    
    // Helper function to check if category matches (by ID or slug)
    bool categoryMatches(CategoryModel cat) {
      if (categoryId != null && idsMatch(cat.id, categoryId)) return true;
      if (categorySlug != null && slugsMatch(cat.slug, categorySlug)) return true;
      return false;
    }
    
    // Helper function to check if parent matches (by ID or slug)
    bool parentMatches(CategoryModel cat) {
      final parent = cat.parent;
      if (parent == null) return false;
      if (categoryId != null && idsMatch(parent.id, categoryId)) return true;
      if (categorySlug != null && slugsMatch(parent.slug, categorySlug)) return true;
      return false;
    }
    
    // Access observables to ensure GetX tracks them (RxList doesn't need .value)
    final tree = categoryTree;
    final available = availableCategories;
    
    // Helper function to recursively find category in tree
    CategoryModel? _findCategoryInTree(List<CategoryModel> categories) {
      for (final cat in categories) {
        if (categoryMatches(cat)) {
          return cat;
        }
        if (cat.children != null && cat.children!.isNotEmpty) {
          final found = _findCategoryInTree(cat.children!);
          if (found != null) return found;
        }
      }
      return null;
    }
    
    // First, try to find subcategories from category tree (children property)
    if (tree.isNotEmpty) {
      // Recursively search for the category in the tree
      final parentCategory = _findCategoryInTree(tree);
      
      if (parentCategory != null && 
          parentCategory.children != null && 
          parentCategory.children!.isNotEmpty) {
        // Sort by displayOrder if available, otherwise by name
        final sorted = List<CategoryModel>.from(parentCategory.children!);
        sorted.sort((a, b) {
          final orderA = a.displayOrder ?? 999;
          final orderB = b.displayOrder ?? 999;
          if (orderA != orderB) return orderA.compareTo(orderB);
          return (a.name ?? '').compareTo(b.name ?? '');
        });
        print('Found ${sorted.length} subcategories from category tree children for ${category.name}');
        return sorted;
      }
      
      // Also check if any category in flattened tree has this as parent
      final subcatsFromTree = available.where((cat) => parentMatches(cat)).toList();
      
      if (subcatsFromTree.isNotEmpty) {
        subcatsFromTree.sort((a, b) {
          final orderA = a.displayOrder ?? 999;
          final orderB = b.displayOrder ?? 999;
          if (orderA != orderB) return orderA.compareTo(orderB);
          return (a.name ?? '').compareTo(b.name ?? '');
        });
        print('Found ${subcatsFromTree.length} subcategories from available categories by parent for ${category.name}');
        return subcatsFromTree;
      }
    }
    
    // Fallback: Find subcategories from available categories by checking parent ID or slug
    final subcats = available.where((cat) => parentMatches(cat)).toList();
    
    // Sort by displayOrder if available, otherwise by name
    subcats.sort((a, b) {
      final orderA = a.displayOrder ?? 999;
      final orderB = b.displayOrder ?? 999;
      if (orderA != orderB) return orderA.compareTo(orderB);
      return (a.name ?? '').compareTo(b.name ?? '');
    });
    
    if (subcats.isNotEmpty) {
      print('Found ${subcats.length} subcategories from available categories');
    } else {
      print('No subcategories found for category: ${category.name} (ID: $categoryId, Slug: $categorySlug)');
      print('Category tree length: ${tree.length}');
      print('Available categories length: ${available.length}');
      
      // Debug: Print category tree structure
      print('Category tree structure:');
      for (final cat in tree) {
        print('  - ${cat.name} (ID: ${cat.id}, Slug: ${cat.slug}) - Children: ${cat.children?.length ?? 0}');
        if (cat.children != null && cat.children!.isNotEmpty) {
          for (final child in cat.children!) {
            print('    - ${child.name} (ID: ${child.id}, Slug: ${child.slug})');
          }
        }
      }
      
      // Debug: Print available categories with parent info
      print('Available categories with parent info:');
      for (final cat in available) {
        if (cat.parent != null) {
          print('  - ${cat.name} (ID: ${cat.id}) - Parent: ${cat.parent!.name} (ID: ${cat.parent!.id}, Slug: ${cat.parent!.slug})');
        }
      }
    }
    
    return subcats;
  }

  void onSortChanged(String sort) {
    sortBy.value = sort;
    loadProducts(reset: true);
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  void navigateToProductDetail(ProductModel product, {String? heroTag}) {
    Get.toNamed(
      '/product-detail',
      arguments: {
        'product': product,
        if (heroTag != null) 'heroTag': heroTag,
      },
    );
  }

  void loadMore() {
    if (hasMoreProducts.value && !isLoadingProducts.value) {
      loadProducts();
    }
  }
}

