import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/data_model/wishlist_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

class WishlistController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final wishlist = Rxn<WishlistModel>();
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final RxMap<String, bool> _pendingItems = <String, bool>{}.obs;

  List<WishlistItem> get items => wishlist.value?.items ?? <WishlistItem>[];

  String _resolveKey({ProductModel? product, WishlistItem? item}) {
    final candidates = <String?>[
      product?.id,
      item?.product?.id,
      item?.productId,
      product?.slug,
      item?.product?.slug,
      product?.sku,
      item?.product?.sku,
      item?.id,
      product?.name,
      item?.product?.name,
    ];
    for (final value in candidates) {
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    final fallback = product ?? item;
    return fallback.hashCode.toString();
  }

  Future<void> _refreshWishlistFromServer() async {
    await runWithLoading(
      () async {
        final refreshed = await _service.getWishlist();
        if (refreshed != null) {
          wishlist.value = refreshed;
          wishlist.refresh();
        }
      },
      showBusy: false,
      showError: false,
      silent401ForGuest: true,
    );
    _cleanupPendingKeys();
  }

  bool _requiresWishlistEnrichment(WishlistModel? candidate) {
    final items = candidate?.items;
    if (items == null || items.isEmpty) return false;
    return items.any((item) => item.product == null);
  }

  Future<void> _ensureWishlistHydrated({WishlistModel? candidate}) async {
    final snapshot = candidate ?? wishlist.value;
    if (_requiresWishlistEnrichment(snapshot)) {
      await _refreshWishlistFromServer();
    }
  }

  void _mergeExistingProductDetails(WishlistModel? incoming) {
    if (incoming?.items == null || incoming!.items!.isEmpty) return;
    final existingItems = wishlist.value?.items;
    if (existingItems == null || existingItems.isEmpty) return;

    for (final item in incoming.items!) {
      if (item.product != null) continue;
      final key = item.productId ?? item.product?.id;
      if (key == null) continue;
      for (final existing in existingItems) {
        final existingKey = existing.product?.id ?? existing.productId;
        if (existingKey == key && existing.product != null) {
          item.product = existing.product;
          item.variant ??= existing.variant;
          break;
        }
      }
    }
  }

  Future<void> _withPending(
    String key,
    Future<WishlistModel?> Function() updater, {
    bool useGlobalLoader = false,
  }) async {
    if (key.isNotEmpty) {
      _pendingItems[key] = true;
      _pendingItems.refresh();
    }
    try {
      await _updateWishlist(updater, useGlobalLoader: useGlobalLoader);
    } finally {
      if (key.isNotEmpty) {
        _pendingItems.remove(key);
        _pendingItems.refresh();
      }
    }
  }

  void _cleanupPendingKeys() {
    if (_pendingItems.isEmpty) return;
    final validKeys = items.map((item) => _resolveKey(item: item)).toSet();
    final toRemove = _pendingItems.keys
        .where((key) => !validKeys.contains(key))
        .toList();
    if (toRemove.isEmpty) return;
    for (final key in toRemove) {
      _pendingItems.remove(key);
    }
    _pendingItems.refresh();
  }

  bool isItemProcessing(WishlistItem item) {
    final key = _resolveKey(item: item);
    return _pendingItems[key] == true;
  }

  bool isProductProcessing(ProductModel product) {
    final key = _resolveKey(product: product);
    return _pendingItems[key] == true;
  }

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    await runWithLoading(
      () async {
        isLoading.value = true;
        final result = await _service.getWishlist();
        _mergeExistingProductDetails(result);
        wishlist.value = result;
        wishlist.refresh();
        _cleanupPendingKeys();
        await _ensureWishlistHydrated(candidate: result);
      },
      showBusy: false,
      showError: false,
      silent401ForGuest: true,
    ).whenComplete(() {
      isLoading.value = false;
    });
  }

  bool isInWishlist(ProductModel product) {
    final productId = product.id ?? product.slug ?? product.sku;
    if (productId == null) return false;
    return items.any(
      (item) =>
          item.product?.id == productId ||
          item.product?.slug == product.slug ||
          item.product?.sku == product.sku,
    );
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (isInWishlist(product)) {
      await removeFromWishlist(product);
    } else {
      await addToWishlist(product);
    }
  }

  Future<void> addToWishlist(ProductModel product) async {
    final productId = product.id;
    if (productId == null) {
      showErrorMessage(
        title: 'Unavailable',
        message: 'Product information is incomplete.',
      );
      return;
    }
    final key = _resolveKey(product: product);
    await _withPending(
      key,
      () => _service.addWishlistItem(productId),
      useGlobalLoader: false,
    );
    showSuccessMessage(
      title: 'Wishlist',
      message: '${product.name ?? 'Item'} added to wishlist.',
    );
  }

  Future<void> removeFromWishlist(ProductModel product) async {
    final productId = product.id;
    if (productId == null) return;
    final key = _resolveKey(product: product);
    await _withPending(
      key,
      () => _service.removeWishlistItem(productId),
      useGlobalLoader: false,
    );
    showSuccessMessage(
      title: 'Wishlist',
      message: '${product.name ?? 'Item'} removed from wishlist.',
    );
  }

  Future<void> clearWishlist() async {
    await _updateWishlist(_service.clearWishlist);
    if (_pendingItems.isNotEmpty) {
      _pendingItems.clear();
      _pendingItems.refresh();
    }
    showSuccessMessage(
      title: 'Wishlist cleared',
      message: 'All items removed from wishlist.',
    );
  }

  Future<void> _updateWishlist(
    Future<WishlistModel?> Function() updater, {
    bool useGlobalLoader = true,
  }) async {
    try {
      if (useGlobalLoader) {
        isUpdating.value = true;
      }
      final result = await updater();
      if (result != null) {
        _mergeExistingProductDetails(result);
        wishlist.value = result;
        wishlist.refresh();
        _cleanupPendingKeys();
        await _ensureWishlistHydrated(candidate: result);
      } else {
        await _refreshWishlistFromServer();
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
    } finally {
      if (useGlobalLoader) {
        isUpdating.value = false;
      }
    }
  }

  Future<void> updateWishlist(WishlistModel? updated) async {
    if (updated != null) {
      _mergeExistingProductDetails(updated);
      wishlist.value = updated;
      wishlist.refresh();
      _cleanupPendingKeys();
      await _ensureWishlistHydrated(candidate: updated);
    } else {
      await _refreshWishlistFromServer();
    }
  }
}
