import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';

/// Service to handle Razorpay payment integration for ecommerce orders
class EcommerceRazorpayService {
  Razorpay? _razorpay;
  
  // Callbacks
  Function(Map<String, dynamic>)? onSuccess;
  Function(String)? onError;
  Function(PaymentFailureResponse)? onFailure;
  
  // Guard to prevent multiple success callbacks (Razorpay can fire multiple times)
  bool _paymentSuccessHandled = false;
  
  /// Initialize Razorpay
  void initialize({
    Function(Map<String, dynamic>)? onSuccess,
    Function(String)? onError,
    Function(PaymentFailureResponse)? onFailure,
  }) {
    this.onSuccess = onSuccess;
    this.onError = onError;
    this.onFailure = onFailure;
    
    // Reset guard when initializing new payment
    _paymentSuccessHandled = false;
    
    // Dispose existing instance if any
    _razorpay?.clear();
    
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  
  /// Open Razorpay checkout
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

    final options = {
      'key': razorpayData.key,
      'amount': razorpayData.amount, // Data is already in paise from backend
      'name': razorpayData.name,
      'description': razorpayData.description,
      'prefill': {
        if (razorpayData.prefill?.contact != null)
          'contact': razorpayData.prefill!.contact,
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
    } catch (e) {
      debugPrint('Razorpay: open() failed: $e');
      onError?.call('Failed to open Razorpay: $e');
    }
  }
  
  /// Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // CRITICAL: Prevent multiple callbacks (Razorpay can fire EVENT_PAYMENT_SUCCESS multiple times)
    if (_paymentSuccessHandled) {
      debugPrint('⚠️ Payment success already handled — ignoring duplicate Razorpay callback');
      return;
    }
    
    _paymentSuccessHandled = true;
    debugPrint('Payment Success: ${response.paymentId}');
    onSuccess?.call({
      'paymentId': response.paymentId,
      'orderId': response.orderId,
      'signature': response.signature,
    });
  }
  
  /// Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    onFailure?.call(response);
    onError?.call('Payment failed: ${response.message}');
  }
  
  /// Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    // Handle external wallet if needed
  }
  
  /// Dispose Razorpay instance
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}


