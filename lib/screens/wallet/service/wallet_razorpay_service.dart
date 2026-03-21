import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/utils/plugin_safe.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';

class WalletRazorpayService {
  Razorpay? _razorpay;

  // Callbacks
  Function(Map<String, dynamic>)? onSuccess;
  Function(String)? onError;
  Function(PaymentFailureResponse)? onFailure;

  // Guard to prevent multiple success callbacks (Razorpay can fire multiple times)
  bool _paymentSuccessHandled = false;

  void initialize({
    Function(Map<String, dynamic>)? onSuccess,
    Function(String)? onError,
    Function(PaymentFailureResponse)? onFailure,
  }) {
    this.onSuccess = onSuccess;
    this.onError = onError;
    this.onFailure = onFailure;
    _paymentSuccessHandled = false;

    try {
      _razorpay?.clear();
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_WALLET_INIT',
      );
      onError?.call(
        UserFriendlyError.message(
          e,
          fallback: 'Payment is temporarily unavailable. Please try again.',
        ),
      );
    }
  }

  void openCheckout({
    required RazorpayData razorpayData,
    Map<String, dynamic>? notes,
  }) {
    debugPrint('Razorpay: openCheckout called');
    if (_razorpay == null) {
      debugPrint('Razorpay: _razorpay is null');
      onError?.call('Razorpay not initialized');
      return;
    }

    // CRITICAL: Reset success handler flag when opening new checkout
    _paymentSuccessHandled = false;

    final loginPhone = UserData().getLoginData.user?.phone;
    final sanitizedLoginPhone = loginPhone?.replaceAll(RegExp(r'[^\d]'), '');
    final contactToUse =
        (sanitizedLoginPhone != null && sanitizedLoginPhone.isNotEmpty)
        ? sanitizedLoginPhone
        : razorpayData.prefill?.contact;

    final options = {
      'key': razorpayData.key,
      'amount': razorpayData.amount, // Data is already in paise from backend
      'name': razorpayData.name,
      'description': razorpayData.description,
      'prefill': {
        if (contactToUse != null && contactToUse.isNotEmpty)
          'contact': contactToUse,
        if (razorpayData.prefill?.email != null)
          'email': razorpayData.prefill!.email,
        if (razorpayData.prefill?.name != null)
          'name': razorpayData.prefill!.name,
      },
      'external': {
        'wallets': ['paytm'],
      },
      'order_id': razorpayData.orderId,
      if (notes != null) 'notes': notes,
      'theme': {'color': '#eb662c'},
    };

    debugPrint('Razorpay options: $options');

    try {
      _razorpay!.open(options);
      debugPrint('Razorpay: open() called successfully');
    } catch (e, s) {
      debugPrint('Razorpay: open() failed: $e');
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_WALLET_OPEN',
      );
      onError?.call(
        UserFriendlyError.message(
          e,
          fallback: 'Unable to start payment. Please try again.',
        ),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    guardPluginCallback(
      'RAZORPAY_WALLET_SUCCESS',
      () {
        if (_paymentSuccessHandled) {
          debugPrint(
            '⚠️ Payment success already handled — ignoring duplicate Razorpay callback',
          );
          return;
        }
        _paymentSuccessHandled = true;
        debugPrint('Payment Success: ${response.paymentId}');
        onSuccess?.call({
          'paymentId': response.paymentId,
          'orderId': response.orderId,
          'signature': response.signature,
        });
      },
      type: CrashErrorType.payment,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    guardPluginCallback(
      'RAZORPAY_WALLET_ERROR',
      () {
        debugPrint('Payment Error: ${response.code} - ${response.message}');
        onFailure?.call(response);
        onError?.call(
          UserFriendlyError.message(
            response.message,
            fallback: 'Payment failed. Please try again.',
          ),
        );
      },
      type: CrashErrorType.payment,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    guardPluginCallback(
      'RAZORPAY_WALLET_EXT',
      () => debugPrint('External Wallet: ${response.walletName}'),
      type: CrashErrorType.payment,
    );
  }

  void dispose() {
    try {
      _razorpay?.clear();
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_WALLET_DISPOSE',
      );
    }
    _razorpay = null;
  }
}
