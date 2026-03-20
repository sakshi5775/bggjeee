import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';

/// Service to handle Razorpay payment integration for course enrollment
class RazorpayPaymentService {
  Razorpay? _razorpay;
  
  // Callbacks
  Function(Map<String, dynamic>)? onSuccess;
  Function(String)? onError;
  Function(PaymentFailureResponse)? onFailure;
  
  // Guard to prevent multiple success callbacks (Razorpay can fire multiple times)
  bool _paymentSuccessHandled = false;
  
  /// Initialize Razorpay
  void initialize({
    required String keyId,
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
    required String orderId,
    required String gatewayOrderId,
    required int amount,
    required String name,
    required String description,
    required String prefillEmail,
    required String prefillContact,
    String? prefillName,
    String? razorpayKey,
    Map<String, dynamic>? notes,
  }) async {
    final loginPhone = UserData().getLoginData.user?.phone;
    final sanitizedLoginPhone = loginPhone?.replaceAll(RegExp(r'[^\d]'), '');
    final contactToUse =
        (sanitizedLoginPhone != null && sanitizedLoginPhone.isNotEmpty)
        ? sanitizedLoginPhone
        : prefillContact;

    if (_razorpay == null) {
      onError?.call('Razorpay not initialized');
      return;
    }
    
    // CRITICAL: Reset success handler flag when opening new checkout
    _paymentSuccessHandled = false;
    
    // Get the key from the stored initialization or use provided key
    final key = razorpayKey ?? 'YOUR_RAZORPAY_KEY_ID';
    
    final options = {
      'key': key,
      'amount': amount * 100, // Amount in paise
      'name': name,
      'description': description,
      'prefill': {
        if (contactToUse.isNotEmpty) 'contact': contactToUse,
        if (prefillEmail.isNotEmpty) 'email': prefillEmail,
        if (prefillName != null && prefillName.isNotEmpty) 'name': prefillName,
      },
      'external': {
        'wallets': ['paytm']
      },
      'order_id': gatewayOrderId, // Use Razorpay order ID from backend
      if (notes != null) 'notes': notes,
      // Theme customization
      'theme': {
        'color': '#eb662c', // Saffron theme color
      },
      // Note: Razorpay doesn't support SVG images directly
      // If you have a PNG/JPG version of the logo, use it here:
      // 'image': 'https://your-domain.com/logo.png',
    };
    
    try {
      _razorpay!.open(options);
    } catch (e) {
      onError?.call(
        UserFriendlyError.message(
          e,
          fallback: 'Unable to start payment. Please try again.',
        ),
      );
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
    onError?.call(
      UserFriendlyError.message(
        response.message,
        fallback: 'Payment failed. Please try again.',
      ),
    );
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

