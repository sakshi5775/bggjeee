class AddressModel {
  String? id;
  String? userId;
  String? type;
  String? fullName;
  String? phone;
  String? alternatePhone;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? country;
  bool? isDefault;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  AddressModel({
    this.id,
    this.userId,
    this.type,
    this.fullName,
    this.phone,
    this.alternatePhone,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.country,
    this.isDefault,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    userId = json['user']?.toString();
    type = json['type']?.toString();
    fullName = json['fullName']?.toString();
    phone = json['phone']?.toString();
    alternatePhone = json['alternatePhone']?.toString();
    email = json['email']?.toString();
    addressLine1 = json['addressLine1']?.toString();
    addressLine2 = json['addressLine2']?.toString();
    landmark = json['landmark']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    pincode = json['pincode']?.toString();
    country = json['country']?.toString();
    isDefault = json['isDefault'] is bool ? json['isDefault'] : null;
    isActive = json['isActive'] is bool ? json['isActive'] : null;
    isDeleted = json['isDeleted'] is bool ? json['isDeleted'] : null;
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['user'] = userId;
    data['type'] = type;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['alternatePhone'] = alternatePhone;
    data['email'] = email;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['country'] = country;
    data['isDefault'] = isDefault;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toRequestBody({bool includeDefault = true, bool forUpdate = false}) {
    final data = <String, dynamic>{};
    if (forUpdate) {
      data['type'] = type;
    } else {
      data['addressType'] = type;
    }
    data['fullName'] = fullName;
    data['phone'] = phone;
    if (alternatePhone != null && alternatePhone!.isNotEmpty) {
      data['alternatePhone'] = alternatePhone;
    }
    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }
    data['addressLine1'] = addressLine1;
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      data['addressLine2'] = addressLine2;
    }
    if (landmark != null && landmark!.isNotEmpty) {
      data['landmark'] = landmark;
    }
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['country'] = country;

    if (includeDefault && isDefault != null) {
      data['isDefault'] = isDefault;
    }
    return data;
  }
}

