import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:get/get.dart';

class WalletService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  /// Initiate wallet recharge
  Future<WalletRechargeInitiateResponse?> initiateRecharge({
    required int amount,
    String paymentMethod = 'online',
    String paymentProvider = 'mock',
  }) async {
    final request = WalletRechargeInitiateRequest(
      amount: amount,
      paymentMethod: paymentMethod,
      paymentProvider: paymentProvider,
    );

    final response = await _apiRepository.postApi(
      EndPoints.walletRechargeInitiate,
      request.toJson(),
    );

    if (response.body['success'] == true) {
      return WalletRechargeInitiateResponse.fromJson(response.body);
    } else {
      String msg =
          response.body['message']?.toString() ??
          "Failed to initiate recharge. Please try again.";
      throw msg;
    }
  }

  /// Verify wallet recharge
  Future<WalletRechargeVerifyResponse?> verifyRecharge({
    required String rechargeId,
    required String transactionId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) async {
    final request = WalletRechargeVerifyRequest(
      rechargeId: rechargeId,
      transactionId: transactionId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );

    final response = await _apiRepository.postApi(
      EndPoints.walletRechargeVerify,
      request.toJson(),
    );

    if (response.body['success'] == true) {
      return WalletRechargeVerifyResponse.fromJson(response.body);
    } else {
      throw response.body['message']?.toString() ??
          "Failed to verify recharge. Please try again.";
    }
  }

  /// Get wallet recharge history
  Future<WalletRechargeHistoryResponse?> getRechargeHistory({
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _apiRepository.getApi(
      EndPoints.walletRechargeHistory,
      query: queryParams,
    );

    if (response.body['success'] == true) {
      return WalletRechargeHistoryResponse.fromJson(response.body);
    } else {
      throw "Failed to fetch recharge history. Please try again.";
    }
  }

  /// Get wallet recharge detail by ID
  Future<WalletRechargeDetailResponse?> getRechargeDetail(
    String rechargeId,
  ) async {
    final response = await _apiRepository.getApi(
      EndPoints.walletRechargeById(rechargeId),
    );

    if (response.body['success'] == true) {
      return WalletRechargeDetailResponse.fromJson(response.body);
    } else {
      throw "Failed to fetch recharge details. Please try again.";
    }
  }

  /// Cancel wallet recharge
  Future<WalletCancelResponse?> cancelRecharge(String rechargeId) async {
    final response = await _apiRepository.postApi(
      EndPoints.walletRechargeCancel(rechargeId),
      {},
    );

    return WalletCancelResponse.fromJson(response.body);
  }

  /// Get wallet balance
  Future<WalletBalanceResponse?> getWalletBalance(String userId) async {
    final response = await _apiRepository.getApi(
      EndPoints.walletBalance(userId),
    );

    return WalletBalanceResponse.fromJson(response.body);
  }
}

class WalletBalanceResponse {
  final bool success;
  final WalletBalanceData? data;

  WalletBalanceResponse({required this.success, this.data});

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? WalletBalanceData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class WalletBalanceData {
  final int balance;
  final String currency;

  WalletBalanceData({required this.balance, required this.currency});

  factory WalletBalanceData.fromJson(Map<String, dynamic> json) {
    return WalletBalanceData(
      balance: json['balance'] != null
          ? int.tryParse(json['balance'].toString()) ?? 0
          : 0,
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}
