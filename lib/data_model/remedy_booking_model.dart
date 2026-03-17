import 'package:astrobharataiuser/data_model/remedy_category_model.dart'
    show Pagination;

/// Address for remedy booking
class RemedyBookingAddress {
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? pincode;
  String? country;

  RemedyBookingAddress({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.country,
  });

  factory RemedyBookingAddress.fromJson(Map<String, dynamic> json) {
    return RemedyBookingAddress(
      addressLine1: json['addressLine1']?.toString(),
      addressLine2: json['addressLine2']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      pincode: json['pincode']?.toString(),
      country: json['country']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (addressLine1 != null) 'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (country != null) 'country': country,
    };
  }
}

/// Person details for remedy booking
class RemedyBookingPersonDetails {
  String? name;
  String? dateOfBirth;
  String? birthPlace;
  String? birthTime;
  String? gotra;
  String? rashi;
  String? nakshatra;

  RemedyBookingPersonDetails({
    this.name,
    this.dateOfBirth,
    this.birthPlace,
    this.birthTime,
    this.gotra,
    this.rashi,
    this.nakshatra,
  });

  factory RemedyBookingPersonDetails.fromJson(Map<String, dynamic> json) {
    return RemedyBookingPersonDetails(
      name: json['name']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      birthPlace: json['birthPlace']?.toString(),
      birthTime: json['birthTime']?.toString(),
      gotra: json['gotra']?.toString(),
      rashi: json['rashi']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (birthPlace != null) 'birthPlace': birthPlace,
      if (birthTime != null) 'birthTime': birthTime,
      if (gotra != null) 'gotra': gotra,
      if (rashi != null) 'rashi': rashi,
      if (nakshatra != null) 'nakshatra': nakshatra,
    };
  }
}

/// Booking details payload
class RemedyBookingDetailsPayload {
  String? preferredDate;
  String? preferredTimeSlot;
  String? specialInstructions;
  RemedyBookingPersonDetails? personDetails;
  String? purpose;
  List<Map<String, dynamic>>? familyMembers;

  RemedyBookingDetailsPayload({
    this.preferredDate,
    this.preferredTimeSlot,
    this.specialInstructions,
    this.personDetails,
    this.purpose,
    this.familyMembers,
  });

  Map<String, dynamic> toJson() {
    return {
      if (preferredDate != null) 'preferredDate': preferredDate,
      if (preferredTimeSlot != null) 'preferredTimeSlot': preferredTimeSlot,
      if (specialInstructions != null) 'specialInstructions': specialInstructions,
      if (personDetails != null) 'personDetails': personDetails!.toJson(),
      if (purpose != null) 'purpose': purpose,
      if (familyMembers != null) 'familyMembers': familyMembers ?? [],
    };
  }
}

/// Customer details payload
class RemedyBookingCustomerDetailsPayload {
  String? fullName;
  String? email;
  String? phone;
  String? alternatePhone;
  RemedyBookingAddress? address;

  RemedyBookingCustomerDetailsPayload({
    this.fullName,
    this.email,
    this.phone,
    this.alternatePhone,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (alternatePhone != null) 'alternatePhone': alternatePhone,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

/// Create remedy booking request
class RemedyCreateBookingRequest {
  String serviceId;
  RemedyBookingCustomerDetailsPayload customerDetails;
  RemedyBookingDetailsPayload bookingDetails;
  String paymentMethod;

  RemedyCreateBookingRequest({
    required this.serviceId,
    required this.customerDetails,
    required this.bookingDetails,
    this.paymentMethod = 'online',
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'customerDetails': customerDetails.toJson(),
      'bookingDetails': bookingDetails.toJson(),
      'paymentMethod': paymentMethod,
    };
  }
}

class RemedyServiceSnapshot {
  String? title;
  String? slug;
  String? image;
  double? price;
  String? description;
  String? categoryTitle;
  String? categoryId;

  RemedyServiceSnapshot({
    this.title,
    this.slug,
    this.image,
    this.price,
    this.description,
    this.categoryTitle,
    this.categoryId,
  });

  factory RemedyServiceSnapshot.fromJson(Map<String, dynamic> json) {
    return RemedyServiceSnapshot(
      title: json['title']?.toString(),
      slug: json['slug']?.toString(),
      image: json['image']?.toString(),
      price: (json['price'] as num?)?.toDouble(),
      description: json['description']?.toString(),
      categoryTitle: json['categoryTitle']?.toString(),
      categoryId: json['categoryId']?.toString(),
    );
  }
}

class RemedyBookingPricing {
  double? basePrice;
  double? additionalCharges;
  double? discount;
  double? tax;
  double? totalAmount;

  RemedyBookingPricing({
    this.basePrice,
    this.additionalCharges,
    this.discount,
    this.tax,
    this.totalAmount,
  });

  factory RemedyBookingPricing.fromJson(Map<String, dynamic> json) {
    return RemedyBookingPricing(
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      additionalCharges: (json['additionalCharges'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
    );
  }
}

class RemedyBookingPaymentInfo {
  String? method;
  String? status;
  String? transactionId;
  String? gatewayOrderId;
  String? gatewayPaymentId;
  String? initiatedAt;
  String? paidAt;
  String? failureReason;

  RemedyBookingPaymentInfo({
    this.method,
    this.status,
    this.transactionId,
    this.gatewayOrderId,
    this.gatewayPaymentId,
    this.initiatedAt,
    this.paidAt,
    this.failureReason,
  });

  factory RemedyBookingPaymentInfo.fromJson(Map<String, dynamic> json) {
    return RemedyBookingPaymentInfo(
      method: json['method']?.toString(),
      status: json['status']?.toString(),
      transactionId: json['transactionId']?.toString(),
      gatewayOrderId: json['gatewayOrderId']?.toString(),
      gatewayPaymentId: json['gatewayPaymentId']?.toString(),
      initiatedAt: json['initiatedAt']?.toString(),
      paidAt: json['paidAt']?.toString(),
      failureReason: json['failureReason']?.toString(),
    );
  }
}

class RemedyBookingCustomerDetails {
  String? fullName;
  String? email;
  String? phone;
  String? alternatePhone;
  RemedyBookingAddress? address;

  RemedyBookingCustomerDetails({
    this.fullName,
    this.email,
    this.phone,
    this.alternatePhone,
    this.address,
  });

  factory RemedyBookingCustomerDetails.fromJson(Map<String, dynamic> json) {
    return RemedyBookingCustomerDetails(
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      alternatePhone: json['alternatePhone']?.toString(),
      address: json['address'] != null
          ? RemedyBookingAddress.fromJson(
              json['address'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RemedyBookingDetailsResponse {
  String? preferredDate;
  String? preferredTimeSlot;
  String? specialInstructions;
  RemedyBookingPersonDetails? personDetails;
  String? purpose;
  List<dynamic>? familyMembers;

  RemedyBookingDetailsResponse({
    this.preferredDate,
    this.preferredTimeSlot,
    this.specialInstructions,
    this.personDetails,
    this.purpose,
    this.familyMembers,
  });

  factory RemedyBookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RemedyBookingDetailsResponse(
      preferredDate: json['preferredDate']?.toString(),
      preferredTimeSlot: json['preferredTimeSlot']?.toString(),
      specialInstructions: json['specialInstructions']?.toString(),
      personDetails: json['personDetails'] != null
          ? RemedyBookingPersonDetails.fromJson(
              json['personDetails'] as Map<String, dynamic>,
            )
          : null,
      purpose: json['purpose']?.toString(),
      familyMembers: json['familyMembers'] as List<dynamic>?,
    );
  }
}

class RemedyBookingCancellation {
  String? cancelledAt;
  String? cancelledBy;
  String? reason;
  String? refundStatus;
  double? refundAmount;

  RemedyBookingCancellation({
    this.cancelledAt,
    this.cancelledBy,
    this.reason,
    this.refundStatus,
    this.refundAmount,
  });

  factory RemedyBookingCancellation.fromJson(Map<String, dynamic> json) {
    return RemedyBookingCancellation(
      cancelledAt: json['cancelledAt']?.toString(),
      cancelledBy: json['cancelledBy']?.toString(),
      reason: json['reason']?.toString(),
      refundStatus: json['refundStatus']?.toString(),
      refundAmount: (json['refundAmount'] as num?)?.toDouble(),
    );
  }
}

class RemedyBookingItem {
  String? id;
  String? bookingId;
  RemedyServiceSnapshot? serviceSnapshot;
  dynamic service;
  RemedyBookingCustomerDetails? customerDetails;
  RemedyBookingDetailsResponse? bookingDetails;
  RemedyBookingPricing? pricing;
  RemedyBookingPaymentInfo? payment;
  String? status;
  RemedyBookingCancellation? cancellation;
  String? createdAt;

  RemedyBookingItem({
    this.id,
    this.bookingId,
    this.serviceSnapshot,
    this.service,
    this.customerDetails,
    this.bookingDetails,
    this.pricing,
    this.payment,
    this.status,
    this.cancellation,
    this.createdAt,
  });

  factory RemedyBookingItem.fromJson(Map<String, dynamic> json) {
    return RemedyBookingItem(
      id: json['_id']?.toString(),
      bookingId: json['bookingId']?.toString(),
      serviceSnapshot: json['serviceSnapshot'] != null
          ? RemedyServiceSnapshot.fromJson(
              json['serviceSnapshot'] as Map<String, dynamic>,
            )
          : null,
      service: json['service'],
      customerDetails: json['customerDetails'] != null
          ? RemedyBookingCustomerDetails.fromJson(
              json['customerDetails'] as Map<String, dynamic>,
            )
          : null,
      bookingDetails: json['bookingDetails'] != null
          ? RemedyBookingDetailsResponse.fromJson(
              json['bookingDetails'] as Map<String, dynamic>,
            )
          : null,
      pricing: json['pricing'] != null
          ? RemedyBookingPricing.fromJson(
              json['pricing'] as Map<String, dynamic>,
            )
          : null,
      payment: json['payment'] != null
          ? RemedyBookingPaymentInfo.fromJson(
              json['payment'] as Map<String, dynamic>,
            )
          : null,
      status: json['status']?.toString(),
      cancellation: json['cancellation'] != null
          ? RemedyBookingCancellation.fromJson(
              json['cancellation'] as Map<String, dynamic>,
            )
          : null,
      createdAt: json['createdAt']?.toString(),
    );
  }
}

class RemedyBookingsListResponse {
  List<RemedyBookingItem> items;
  Pagination? pagination;

  RemedyBookingsListResponse({
    this.items = const [],
    this.pagination,
  });

  factory RemedyBookingsListResponse.fromJson(Map<String, dynamic> json) {
    List<RemedyBookingItem> items = [];
    if (json['items'] is List) {
      for (var e in json['items'] as List) {
        if (e is Map<String, dynamic>) {
          items.add(RemedyBookingItem.fromJson(e));
        }
      }
    }
    return RemedyBookingsListResponse(
      items: items,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RemedyPaymentInitiateResponse {
  bool success;
  String message;
  RemedyPaymentInitiateData? data;

  RemedyPaymentInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RemedyPaymentInitiateResponse.fromJson(Map<String, dynamic> json) {
    return RemedyPaymentInitiateResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? RemedyPaymentInitiateData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RemedyPaymentInitiateData {
  String paymentId;
  String bookingId;
  double amount;
  String currency;
  String razorpayKeyId;
  String gatewayOrderId;
  RemedyRazorpayOrder? razorpayOrder;

  RemedyPaymentInitiateData({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.razorpayKeyId,
    required this.gatewayOrderId,
    this.razorpayOrder,
  });

  factory RemedyPaymentInitiateData.fromJson(Map<String, dynamic> json) {
    return RemedyPaymentInitiateData(
      paymentId: json['paymentId']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      razorpayKeyId: json['razorpayKeyId']?.toString() ?? '',
      gatewayOrderId: json['gatewayOrderId']?.toString() ?? '',
      razorpayOrder: json['razorpayOrder'] != null
          ? RemedyRazorpayOrder.fromJson(
              json['razorpayOrder'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RemedyRazorpayOrder {
  String id;
  int amount;
  String currency;

  RemedyRazorpayOrder({
    required this.id,
    required this.amount,
    required this.currency,
  });

  factory RemedyRazorpayOrder.fromJson(Map<String, dynamic> json) {
    return RemedyRazorpayOrder(
      id: json['id']?.toString() ?? '',
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}

class RemedyPaymentVerifyRequest {
  String razorpayOrderId;
  String razorpayPaymentId;
  String razorpaySignature;

  RemedyPaymentVerifyRequest({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };
  }
}
