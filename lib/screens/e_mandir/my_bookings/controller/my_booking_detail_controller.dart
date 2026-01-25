import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/service/my_bookings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBookingDetailController extends BaseController {
  final MyBookingsService _bookingsService = MyBookingsService();

  final Rx<MyBookingDetailModel?> booking = Rx<MyBookingDetailModel?>(null);
  final RxString errorMessage = ''.obs;

  String? bookingId;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    loadBookingDetail();
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
}
