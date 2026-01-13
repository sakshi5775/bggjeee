import 'product_model.dart';

class CartModel {
  String? id;
  CartTotals? totals;
  CartAppliedCoupon? appliedCoupon;
  List<CartItem>? items;
  List<CartItem>? savedForLater;
  bool? isActive;
  int? itemCount;
  double? total;
  String? sessionId;
  String? userId;
  String? expiresAt;
  String? createdAt;
  String? updatedAt;

  CartModel({
    this.id,
    this.totals,
    this.appliedCoupon,
    this.items,
    this.isActive,
    this.itemCount,
    this.total,
    this.sessionId,
    this.userId,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    totals = json['totals'] != null && json['totals'] is Map
        ? CartTotals.fromJson(json['totals'] as Map<String, dynamic>)
        : null;
    appliedCoupon = json['appliedCoupon'] != null && json['appliedCoupon'] is Map
        ? CartAppliedCoupon.fromJson(json['appliedCoupon'] as Map<String, dynamic>)
        : null;
    items = _parseCartItems(json['items']);
    savedForLater = _parseCartItems(json['savedForLater']);
    isActive = json['isActive'] is bool ? json['isActive'] : null;
    itemCount = json['itemCount'] is int ? json['itemCount'] : null;
    total = _toDouble(json['total']);
    sessionId = json['sessionId']?.toString();
    userId = json['user']?.toString();
    expiresAt = json['expiresAt']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    if (totals != null) {
      data['totals'] = totals!.toJson();
    }
    if (appliedCoupon != null) {
      data['appliedCoupon'] = appliedCoupon!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (savedForLater != null) {
      data['savedForLater'] = savedForLater!.map((v) => v.toJson()).toList();
    }
    data['isActive'] = isActive;
    data['itemCount'] = itemCount;
    data['total'] = total;
    data['sessionId'] = sessionId;
    data['user'] = userId;
    data['expiresAt'] = expiresAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

List<CartItem>? _parseCartItems(dynamic source) {
  if (source == null || source is! List) return null;
  final list = <CartItem>[];
  for (final item in source) {
    if (item is Map<String, dynamic>) {
      list.add(CartItem.fromJson(item));
    }
  }
  return list;
}

class CartTotals {
  double? subtotal;
  double? discount;
  double? tax;
  double? shipping;
  double? total;

  CartTotals({this.subtotal, this.discount, this.tax, this.shipping, this.total});

  CartTotals.fromJson(Map<String, dynamic> json) {
    subtotal = CartModel._toDouble(json['subtotal']);
    discount = CartModel._toDouble(json['discount']);
    tax = CartModel._toDouble(json['tax']);
    shipping = CartModel._toDouble(json['shipping']);
    total = CartModel._toDouble(json['total']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['subtotal'] = subtotal;
    data['discount'] = discount;
    data['tax'] = tax;
    data['shipping'] = shipping;
    data['total'] = total;
    return data;
  }
}

class CartAppliedCoupon {
  String? code;
  double? discount;
  String? couponId;

  CartAppliedCoupon({this.code, this.discount, this.couponId});

  CartAppliedCoupon.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    discount = CartModel._toDouble(json['discount']);
    couponId = json['couponId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['discount'] = discount;
    data['couponId'] = couponId;
    return data;
  }
}

class CartItem {
  String? id;
  CartProductSnapshot? productSnapshot;
  ProductModel? product;
  String? variantId;
  int? quantity;
  double? price;
  double? discountedPrice;
  double? subtotal;
  String? addedAt;

  CartItem({
    this.id,
    this.productSnapshot,
    this.product,
    this.variantId,
    this.quantity,
    this.price,
    this.discountedPrice,
    this.subtotal,
    this.addedAt,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    productSnapshot = json['productSnapshot'] != null && json['productSnapshot'] is Map
        ? CartProductSnapshot.fromJson(json['productSnapshot'] as Map<String, dynamic>)
        : null;
    product = json['product'] != null && json['product'] is Map
        ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
        : null;
    variantId = json['variant']?.toString();
    quantity = json['quantity'] is int ? json['quantity'] : null;
    price = CartModel._toDouble(json['price']);
    discountedPrice = CartModel._toDouble(json['discountedPrice']);
    subtotal = CartModel._toDouble(json['subtotal']);
    addedAt = json['addedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    if (productSnapshot != null) {
      data['productSnapshot'] = productSnapshot!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['variant'] = variantId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['discountedPrice'] = discountedPrice;
    data['subtotal'] = subtotal;
    data['addedAt'] = addedAt;
    return data;
  }

  String? get productId => product?.id ?? productSnapshot?.productId;
}

class CartProductSnapshot {
  String? productId;
  String? name;
  String? sku;

  CartProductSnapshot({this.productId, this.name, this.sku});

  CartProductSnapshot.fromJson(Map<String, dynamic> json) {
    productId = json['_id']?.toString() ?? json['productId']?.toString();
    name = json['name']?.toString();
    sku = json['sku']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = productId;
    data['name'] = name;
    data['sku'] = sku;
    return data;
  }
}

