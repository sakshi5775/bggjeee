import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/puja_booking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PujaBookingService {
  final ApiRepository _apiRepository = Get.find();

  /// Create a new puja booking
  Future<String?> createBooking(PujaBookingRequest request) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.pujaBookings,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          return response.body['data']['booking']['_id'];
        } else if (response.body['data'] != null) {
          return response.body['data']['booking']['_id'];
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating booking: $e');
      }
      return null;
    }
  }

  /// Fetch latest payment status for a booking.
  Future<String?> getBookingPaymentStatus(String bookingId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.bookingDetail(bookingId),
      );
      final data = response.body['data'];
      if (data is Map<String, dynamic>) {
        final payment = data['payment'];
        if (payment is Map<String, dynamic>) {
          return payment['status']?.toString();
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching booking payment status: $e');
      }
      return null;
    }
  }
}
