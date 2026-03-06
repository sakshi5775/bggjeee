import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/data_model/cart_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/data_model/wishlist_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_razorpay_service.dart';

class CartController extends BaseController {
  static const int maxQuantity = 50;
  static const int minQuantity = 1;

  final EcommerceService _service = EcommerceService();

  final cart = Rxn<CartModel>();
  final savedItems = <CartItem>[].obs;

  final isLoading = true.obs;
  final isUpdatingCart = false.obs;
  final isApplyingCoupon = false.obs;
  final isLoadingAddresses = false.obs;
  final isSavingAddress = false.obs;
  final isPlacingOrder = false.obs;

  final addresses = <AddressModel>[].obs;
  final selectedAddress = Rxn<AddressModel>();

  final couponController = TextEditingController();
  final _pendingProducts = <String, bool>{}.obs;

  // Payment Method
  final RxString selectedPaymentMethod = 'online'.obs; // Default to online

  final EcommerceRazorpayService _razorpayService = EcommerceRazorpayService();

  // You may also like (featured products for cart page)
  final youMayAlsoLikeProducts = <ProductModel>[].obs;
  final isLoadingYouMayAlsoLike = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    loadAddresses();
    loadYouMayAlsoLike();
    _initializeRazorpay();
  }

  Future<void> loadYouMayAlsoLike() async {
    try {
      isLoadingYouMayAlsoLike.value = true;
      final list = await _service.getFeaturedProducts(limit: 8);
      if (list != null && list.isNotEmpty) {
        youMayAlsoLikeProducts.assignAll(list);
      }
    } catch (_) {}
    isLoadingYouMayAlsoLike.value = false;
  }

  @override
  void onClose() {
    couponController.dispose();
    _razorpayService.dispose();
    super.onClose();
  }

  void _initializeRazorpay() {
    _razorpayService.initialize(
      onSuccess: (data) {
        _handlePaymentSuccess(data);
      },
      onError: (message) {
        isPlacingOrder.value = false;
        showErrorMessage(title: 'Payment Failed', message: message);
      },
      onFailure: (response) {
        isPlacingOrder.value = false;
        showErrorMessage(
          title: 'Payment Failed',
          message: '${response.code}: ${response.message}',
        );
      },
    );
  }

  Future<void> _handlePaymentSuccess(Map<String, dynamic> data) async {
    try {
      final paymentId = data['paymentId']?.toString() ?? '';
      final orderId = data['orderId']?.toString() ?? '';
      final signature = data['signature']?.toString() ?? '';

      // We need the original payment ID (database ID) from initiation
      // Since we can't easily pass state through Razorpay callbacks without local storage,
      // we can rely on the fact that verifyPayment needs 'paymentId' (our DB id) which we have available in the scope if we were inside placeOrder.
      // BUT callbacks are async.
      // A common pattern is to store the Pending Payment ID in a variable.

      if (_pendingPaymentId == null) {
        showErrorMessage(
          title: "Error",
          message: "Payment session lost. Please contact support.",
        );
        isPlacingOrder.value = false;
        return;
      }

      await _service.verifyPayment(
        paymentId: _pendingPaymentId!,
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
      );

      // Clear cart and reload before showing success modal
      await clearCart();
      await loadCart();

      // Show success modal that auto-closes after 3 seconds
      _showPaymentSuccessModal();
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Verification failed: $e');
    } finally {
      isPlacingOrder.value = false;
      _pendingPaymentId = null;
    }
  }

  void _showPaymentSuccessModal() {
    Get.dialog(
      PopScope(
        canPop: false, // Prevent back button from closing
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, AppColors.cream],
              ),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          'Payment Successful',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success Icon
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 50.w,
                        ),
                      ),
                      Spacing.h(24),
                      // Success Message
                      AutoTranslateText(
                        'Order Placed Successfully!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.h(12),
                      AutoTranslateText(
                        'Your order has been placed successfully. You will receive an order confirmation shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Auto-close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close success modal
        // Navigate back to previous screen (cart or ecommerce home)
        if (Get.currentRoute.contains('/cart')) {
          Get.back(); // Close cart screen
        }
      }
    });
  }

  // Temporary storage for payment verification
  String? _pendingPaymentId;

  Future<void> loadCart() async {
    await runWithLoading(
      () async {
        isLoading.value = true;
        // Try to merge cart if we have a session ID (guest cart to merge with user cart)
        // If no session ID is available, mergeCart will skip the API call
        await _service.mergeCart();
        final result = await _service.getCart();
        _updateCartState(result);
      },
      showBusy: false,
      showError: false,
      silent401ForGuest: true,
    ).whenComplete(() {
      isLoading.value = false;
    });
  }

  void _updateCartState(CartModel? updatedCart) {
    if (updatedCart == null) return;
    cart.value = updatedCart;
    couponController.text = updatedCart.appliedCoupon?.code ?? '';
    savedItems
      ..clear()
      ..addAll(updatedCart.savedForLater ?? <CartItem>[]);
    cart.refresh();
    savedItems.refresh();
  }

  Future<void> _refreshCartFromServer() async {
    final refreshed = await _service.getCart();
    if (refreshed != null) {
      _updateCartState(refreshed);
    }
  }

  bool _requiresCartEnrichment(CartModel? candidate) {
    final items = candidate?.items;
    if (items == null || items.isEmpty) return false;
    return items.any((item) => item.product == null);
  }

  Future<void> _ensureCartFullyLoaded({CartModel? candidate}) async {
    final cartSnapshot = candidate ?? cart.value;
    if (_requiresCartEnrichment(cartSnapshot)) {
      await _refreshCartFromServer();
    }
  }

  String _resolveCartItemKey(CartItem item) {
    final product = item.product;
    if (product != null) {
      final productKey = resolveProductKey(product);
      if (productKey.isNotEmpty) {
        return productKey;
      }
    }
    return item.id ??
        item.productSnapshot?.productId ??
        item.productSnapshot?.sku ??
        item.productSnapshot?.name ??
        item.hashCode.toString();
  }

  String _resolveWishlistKey(WishlistItem item) {
    final product = item.product;
    if (product != null) {
      final productKey = resolveProductKey(product);
      if (productKey.isNotEmpty) {
        return productKey;
      }
    }
    return item.productId ??
        item.id ??
        item.product?.slug ??
        item.product?.sku ??
        item.hashCode.toString();
  }

  void replaceCart(CartModel updatedCart) {
    _updateCartState(updatedCart);
  }

  Future<bool> addItem({
    required ProductModel product,
    required int quantity,
    String? variantId,
    bool showFeedback = true,
  }) async {
    if (product.id == null) {
      showErrorMessage(
        title: 'Unable to add',
        message: 'Product information is incomplete',
      );
      return false;
    }
    if (quantity < minQuantity || quantity > maxQuantity) {
      showErrorMessage(
        title: 'Invalid quantity',
        message: 'Quantity must be between $minQuantity and $maxQuantity',
      );
      return false;
    }

    final previousQty = quantityForProduct(product);
    final productKey = resolveProductKey(product);

    try {
      _pendingProducts[productKey] = true;
      _pendingProducts.refresh();

      final result = await _service.addToCart(
        productId: product.id!,
        quantity: quantity,
        variantId: variantId,
      );

      if (result != null) {
        _updateCartState(result);
        final newQty = quantityForProduct(product);

        if (showFeedback) {
          if (newQty == 0 && previousQty > 0) {
            showSuccessMessage(
              title: 'Removed',
              message: '${product.name ?? 'Product'} removed from cart',
            );
          } else if (previousQty == 0 && newQty > 0) {
            showSuccessMessage(
              title: 'Added to cart',
              message:
                  '${product.name ?? 'Product'} has been added to your cart',
            );
          } else if (previousQty != newQty) {
            showSuccessMessage(
              title: 'Cart updated',
              message: '${product.name ?? 'Product'} quantity updated',
            );
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return false;
    } finally {
      _pendingProducts.remove(productKey);
      _pendingProducts.refresh();
    }
  }

  Future<void> incrementProduct(ProductModel product) async {
    final current = quantityForProduct(product);
    if (current >= maxQuantity) {
      showErrorMessage(
        title: 'Limit reached',
        message: 'You can add up to $maxQuantity items of this product.',
      );
      return;
    }
    final variantId = _findCartItem(product)?.variantId;
    await addItem(
      product: product,
      quantity: 1,
      variantId: variantId,
      showFeedback: false,
    );
  }

  Future<void> decrementProduct(ProductModel product) async {
    final current = quantityForProduct(product);
    final variantId = _findCartItem(product)?.variantId;
    await setProductQuantity(
      product: product,
      variantId: variantId,
      targetQuantity: current - 1,
      showFeedback: false,
    );
  }

  Future<void> incrementItem(CartItem item) async {
    final product = item.product;
    if (product == null) {
      showErrorMessage(
        title: 'Error',
        message: 'Product data missing for this item',
      );
      return;
    }
    final current = item.quantity ?? 0;
    if (current >= maxQuantity) {
      showErrorMessage(
        title: 'Limit reached',
        message: 'You can add up to $maxQuantity items of this product.',
      );
      return;
    }
    await addItem(
      product: product,
      quantity: 1,
      variantId: item.variantId,
      showFeedback: false,
    );
  }

  Future<void> decrementItem(CartItem item) async {
    final product = item.product;
    if (product == null) {
      showErrorMessage(
        title: 'Error',
        message: 'Product data missing for this item',
      );
      return;
    }
    final current = item.quantity ?? 0;
    await setProductQuantity(
      product: product,
      variantId: item.variantId,
      targetQuantity: current - 1,
      showFeedback: false,
    );
  }

  Future<void> removeItem(CartItem item) async {
    await _removeCartItem(item);
  }

  Future<void> clearCart() async {
    try {
      isUpdatingCart.value = true;
      final result = await _service.clearCart();
      if (result != null) {
        _updateCartState(result);
        showSuccessMessage(
          title: 'Cart cleared',
          message: 'Your cart has been cleared successfully',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
    } finally {
      isUpdatingCart.value = false;
      _pendingProducts.clear();
      _pendingProducts.refresh();
    }
  }

  int get itemCount {
    if (cart.value?.itemCount != null) {
      return cart.value!.itemCount!;
    }
    final items = cart.value?.items;
    if (items == null) return 0;
    return items.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  double get total => cart.value?.totals?.total ?? cart.value?.total ?? 0;
  double get subtotal => cart.value?.totals?.subtotal ?? cart.value?.total ?? 0;
  double get discount => cart.value?.totals?.discount ?? 0;
  double get tax => cart.value?.totals?.tax ?? 0;
  double get deliveryFee => cart.value?.totals?.shipping ?? 0;

  bool isProductUpdating(ProductModel product) {
    final key = resolveProductKey(product);
    return isUpdatingCart.value || (_pendingProducts[key] == true);
  }

  bool isCartItemProcessing(CartItem item) {
    final key = _resolveCartItemKey(item);
    return isUpdatingCart.value || (_pendingProducts[key] == true);
  }

  bool isWishlistItemProcessing(WishlistItem item) {
    final key = _resolveWishlistKey(item);
    return isUpdatingCart.value || (_pendingProducts[key] == true);
  }

  String resolveProductKey(ProductModel product) {
    return product.id ??
        product.slug ??
        product.sku ??
        product.name ??
        product.hashCode.toString();
  }

  CartItem? _findCartItem(ProductModel product) {
    final items = cart.value?.items;
    if (items == null) return null;
    for (final item in items) {
      final cartProduct = item.product;
      if (cartProduct?.id != null && cartProduct!.id == product.id) {
        return item;
      }
      if (cartProduct?.slug != null && cartProduct!.slug == product.slug) {
        return item;
      }
      if (cartProduct?.sku != null && cartProduct!.sku == product.sku) {
        return item;
      }
    }
    return null;
  }

  int quantityForProduct(ProductModel product) {
    final item = _findCartItem(product);
    return item?.quantity ?? 0;
  }

  Future<bool> setProductQuantity({
    required ProductModel product,
    int? targetQuantity,
    String? variantId,
    bool showFeedback = false,
  }) async {
    if (product.id == null) {
      showErrorMessage(
        title: 'Unable to update',
        message: 'Product information is incomplete',
      );
      return false;
    }

    final desired = targetQuantity ?? quantityForProduct(product);
    if (desired <= 0) {
      return _removeProductFromCart(product, showFeedback: showFeedback);
    }

    if (desired > maxQuantity) {
      showErrorMessage(
        title: 'Limit reached',
        message: 'You can add up to $maxQuantity items of this product.',
      );
      return false;
    }

    final existingItem = _findCartItem(product);
    final productKey = resolveProductKey(product);

    try {
      _pendingProducts[productKey] = true;
      _pendingProducts.refresh();

      if (existingItem != null && existingItem.id != null) {
        final removal = await _service.removeCartItem(existingItem.id!);
        if (removal == null) {
          showErrorMessage(
            title: 'Unable to update',
            message: 'Please try again in a moment.',
          );
          return false;
        }
        _updateCartState(removal);
      }

      final added = await _service.addToCart(
        productId: product.id!,
        quantity: desired,
        variantId: variantId,
      );

      if (added != null) {
        _updateCartState(added);
        if (showFeedback) {
          final name = product.name ?? 'Product';
          showSuccessMessage(
            title: 'Cart updated',
            message: '$name quantity updated to $desired',
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return false;
    } finally {
      _pendingProducts.remove(productKey);
      _pendingProducts.refresh();
    }
  }

  Future<bool> _removeProductFromCart(
    ProductModel product, {
    bool showFeedback = true,
  }) async {
    final item = _findCartItem(product);
    if (item == null) {
      if (showFeedback) {
        showErrorMessage(
          title: 'Not found',
          message: 'Unable to locate this item in your cart.',
        );
      }
      return false;
    }
    return _removeCartItem(
      item,
      productOverride: product,
      showFeedback: showFeedback,
    );
  }

  Future<bool> _removeCartItem(
    CartItem item, {
    ProductModel? productOverride,
    bool showFeedback = true,
  }) async {
    if (item.id == null) {
      if (showFeedback) {
        showErrorMessage(
          title: 'Unable to remove',
          message: 'Item information is incomplete.',
        );
      }
      return false;
    }

    final product = productOverride ?? item.product;
    final pendingKey = product != null
        ? resolveProductKey(product)
        : _resolveCartItemKey(item);

    try {
      _pendingProducts[pendingKey] = true;
      _pendingProducts.refresh();

      final result = await _service.removeCartItem(item.id!);
      if (result != null) {
        _updateCartState(result);
        if (showFeedback) {
          final name = product?.name ?? item.productSnapshot?.name ?? 'Product';
          showSuccessMessage(
            title: 'Removed',
            message: '$name removed from cart',
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return false;
    } finally {
      _pendingProducts.remove(pendingKey);
      _pendingProducts.refresh();
    }
  }

  Future<void> saveForLater(CartItem item) async {
    if (item.id == null) return;
    final pendingKey = _resolveCartItemKey(item);
    try {
      _pendingProducts[pendingKey] = true;
      _pendingProducts.refresh();
      final result = await _service.saveCartItemForLater(item.id!);
      if (result != null) {
        _updateCartState(result);
        if (savedItems.isEmpty || (result.savedForLater?.isEmpty ?? true)) {
          final refreshed = await _service.getCart();
          _updateCartState(refreshed);
        }
        showSuccessMessage(
          title: 'Saved for later',
          message:
              '${item.product?.name ?? item.productSnapshot?.name ?? 'Product'} saved for later.',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
    } finally {
      _pendingProducts.remove(pendingKey);
      _pendingProducts.refresh();
    }
  }

  Future<void> moveSavedItemToCart(CartItem item) async {
    if (item.id == null) return;
    final pendingKey = _resolveCartItemKey(item);
    try {
      _pendingProducts[pendingKey] = true;
      _pendingProducts.refresh();
      final response = await _service.moveSavedItemToCart(item.id!);
      if (response != null) {
        if (response.cart != null) {
          _updateCartState(response.cart);
          await _ensureCartFullyLoaded(candidate: response.cart);
        } else {
          await _refreshCartFromServer();
        }
        final wishlistController = Get.isRegistered<WishlistController>()
            ? Get.find<WishlistController>()
            : null;
        if (wishlistController != null) {
          await wishlistController.updateWishlist(response.wishlist);
        }
        showSuccessMessage(
          title: 'Moved to cart',
          message:
              '${item.product?.name ?? item.productSnapshot?.name ?? 'Product'} moved to cart.',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
    } finally {
      _pendingProducts.remove(pendingKey);
      _pendingProducts.refresh();
    }
  }

  Future<void> moveWishlistItemToCart(WishlistItem item) async {
    final productId = item.product?.id;
    if (productId == null) return;
    final pendingKey = _resolveWishlistKey(item);
    try {
      _pendingProducts[pendingKey] = true;
      _pendingProducts.refresh();
      final response = await _service.moveWishlistItemToCart(productId);
      if (response != null) {
        if (response.cart != null) {
          _updateCartState(response.cart);
          await _ensureCartFullyLoaded(candidate: response.cart);
        } else {
          await _refreshCartFromServer();
        }
        final wishlistController = Get.isRegistered<WishlistController>()
            ? Get.find<WishlistController>()
            : null;
        if (wishlistController != null) {
          await wishlistController.updateWishlist(response.wishlist);
        }
        showSuccessMessage(
          title: 'Moved to cart',
          message:
              '${item.product?.name ?? 'Item'} moved to cart successfully.',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
    } finally {
      _pendingProducts.remove(pendingKey);
      _pendingProducts.refresh();
    }
  }

  Future<void> applyCoupon() async {
    final code = couponController.text.trim();
    if (code.isEmpty) {
      showErrorMessage(title: 'Coupon', message: 'Please enter a coupon code.');
      return;
    }
    try {
      isApplyingCoupon.value = true;
      final result = await _service.applyCartCoupon(code);
      if (result != null) {
        _updateCartState(result);
        showSuccessMessage(
          title: 'Coupon applied',
          message: 'Coupon "$code" applied successfully.',
        );
      }
    } finally {
      isApplyingCoupon.value = false;
    }
  }

  Future<void> removeCoupon() async {
    try {
      isApplyingCoupon.value = true;
      final result = await _service.removeCartCoupon();
      if (result != null) {
        _updateCartState(result);
        couponController.clear();
        showSuccessMessage(
          title: 'Coupon removed',
          message: 'Coupon removed successfully.',
        );
      }
    } finally {
      isApplyingCoupon.value = false;
    }
  }

  Future<void> loadAddresses() async {
    await runWithLoading(
      () async {
        isLoadingAddresses.value = true;
        final defaultAddress = await _service.getDefaultAddress();
        final allAddresses = await _service.getAddresses();
        final sorted = List<AddressModel>.from(allAddresses);
        sorted.sort((a, b) {
          final aDefault = a.isDefault == true;
          final bDefault = b.isDefault == true;
          if (aDefault == bDefault) return 0;
          return aDefault ? -1 : 1;
        });
        addresses
          ..clear()
          ..addAll(sorted);
        if (defaultAddress != null) {
          selectedAddress.value = defaultAddress;
        } else if (addresses.isNotEmpty) {
          AddressModel? fallback;
          for (final address in addresses) {
            if (address.isDefault == true) {
              fallback = address;
              break;
            }
          }
          selectedAddress.value = fallback ?? addresses.first;
        }
        addresses.refresh();
      },
      showBusy: false,
      showError: false,
      silent401ForGuest: true,
    ).whenComplete(() {
      isLoadingAddresses.value = false;
    });
  }

  Future<void> saveAddress(
    AddressModel address, {
    bool setAsDefault = false,
  }) async {
    try {
      isSavingAddress.value = true;
      final saved = await _service.upsertAddress(address);
      if (saved != null) {
        if (setAsDefault || address.isDefault == true) {
          if (saved.id != null) {
            await _service.setDefaultAddress(saved.id!);
          }
        }
        showSuccessMessage(
          title: 'Address saved',
          message: 'Your address has been saved successfully.',
        );
        await loadAddresses();
      }
    } finally {
      isSavingAddress.value = false;
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    if (address.id == null) return;
    final success = await _service.deleteAddress(address.id!);
    if (success) {
      showSuccessMessage(
        title: 'Address removed',
        message: 'Address removed from your saved list.',
      );
      await loadAddresses();
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> markDefault(AddressModel address) async {
    if (address.id == null) return;
    final updated = await _service.setDefaultAddress(address.id!);
    if (updated != null) {
      showSuccessMessage(
        title: 'Default address updated',
        message: '${updated.fullName ?? 'Address'} set as default.',
      );
      await loadAddresses();
    }
  }

  Future<void> placeOrder() async {
    final paymentMethod = selectedPaymentMethod.value;
    print('Placing order with payment method: $paymentMethod'); // Debug log

    final currentCart = cart.value;
    if (currentCart == null || (currentCart.items?.isEmpty ?? true)) {
      showErrorMessage(
        title: 'Cart empty',
        message: 'Please add items to cart first.',
      );
      return;
    }
    final address = selectedAddress.value;
    if (address == null || address.id == null) {
      showErrorMessage(
        title: 'Address required',
        message: 'Please select or add a delivery address.',
      );
      return;
    }

    try {
      isPlacingOrder.value = true;
      final selectedId = address.id!;
      final orderData = await _service.createOrder(
        addressId: selectedId,
        billingAddressId: selectedId,
        shippingAddressId: selectedId,
        paymentMethod: paymentMethod,
        couponCode: currentCart.appliedCoupon?.code,
      );

      if (orderData == null) return;

      print('Order Data received: $orderData'); // Debugging

      // Extract Display ID (e.g., ORD12345) for UI
      final displayOrderId =
          orderData['orderId']?.toString() ??
          orderData['order']?['orderId']?.toString() ??
          '';

      // Extract Internal ID (MongoDB _id) for Payment API
      // If _id or id is missing, fallback to displayOrderId (though likely wrong)
      final paymentOrderId =
          orderData['_id']?.toString() ??
          orderData['id']?.toString() ??
          orderData['order']?['_id']?.toString() ??
          orderData['order']?['id']?.toString() ??
          displayOrderId;

      print('Payment Order ID: $paymentOrderId');
      print('Display Order ID: $displayOrderId');

      if (paymentMethod != 'cod' && paymentOrderId.isNotEmpty) {
        final paymentInit = await _service.initiatePayment(
          orderId: paymentOrderId,
          paymentMethod: paymentMethod, // removed amount
        );

        if (paymentInit != null &&
            paymentInit.success &&
            paymentInit.data?.razorpay != null) {
          _pendingPaymentId = paymentInit.data!.paymentId;

          _razorpayService.openCheckout(
            razorpayData: paymentInit.data!.razorpay!,
          );
          // Wait for callback
        } else {
          isPlacingOrder.value = false;
          showErrorMessage(
            title: "Payment Error",
            message: "Failed to initiate payment parameters.",
          );
        }
      } else {
        // COD or other sync success
        showSuccessMessage(
          title: 'Order placed',
          message: displayOrderId.isNotEmpty
              ? 'Order #$displayOrderId has been placed successfully.'
              : 'Your order has been placed successfully.',
        );
        await clearCart();
        await loadCart();
        isPlacingOrder.value = false;
      }
    } catch (e) {
      isPlacingOrder.value = false;
      showErrorMessage(title: 'Error', message: e.toString());
    }
  }
}
