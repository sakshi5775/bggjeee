import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';

class EcommerceRazorpayService {
  Razorpay? _razorpay;

  // Callbacks
  Function(Map<String, dynamic>)? onSuccess;
  Function(String)? onError;
  Function(PaymentFailureResponse)? onFailure;

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

    _razorpay?.clear();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required RazorpayData razorpayData,
    Map<String, dynamic>? notes,
  }) {
    if (_razorpay == null) {
      onError?.call('Razorpay not initialized');
      return;
    }

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

    try {
      _razorpay!.open(options);
    } catch (e) {
      onError?.call('Failed to open Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_paymentSuccessHandled) {
      return;
    }
    _paymentSuccessHandled = true;
    onSuccess?.call({
      'paymentId': response.paymentId,
      'orderId': response.orderId,
      'signature': response.signature,
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onFailure?.call(response);
    onError?.call('Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
