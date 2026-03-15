/// Thrown when API returns 402 (Payment Required) for Persona AI chat/call.
/// Contains wallet balance data for showing the recharge dialog.
class InsufficientWalletException implements Exception {
  final double requiredAmount;
  final double currentBalance;
  final double shortfall;
  final String? message;

  InsufficientWalletException({
    required this.requiredAmount,
    required this.currentBalance,
    required this.shortfall,
    this.message,
  });

  @override
  String toString() =>
      message ??
      'Insufficient wallet balance. Required: $requiredAmount, Current: $currentBalance, Shortfall: $shortfall';
}
