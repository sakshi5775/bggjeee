import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/remedy_booking_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RemedyBookingDetailController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();
  Razorpay? _razorpay;

  final Rx<RemedyBookingItem?> booking = Rx<RemedyBookingItem?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isPaymentInProgress = false.obs;
  final RxBool isCancelling = false.obs;

  String? _bookingId;

  @override
  void onInit() {
    super.onInit();
    _parseArgs();
    _initRazorpay();
    _loadBooking();
  }

  void _parseArgs() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _bookingId = args['bookingId'] as String?;
      final item = args['bookingItem'];
      if (item is RemedyBookingItem) booking.value = item;
    }
  }

  void _initRazorpay() {
    try {
      final razorpay = Razorpay();
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
      _razorpay = razorpay;
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_REMEDY_DETAIL_INIT',
      );
      _razorpay = null;
    }
  }

  Future<void> _loadBooking() async {
    final id = _bookingId ?? booking.value?.id;
    if (id == null) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;
      final b = await _remediesService.getRemedyBookingById(id);
      if (b != null) booking.value = b;
    } catch (e) {
      print('Error loading booking: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool get canPay {
    final s = booking.value?.payment?.status ?? '';
    final status = booking.value?.status ?? '';
    return (s == 'pending' || status == 'pending' || status == 'payment_pending') &&
        booking.value?.cancellation == null;
  }

  bool get canCancel {
    final status = booking.value?.status ?? '';
    return status != 'cancelled' &&
        status != 'completed' &&
        booking.value?.cancellation == null;
  }

  Future<void> initiatePayment() async {
    final id = booking.value?.id;
    if (id == null) return;
    isPaymentInProgress.value = true;
    try {
      final response = await _remediesService.initiateRemedyPayment(
        id,
        paymentProvider: 'razorpay',
      );
      if (response != null &&
          response.success &&
          response.data != null &&
          response.data!.razorpayKeyId.isNotEmpty) {
        final d = response.data!;
        final orderId = d.razorpayOrder?.id ?? d.gatewayOrderId;
        final amount = d.razorpayOrder?.amount ?? (d.amount * 100).toInt();
        if (orderId.isEmpty) {
          Get.snackbar('Payment Error', 'Invalid order id');
          return;
        }
        final rp = _razorpay;
        if (rp == null) {
          Get.snackbar(
            'Payment Unavailable',
            'Payment could not be started. Please restart the app and try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        rp.open({
          'key': d.razorpayKeyId,
          'amount': amount,
          'currency': d.currency,
          'order_id': orderId,
          'name': 'AstroBharatai',
          'description': 'Remedy Booking',
          'theme': {'color': '#FF9933'},
        });
      } else {
        Get.snackbar(
          'Payment Failed',
          response?.message ?? 'Could not start payment',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isPaymentInProgress.value = false;
    }
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) async {
    isPaymentInProgress.value = true;
    try {
      final id = booking.value?.id;
      if (id == null) return;
      final verifyRequest = RemedyPaymentVerifyRequest(
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );
      await _remediesService.verifyRemedyPayment(id, verifyRequest);
      await _loadBooking();
      Get.snackbar(
        'Payment Successful',
        'Your remedy booking is confirmed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Verification Error', e.toString());
    } finally {
      isPaymentInProgress.value = false;
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment could not be completed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('External Wallet', 'Selected: ${response.walletName}');
  }

  Future<void> cancelBooking(String reason) async {
    final id = booking.value?.id;
    if (id == null) return;
    if (reason.trim().length < 10) {
      Get.snackbar('Validation', 'Reason must be at least 10 characters');
      return;
    }
    isCancelling.value = true;
    try {
      final updated = await _remediesService.cancelRemedyBooking(id, reason);
      if (updated != null) {
        booking.value = updated;
        Get.snackbar(
          'Cancelled',
          'Booking cancelled successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Could not cancel booking');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCancelling.value = false;
    }
  }

  void showCancelDialog() {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Reason for cancellation (min 10 characters)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              cancelBooking(reasonController.text.trim());
            },
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _razorpay?.clear();
    super.onClose();
  }
}
