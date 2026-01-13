class PaymentProcessResponse {
  final bool success;
  final String message;
  final PaymentProcessData data;

  PaymentProcessResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentProcessResponse.fromJson(Map<String, dynamic> json) {
    return PaymentProcessResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PaymentProcessData.fromJson(json['data'] ?? {}),
    );
  }
}

class PaymentProcessData {
  final OrderInfo order;
  final PaymentInfo payment;
  final EnrollmentInfo enrollment;

  PaymentProcessData({
    required this.order,
    required this.payment,
    required this.enrollment,
  });

  factory PaymentProcessData.fromJson(Map<String, dynamic> json) {
    return PaymentProcessData(
      order: OrderInfo.fromJson(json['order'] ?? {}),
      payment: PaymentInfo.fromJson(json['payment'] ?? {}),
      enrollment: EnrollmentInfo.fromJson(json['enrollment'] ?? {}),
    );
  }
}

class OrderInfo {
  final String orderId;
  final String status;
  final DateTime? completedAt;

  OrderInfo({
    required this.orderId,
    required this.status,
    this.completedAt,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      orderId: json['orderId'] ?? '',
      status: json['status'] ?? '',
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
    );
  }
}

class PaymentInfo {
  final String transactionId;
  final String gatewayPaymentId;
  final String status;
  final int amount;
  final String currency;

  PaymentInfo({
    required this.transactionId,
    required this.gatewayPaymentId,
    required this.status,
    required this.amount,
    required this.currency,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      transactionId: json['transactionId'] ?? '',
      gatewayPaymentId: json['gatewayPaymentId'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }
}

class EnrollmentInfo {
  final String id;
  final DateTime? enrolledAt;
  final String accessStatus;

  EnrollmentInfo({
    required this.id,
    this.enrolledAt,
    required this.accessStatus,
  });

  factory EnrollmentInfo.fromJson(Map<String, dynamic> json) {
    return EnrollmentInfo(
      id: json['_id'] ?? '',
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.tryParse(json['enrolledAt'])
          : null,
      accessStatus: json['accessStatus'] ?? '',
    );
  }
}







