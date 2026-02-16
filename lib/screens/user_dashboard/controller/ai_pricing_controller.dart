import 'package:astrobharataiuser/data_model/ai_pricing_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/ai_pricing_service.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/screens/wallet/view/wallet_view.dart';
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

  void showInsufficientBalancePopup(String key) {
    final pricing = getPricingFor(key);
    final needed = pricing?.priceOffer ?? 0;
    final balance = _walletController.walletBalance.value;
    final diff = needed - balance;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "Insufficient Balance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "You need ₹${diff.toStringAsFixed(0)} more to access this service.\nCurrent Wallet Balance: ₹${balance.toStringAsFixed(0)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.to(() => const WalletView());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F221E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Recharge"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
