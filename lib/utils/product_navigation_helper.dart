import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/material.dart';

/// Helper class for navigating to product categories in ecommerce
class ProductNavigationHelper {
  static final EcommerceService _ecommerceService = EcommerceService();

  /// Product type to category name/slug mapping
  static final Map<String, List<String>> _productTypeMapping = {
    'rudraksha': ['rudraksha', 'rudraksh', 'rudraksham'],
    'gemstone': ['gemstone', 'gem', 'gems', 'gemstones', 'ratna'],
    'yantra': ['yantra', 'yantras'],
    'jadi': ['jadi', 'jadi-buti', 'herbs'],
    'mala': ['mala', 'malas', 'rosary'],
    'puja': ['puja', 'puja-items', 'puja-samagri'],
    'idol': ['idol', 'idols', 'murti'],
    'book': ['book', 'books', 'pustak'],
    'incense': ['incense', 'agarbatti', 'dhoop'],
    'candle': ['candle', 'candles', 'diya'],
  };

  /// Navigate to product category or ecommerce home
  static Future<void> navigateToProductCategory(String productType) async {
    try {
      // Normalize product type (lowercase, trim)
      final normalizedType = productType.toLowerCase().trim();

      // Get possible category names/slugs for this product type
      final possibleNames = _productTypeMapping[normalizedType] ?? [normalizedType];

      // Try to find category by slug first (most common)
      CategoryModel? foundCategory;

      for (final name in possibleNames) {
        try {
          final category = await _ecommerceService.getCategoryBySlug(name);
          if (category != null) {
            foundCategory = category;
            break;
          }
        } catch (e) {
          // Continue to next name
          debugPrint('Category not found by slug: $name');
        }
      }

      // If not found by slug, try searching in category tree
      if (foundCategory == null) {
        try {
          final categoryTree = await _ecommerceService.getCategoryTree();
          if (categoryTree != null) {
            foundCategory = _findCategoryInTree(categoryTree, possibleNames);
          }
        } catch (e) {
          debugPrint('Error searching category tree: $e');
        }
      }

      // If category found, navigate to product list
      if (foundCategory != null) {
        UserMainController.pushInCurrentTab(
          AppRoutes.productList,
          arguments: {
            'category': foundCategory,
          },
        );
      } else {
        // Category not found, navigate to ecommerce home
        UserMainController.pushInCurrentTab(
          AppRoutes.ecommerceHome,
        );
      }
    } catch (e) {
      debugPrint('Error navigating to product category: $e');
      // On error, navigate to ecommerce home
      UserMainController.pushInCurrentTab(
        AppRoutes.ecommerceHome,
      );
    }
  }

  /// Recursively search for category in tree
  static CategoryModel? _findCategoryInTree(
    List<CategoryModel> categories,
    List<String> searchTerms,
  ) {
    for (final category in categories) {
      // Check if category name or slug matches
      final categoryName = (category.name ?? '').toLowerCase();
      final categorySlug = (category.slug ?? '').toLowerCase();

      for (final term in searchTerms) {
        if (categoryName.contains(term) || categorySlug.contains(term)) {
          return category;
        }
      }

      // Recursively search children
      if (category.children != null && category.children!.isNotEmpty) {
        final found = _findCategoryInTree(category.children!, searchTerms);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Check if a string contains product type keywords
  static bool containsProductType(String text) {
    final lowerText = text.toLowerCase();
    return _productTypeMapping.keys.any(
      (key) => lowerText.contains(key),
    ) || _productTypeMapping.values.any(
      (names) => names.any((name) => lowerText.contains(name)),
    );
  }

  /// Extract product type from text
  static String? extractProductType(String text) {
    final lowerText = text.toLowerCase();
    for (final entry in _productTypeMapping.entries) {
      if (lowerText.contains(entry.key)) {
        return entry.key;
      }
      for (final name in entry.value) {
        if (lowerText.contains(name)) {
          return entry.key;
        }
      }
    }
    return null;
  }
}
