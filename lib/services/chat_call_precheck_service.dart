import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service to handle pre-checks before initiating chat/call
class ChatCallPrecheckService {
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();

  /// Check profile and wallet before proceeding with chat/call.
  /// Returns true if all checks pass, false otherwise.
  /// Shows appropriate dialogs if checks fail.
  ///
  /// For Persona AI (per doc): wallet check uses min 1 minute (1 message / 1 min call).
  /// For astrologers: uses [estimatedMinutes] (default 15).
  Future<bool> checkBeforeProceeding({
    AstrologerModel? astrologer,
    PersonaModel? persona,
    double? pricePerMinute,
    String? personaName,
    int estimatedMinutes = 15,
  }) async {
    // Determine price per minute.
    // IMPORTANT: do not use any hardcoded fallback like 299.0 (it shows "random price").
    // If caller didn't pass a price, we only infer from model; otherwise treat as not configured.
    double finalPricePerMinute = pricePerMinute ?? 0.0;
    String name = personaName ?? 'Astrologer';

    if (astrologer != null) {
      // Prefer explicit pricePerMinute passed by caller (per service).
      // If missing, infer from model without any hardcoded default.
      finalPricePerMinute = pricePerMinute ??
          astrologer.chatPricePerMin ??
          astrologer.chatPrice ??
          astrologer.voicePricePerMin ??
          astrologer.videoPricePerMin ??
          0.0;
      name = astrologer.displayName;
    } else if (persona != null) {
      finalPricePerMinute = pricePerMinute ??
          persona.chatPricePerMinute ??
          persona.pricePerMin ??
          0.0;
      name = persona.displayName;
    } else {
      finalPricePerMinute = pricePerMinute ?? 0.0;
      name = personaName ?? 'Astrologer';
    }

    // If astrologer service price is not configured (0/min), treat as NOT AVAILABLE
    // so we don't show recharge popup for a service that can't be used.
    if (astrologer != null && finalPricePerMinute <= 0) {
      Get.snackbar(
        'Service Not Available',
        '$name is not available for this service right now.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }

    // Free service (0/min): allow without wallet check (persona/free flows)
    if (finalPricePerMinute <= 0) return true;
    /* 
    // Check profile completeness (DISABLED AS PER USER REQUEST)
    final isProfileComplete = await _profileHelper.isProfileComplete();
    if (!isProfileComplete) {
      // Show profile completion dialog
      await Get.dialog(
        ProfileCompletionDialog(
          onProfileComplete: () async {
            // After profile is complete, check wallet
            await _checkWalletAndProceed(
              pricePerMinute: finalPricePerMinute,
              name: name,
              estimatedMinutes: estimatedMinutes,
            );
          },
          onCancel: () {
            // User cancelled profile completion
          },
        ),
        barrierDismissible: false,
      );
      return false;
    }
    */

    // Profile is complete, check wallet
    // Persona AI: require min 1 min (1 message or 1 min call) per doc
    final mins = persona != null ? 1 : estimatedMinutes;
    return await _checkWalletAndProceed(
      pricePerMinute: finalPricePerMinute,
      name: name,
      estimatedMinutes: mins,
    );
  }

  /// Check wallet balance and show recharge dialog if needed
  Future<bool> _checkWalletAndProceed({
    required double pricePerMinute,
    required String? name,
    int estimatedMinutes = 15,
  }) async {
    if (pricePerMinute <= 0) return true;
    final requiredBalance = _profileHelper.getMinimumRequiredBalance(
      pricePerMinute,
      estimatedMinutes: estimatedMinutes,
    );

    final currentBalance = await _profileHelper.getWalletBalance();
    final isSufficient = currentBalance >= requiredBalance;

    if (!isSufficient) {
      // Show wallet recharge dialog
      await Get.dialog(
        WalletRechargeDialog(
          currentBalance: currentBalance,
          requiredBalance: requiredBalance,
          astrologerName: name ?? 'Astrologer',
        ),
        barrierDismissible: false,
      );
      return false;
    }

    // All checks passed
    return true;
  }

  /// Check if profile is complete (without showing dialog)
  /// Useful for conditional UI rendering
  Future<bool> isProfileComplete() async {
    return await _profileHelper.isProfileComplete();
  }

  /// Check if wallet balance is sufficient (without showing dialog)
  /// Useful for conditional UI rendering
  Future<bool> isWalletBalanceSufficient(double requiredAmount) async {
    return await _profileHelper.isWalletBalanceSufficient(requiredAmount);
  }
}
