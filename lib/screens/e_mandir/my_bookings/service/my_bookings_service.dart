import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MyBookingsService {
  final ApiRepository _apiRepository = Get.find();

  /// Get list of my bookings with pagination
  Future<MyBookingsResponse?> getMyBookings({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.myBookings(page, limit),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          return MyBookingsResponse.fromJson(response.body['data']);
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching my bookings: $e');
      }
      return null;
    }
  }

  /// Get booking detail by ID
  Future<MyBookingDetailModel?> getBookingDetail(String bookingId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.bookingDetail(bookingId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          return MyBookingDetailModel.fromJson(response.body['data']);
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching booking detail: $e');
      }
      return null;
    }
  }
}
