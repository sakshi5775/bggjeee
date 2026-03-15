import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_service.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:flutter/foundation.dart';

/// Monitors wallet balance during Persona AI chat.
/// - Polls balance from API
/// - Shows warning ~3 minutes before balance runs out
/// - Ends chat when balance depleted (if user doesn't recharge)
class ChatBalanceMonitor {
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();
  final WalletService _walletService = WalletService();
  Timer? _pollTimer;
  double _pricePerMinute = 0;
  VoidCallback? _onLowBalanceWarning;
  VoidCallback? _onBalanceDepleted;
  bool _warningShown = false;

  static const Duration pollInterval = Duration(seconds: 30);
  static const int warningMinutesBefore = 3;

  void start({
    required double chatPricePerMinute,
    required VoidCallback onLowBalanceWarning,
    required VoidCallback onBalanceDepleted,
  }) {
    stop();
    _pricePerMinute = chatPricePerMinute;
    _onLowBalanceWarning = onLowBalanceWarning;
    _onBalanceDepleted = onBalanceDepleted;
    if (_pricePerMinute <= 0) return;
    _pollTimer = Timer.periodic(pollInterval, (_) => _checkBalance());
    _checkBalance();
  }

  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _onLowBalanceWarning = null;
    _onBalanceDepleted = null;
    _warningShown = false;
  }

  Future<void> _checkBalance() async {
    try {
      double balance = 0;
      final userId = UserData().getLoginData.user?.userId;
      if (userId != null) {
        final resp = await _walletService.getWalletBalance(userId);
        balance = (resp?.data?.balance ?? 0).toDouble();
      }
      if (balance <= 0 && userId == null) {
        balance = await _profileHelper.getWalletBalance();
      }

      if (_pricePerMinute <= 0) return;

      final minutesLeft = balance / _pricePerMinute;
      if (balance <= 0) {
        _onBalanceDepleted?.call();
        stop();
        return;
      }
      if (minutesLeft <= warningMinutesBefore && minutesLeft > 0 && !_warningShown) {
        _warningShown = true;
        _onLowBalanceWarning?.call();
      }
    } catch (e) {
      if (kDebugMode) print('ChatBalanceMonitor error: $e');
    }
  }
}
