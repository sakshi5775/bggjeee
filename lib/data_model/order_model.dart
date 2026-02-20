import 'package:astrobharataiuser/data_model/product_model.dart';

class OrdersResponse {
  OrdersResponse({
    this.items = const [],
    this.pagination,
  });

  OrdersResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] is List) {
      items = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList();
    }
    if (json['pagination'] is Map<String, dynamic>) {
      pagination = OrderPagination.fromJson(json['pagination'] as Map<String, dynamic>);
    }
  }

  List<OrderModel> items = const [];
  OrderPagination? pagination;
}

class OrderPagination {
  OrderPagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
  });

  OrderPagination.fromJson(Map<String, dynamic> json) {
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

class OrderModel {
  OrderModel({
    this.id,
    this.orderId,
    this.userId,
    this.status,
    this.itemCount,
    this.createdAt,
    this.updatedAt,
    this.billingAddress,
    this.shippingAddress,
    this.pricing,
    this.appliedCoupon,
    this.payment,
    this.invoice,
    this.items = const [],
    this.customerNotes,
    this.adminNotes,
    this.cancellationReason,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? json['_id']?.toString();
    orderId = json['orderId']?.toString();
    userId = json['user']?.toString();
    status = json['status']?.toString();
    itemCount = _toInt(json['itemCount']);
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['billingAddress'] is Map<String, dynamic>) {
      billingAddress = OrderAddress.fromJson(json['billingAddress'] as Map<String, dynamic>);
    }
    if (json['shippingAddress'] is Map<String, dynamic>) {
      shippingAddress = OrderAddress.fromJson(json['shippingAddress'] as Map<String, dynamic>);
    }
    if (json['pricing'] is Map<String, dynamic>) {
      pricing = OrderPricing.fromJson(json['pricing'] as Map<String, dynamic>);
    }
    if (json['appliedCoupon'] is Map<String, dynamic>) {
      appliedCoupon = OrderCoupon.fromJson(json['appliedCoupon'] as Map<String, dynamic>);
    }
    if (json['payment'] is Map<String, dynamic>) {
      payment = OrderPayment.fromJson(json['payment'] as Map<String, dynamic>);
    }
    if (json['invoice'] is Map<String, dynamic>) {
      invoice = OrderInvoice.fromJson(json['invoice'] as Map<String, dynamic>);
    }
    if (json['items'] is List) {
      items = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map(OrderItem.fromJson)
          .toList();
    }
    customerNotes = json['customerNotes']?.toString();
    adminNotes = json['adminNotes']?.toString();
    cancellationReason = json['cancellationReason']?.toString();
  }

  String? id;
  String? orderId;
  String? userId;
  String? status;
  int? itemCount;
  String? createdAt;
  String? updatedAt;
  OrderAddress? billingAddress;
  OrderAddress? shippingAddress;
  OrderPricing? pricing;
  OrderCoupon? appliedCoupon;
  OrderPayment? payment;
  OrderInvoice? invoice;
  List<OrderItem> items = const [];
  String? customerNotes;
  String? adminNotes;
  String? cancellationReason;

  double get totalAmount => pricing?.total ?? 0;
  double get subtotal => pricing?.subtotal ?? 0;
  double get tax => pricing?.tax ?? 0;
}

class OrderAddress {
  OrderAddress({
    this.fullName,
    this.phone,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.country,
    this.landmark,
  });

  OrderAddress.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName']?.toString();
    phone = json['phone']?.toString();
    email = json['email']?.toString();
    addressLine1 = json['addressLine1']?.toString();
    addressLine2 = json['addressLine2']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    pincode = json['pincode']?.toString();
    country = json['country']?.toString();
    landmark = json['landmark']?.toString();
  }

  String? fullName;
  String? phone;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? pincode;
  String? country;
  String? landmark;

  String get formattedAddress {
    final parts = <String>[
      if (addressLine1 != null && addressLine1!.isNotEmpty) addressLine1!,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      if (city != null && city!.isNotEmpty) city!,
      if (state != null && state!.isNotEmpty) state!,
      if (pincode != null && pincode!.isNotEmpty) pincode!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }
}

class OrderPricing {
  OrderPricing({
    this.subtotal,
    this.discount,
    this.couponDiscount,
    this.tax,
    this.shipping,
    this.total,
    this.taxBreakup,
  });

  OrderPricing.fromJson(Map<String, dynamic> json) {
    subtotal = _toDouble(json['subtotal']);
    discount = _toDouble(json['discount']);
    couponDiscount = _toDouble(json['couponDiscount']);
    tax = _toDouble(json['tax']);
    shipping = _toDouble(json['shipping']);
    total = _toDouble(json['total']);
    if (json['taxBreakup'] is Map<String, dynamic>) {
      taxBreakup = OrderTaxBreakup.fromJson(json['taxBreakup'] as Map<String, dynamic>);
    }
  }

  double? subtotal;
  double? discount;
  double? couponDiscount;
  double? tax;
  double? shipping;
  double? total;
  OrderTaxBreakup? taxBreakup;
}

class OrderTaxBreakup {
  OrderTaxBreakup({
    this.cgst,
    this.sgst,
    this.igst,
  });

  OrderTaxBreakup.fromJson(Map<String, dynamic> json) {
    cgst = _toDouble(json['cgst']);
    sgst = _toDouble(json['sgst']);
    igst = _toDouble(json['igst']);
  }

  double? cgst;
  double? sgst;
  double? igst;
}

class OrderCoupon {
  OrderCoupon({
    this.code,
    this.discount,
    this.couponId,
  });

  OrderCoupon.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    discount = _toDouble(json['discount']);
    couponId = json['couponId']?.toString();
  }

  String? code;
  double? discount;
  String? couponId;
}

class OrderPayment {
  OrderPayment({
    this.method,
    this.status,
    this.transactionId,
    this.gatewayOrderId,
    this.gatewayPaymentId,
    this.paidAt,
    this.failureReason,
  });

  OrderPayment.fromJson(Map<String, dynamic> json) {
    method = json['method']?.toString();
    status = json['status']?.toString();
    transactionId = json['transactionId']?.toString();
    gatewayOrderId = json['gatewayOrderId']?.toString();
    gatewayPaymentId = json['gatewayPaymentId']?.toString();
    paidAt = json['paidAt']?.toString();
    failureReason = json['failureReason']?.toString();
  }

  String? method;
  String? status;
  String? transactionId;
  String? gatewayOrderId;
  String? gatewayPaymentId;
  String? paidAt;
  String? failureReason;
}

class OrderInvoice {
  OrderInvoice({
    this.invoiceNumber,
    this.invoiceUrl,
    this.generatedAt,
  });

  OrderInvoice.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoiceNumber']?.toString();
    invoiceUrl = json['invoiceUrl']?.toString();
    generatedAt = json['generatedAt']?.toString();
  }

  String? invoiceNumber;
  String? invoiceUrl;
  String? generatedAt;
}

class OrderItem {
  OrderItem({
    this.id,
    this.quantity,
    this.price,
    this.discountedPrice,
    this.tax,
    this.total,
    this.product,
    this.variant,
    this.productSnapshot,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    quantity = _toInt(json['quantity']);
    price = _toDouble(json['price']);
    discountedPrice = _toDouble(json['discountedPrice']);
    tax = _toDouble(json['tax']);
    total = _toDouble(json['total']);
    if (json['product'] is Map<String, dynamic>) {
      product = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
    }
    if (json['variant'] is Map<String, dynamic>) {
      variant = ProductVariant.fromJson(json['variant'] as Map<String, dynamic>);
    }
    if (json['productSnapshot'] is Map<String, dynamic>) {
      productSnapshot =
          OrderProductSnapshot.fromJson(json['productSnapshot'] as Map<String, dynamic>);
    }
  }

  String? id;
  int? quantity;
  double? price;
  double? discountedPrice;
  double? tax;
  double? total;
  ProductModel? product;
  ProductVariant? variant;
  OrderProductSnapshot? productSnapshot;
}

class OrderProductSnapshot {
  OrderProductSnapshot({
    this.name,
    this.sku,
    this.image,
    this.description,
    this.specifications,
  });

  OrderProductSnapshot.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    sku = json['sku']?.toString();
    image = json['image']?.toString();
    description = json['description']?.toString();
    if (json['specifications'] is Map<String, dynamic>) {
      specifications =
          ProductSpecifications.fromJson(json['specifications'] as Map<String, dynamic>);
    }
  }

  String? name;
  String? sku;
  String? image;
  String? description;
  ProductSpecifications? specifications;
}

class OrderTimelineEntry {
  OrderTimelineEntry({
    this.status,
    this.date,
    this.completed = false,
  });

  OrderTimelineEntry.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    date = json['date']?.toString();
    completed = json['completed'] == true;
  }

  String? status;
  String? date;
  bool completed = false;
}

class OrderHistoryEntry {
  OrderHistoryEntry({
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.actor,
  });

  OrderHistoryEntry.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    note = json['note']?.toString() ?? json['message']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    actor = json['updatedBy']?.toString() ?? json['actor']?.toString();
  }

  String? status;
  String? note;
  String? createdAt;
  String? updatedAt;
  String? actor;
}

class OrderTrackingInfo {
  OrderTrackingInfo({
    this.orderId,
    this.status,
    this.timeline = const [],
  });

  OrderTrackingInfo.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId']?.toString();
    status = json['status']?.toString();
    if (json['timeline'] is List) {
      timeline = (json['timeline'] as List)
          .whereType<Map<String, dynamic>>()
          .map(OrderTimelineEntry.fromJson)
          .toList();
    }
  }

  String? orderId;
  String? status;
  List<OrderTimelineEntry> timeline = const [];
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is double) return value.toInt();
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

