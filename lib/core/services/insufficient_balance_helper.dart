import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:get/get.dart';

/// Global helper for insufficient wallet balance.
/// Use this anywhere a paid action requires balance so the user cannot proceed without recharging.
class InsufficientBalanceHelper {
  /// Shows the global insufficient balance dialog (blocking).
  /// User can only "Go Back" or "Recharge Now"; they cannot proceed with the paid action.
  ///
  /// [currentBalance] - User's current wallet balance
  /// [requiredBalance] - Minimum balance required for the action
  /// [contextName] - Optional e.g. astrologer/persona/service name for the message
  /// [customMessage] - Optional full message; if set, [contextName] is ignored for message
  static Future<void> show({
    required double currentBalance,
    required double requiredBalance,
    String? contextName,
    String? customMessage,
  }) async {
    await Get.dialog(
      WalletRechargeDialog(
        currentBalance: currentBalance,
        requiredBalance: requiredBalance,
        contextName: contextName,
        customMessage: customMessage,
      ),
      barrierDismissible: false,
    );
  }
}
