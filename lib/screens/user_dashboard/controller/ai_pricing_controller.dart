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
    // Delay slightly to ensure ApiRepository is ready
    Future.delayed(const Duration(seconds: 2), () => fetchPricing());
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
    try {
      return pricingData.firstWhere((element) => element.key == key);
    } catch (e) {
      return null;
    }
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

  bool hasSufficientBalance(String key) {
    final pricing = getPricingFor(key);
    // If free, always sufficient
    if (pricing == null || pricing.priceOffer <= 0) return true;

    final double balance = _walletController.walletBalance.value;
    return balance >= pricing.priceOffer;
  }

  /// Shows the global insufficient balance popup; user cannot proceed without recharging.
  Future<void> showInsufficientBalancePopup(String key) async {
    final pricing = getPricingFor(key);
    final requiredBalance = pricing?.priceOffer ?? 0.0;
    final balance = _walletController.walletBalance.value;
    await InsufficientBalanceHelper.show(
      currentBalance: balance,
      requiredBalance: requiredBalance,
      contextName: pricing?.displayName,
    );
  }
}
