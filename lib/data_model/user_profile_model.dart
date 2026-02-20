import 'wallet_model.dart';

/// User Profile Model matching the new API structure
class UserProfileModel {
  UserProfileModel({
    this.personalInfo,
    this.contactInfo,
    this.birthChart,
    this.wallet,
    this.consultations,
    this.preferences,
    this.stats,
    this.metadata,
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  PersonalInfo? personalInfo;
  ContactInfo? contactInfo;
  BirthChart? birthChart;
  Wallet? wallet;
  Consultations? consultations;
  Preferences? preferences;
  Stats? stats;
  Metadata? metadata;
  String? id;
  String? userId;
  String? createdAt;
  String? updatedAt;

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    personalInfo = json['personalInfo'] != null
        ? PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>)
        : null;
    contactInfo = json['contactInfo'] != null
        ? ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>)
        : null;
    birthChart = json['birthChart'] != null
        ? BirthChart.fromJson(json['birthChart'] as Map<String, dynamic>)
        : null;
    wallet = json['wallet'] != null
        ? Wallet.fromJson(json['wallet'] as Map<String, dynamic>)
        : null;
    consultations = json['consultations'] != null
        ? Consultations.fromJson(json['consultations'] as Map<String, dynamic>)
        : null;
    preferences = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'] as Map<String, dynamic>)
        : null;
    stats = json['stats'] != null
        ? Stats.fromJson(json['stats'] as Map<String, dynamic>)
        : null;
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'] as Map<String, dynamic>)
        : null;
    id = json['_id']?.toString();
    userId = json['userId']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (personalInfo != null) {
      data['personalInfo'] = personalInfo!.toJson();
    }
    if (contactInfo != null) {
      data['contactInfo'] = contactInfo!.toJson();
    }
    if (birthChart != null) {
      data['birthChart'] = birthChart!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (consultations != null) {
      data['consultations'] = consultations!.toJson();
    }
    if (preferences != null) {
      data['preferences'] = preferences!.toJson();
    }
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['_id'] = id;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PersonalInfo {
  PersonalInfo({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.occupation,
    this.profilePicture,
  });

  String? fullName;

  /// Date of birth in yyyy-MM-dd format (for API update)
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? occupation;
  String? profilePicture;

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName']?.toString();
    dateOfBirth = json['dateOfBirth']?.toString();
    gender = json['gender']?.toString();
    maritalStatus = json['maritalStatus']?.toString();
    occupation = json['occupation']?.toString();
    profilePicture = json['profilePicture']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['maritalStatus'] = maritalStatus;
    data['occupation'] = occupation;
    data['profilePicture'] = profilePicture;
    return data;
  }
}

class ContactInfo {
  ContactInfo({this.address, this.phone, this.email, this.alternatePhone});

  Address? address;
  String? phone;
  String? email;
  String? alternatePhone;

  ContactInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null
        ? Address.fromJson(json['address'] as Map<String, dynamic>)
        : null;
    phone = json['phone']?.toString();
    email = json['email']?.toString();
    alternatePhone = json['alternatePhone']?.toString();
  }

  Map<String, dynamic> toJson({bool excludeProtectedFields = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    // Exclude protected fields (email and phone) when updating profile
    // These can only be updated through authentication service
    if (!excludeProtectedFields) {
      data['phone'] = phone;
      data['email'] = email;
    }
    data['alternatePhone'] = alternatePhone;
    return data;
  }
}

class Address {
  Address({this.city, this.state, this.country, this.pincode});

  String? city;
  String? state;
  String? country;
  String? pincode;

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city']?.toString();
    state = json['state']?.toString();
    country = json['country']?.toString();
    pincode = json['pincode']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pincode'] = pincode;
    return data;
  }
}

class BirthChart {
  BirthChart({
    this.birthPlace,
    this.birthTime,
    this.generatedAt,
    this.lastUpdated,
    this.chartData,
  });

  BirthPlace? birthPlace;
  BirthTime? birthTime;
  String? generatedAt;
  String? lastUpdated;
  Map<String, dynamic>? chartData;

  BirthChart.fromJson(Map<String, dynamic> json) {
    birthPlace = json['birthPlace'] != null
        ? BirthPlace.fromJson(json['birthPlace'] as Map<String, dynamic>)
        : null;
    birthTime = json['birthTime'] != null
        ? BirthTime.fromJson(json['birthTime'] as Map<String, dynamic>)
        : null;
    generatedAt = json['generatedAt']?.toString();
    lastUpdated = json['lastUpdated']?.toString();
    chartData = json['chartData'] as Map<String, dynamic>?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (birthPlace != null) {
      data['birthPlace'] = birthPlace!.toJson();
    }
    if (birthTime != null) {
      data['birthTime'] = birthTime!.toJson();
    }
    data['generatedAt'] = generatedAt;
    data['lastUpdated'] = lastUpdated;
    if (chartData != null) {
      data['chartData'] = chartData;
    }
    return data;
  }
}

class BirthPlace {
  BirthPlace({
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.timezone,
  });

  String? city;
  String? state;
  String? country;
  double? latitude;
  double? longitude;
  String? timezone;

  BirthPlace.fromJson(Map<String, dynamic> json) {
    city = json['city']?.toString();
    state = json['state']?.toString();
    country = json['country']?.toString();
    latitude = json['latitude'] != null
        ? double.tryParse(json['latitude'].toString())
        : null;
    longitude = json['longitude'] != null
        ? double.tryParse(json['longitude'].toString())
        : null;
    timezone = json['timezone']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['timezone'] = timezone;
    return data;
  }
}

class BirthTime {
  BirthTime({this.hour, this.minute, this.second});

  int? hour;
  int? minute;
  int? second;

  BirthTime.fromJson(Map<String, dynamic> json) {
    hour = json['hour'] != null ? int.tryParse(json['hour'].toString()) : null;
    minute = json['minute'] != null
        ? int.tryParse(json['minute'].toString())
        : null;
    second = json['second'] != null
        ? int.tryParse(json['second'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hour'] = hour;
    data['minute'] = minute;
    data['second'] = second;
    return data;
  }
}

class Wallet {
  Wallet({this.balance, this.currency, this.transactions});

  double? balance;
  String? currency;
  List<WalletTransaction>? transactions;

  Wallet.fromJson(Map<String, dynamic> json) {
    balance = json['balance'] != null
        ? double.tryParse(json['balance'].toString())
        : null;
    currency = json['currency']?.toString();
    if (json['transactions'] != null) {
      transactions = <WalletTransaction>[];
      json['transactions'].forEach((v) {
        transactions!.add(
          WalletTransaction.fromJson(v as Map<String, dynamic>),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['currency'] = currency;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Consultations {
  Consultations({
    this.totalConsultations,
    this.activeConsultations,
    this.completedConsultations,
  });

  int? totalConsultations;
  List<dynamic>? activeConsultations;
  List<dynamic>? completedConsultations;

  Consultations.fromJson(Map<String, dynamic> json) {
    totalConsultations = json['totalConsultations'] != null
        ? int.tryParse(json['totalConsultations'].toString())
        : null;
    activeConsultations = json['activeConsultations'] as List<dynamic>?;
    completedConsultations = json['completedConsultations'] as List<dynamic>?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalConsultations'] = totalConsultations;
    if (activeConsultations != null) {
      data['activeConsultations'] = activeConsultations;
    }
    if (completedConsultations != null) {
      data['completedConsultations'] = completedConsultations;
    }
    return data;
  }
}

class Preferences {
  Preferences({
    this.notificationSettings,
    this.language,
    this.favoriteAstrologers,
    this.interests,
  });

  NotificationSettings? notificationSettings;
  String? language;
  List<dynamic>? favoriteAstrologers;
  List<String>? interests;

  Preferences.fromJson(Map<String, dynamic> json) {
    notificationSettings = json['notificationSettings'] != null
        ? NotificationSettings.fromJson(
            json['notificationSettings'] as Map<String, dynamic>,
          )
        : null;
    language = json['language']?.toString();
    favoriteAstrologers = json['favoriteAstrologers'] as List<dynamic>?;
    interests = json['interests'] != null
        ? (json['interests'] as List).map((e) => e.toString()).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notificationSettings != null) {
      data['notificationSettings'] = notificationSettings!.toJson();
    }
    data['language'] = language;
    if (favoriteAstrologers != null) {
      data['favoriteAstrologers'] = favoriteAstrologers;
    }
    if (interests != null) {
      data['interests'] = interests;
    }
    return data;
  }
}

class NotificationSettings {
  NotificationSettings({this.email, this.sms, this.push, this.whatsapp});

  bool? email;
  bool? sms;
  bool? push;
  bool? whatsapp;

  NotificationSettings.fromJson(Map<String, dynamic> json) {
    email = json['email'] == true;
    sms = json['sms'] == true;
    push = json['push'] == true;
    whatsapp = json['whatsapp'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['sms'] = sms;
    data['push'] = push;
    data['whatsapp'] = whatsapp;
    return data;
  }
}

class Stats {
  Stats({this.totalSpent, this.totalRecharges});

  double? totalSpent;
  double? totalRecharges;

  Stats.fromJson(Map<String, dynamic> json) {
    totalSpent = json['totalSpent'] != null
        ? double.tryParse(json['totalSpent'].toString())
        : null;
    totalRecharges = json['totalRecharges'] != null
        ? double.tryParse(json['totalRecharges'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSpent'] = totalSpent;
    data['totalRecharges'] = totalRecharges;
    return data;
  }
}

class Metadata {
  Metadata({
    this.isActive,
    this.isVerified,
    this.accountStatus,
    this.suspensionReason,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool? isActive;
  bool? isVerified;
  String? accountStatus;
  String? suspensionReason;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Metadata.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'] == true;
    isVerified = json['isVerified'] == true;
    accountStatus = json['accountStatus']?.toString();
    suspensionReason = json['suspensionReason']?.toString();
    deletedAt = json['deletedAt']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    data['accountStatus'] = accountStatus;
    data['suspensionReason'] = suspensionReason;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

/// Response wrapper for User Profile API
class UserProfileResponse {
  UserProfileResponse({bool? success, this.message, this.data})
    : success = success ?? false;

  bool success;
  String? message;
  UserProfileModel? data;

  UserProfileResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'] == true {
    message = json['message']?.toString();
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = UserProfileModel.fromJson(json['data'] as Map<String, dynamic>);
    }
  }
}

/// Request model for updating birth chart
class BirthChartUpdateRequest {
  BirthChartUpdateRequest({
    required this.birthPlace,
    required this.birthTime,
    this.dateOfBirth,
  });

  final BirthPlace birthPlace;
  final BirthTime birthTime;
  final String? dateOfBirth;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'birthPlace': birthPlace.toJson(),
      'birthTime': birthTime.toJson(),
    };
    if (dateOfBirth != null && dateOfBirth!.isNotEmpty) {
      data['dateOfBirth'] = dateOfBirth;
    }
    return data;
  }
}
