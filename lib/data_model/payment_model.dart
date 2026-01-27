import 'package:astrobharataiuser/data_model/order_model.dart';

class PaymentsResponse {
  PaymentsResponse({this.items = const [], this.pagination});

  PaymentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] is List) {
      items = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map(PaymentModel.fromJson)
          .toList();
    }
    if (json['pagination'] is Map<String, dynamic>) {
      pagination = PaymentPagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      );
    }
  }

  List<PaymentModel> items = const [];
  PaymentPagination? pagination;
}

class PaymentPagination {
  PaymentPagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
  });

  PaymentPagination.fromJson(Map<String, dynamic> json) {
    totalItems = _toInt(json['totalItems']);
    currentPage = _toInt(json['currentPage']);
    totalPages = _toInt(json['totalPages']);
    hasNextPage = json['hasNextPage'] as bool?;
    hasPrevPage = json['hasPrevPage'] as bool?;
    limit = _toInt(json['limit']);
  }

  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? limit;
}

class PaymentModel {
  PaymentModel({
    this.id,
    this.order,
    this.userId,
    double amountValue = 0,
    this.currency,
    this.paymentMethod,
    this.paymentProvider,
    this.status,
    this.gatewayOrderId,
    this.gatewayPaymentId,
    this.gatewaySignature,
    this.transactionId,
    this.initiatedAt,
    this.completedAt,
    this.failedAt,
    this.failureReason,
    this.failureCode,
    this.metadata,
    this.paymentDetails,
    this.refund,
    this.createdAt,
    this.updatedAt,
  }) : amount = amountValue;

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? json['_id']?.toString();
    if (json['order'] is Map<String, dynamic>) {
      order = OrderModel.fromJson(json['order'] as Map<String, dynamic>);
    }
    userId = json['user']?.toString();
    amount = _toDouble(json['amount']) ?? 0;
    currency = json['currency']?.toString();
    paymentMethod = json['paymentMethod']?.toString();
    paymentProvider = json['paymentProvider']?.toString();
    status = json['status']?.toString();
    gatewayOrderId = json['gatewayOrderId']?.toString();
    gatewayPaymentId = json['gatewayPaymentId']?.toString();
    gatewaySignature = json['gatewaySignature']?.toString();
    transactionId = json['transactionId']?.toString();
    initiatedAt = json['initiatedAt']?.toString();
    completedAt = json['completedAt']?.toString();
    failedAt = json['failedAt']?.toString();
    failureReason = json['failureReason']?.toString();
    failureCode = json['failureCode']?.toString();
    metadata = json['metadata'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['metadata'] as Map)
        : null;
    if (json['paymentDetails'] is Map<String, dynamic>) {
      paymentDetails = PaymentDetails.fromJson(
        json['paymentDetails'] as Map<String, dynamic>,
      );
    }
    if (json['refund'] is Map<String, dynamic>) {
      refund = PaymentRefund.fromJson(json['refund'] as Map<String, dynamic>);
    }
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  String? id;
  OrderModel? order;
  String? userId;
  double amount = 0;
  String? currency;
  String? paymentMethod;
  String? paymentProvider;
  String? status;
  String? gatewayOrderId;
  String? gatewayPaymentId;
  String? gatewaySignature;
  String? transactionId;
  String? initiatedAt;
  String? completedAt;
  String? failedAt;
  String? failureReason;
  String? failureCode;
  Map<String, dynamic>? metadata;
  PaymentDetails? paymentDetails;
  PaymentRefund? refund;
  String? createdAt;
  String? updatedAt;
}

class PaymentDetails {
  PaymentDetails({
    this.cardLast4,
    this.cardNetwork,
    this.bankName,
    this.upiId,
    this.walletName,
    this.emiTenure,
  });

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    cardLast4 = json['cardLast4']?.toString();
    cardNetwork = json['cardNetwork']?.toString();
    bankName = json['bankName']?.toString();
    upiId = json['upiId']?.toString();
    walletName = json['walletName']?.toString();
    emiTenure = json['emiTenure']?.toString();
  }

  String? cardLast4;
  String? cardNetwork;
  String? bankName;
  String? upiId;
  String? walletName;
  String? emiTenure;
}

class PaymentRefund {
  PaymentRefund({
    this.status,
    double amountValue = 0,
    this.refundId,
    this.initiatedAt,
    this.completedAt,
    this.reason,
  }) : amount = amountValue;

  PaymentRefund.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    amount = _toDouble(json['amount']) ?? 0;
    refundId = json['refundId']?.toString();
    initiatedAt = json['initiatedAt']?.toString();
    completedAt = json['completedAt']?.toString();
    reason = json['reason']?.toString();
  }

  String? status;
  double amount = 0;
  String? refundId;
  String? initiatedAt;
  String? completedAt;
  String? reason;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

// Payment Initiation Models
class EcommercePaymentInitiateRequest {
  final String orderId;
  final String paymentMethod;
  final String paymentProvider;

  EcommercePaymentInitiateRequest({
    required this.orderId,
    required this.paymentMethod,
    required this.paymentProvider,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'paymentMethod': paymentMethod,
      'paymentProvider': paymentProvider,
    };
  }
}

class EcommercePaymentInitiateResponse {
  final bool success;
  final String message;
  final EcommercePaymentInitiateData? data;

  EcommercePaymentInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory EcommercePaymentInitiateResponse.fromJson(Map<String, dynamic> json) {
    return EcommercePaymentInitiateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? EcommercePaymentInitiateData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class EcommercePaymentInitiateData {
  final String paymentId;
  final String gatewayOrderId;
  final double amount;
  final String currency;
  final RazorpayData? razorpay;

  EcommercePaymentInitiateData({
    required this.paymentId,
    required this.gatewayOrderId,
    required this.amount,
    required this.currency,
    this.razorpay,
  });

  factory EcommercePaymentInitiateData.fromJson(Map<String, dynamic> json) {
    return EcommercePaymentInitiateData(
      paymentId: json['paymentId']?.toString() ?? '',
      gatewayOrderId: json['gatewayOrderId']?.toString() ?? '',
      amount: _toDouble(json['amount']) ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      razorpay: json['razorpay'] != null
          ? RazorpayData.fromJson(json['razorpay'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Reusing RazorpayData structure but defining here to avoid circular dependencies if wallet_model not imported
// Ideally this should be in a shared model file
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

// Payment Verification Models
class EcommercePaymentVerifyRequest {
  final String paymentId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  EcommercePaymentVerifyRequest({
    required this.paymentId,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };
  }
}

class EcommercePaymentVerifyResponse {
  final bool success;
  final String message;
  final EcommercePaymentVerifyData? data;

  EcommercePaymentVerifyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory EcommercePaymentVerifyResponse.fromJson(Map<String, dynamic> json) {
    return EcommercePaymentVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? EcommercePaymentVerifyData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class EcommercePaymentVerifyData {
  final PaymentModel? payment;
  final OrderModel? order;

  EcommercePaymentVerifyData({this.payment, this.order});

  factory EcommercePaymentVerifyData.fromJson(Map<String, dynamic> json) {
    return EcommercePaymentVerifyData(
      payment: json['payment'] != null
          ? PaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      order: json['order'] != null
          ? OrderModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ============================================================================
// Puja Booking Payment Models
// ============================================================================

/// Puja payment initiate request model
class PujaPaymentInitiateRequest {
  final String bookingId;
  final String paymentProvider;

  PujaPaymentInitiateRequest({
    required this.bookingId,
    this.paymentProvider = 'razorpay',
  });

  Map<String, dynamic> toJson() {
    return {'bookingId': bookingId, 'paymentProvider': paymentProvider};
  }
}

/// Puja payment initiate response model
class PujaPaymentInitiateResponse {
  final bool success;
  final String message;
  final PujaPaymentInitiateData? data;

  PujaPaymentInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PujaPaymentInitiateResponse.fromJson(Map<String, dynamic> json) {
    return PujaPaymentInitiateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PujaPaymentInitiateData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Puja payment initiate data model
class PujaPaymentInitiateData {
  final String paymentId;
  final String razorpayKeyId;
  final PujaPaymentOrder? order;
  final double amount;
  final String currency;
  final String bookingId;

  PujaPaymentInitiateData({
    required this.paymentId,
    required this.razorpayKeyId,
    this.order,
    required this.amount,
    required this.currency,
    required this.bookingId,
  });

  factory PujaPaymentInitiateData.fromJson(Map<String, dynamic> json) {
    return PujaPaymentInitiateData(
      paymentId: json['paymentId']?.toString() ?? '',
      razorpayKeyId: json['razorpayKeyId']?.toString() ?? '',
      order: json['order'] != null
          ? PujaPaymentOrder.fromJson(json['order'] as Map<String, dynamic>)
          : null,
      amount: _toDouble(json['amount']) ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      bookingId: json['bookingId']?.toString() ?? '',
    );
  }
}

/// Puja payment order model from initiate response
class PujaPaymentOrder {
  final String id;
  final int amount;
  final String currency;

  PujaPaymentOrder({
    required this.id,
    required this.amount,
    required this.currency,
  });

  factory PujaPaymentOrder.fromJson(Map<String, dynamic> json) {
    return PujaPaymentOrder(
      id: json['id']?.toString() ?? '',
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}

/// Puja payment verify request model
class PujaPaymentVerifyRequest {
  final String bookingId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  PujaPaymentVerifyRequest({
    required this.bookingId,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };
  }
}

/// Puja payment verify response model
class PujaPaymentVerifyResponse {
  final bool success;
  final String message;
  final PujaPaymentVerifyData? data;

  PujaPaymentVerifyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PujaPaymentVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PujaPaymentVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PujaPaymentVerifyData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Puja payment verify data model
class PujaPaymentVerifyData {
  final String bookingId;
  final String paymentId;
  final String status;

  PujaPaymentVerifyData({
    required this.bookingId,
    required this.paymentId,
    required this.status,
  });

  factory PujaPaymentVerifyData.fromJson(Map<String, dynamic> json) {
    return PujaPaymentVerifyData(
      bookingId: json['bookingId']?.toString() ?? '',
      paymentId: json['paymentId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
