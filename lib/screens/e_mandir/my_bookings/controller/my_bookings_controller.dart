import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/service/my_bookings_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_booking_form/service/puja_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyBookingsController extends BaseController {
  final MyBookingsService _bookingsService = MyBookingsService();
  final PujaPaymentService _paymentService = PujaPaymentService();

  // Razorpay instance
  late Razorpay _razorpay;

  final RxList<MyBookingItemModel> bookings = <MyBookingItemModel>[].obs;
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxInt currentPage = 1.obs;
  final int limit = 10;

  // Current booking ID for payment
  String? _currentPaymentBookingId;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
    loadBookings();
    _setupScrollListener();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreBookings();
      }
    });
  }

  Future<void> loadBookings() async {
    setLoadingState(true);
    errorMessage.value = '';
    currentPage.value = 1;

    try {
      final result = await _bookingsService.getMyBookings(
        page: currentPage.value,
        limit: limit,
      );
      if (result != null) {
        bookings.value = result.items ?? [];
        pagination.value = result.pagination;
      } else {
        errorMessage.value = 'Failed to load bookings';
      }
    } catch (e) {
      errorMessage.value = 'Error loading bookings: ${e.toString()}';
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> loadMoreBookings() async {
    if (isLoadingMore.value) return;
    if (pagination.value?.hasNextPage != true) return;

    isLoadingMore.value = true;

    try {
      currentPage.value++;
      final result = await _bookingsService.getMyBookings(
        page: currentPage.value,
        limit: limit,
      );
      if (result != null && result.items != null) {
        bookings.addAll(result.items!);
        pagination.value = result.pagination;
      }
    } catch (e) {
      currentPage.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshBookings() async {
    await loadBookings();
  }

  void onBookingTap(MyBookingItemModel booking) {
    if (booking.id == null) return;
    UserMainController.pushInCurrentTab(
      AppRoutes.myBookingDetail,
      arguments: {'bookingId': booking.id},
    );
  }

  /// Initiate payment for a pending booking
  Future<void> onPayPendingBooking(MyBookingItemModel booking) async {
    if (booking.id == null) return;

    isProcessingPayment.value = true;
    _currentPaymentBookingId = booking.id;

    try {
      final request = PujaPaymentInitiateRequest(
        bookingId: booking.id!,
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

    try {
      _razorpay.open(options);
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
        bookingId: _currentPaymentBookingId ?? '',
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
        // Refresh bookings to update status
        await refreshBookings();
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
      _currentPaymentBookingId = null;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isProcessingPayment.value = false;
    _currentPaymentBookingId = null;

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

  @override
  void onClose() {
    scrollController.dispose();
    _razorpay.clear();
    super.onClose();
  }
}
