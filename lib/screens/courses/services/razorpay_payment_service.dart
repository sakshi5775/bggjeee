import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/utils/plugin_safe.dart';
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
        reason: 'RAZORPAY_COURSE_INIT',
      );
      onError?.call(
        UserFriendlyError.message(
          e,
          fallback: 'Payment is temporarily unavailable. Please try again.',
        ),
      );
    }
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
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_COURSE_OPEN',
      );
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
    guardPluginCallback(
      'RAZORPAY_COURSE_SUCCESS',
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

  /// Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    guardPluginCallback(
      'RAZORPAY_COURSE_ERROR',
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

  /// Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    guardPluginCallback(
      'RAZORPAY_COURSE_WALLET',
      () => debugPrint('External Wallet: ${response.walletName}'),
      type: CrashErrorType.payment,
    );
  }

  /// Dispose Razorpay instance
  void dispose() {
    try {
      _razorpay?.clear();
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_COURSE_DISPOSE',
      );
    }
    _razorpay = null;
  }
}

