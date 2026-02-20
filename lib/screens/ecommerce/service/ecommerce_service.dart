import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/data_model/cart_model.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/data_model/wishlist_model.dart';
import 'package:astrobharataiuser/data_model/coupon_model.dart';
import 'package:astrobharataiuser/data_model/search_model.dart';
import 'package:get/get.dart';

class EcommerceService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  CartModel? _parseCartResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['cart'] is Map<String, dynamic>) {
        return CartModel.fromJson(data['cart'] as Map<String, dynamic>);
      }
      return CartModel.fromJson(data);
    }
    return null;
  }

  CartAndWishlistResponse? _parseCartWishlistResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    CartModel? cartModel;
    WishlistModel? wishlistModel;
    if (data['cart'] != null && data['cart'] is Map<String, dynamic>) {
      cartModel = CartModel.fromJson(data['cart'] as Map<String, dynamic>);
    }
    if (data['wishlist'] != null && data['wishlist'] is Map<String, dynamic>) {
      wishlistModel = WishlistModel.fromJson(
        data['wishlist'] as Map<String, dynamic>,
      );
    }
    return CartAndWishlistResponse(cart: cartModel, wishlist: wishlistModel);
  }

  // Get categories
  Future<CategoryData?> getCategories({
    int page = 1,
    int limit = 20,
    bool? isActive,
    bool? isFeatured,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (isActive != null) {
        queryParams['isActive'] = isActive.toString();
      }
      if (isFeatured != null) {
        queryParams['isFeatured'] = isFeatured.toString();
      }

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCategories,
        query: queryParams,
      );

      if (response.body['success'] == true) {
        final categoryResponse = CategoryResponse.fromJson(response.body);
        return categoryResponse.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get category tree
  Future<List<CategoryModel>?> getCategoryTree() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCategoriesTree,
      );

      if (response.body['success'] == true) {
        try {
          final treeResponse = CategoryTreeResponse.fromJson(response.body);
          return treeResponse.data;
        } catch (parseError) {
          print('Parse error in CategoryTreeResponse: $parseError');
          print('Response body: ${response.body}');
          // Try to parse directly if response structure is different
          if (response.body['data'] != null && response.body['data'] is List) {
            final List<dynamic> data = response.body['data'];
            return data
                .where((item) => item is Map<String, dynamic>)
                .map(
                  (item) =>
                      CategoryModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
          }
          return [];
        }
      }
      return null;
    } catch (e) {
      print('Error in getCategoryTree: $e');
      rethrow;
    }
  }

  Future<CategoryModel?> getCategoryBySlug(String slug) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCategoryBySlug(slug),
      );

      if (response.body['success'] == true) {
        return CategoryModel.fromJson(response.body['data']);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get category by ID
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCategoryById(id),
      );

      if (response.body['success'] == true) {
        return CategoryModel.fromJson(response.body['data']);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get products by category
  Future<ProductData?> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
    bool includeSubcategories = true,
    String sortBy = 'popular',
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'includeSubcategories': includeSubcategories.toString(),
        'sortBy': sortBy,
      };

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCategoryProducts(categoryId),
        query: queryParams,
      );

      if (response.body['success'] == true) {
        final productResponse = ProductResponse.fromJson(response.body);
        return productResponse.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductData?> getProductsByCategorySlug(
    String slug, {
    int page = 1,
    int limit = 20,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductsByCategorySlug(slug),
        query: queryParams,
      );

      if (response.body['success'] == true) {
        return ProductResponse.fromJson(response.body).data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get unique purposes from products
  Future<List<String>> getPurposes() async {
    try {
      // Fetch products with a high limit to get all purposes
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProducts,
        query: {'limit': '100', 'page': '1'},
      );

      if (response.body['success'] == true) {
        final productResponse = ProductResponse.fromJson(response.body);
        final products = productResponse.data?.items ?? [];

        // Extract unique purposes from products
        final Set<String> purposesSet = {};
        for (var product in products) {
          // Check if product has purpose in specifications or as a direct field
          // Since purpose is a filter parameter, we'll need to check the API response
          // For now, we'll extract from a purpose field if it exists
          if (product.specifications != null) {
            // Purpose might be in specifications or as a separate field
            // We'll check the raw JSON for purpose
          }
        }

        // If we can't extract from products, return common purposes
        // This is a fallback - ideally the API should provide a purposes endpoint
        if (purposesSet.isEmpty) {
          return ['Money', 'Love', 'Health', 'Rashi', 'Protection'];
        }

        // Filter to only include the 5 allowed purposes
        final allowedPurposes = [
          'Money',
          'Love',
          'Health',
          'Rashi',
          'Protection',
        ];
        return purposesSet.where((p) => allowedPurposes.contains(p)).toList()
          ..sort();
      }

      // Fallback to common purposes
      return ['Money', 'Love', 'Health', 'Rashi', 'Protection'];
    } catch (e) {
      print('Error fetching purposes: $e');
      // Return fallback purposes
      return ['Money', 'Love', 'Health', 'Rashi', 'Protection'];
    }
  }

  // Get all products with filters
  Future<ProductData?> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? subcategory,
    double? minPrice,
    double? maxPrice,
    int? mukhiCount,
    String? material,
    String? origin,
    bool? isCertified,
    bool? isEnergized,
    bool? isFeatured,
    bool? inStock,
    String? purpose,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (subcategory != null && subcategory.isNotEmpty) {
        queryParams['subcategory'] = subcategory;
      }
      if (minPrice != null) {
        queryParams['minPrice'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['maxPrice'] = maxPrice.toString();
      }
      if (mukhiCount != null) {
        queryParams['mukhiCount'] = mukhiCount.toString();
      }
      if (material != null && material.isNotEmpty) {
        queryParams['material'] = material;
      }
      if (origin != null && origin.isNotEmpty) {
        queryParams['origin'] = origin;
      }
      if (isCertified != null) {
        queryParams['isCertified'] = isCertified.toString();
      }
      if (isEnergized != null) {
        queryParams['isEnergized'] = isEnergized.toString();
      }
      if (isFeatured != null) {
        queryParams['isFeatured'] = isFeatured.toString();
      }
      if (inStock != null) {
        queryParams['inStock'] = inStock.toString();
      }
      if (purpose != null && purpose.isNotEmpty) {
        queryParams['purpose'] = purpose;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProducts,
        query: queryParams,
      );

      if (response.body['success'] == true) {
        final productResponse = ProductResponse.fromJson(response.body);
        return productResponse.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getRecommendations({int limit = 10}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceRecommendations,
        query: {'limit': limit.toString()},
      );

      if (response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList();
        }
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<List<ProductModel>> getPersonalizedRecommendations({
    int limit = 10,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceRecommendationsPersonalized,
        query: {'limit': limit.toString()},
      );

      if (response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList();
        }
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<List<ProductModel>> getRecentlyViewed({int limit = 10}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceRecommendationsRecentlyViewed,
        query: {'limit': limit.toString()},
      );

      if (response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList();
        }
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<List<ProductModel>> getFrequentlyBoughtTogether(
    String productId, {
    int limit = 5,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceRecommendationsFrequentlyBought(productId),
        query: {'limit': limit.toString()},
      );

      if (response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList();
        }
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  // Get featured products
  Future<List<ProductModel>?> getFeaturedProducts({int limit = 10}) async {
    try {
      final queryParams = <String, String>{'limit': limit.toString()};

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductsFeatured,
        query: queryParams,
      );

      if (response.body['success'] == true) {
        final dynamic dataField = response.body['data'];

        if (dataField == null || dataField is! List) {
          return [];
        }

        final List<dynamic> data = dataField;
        final List<ProductModel> products = [];
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              products.add(ProductModel.fromJson(item));
            } catch (e) {
              print('Error parsing product in getFeaturedProducts: $e');
            }
          }
        }
        return products;
      }
      return null;
    } catch (e) {
      print('Error in getFeaturedProducts: $e');
      rethrow;
    }
  }

  Future<SearchResponse?> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceSearch,
        query: {'q': query, 'page': page.toString(), 'limit': limit.toString()},
      );

      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return SearchResponse.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<SearchSuggestions> getSearchSuggestions({
    required String query,
    int limit = 5,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceSearchSuggestions,
        query: {'q': query, 'limit': limit.toString()},
      );

      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return SearchSuggestions.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      rethrow;
    }
    return SearchSuggestions();
  }

  Future<List<SearchPopularTerm>> getPopularSearches({int limit = 10}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceSearchPopular,
        query: {'limit': limit.toString()},
      );

      if (response.body['success'] == true && response.body['data'] is List) {
        return (response.body['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map(SearchPopularTerm.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Get top selling products
  Future<List<ProductModel>?> getTopSellingProducts({int limit = 10}) async {
    try {
      final queryParams = <String, String>{'limit': limit.toString()};

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductsTopSelling,
        query: queryParams,
      );

      if (response.body['success'] == true) {
        final dynamic dataField = response.body['data'];

        if (dataField == null || dataField is! List) {
          return [];
        }

        final List<dynamic> data = dataField;
        final List<ProductModel> products = [];
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              products.add(ProductModel.fromJson(item));
            } catch (e) {
              print('Error parsing product in getTopSellingProducts: $e');
            }
          }
        }
        return products;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get product by slug
  Future<ProductDetailData?> getProductBySlug(String slug) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductBySlug(slug),
      );

      if (response.body['success'] == true) {
        final productResponse = ProductDetailResponse.fromJson(response.body);
        return productResponse.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get product by ID
  Future<ProductDetailData?> getProductById(String id) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductById(id),
      );

      if (response.body['success'] == true) {
        final productResponse = ProductDetailResponse.fromJson(response.body);
        return productResponse.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get related products
  Future<List<ProductModel>?> getRelatedProducts(
    String productId, {
    int limit = 5,
  }) async {
    try {
      final queryParams = <String, String>{'limit': limit.toString()};

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductRelated(productId),
        query: queryParams,
      );

      if (response.body['success'] == true) {
        if (response.body['data'] != null && response.body['data'] is List) {
          final List<dynamic> data = response.body['data'];
          final List<ProductModel> products = [];
          for (var item in data) {
            if (item is Map<String, dynamic>) {
              try {
                products.add(ProductModel.fromJson(item));
              } catch (e) {
                print('Error parsing related product: $e');
              }
            }
          }
          return products;
        }
        return [];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get product variants
  Future<List<ProductVariant>?> getProductVariants(String productId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductVariants(productId),
      );

      if (response.body['success'] == true) {
        if (response.body['data'] != null && response.body['data'] is List) {
          final List<dynamic> data = response.body['data'];
          final List<ProductVariant> variants = [];
          for (var item in data) {
            if (item is Map<String, dynamic>) {
              try {
                variants.add(ProductVariant.fromJson(item));
              } catch (e) {
                print('Error parsing variant: $e');
              }
            }
          }
          return variants;
        }
        return [];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get product reviews
  Future<ProductReviewData?> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
    int? rating,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (rating != null) {
        queryParams['rating'] = rating.toString();
      }

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceProductReviews(productId),
        query: queryParams,
      );

      if (response.body['success'] == true) {
        try {
          final reviewResponse = ProductReviewResponse.fromJson(response.body);
          return reviewResponse.data;
        } catch (parseError) {
          print('Parse error in ProductReviewResponse: $parseError');
          if (response.body['data'] != null) {
            try {
              return ProductReviewData.fromJson(response.body['data']);
            } catch (e) {
              return null;
            }
          }
          return null;
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Orders

  Future<OrdersResponse?> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null && status.isNotEmpty) {
        query['status'] = status;
      }
      if (search != null && search.isNotEmpty) {
        query['search'] = search;
      }

      final response = await _apiRepository.getApi(
        EndPoints.ecommerceOrders,
        query: query,
      );

      // Handle 403 (Forbidden) - user doesn't have ecommerce access, return null silently
      if (response.statusCode == 403) {
        return null;
      }

      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return OrdersResponse.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      // Check if error is 403 (Forbidden) or contains deactivated message - don't show error
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('403') ||
          errorStr.contains('forbidden') ||
          errorStr.contains('account has been deactivated')) {
        return null;
      }
      rethrow;
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceOrderById(orderId),
      );

      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return OrderModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel?> getOrderByOrderNumber(String orderNumber) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceOrderByOrderId(orderNumber),
      );

      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return OrderModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderHistoryEntry>> getOrderHistory(String orderId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceOrderHistory(orderId),
      );

      if (response.statusCode != null && response.statusCode! >= 500) {
        // Backend occasionally returns 5xx for history; fail gracefully without spamming the UI.
        return [];
      }

      if (response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(OrderHistoryEntry.fromJson)
              .toList();
        } else if (data is Map<String, dynamic>) {
          if (data['items'] is List) {
            return (data['items'] as List)
                .whereType<Map<String, dynamic>>()
                .map(OrderHistoryEntry.fromJson)
                .toList();
          }
          if (data['history'] is List) {
            return (data['history'] as List)
                .whereType<Map<String, dynamic>>()
                .map(OrderHistoryEntry.fromJson)
                .toList();
          }
        }
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<OrderTrackingInfo?> getOrderTracking(String orderId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceOrderTrack(orderId),
      );
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return OrderTrackingInfo.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel?> cancelOrder(
    String orderId, {
    required String reason,
  }) async {
    try {
      // Validate reason before sending
      if (reason.isEmpty) {
        showErrorMessage(
          title: "Validation Error",
          message: 'Cancellation reason is required',
        );
        return null;
      }
      if (reason.length < 10) {
        showErrorMessage(
          title: "Validation Error",
          message: 'Reason must be at least 10 characters',
        );
        return null;
      }
      if (reason.length > 500) {
        showErrorMessage(
          title: "Validation Error",
          message: 'Reason must not exceed 500 characters',
        );
        return null;
      }

      final response = await _apiRepository.putApiCall(
        EndPoints.ecommerceOrderCancel(orderId),
        {'reason': reason},
      );
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return OrderModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Cart APIs
  Future<CartModel?> getCart() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.ecommerceCart);
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return CartModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel?> addToCart({
    required String productId,
    int quantity = 1,
    String? variantId,
  }) async {
    try {
      final body = <String, dynamic>{
        'productId': productId,
        'quantity': quantity,
      };
      if (variantId != null && variantId.isNotEmpty) {
        body['variantId'] = variantId;
      }

      final response = await _apiRepository.postApi(
        EndPoints.ecommerceCartItems,
        body,
      );
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return CartModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel?> clearCart() async {
    try {
      final response = await _apiRepository.deleteReq(EndPoints.ecommerceCart);
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return CartModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceAddresses,
      );

      // Handle 403 (Forbidden) - user doesn't have ecommerce access, return empty list silently
      if (response.statusCode == 403) {
        return [];
      }

      if (response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((map) => AddressModel.fromJson(map))
              .toList();
        }
      }
      return [];
    } catch (e) {
      // Check if error is 403 (Forbidden) or contains deactivated message - don't show error
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('403') ||
          errorStr.contains('forbidden') ||
          errorStr.contains('account has been deactivated')) {
        // Silently return empty list - user doesn't have ecommerce access
        return [];
      }
      rethrow;
    }
  }

  Future<AddressModel?> getDefaultAddress() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceAddressesDefault,
      );
      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return AddressModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddressModel?> getAddressById(String addressId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceAddressById(addressId),
      );
      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return AddressModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddressModel?> setDefaultAddress(String addressId) async {
    try {
      final response = await _apiRepository.putApiCall(
        EndPoints.ecommerceAddressSetDefault(addressId),
        {},
      );
      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return AddressModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddressModel?> upsertAddress(AddressModel address) async {
    try {
      final isUpdate = address.id != null && address.id!.isNotEmpty;
      final body = address.toRequestBody(
        includeDefault: !isUpdate,
        forUpdate: isUpdate,
      );

      // Remove null entries to avoid validation errors
      body.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty),
      );

      if (address.id != null && address.id!.isNotEmpty) {
        final response = await _apiRepository.putApiCall(
          EndPoints.ecommerceAddressById(address.id!),
          body,
        );
        if (response.body['success'] == true &&
            response.body['data'] is Map<String, dynamic>) {
          return AddressModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
      } else {
        final response = await _apiRepository.postApi(
          EndPoints.ecommerceAddresses,
          body,
        );
        if (response.body['success'] == true &&
            response.body['data'] is Map<String, dynamic>) {
          return AddressModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
    }
    return null;
  }

  Future<bool> deleteAddress(String addressId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.ecommerceAddressById(addressId),
      );
      if (response.body['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CouponModel>> getAvailableCoupons() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCouponsAvailable,
      );

      // Handle 403 (Forbidden) - user doesn't have ecommerce access, return empty list silently
      if (response.statusCode == 403) {
        return [];
      }

      if (response.body['success'] == true && response.body['data'] is List) {
        return (response.body['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map(CouponModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      // Check if error is 403 (Forbidden) or contains deactivated message - don't show error
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('403') ||
          errorStr.contains('forbidden') ||
          errorStr.contains('account has been deactivated')) {
        // Silently return empty list - user doesn't have ecommerce access
        return [];
      }
      rethrow;
    }
  }

  Future<CouponValidationResult?> validateCoupon({
    required String code,
    double? cartTotal,
  }) async {
    try {
      final body = {
        'code': code,
        if (cartTotal != null) 'cartTotal': cartTotal,
      };
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceCouponValidate,
        body,
      );
      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return CouponValidationResult.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CouponModel?> getCouponByCode(String code) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCouponByCode(code),
      );
      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return CouponModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createOrder({
    required String paymentMethod,
    String? addressId,
    String? couponCode,
    String? billingAddressId,
    String? shippingAddressId,
  }) async {
    try {
      final body = <String, dynamic>{
        'paymentMethod': paymentMethod,
        if (addressId != null && addressId.isNotEmpty) 'addressId': addressId,
        if (billingAddressId != null && billingAddressId.isNotEmpty)
          'billingAddressId': billingAddressId,
        if (shippingAddressId != null && shippingAddressId.isNotEmpty)
          'shippingAddressId': shippingAddressId,
        if (couponCode != null && couponCode.isNotEmpty)
          'couponCode': couponCode,
      };

      final response = await _apiRepository.postApi(
        EndPoints.ecommerceOrders,
        body,
      );
      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.body['data'] as Map);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<EcommercePaymentInitiateResponse?> initiatePayment({
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      // Determine payment provider based on payment method
      final paymentProvider =
          paymentMethod == 'online' || paymentMethod == 'razorpay'
          ? 'razorpay'
          : paymentMethod;

      final body = {
        'orderId': orderId,
        'paymentMethod': paymentMethod,
        'paymentProvider': paymentProvider,
      };
      final response = await _apiRepository.postApi(
        EndPoints.ecommercePaymentsInitiate,
        body,
      );
      if (response.body['success'] == true) {
        return EcommercePaymentInitiateResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<EcommercePaymentVerifyResponse?> verifyPayment({
    required String paymentId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) async {
    try {
      final body = <String, dynamic>{
        'paymentId': paymentId,
        if (razorpayOrderId != null) 'razorpay_order_id': razorpayOrderId,
        if (razorpayPaymentId != null) 'razorpay_payment_id': razorpayPaymentId,
        if (razorpaySignature != null) 'razorpay_signature': razorpaySignature,
      };
      final response = await _apiRepository.postApi(
        EndPoints.ecommercePaymentsVerify,
        body,
      );
      if (response.body['success'] == true) {
        return EcommercePaymentVerifyResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentsResponse?> getPayments({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null && status.isNotEmpty) {
        query['status'] = status;
      }

      final response = await _apiRepository.getApi(
        EndPoints.ecommercePayments,
        query: query,
      );
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return PaymentsResponse.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentModel?> getPaymentById(String paymentId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommercePaymentById(paymentId),
      );
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data'] is Map<String, dynamic>) {
        return PaymentModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Cart

  Future<CartModel?> removeCartItem(String itemId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.ecommerceCartItem(itemId),
      );
      if (response.body['success'] == true) {
        final cart = _parseCartResponse(response.body['data']);
        return cart ?? CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel?> saveCartItemForLater(String itemId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceCartItemSaveForLater(itemId),
        {},
      );
      if (response.body['success'] == true) {
        final cart = _parseCartResponse(response.body['data']);
        return cart ?? CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel?> applyCartCoupon(String code) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceCartCoupon,
        {'code': code},
      );
      if (response.body['success'] == true) {
        final cart = _parseCartResponse(response.body['data']);
        return cart ?? CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel?> removeCartCoupon() async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.ecommerceCartCoupon,
      );
      if (response.body['success'] == true) {
        final cart = _parseCartResponse(response.body['data']);
        return cart ?? CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel?> mergeCart({String? sessionId}) async {
    // Only merge if we have a session ID (guest cart to merge)
    if (sessionId == null || sessionId.isEmpty) {
      return null;
    }

    try {
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceCartMerge,
        {'sessionId': sessionId},
      );
      if (response.body['success'] == true) {
        final cart = _parseCartResponse(response.body['data']);
        return cart ?? CartModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartAndWishlistResponse?> moveSavedItemToCart(
    String savedItemId,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceSavedItemMoveToCart(savedItemId),
        {},
      );
      if (response.body['success'] == true) {
        return _parseCartWishlistResponse(response.body['data']);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Wishlist

  Future<WishlistModel?> getWishlist() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.ecommerceWishlist);
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return WishlistModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return WishlistModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<WishlistModel?> addWishlistItem(String productId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceWishlistItems,
        {'productId': productId},
      );
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return WishlistModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return WishlistModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<WishlistModel?> removeWishlistItem(String productId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.ecommerceWishlistItem(productId),
      );
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return WishlistModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return WishlistModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<WishlistModel?> clearWishlist() async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.ecommerceWishlist,
      );
      if (response.body['success'] == true) {
        if (response.body['data'] != null &&
            response.body['data'] is Map<String, dynamic>) {
          return WishlistModel.fromJson(
            response.body['data'] as Map<String, dynamic>,
          );
        }
        return WishlistModel();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartAndWishlistResponse?> moveWishlistItemToCart(
    String productId,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.ecommerceWishlistItemMoveToCart(productId),
        {},
      );
      if (response.body['success'] == true) {
        return _parseCartWishlistResponse(response.body['data']);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}

class CartAndWishlistResponse {
  final CartModel? cart;
  final WishlistModel? wishlist;

  CartAndWishlistResponse({this.cart, this.wishlist});
}
