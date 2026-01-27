import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PujaPaymentService {
  final ApiRepository _apiRepository = Get.find();

  /// Initiate payment for a puja booking
  Future<PujaPaymentInitiateResponse?> initiatePayment(
    PujaPaymentInitiateRequest request,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.pujaPaymentInitiate,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PujaPaymentInitiateResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error initiating payment: $e');
      }
      return null;
    }
  }

  /// Verify payment after Razorpay callback
  Future<PujaPaymentVerifyResponse?> verifyPayment(
    PujaPaymentVerifyRequest request,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.pujaPaymentVerify,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PujaPaymentVerifyResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying payment: $e');
      }
      return null;
    }
  }
}
