import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/service/my_bookings_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_booking_form/service/puja_payment_service.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyBookingDetailController extends BaseController {
  final MyBookingsService _bookingsService = MyBookingsService();
  final PujaPaymentService _paymentService = PujaPaymentService();

  // Razorpay instance (null if init failed)
  Razorpay? _razorpay;

  final Rx<MyBookingDetailModel?> booking = Rx<MyBookingDetailModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isProcessingPayment = false.obs;

  String? bookingId;

  bool get isPendingPayment =>
      booking.value?.status?.toLowerCase() == 'pending_payment';

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
    _parseArguments();
    loadBookingDetail();
  }

  void _initializeRazorpay() {
    try {
      final razorpay = Razorpay();
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _razorpay = razorpay;
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_MY_BOOKING_DETAIL_INIT',
      );
      _razorpay = null;
    }
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      bookingId = args['bookingId'] as String?;
    }
  }

  Future<void> loadBookingDetail() async {
    if (bookingId == null) {
      errorMessage.value = 'Booking ID not found';
      return;
    }

    setLoadingState(true);
    errorMessage.value = '';

    try {
      final result = await _bookingsService.getBookingDetail(bookingId!);
      if (result != null) {
        booking.value = result;
      } else {
        errorMessage.value = 'Failed to load booking details';
      }
    } catch (e) {
      errorMessage.value = 'Error loading booking: ${e.toString()}';
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> refreshBooking() async {
    await loadBookingDetail();
  }

  /// Initiate payment for the pending booking
  Future<void> onPayPendingBooking() async {
    if (bookingId == null) return;

    isProcessingPayment.value = true;

    try {
      final request = PujaPaymentInitiateRequest(
        bookingId: bookingId!,
        paymentProvider: 'razorpay',
      );

      final response = await _paymentService.initiatePayment(request);

      if (response != null &&
          response.success &&
          response.data != null &&
          response.data!.order != null) {
        _openRazorpayCheckout(response.data!);
      } else {
        Get.snackbar(
          'Payment Initiation Failed',
          response?.message ?? 'Unable to initiate payment. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
        isProcessingPayment.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Payment Error',
        'An error occurred while initiating payment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      isProcessingPayment.value = false;
    }
  }

  void _openRazorpayCheckout(PujaPaymentInitiateData paymentData) {
    var options = {
      'key': paymentData.razorpayKeyId,
      'amount': paymentData.order!.amount,
      'currency': paymentData.order!.currency,
      'order_id': paymentData.order!.id,
      'name': 'AstroBharatai',
      'description': 'Pooja Booking Payment',
      'theme': {
        'color': '#FF9933', // Saffron color
      },
    };

    final rp = _razorpay;
    if (rp == null) {
      Get.snackbar(
        'Payment Unavailable',
        'Payment could not be started. Please restart the app and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      isProcessingPayment.value = false;
      return;
    }
    try {
      rp.open(options);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to open payment gateway: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      isProcessingPayment.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final verifyRequest = PujaPaymentVerifyRequest(
        bookingId: bookingId ?? '',
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );

      final verifyResponse = await _paymentService.verifyPayment(verifyRequest);

      if (verifyResponse != null && verifyResponse.success) {
        Get.snackbar(
          'Payment Successful! 🎉',
          'Your payment has been completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        // Refresh booking to update status
        await refreshBooking();
      } else {
        Get.snackbar(
          'Payment Verification Failed',
          verifyResponse?.message ??
              'Unable to verify payment. Please contact support.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while verifying payment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isProcessingPayment.value = false;

    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment could not be completed. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      'External Wallet',
      'External wallet selected: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withValues(alpha: 0.9),
      colorText: Colors.white,
    );
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending_payment':
        return const Color(0xFFFF9800);
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF8BC34A);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color getPaymentStatusColor(String? status) {
    switch (status) {
      case 'completed':
      case 'success':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'failed':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  void onClose() {
    _razorpay?.clear();
    super.onClose();
  }
}
