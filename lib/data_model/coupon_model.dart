class CouponModel {
  CouponModel({
    this.id,
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.maxDiscountAmount,
    this.minPurchaseAmount,
    this.validUntil,
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    code = json['code']?.toString();
    description = json['description']?.toString();
    discountType = json['discountType']?.toString();
    discountValue = _toDouble(json['discountValue']);
    maxDiscountAmount = _toDouble(json['maxDiscountAmount']);
    minPurchaseAmount = _toDouble(json['minPurchaseAmount']);
    validUntil = json['validUntil']?.toString();
  }

  String? id;
  String? code;
  String? description;
  String? discountType;
  double? discountValue;
  double? maxDiscountAmount;
  double? minPurchaseAmount;
  String? validUntil;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['discountType'] = discountType;
    data['discountValue'] = discountValue;
    data['maxDiscountAmount'] = maxDiscountAmount;
    data['minPurchaseAmount'] = minPurchaseAmount;
    data['validUntil'] = validUntil;
    return data;
  }
}

class CouponValidationResult {
  CouponValidationResult({
    this.isValid = false,
    this.coupon,
    this.discountAmount,
    this.finalAmount,
  });

  CouponValidationResult.fromJson(Map<String, dynamic> json) {
    isValid = json['valid'] == true;
    discountAmount = _toDouble(json['discountAmount']);
    finalAmount = _toDouble(json['finalAmount']);
    if (json['coupon'] is Map<String, dynamic>) {
      coupon = CouponModel.fromJson(json['coupon'] as Map<String, dynamic>);
    }
  }

  bool isValid = false;
  CouponModel? coupon;
  double? discountAmount;
  double? finalAmount;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  if (value is Map<String, dynamic>) {
    // Sometimes backend returns an empty object
    if (value.isEmpty) return null;
  }
  return null;
}

