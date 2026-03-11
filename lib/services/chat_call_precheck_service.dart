import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:get/get.dart';

/// Service to handle pre-checks before initiating chat/call
class ChatCallPrecheckService {
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();

  /// Check profile and wallet before proceeding with chat/call
  /// Returns true if all checks pass, false otherwise
  /// Shows appropriate dialogs if checks fail
  Future<bool> checkBeforeProceeding({
    AstrologerModel? astrologer,
    PersonaModel? persona,
    double? pricePerMinute,
    String? personaName,
    int estimatedMinutes = 15,
  }) async {
    // Determine price per minute
    double finalPricePerMinute = pricePerMinute ?? 299.0;
    String? name;

    if (astrologer != null) {
      finalPricePerMinute =
          pricePerMinute ??
          astrologer.voicePricePerMin ??
          astrologer.videoPricePerMin ??
          astrologer.chatPrice ??
          299.0;
      name = astrologer.displayName;
    } else if (persona != null) {
      finalPricePerMinute = pricePerMinute ??
          persona.chatPricePerMinute ??
          persona.pricePerMin ??
          299.0;
      name = persona.displayName;
    } else {
      finalPricePerMinute = pricePerMinute ?? 299.0;
      name = personaName ?? 'Astrologer';
    }
    // Free service (0/min): allow without wallet check
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
    return await _checkWalletAndProceed(
      pricePerMinute: finalPricePerMinute,
      name: name,
      estimatedMinutes: estimatedMinutes,
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
