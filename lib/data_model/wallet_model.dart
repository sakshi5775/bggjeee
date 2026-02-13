/// Wallet Recharge Models
class WalletRechargeInitiateRequest {
  final int amount;
  final String paymentMethod;
  final String paymentProvider;

  WalletRechargeInitiateRequest({
    required this.amount,
    required this.paymentMethod,
    required this.paymentProvider,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentProvider': paymentProvider,
    };
  }
}

class WalletRechargeInitiateResponse {
  final bool success;
  final String message;
  final WalletRechargeData? data;

  WalletRechargeInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WalletRechargeInitiateResponse.fromJson(Map<String, dynamic> json) {
    return WalletRechargeInitiateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? WalletRechargeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class WalletRechargeData {
  final String rechargeId;
  final int amount;
  final String gatewayOrderId;
  final String paymentMethod;
  final String paymentProvider;
  final String status;
  final String? instructions;
  final RazorpayData? razorpay;

  WalletRechargeData({
    required this.rechargeId,
    required this.amount,
    required this.gatewayOrderId,
    required this.paymentMethod,
    required this.paymentProvider,
    required this.status,
    this.instructions,
    this.razorpay,
  });

  factory WalletRechargeData.fromJson(Map<String, dynamic> json) {
    return WalletRechargeData(
      rechargeId: json['rechargeId']?.toString() ?? '',
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString()) ?? 0
          : 0,
      gatewayOrderId: json['gatewayOrderId']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentProvider: json['paymentProvider']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      instructions: json['instructions']?.toString(),
      razorpay: json['razorpay'] != null
          ? RazorpayData.fromJson(json['razorpay'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RazorpayData {
  final String key;
  final String orderId;
  final int amount;
  final String currency;
  final String name;
  final String description;
  final RazorpayPrefill? prefill;

  RazorpayData({
    required this.key,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.name,
    required this.description,
    this.prefill,
  });

  factory RazorpayData.fromJson(Map<String, dynamic> json) {
    return RazorpayData(
      key: json['key']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString()) ?? 0
          : 0,
      currency: json['currency']?.toString() ?? 'INR',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      prefill: json['prefill'] != null
          ? RazorpayPrefill.fromJson(json['prefill'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RazorpayPrefill {
  final String name;
  final String email;
  final String contact;

  RazorpayPrefill({
    required this.name,
    required this.email,
    required this.contact,
  });

  factory RazorpayPrefill.fromJson(Map<String, dynamic> json) {
    return RazorpayPrefill(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
    );
  }
}

class WalletRechargeVerifyRequest {
  final String rechargeId;
  final String transactionId;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;

  WalletRechargeVerifyRequest({
    required this.rechargeId,
    required this.transactionId,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'rechargeId': rechargeId,
      'transactionId': transactionId,
    };
    if (razorpayOrderId != null) data['razorpay_order_id'] = razorpayOrderId;
    if (razorpayPaymentId != null)
      data['razorpay_payment_id'] = razorpayPaymentId;
    if (razorpaySignature != null)
      data['razorpay_signature'] = razorpaySignature;
    return data;
  }
}

class WalletRechargeVerifyResponse {
  final bool success;
  final String message;
  final WalletRechargeVerifyData? data;

  WalletRechargeVerifyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WalletRechargeVerifyResponse.fromJson(Map<String, dynamic> json) {
    return WalletRechargeVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? WalletRechargeVerifyData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class WalletRechargeVerifyData {
  final String rechargeId;
  final int amount;
  final int previousBalance;
  final int newBalance;
  final String currency;
  final WalletTransaction? transaction;

  WalletRechargeVerifyData({
    required this.rechargeId,
    required this.amount,
    required this.previousBalance,
    required this.newBalance,
    required this.currency,
    this.transaction,
  });

  factory WalletRechargeVerifyData.fromJson(Map<String, dynamic> json) {
    return WalletRechargeVerifyData(
      rechargeId: json['rechargeId']?.toString() ?? '',
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString()) ?? 0
          : 0,
      previousBalance: json['previousBalance'] != null
          ? int.tryParse(json['previousBalance'].toString()) ?? 0
          : 0,
      newBalance: json['newBalance'] != null
          ? int.tryParse(json['newBalance'].toString()) ?? 0
          : 0,
      currency: json['currency']?.toString() ?? 'INR',
      transaction: json['transaction'] != null
          ? WalletTransaction.fromJson(
              json['transaction'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class WalletTransaction {
  final String? id;
  final String transactionId;
  final String type;
  final int amount;
  final int balanceAfter;
  final String status;
  final String? description;
  final String? paymentMethod;
  final String? referenceId;
  final String? createdAt;

  WalletTransaction({
    this.id,
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.status,
    this.description,
    this.paymentMethod,
    this.referenceId,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['_id']?.toString(),
      transactionId: json['transactionId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString()) ?? 0
          : 0,
      balanceAfter: json['balanceAfter'] != null
          ? int.tryParse(json['balanceAfter'].toString()) ?? 0
          : 0,
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString(),
      paymentMethod: json['paymentMethod']?.toString(),
      referenceId: json['referenceId']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  DateTime? get createdAtDate {
    if (createdAt == null) return null;
    try {
      return DateTime.parse(createdAt!);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'transactionId': transactionId,
      'type': type,
      'amount': amount,
      'balanceAfter': balanceAfter,
      'status': status,
      'description': description,
      'paymentMethod': paymentMethod,
      'referenceId': referenceId,
      'createdAt': createdAt,
    };
  }
}

class WalletRechargeHistoryResponse {
  final bool success;
  final WalletRechargeHistoryData? data;

  WalletRechargeHistoryResponse({required this.success, this.data});

  factory WalletRechargeHistoryResponse.fromJson(Map<String, dynamic> json) {
    return WalletRechargeHistoryResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? WalletRechargeHistoryData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class WalletRechargeHistoryData {
  final List<WalletRechargeHistoryItem> recharges;
  final WalletPagination pagination;

  WalletRechargeHistoryData({
    required this.recharges,
    required this.pagination,
  });

  factory WalletRechargeHistoryData.fromJson(Map<String, dynamic> json) {
    return WalletRechargeHistoryData(
      recharges:
          (json['recharges'] as List<dynamic>?)
              ?.map(
                (item) => WalletRechargeHistoryItem.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? WalletPagination.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : WalletPagination(total: 0, limit: 20, offset: 0, hasMore: false),
    );
  }
}

class WalletRechargeHistoryItem {
  final String? id;
  final String rechargeId;
  final String userId;
  final int amount;
  final String status;
  final String paymentMethod;
  final String paymentProvider;
  final String gatewayOrderId;
  final String? initiatedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? completedAt;
  final String? transactionId;

  WalletRechargeHistoryItem({
    this.id,
    required this.rechargeId,
    required this.userId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentProvider,
    required this.gatewayOrderId,
    this.initiatedAt,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.transactionId,
  });

  factory WalletRechargeHistoryItem.fromJson(Map<String, dynamic> json) {
    return WalletRechargeHistoryItem(
      id: json['_id']?.toString(),
      rechargeId: json['rechargeId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString()) ?? 0
          : 0,
      status: json['status']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentProvider: json['paymentProvider']?.toString() ?? '',
      gatewayOrderId: json['gatewayOrderId']?.toString() ?? '',
      initiatedAt: json['initiatedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
      transactionId: json['transactionId']?.toString(),
    );
  }

  DateTime? get initiatedAtDate {
    if (initiatedAt == null) return null;
    try {
      return DateTime.parse(initiatedAt!);
    } catch (e) {
      return null;
    }
  }

  DateTime? get createdAtDate {
    if (createdAt == null) return null;
    try {
      return DateTime.parse(createdAt!);
    } catch (e) {
      return null;
    }
  }

  bool get canCancel {
    return status == 'INITIATED' || status == 'PENDING';
  }
}

class WalletPagination {
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;

  WalletPagination({
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  factory WalletPagination.fromJson(Map<String, dynamic> json) {
    return WalletPagination(
      total: json['total'] != null
          ? int.tryParse(json['total'].toString()) ?? 0
          : 0,
      limit: json['limit'] != null
          ? int.tryParse(json['limit'].toString()) ?? 20
          : 20,
      offset: json['offset'] != null
          ? int.tryParse(json['offset'].toString()) ?? 0
          : 0,
      hasMore: json['hasMore'] ?? false,
    );
  }
}

class WalletRechargeDetailResponse {
  final bool success;
  final WalletRechargeHistoryItem? data;

  WalletRechargeDetailResponse({required this.success, this.data});

  factory WalletRechargeDetailResponse.fromJson(Map<String, dynamic> json) {
    return WalletRechargeDetailResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? WalletRechargeHistoryItem.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class WalletCancelResponse {
  final bool success;
  final String message;

  WalletCancelResponse({required this.success, required this.message});

  factory WalletCancelResponse.fromJson(Map<String, dynamic> json) {
    return WalletCancelResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
