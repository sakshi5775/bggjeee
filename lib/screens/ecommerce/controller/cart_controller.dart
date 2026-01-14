import 'dart:math';

import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/data_model/cart_model.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/data_model/wishlist_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class CartController extends BaseController {
  static const int maxQuantity = 50;
  static const int minQuantity = 1;

  final EcommerceService _service = EcommerceService();

  final cart = Rxn<CartModel>();
  final savedItems = <CartItem>[].obs;

  final isLoading = false.obs;
  final isUpdatingCart = false.obs;
  final isApplyingCoupon = false.obs;
  final isLoadingAddresses = false.obs;
  final isSavingAddress = false.obs;
  final isPlacingOrder = false.obs;

  final addresses = <AddressModel>[].obs;
  final selectedAddress = Rxn<AddressModel>();

  final couponController = TextEditingController();
  final _pendingProducts = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    loadAddresses();
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  Future<void> loadCart() async {
    try {
      isLoading.value = true;
      // Try to merge cart if we have a session ID (guest cart to merge with user cart)
      // If no session ID is available, mergeCart will skip the API call
      await _service.mergeCart();
      final result = await _service.getCart();
      _updateCartState(result);
    } finally {
      isLoading.value = false;
    }
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
              message: '${product.name ?? 'Product'} has been added to your cart',
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
      showErrorMessage(title: 'Error', message: 'Product data missing for this item');
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
      showErrorMessage(title: 'Error', message: 'Product data missing for this item');
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
    return product.id ?? product.slug ?? product.sku ?? product.name ?? product.hashCode.toString();
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
    final pendingKey = product != null ? resolveProductKey(product) : _resolveCartItemKey(item);

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
          message: '${item.product?.name ?? item.productSnapshot?.name ?? 'Product'} saved for later.',
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
          message: '${item.product?.name ?? item.productSnapshot?.name ?? 'Product'} moved to cart.',
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
          message: '${item.product?.name ?? 'Item'} moved to cart successfully.',
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
        showSuccessMessage(title: 'Coupon applied', message: 'Coupon "$code" applied successfully.');
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
        showSuccessMessage(title: 'Coupon removed', message: 'Coupon removed successfully.');
      }
    } finally {
      isApplyingCoupon.value = false;
    }
  }

  Future<void> loadAddresses() async {
    try {
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
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> saveAddress(AddressModel address, {bool setAsDefault = false}) async {
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

  Future<void> placeOrder({String paymentMethod = 'cod'}) async {
    final currentCart = cart.value;
    if (currentCart == null || (currentCart.items?.isEmpty ?? true)) {
      showErrorMessage(title: 'Cart empty', message: 'Please add items to cart first.');
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

      final orderId = orderData['orderId']?.toString() ??
          orderData['order']?['orderId']?.toString() ??
          '';
      final pricingMap = orderData['pricing'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(orderData['pricing'] as Map)
          : orderData['order'] is Map && orderData['order']['pricing'] is Map
              ? Map<String, dynamic>.from(orderData['order']['pricing'] as Map)
              : null;
      final totalAmount = pricingMap?['total'] is num
          ? (pricingMap!['total'] as num).toDouble()
          : total;

      if (paymentMethod != 'cod' && orderId.isNotEmpty) {
        final paymentInit = await _service.initiatePayment(
          orderId: orderId,
          amount: totalAmount,
          paymentMethod: paymentMethod,
        );

        if (paymentInit != null && paymentInit['paymentId'] != null) {
          final paymentId = paymentInit['paymentId'].toString();
          final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
          await _service.verifyPayment(
            paymentId: paymentId,
            transactionId: transactionId,
          );
        }
      }

      showSuccessMessage(
        title: 'Order placed',
        message: orderId.isNotEmpty
            ? 'Order #$orderId has been placed successfully.'
            : 'Your order has been placed successfully.',
      );
      await clearCart();
      await loadCart();
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
