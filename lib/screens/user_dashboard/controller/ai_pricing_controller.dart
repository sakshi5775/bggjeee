import 'package:astrobharataiuser/core/services/insufficient_balance_helper.dart';
import 'package:astrobharataiuser/data_model/ai_pricing_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/ai_pricing_service.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiPricingController extends GetxController {
  final RxList<AiPricingData> pricingData = <AiPricingData>[].obs;
  final RxBool isLoadingPricing = false.obs;

  WalletController get _walletController {
    if (Get.isRegistered<WalletController>()) {
      return Get.find<WalletController>();
    }
    return Get.put(WalletController());
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch pricing immediately; CTA gating depends on this list.
    fetchPricing();
  }

  Future<void> fetchPricing() async {
    isLoadingPricing.value = true;
    try {
      final service = AiPricingService();
      final response = await service.getAiPricing();
      if (response != null && response.success) {
        pricingData.assignAll(response.data);
        debugPrint(
          'AiPricingController: Loaded ${response.data.length} pricing items',
        );
        for (final item in response.data) {
          debugPrint(
            '  → ${item.displayName}: ₹${item.priceOffer.toInt()} (key: ${item.key})',
          );
        }
      } else {
        debugPrint(
          'AiPricingController: Failed to fetch pricing (null or unsuccessful)',
        );
      }
    } catch (e) {
      debugPrint('AiPricingController: Error fetching pricing: $e');
    } finally {
      isLoadingPricing.value = false;
    }
  }

  AiPricingData? getPricingFor(String key) {
    // 1) Exact match first
    try {
      return pricingData.firstWhere((element) => element.key == key);
    } catch (_) {}

    // 2) Fuzzy match: normalize common separators (e.g. '-' vs '_')
    final normalizedKey = _normalizePricingKey(key);
    try {
      return pricingData.firstWhere(
        (e) => _normalizePricingKey(e.key) == normalizedKey,
      );
    } catch (_) {}

    // 3) Substring match fallback (handles cases like 'kundli' vs 'generate_kundli')
    if (normalizedKey.isNotEmpty && normalizedKey.length >= 3) {
      try {
        return pricingData.firstWhere(
          (e) {
            final candidate = _normalizePricingKey(e.key);
            return candidate.contains(normalizedKey) ||
                normalizedKey.contains(candidate);
          },
        );
      } catch (_) {}
    }

    return null;
  }

  String _normalizePricingKey(String value) {
    // Backend keys sometimes differ only by separators/case.
    return value.trim().toLowerCase().replaceAll(RegExp(r'[\\s\\-]+'), '_');
  }

  bool isPaid(String key) {
    final pricing = getPricingFor(key);
    if (pricing == null) return false;
    return pricing.priceOffer > 0;
  }

  String getDisplayPrice(String key) {
    final pricing = getPricingFor(key);
    if (pricing == null || pricing.priceOffer == 0) return '';
    return '₹${pricing.priceOffer.toInt()}';
  }

  /// Returns true only if a positive, non-zero price is configured for this key.
  /// If pricing entry is missing or zero, we treat it as "not configured".
  bool hasConfiguredPricing(String key) {
    final pricing = getPricingFor(key);
    if (pricing == null) return false;
    return pricing.priceOffer > 0;
  }

  bool hasSufficientBalance(String key) {
    final pricing = getPricingFor(key);
    // If pricing entry is missing, treat the service as free.
    // This matches product requirement: "If not set => free; don't block with popup".
    if (pricing == null) return true;
    // Free or zero-priced services never require balance.
    if (pricing.priceOffer <= 0) return true;

    final double balance = _walletController.walletBalance.value;
    return balance >= pricing.priceOffer;
  }

  /// Ensures pricing list is loaded before balance checks.
  ///
  /// If pricing API fails or has no entry for [key], the caller will treat it
  /// as "free" (no blocking popup), per product requirement.
  Future<void> ensurePricingLoaded() async {
    if (pricingData.isNotEmpty) return;
    if (isLoadingPricing.value) return;
    await fetchPricing();
  }

  /// Returns `true` if the service can proceed based on wallet balance.
  ///
  /// Rules:
  /// - If pricing entry is missing => treated as free => returns true.
  /// - If `priceOffer <= 0` => treated as free => returns true.
  /// - Otherwise requires wallet balance >= priceOffer.
  ///
  /// When [showPopup] is true and balance is insufficient, it shows the
  /// global insufficient-balance popup and returns false.
  Future<bool> ensureHasSufficientBalance(
    String key, {
    bool showPopup = true,
  }) async {
    await ensurePricingLoaded();

    final pricing = getPricingFor(key);
    final balance = _walletController.walletBalance.value;

    // Missing/zero pricing => free
    if (pricing == null) return true;
    if (pricing.priceOffer <= 0) return true;

    if (balance >= pricing.priceOffer) return true;

    if (showPopup) {
      await showInsufficientBalancePopup(key);
    }
    return false;
  }

  /// Shows the global insufficient balance popup; user cannot proceed without recharging.
  Future<void> showInsufficientBalancePopup(String key) async {
    final pricing = getPricingFor(key);
    final balance = _walletController.walletBalance.value;

    // If pricing is missing, don't block the user.
    // Service is treated as free, so no insufficient-balance popup.
    if (pricing == null) {
      return;
    }

    // Free/zero-priced services should never show insufficient balance.
    if (pricing.priceOffer <= 0) {
      return;
    }

    final requiredBalance = pricing.priceOffer;

    await InsufficientBalanceHelper.show(
      currentBalance: balance,
      requiredBalance: requiredBalance,
      contextName: pricing.displayName,
    );
  }
}
