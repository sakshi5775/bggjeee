import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

class ProductDetailController extends BaseController {
  final EcommerceService _ecommerceService = EcommerceService();
  late final CartController cartController;

  final product = Rxn<ProductModel>();
  final relatedProducts = <ProductModel>[].obs;
  final frequentlyBoughtTogether = <ProductModel>[].obs;
  final recentlyViewed = <ProductModel>[].obs;
  final variants = <ProductVariant>[].obs;
  final inventoryItems = <ProductInventory>[].obs;
  final reviews = <ProductReview>[].obs;
  final isLoading = false.obs;
  final isLoadingRelated = false.obs;
  final isLoadingFrequentlyBought = false.obs;
  final isLoadingRecentlyViewed = false.obs;
  final isLoadingVariants = false.obs;
  final isLoadingReviews = false.obs;
  final currentImageIndex = 0.obs;
  final quantity = 1.obs;
  final selectedVariant = Rxn<ProductVariant>();
  int reviewsPage = 1;
  final int reviewsLimit = 10;
  final hasMoreReviews = true.obs;
  String? heroTag;

  @override
  void onInit() {
    super.onInit();
    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    ever(cartController.cart, (_) => syncQuantityWithCart());
    _handleArguments();
  }

  @override
  void onReady() {
    super.onReady();
    // Handle arguments again in case controller was reused
    _handleArguments();
  }

  void _handleArguments() {
    final args = Get.arguments;
    print('ProductDetailController - Handling arguments: $args');
    if (args != null && args['heroTag'] != null) {
      heroTag = args['heroTag'] as String?;
    }
    if (args != null && args['product'] != null) {
      final productArg = args['product'] as ProductModel;
      product.value = productArg;
      loadProductDetails();
    } else if (args != null && args['productId'] != null) {
      final productId = args['productId'];
      print('Loading product by ID: $productId (type: ${productId.runtimeType})');
      final productIdStr = productId.toString();
      loadProductById(productIdStr);
    } else if (args != null && args['productSlug'] != null) {
      final productSlug = args['productSlug'];
      print('Loading product by slug: $productSlug (type: ${productSlug.runtimeType})');
      final productSlugStr = productSlug.toString();
      loadProductBySlug(productSlugStr);
    } else {
      print('No valid product arguments found. Args: $args');
    }
    syncQuantityWithCart();
  }

  Future<void> loadProductDetails() async {
    if (product.value?.id == null) return;

    try {
      isLoading.value = true;
      final result = await _ecommerceService.getProductById(product.value!.id!);
      if (result != null && result.product != null) {
        product.value = result.product;
        // Load variants and inventory from detail response
        _captureVariantsAndInventory(result);
        await Future.wait([
          loadRelatedProducts(),
          loadFrequentlyBoughtTogether(),
          loadRecentlyViewed(),
          loadProductVariants(),
          loadProductReviews(),
        ]);
        syncQuantityWithCart();
      }
    } catch (e) {
      print('Error loading product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProductById(String id) async {
    try {
      isLoading.value = true;
      final result = await _ecommerceService.getProductById(id);
      if (result != null && result.product != null) {
        product.value = result.product;
        // Load variants and inventory from detail response
        _captureVariantsAndInventory(result);
        await Future.wait([
          loadRelatedProducts(),
          loadFrequentlyBoughtTogether(),
          loadRecentlyViewed(),
          loadProductVariants(),
          loadProductReviews(),
        ]);
        syncQuantityWithCart();
      }
    } catch (e) {
      print('Error loading product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProductBySlug(String slug) async {
    try {
      isLoading.value = true;
      final result = await _ecommerceService.getProductBySlug(slug);
      if (result != null && result.product != null) {
        product.value = result.product;
        // Load variants and inventory from detail response
        _captureVariantsAndInventory(result);
        await Future.wait([
          loadRelatedProducts(),
          loadFrequentlyBoughtTogether(),
          loadRecentlyViewed(),
          loadProductVariants(),
          loadProductReviews(),
        ]);
        syncQuantityWithCart();
      }
    } catch (e) {
      print('Error loading product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRelatedProducts() async {
    if (product.value?.id == null) return;

    try {
      isLoadingRelated.value = true;
      final result = await _ecommerceService.getRelatedProducts(
        product.value!.id!,
        limit: 5,
      );
      if (result != null) {
        relatedProducts.value = result;
      }
    } catch (e) {
      print('Error loading related products: $e');
    } finally {
      isLoadingRelated.value = false;
    }
  }

  Future<void> loadFrequentlyBoughtTogether() async {
    final productId = product.value?.id;
    if (productId == null) return;

    try {
      isLoadingFrequentlyBought.value = true;
      final items = await _ecommerceService.getFrequentlyBoughtTogether(
        productId,
        limit: 5,
      );
      frequentlyBoughtTogether
        ..clear()
        ..addAll(items);
      frequentlyBoughtTogether.refresh();
    } catch (e) {
      print('Error loading frequently bought together products: $e');
    } finally {
      isLoadingFrequentlyBought.value = false;
    }
  }

  Future<void> loadRecentlyViewed() async {
    try {
      isLoadingRecentlyViewed.value = true;
      final items = await _ecommerceService.getRecentlyViewed(limit: 10);
      recentlyViewed
        ..clear()
        ..addAll(items);
      recentlyViewed.refresh();
    } catch (e) {
      print('Error loading recently viewed products: $e');
    } finally {
      isLoadingRecentlyViewed.value = false;
    }
  }

  Future<void> loadProductVariants() async {
    if (product.value?.id == null) return;
    if (product.value?.hasVariants != true) return;

    try {
      isLoadingVariants.value = true;
      final result = await _ecommerceService.getProductVariants(product.value!.id!);
      if (result != null && result.isNotEmpty) {
        variants.value = result;
        // Auto-select first variant if none selected
        if (selectedVariant.value == null) {
          selectedVariant.value = result.first;
        }
      }
    } catch (e) {
      print('Error loading product variants: $e');
    } finally {
      isLoadingVariants.value = false;
    }
  }

  Future<void> loadProductReviews({bool reset = false}) async {
    if (product.value?.id == null) return;

    try {
      if (reset) {
        reviewsPage = 1;
        reviews.clear();
        hasMoreReviews.value = true;
      }

      if (!hasMoreReviews.value || isLoadingReviews.value) return;

      isLoadingReviews.value = true;
      final result = await _ecommerceService.getProductReviews(
        product.value!.id!,
        page: reviewsPage,
        limit: reviewsLimit,
      );
      
      if (result != null) {
        if (result.items != null && result.items!.isNotEmpty) {
          reviews.addAll(result.items!);
          reviewsPage++;
          hasMoreReviews.value = result.pagination?.hasNextPage ?? false;
        } else {
          hasMoreReviews.value = false;
        }
      }
    } catch (e) {
      print('Error loading product reviews: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  void selectVariant(ProductVariant variant) {
    selectedVariant.value = variant;
  }

  void changeImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void incrementQuantity() {
    final maxAllowed = availableQuantity > 0
        ? (availableQuantity < CartController.maxQuantity ? availableQuantity : CartController.maxQuantity)
        : CartController.maxQuantity;
    if (quantity.value >= maxAllowed) {
      showErrorMessage(
        title: "Limit reached",
        message: availableQuantity <= 0
            ? "Item is currently out of stock."
            : "You can add up to $maxAllowed items of this product.",
      );
      return;
    }
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > CartController.minQuantity) {
      quantity.value--;
    }
  }

  int get availableQuantity {
    if (inventoryItems.isEmpty) return CartController.maxQuantity;
    final first = inventoryItems.first;
    final available = first.quantityAvailable ?? first.totalStock ?? CartController.maxQuantity;
    return available > 0 ? available : 0;
  }

  bool get isOutOfStock => availableQuantity <= 0;

  void _captureVariantsAndInventory(ProductDetailData result) {
    if (result.variants != null && result.variants!.isNotEmpty) {
      variants.value = result.variants!;
    } else {
      variants.clear();
    }

    if (result.inventory != null && result.inventory!.isNotEmpty) {
      inventoryItems.value = result.inventory!;
    } else {
      inventoryItems.clear();
    }
  }

  Future<void> addToCart() async {
    final currentProduct = product.value;
    if (currentProduct?.id == null) {
      showErrorMessage(
        title: "Unable to add",
        message: "Product information is incomplete",
      );
      return;
    }

    final productToUse = currentProduct!;

    if (isOutOfStock) {
      showErrorMessage(
        title: "Out of stock",
        message: "This product is currently not available.",
      );
      return;
    }

    final target = quantity.value.clamp(CartController.minQuantity, availableQuantity);

    final success = await cartController.setProductQuantity(
      product: productToUse,
      targetQuantity: target,
      variantId: selectedVariant.value?.id,
      showFeedback: true,
    );

    if (success) {
      final synced = cartController.quantityForProduct(productToUse);
      quantity.value = synced > 0 ? synced : 1;
    }
  }

  Future<void> buyNow() async {
    final currentProduct = product.value;
    if (currentProduct?.id == null) {
      showErrorMessage(
        title: "Unable to add",
        message: "Product information is incomplete",
      );
      return;
    }

    final productToUse = currentProduct!;

    if (isOutOfStock) {
      showErrorMessage(
        title: "Out of stock",
        message: "This product is currently not available.",
      );
      return;
    }

    final target = quantity.value.clamp(CartController.minQuantity, availableQuantity);

    final success = await cartController.setProductQuantity(
      product: productToUse,
      targetQuantity: target,
      variantId: selectedVariant.value?.id,
      showFeedback: true,
    );

    if (success) {
      final synced = cartController.quantityForProduct(productToUse);
      quantity.value = synced > 0 ? synced : 1;
      Get.toNamed(AppRoutes.cart);
    }
  }

  void navigateToProduct(ProductModel product, {String? heroTag}) {
    Get.toNamed(
      '/product-detail',
      arguments: {
        'product': product,
        if (heroTag != null) 'heroTag': heroTag,
      },
    );
  }

  void syncQuantityWithCart() {
    final current = product.value;
    if (current?.id == null) return;
    final cartQty = cartController.quantityForProduct(current!);
    final maxAllowed = availableQuantity > 0
        ? (availableQuantity < CartController.maxQuantity ? availableQuantity : CartController.maxQuantity)
        : CartController.maxQuantity;
    if (cartQty > 0) {
      quantity.value = cartQty > maxAllowed ? maxAllowed : cartQty;
    } else {
      quantity.value = availableQuantity > 0 ? 1 : 0;
    }
  }
}

