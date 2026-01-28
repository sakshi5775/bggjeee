/// Model for a single booking item in the list
class MyBookingItemModel {
  String? id;
  PujaSnapshot? pujaSnapshot;
  PackageSnapshot? packageSnapshot;
  List<ParticipantInfo>? participants;
  PrasadDelivery? prasadDelivery;
  BookingPricing? pricing;
  BookingPayment? payment;
  String? status;
  String? createdAt;
  String? bookingId;

  MyBookingItemModel({
    this.id,
    this.pujaSnapshot,
    this.packageSnapshot,
    this.participants,
    this.prasadDelivery,
    this.pricing,
    this.payment,
    this.status,
    this.createdAt,
    this.bookingId,
  });

  MyBookingItemModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    pujaSnapshot = json['pujaSnapshot'] != null
        ? PujaSnapshot.fromJson(json['pujaSnapshot'])
        : null;
    packageSnapshot = json['packageSnapshot'] != null
        ? PackageSnapshot.fromJson(json['packageSnapshot'])
        : null;
    if (json['participants'] != null) {
      participants = <ParticipantInfo>[];
      json['participants'].forEach((v) {
        participants!.add(ParticipantInfo.fromJson(v));
      });
    }
    prasadDelivery = json['prasadDelivery'] != null
        ? PrasadDelivery.fromJson(json['prasadDelivery'])
        : null;
    pricing = json['pricing'] != null
        ? BookingPricing.fromJson(json['pricing'])
        : null;
    payment = json['payment'] != null
        ? BookingPayment.fromJson(json['payment'])
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    bookingId = json['bookingId'];
  }

  String get formattedStatus {
    switch (status) {
      case 'pending_payment':
        return 'Payment Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status?.replaceAll('_', ' ').toUpperCase() ?? 'Unknown';
    }
  }

  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return createdAt ?? '';
    }
  }
}

/// Model for booking detail response
class MyBookingDetailModel {
  String? id;
  PujaSnapshot? pujaSnapshot;
  PackageSnapshot? packageSnapshot;
  List<ParticipantInfo>? participants;
  PrasadDelivery? prasadDelivery;
  BookingPricing? pricing;
  BookingPayment? payment;
  BookingDeliverables? deliverables;
  PujaInfo? puja;
  String? sankalpNotes;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? bookingId;
  int? participantCount;
  bool? isPaid;
  bool? canCancel;
  List<StatusHistoryItem>? statusHistory;

  MyBookingDetailModel({
    this.id,
    this.pujaSnapshot,
    this.packageSnapshot,
    this.participants,
    this.prasadDelivery,
    this.pricing,
    this.payment,
    this.deliverables,
    this.puja,
    this.sankalpNotes,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.bookingId,
    this.participantCount,
    this.isPaid,
    this.canCancel,
    this.statusHistory,
  });

  MyBookingDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    pujaSnapshot = json['pujaSnapshot'] != null
        ? PujaSnapshot.fromJson(json['pujaSnapshot'])
        : null;
    packageSnapshot = json['packageSnapshot'] != null
        ? PackageSnapshot.fromJson(json['packageSnapshot'])
        : null;
    if (json['participants'] != null) {
      participants = <ParticipantInfo>[];
      json['participants'].forEach((v) {
        participants!.add(ParticipantInfo.fromJson(v));
      });
    }
    prasadDelivery = json['prasadDelivery'] != null
        ? PrasadDelivery.fromJson(json['prasadDelivery'])
        : null;
    pricing = json['pricing'] != null
        ? BookingPricing.fromJson(json['pricing'])
        : null;
    payment = json['payment'] != null
        ? BookingPayment.fromJson(json['payment'])
        : null;
    deliverables = json['deliverables'] != null
        ? BookingDeliverables.fromJson(json['deliverables'])
        : null;
    puja = json['puja'] != null ? PujaInfo.fromJson(json['puja']) : null;
    sankalpNotes = json['sankalpNotes'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bookingId = json['bookingId'];
    participantCount = json['participantCount'];
    isPaid = json['isPaid'];
    canCancel = json['canCancel'];
    if (json['statusHistory'] != null) {
      statusHistory = <StatusHistoryItem>[];
      json['statusHistory'].forEach((v) {
        statusHistory!.add(StatusHistoryItem.fromJson(v));
      });
    }
  }

  String get formattedStatus {
    switch (status) {
      case 'pending_payment':
        return 'Payment Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status?.replaceAll('_', ' ').toUpperCase() ?? 'Unknown';
    }
  }

  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return createdAt ?? '';
    }
  }
}

/// Puja snapshot model
class PujaSnapshot {
  String? name;
  String? templeId;
  String? templeName;

  PujaSnapshot({this.name, this.templeId, this.templeName});

  PujaSnapshot.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    templeId = json['templeId'];
    templeName = json['templeName'];
  }
}

/// Package snapshot model
class PackageSnapshot {
  int? packageIndex;
  int? personCount;
  String? packageName;
  List<String>? inclusions;
  double? price;

  PackageSnapshot({
    this.packageIndex,
    this.personCount,
    this.packageName,
    this.inclusions,
    this.price,
  });

  PackageSnapshot.fromJson(Map<String, dynamic> json) {
    packageIndex = json['packageIndex'];
    personCount = json['personCount'];
    packageName = json['packageName'];
    inclusions = json['inclusions'] != null
        ? List<String>.from(json['inclusions'])
        : null;
    price = json['price']?.toDouble();
  }
}

/// Participant info model
class ParticipantInfo {
  String? name;
  String? gotra;
  String? mobile;
  String? whatsApp;
  String? nakshatra;
  String? rashi;
  String? relation;

  ParticipantInfo({
    this.name,
    this.gotra,
    this.mobile,
    this.whatsApp,
    this.nakshatra,
    this.rashi,
    this.relation,
  });

  ParticipantInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gotra = json['gotra'];
    mobile = json['mobile'];
    whatsApp = json['whatsApp'];
    nakshatra = json['nakshatra'];
    rashi = json['rashi'];
    relation = json['relation'];
  }
}

/// Prasad delivery model
class PrasadDelivery {
  bool? isRequested;
  String? status;

  PrasadDelivery({this.isRequested, this.status});

  PrasadDelivery.fromJson(Map<String, dynamic> json) {
    isRequested = json['isRequested'];
    status = json['status'];
  }
}

/// Booking pricing model
class BookingPricing {
  double? packagePrice;
  double? discount;
  double? subtotal;
  double? tax;
  TaxBreakup? taxBreakup;
  double? total;
  String? currency;

  BookingPricing({
    this.packagePrice,
    this.discount,
    this.subtotal,
    this.tax,
    this.taxBreakup,
    this.total,
    this.currency,
  });

  BookingPricing.fromJson(Map<String, dynamic> json) {
    packagePrice = json['packagePrice']?.toDouble();
    discount = json['discount']?.toDouble();
    subtotal = json['subtotal']?.toDouble();
    tax = json['tax']?.toDouble();
    taxBreakup = json['taxBreakup'] != null
        ? TaxBreakup.fromJson(json['taxBreakup'])
        : null;
    total = json['total']?.toDouble();
    currency = json['currency'];
  }
}

/// Tax breakup model
class TaxBreakup {
  double? cgst;
  double? sgst;
  double? igst;
  double? gstRate;

  TaxBreakup({this.cgst, this.sgst, this.igst, this.gstRate});

  TaxBreakup.fromJson(Map<String, dynamic> json) {
    cgst = json['cgst']?.toDouble();
    sgst = json['sgst']?.toDouble();
    igst = json['igst']?.toDouble();
    gstRate = json['gstRate']?.toDouble();
  }
}

/// Booking payment model
class BookingPayment {
  String? method;
  String? status;

  BookingPayment({this.method, this.status});

  BookingPayment.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    status = json['status'];
  }
}

/// Booking deliverables model
class BookingDeliverables {
  List<String>? photoUrls;

  BookingDeliverables({this.photoUrls});

  BookingDeliverables.fromJson(Map<String, dynamic> json) {
    photoUrls = json['photoUrls'] != null
        ? List<String>.from(json['photoUrls'])
        : null;
  }
}

/// Puja info for detail
class PujaInfo {
  String? id;
  String? title;
  String? slug;
  TempleInfo? temple;
  List<PackageSnapshot>? packages;

  PujaInfo({this.id, this.title, this.slug, this.temple, this.packages});

  PujaInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    title = json['title'];
    slug = json['slug'];
    temple = json['temple'] != null
        ? TempleInfo.fromJson(json['temple'])
        : null;
    if (json['packages'] != null) {
      packages = <PackageSnapshot>[];
      json['packages'].forEach((v) {
        packages!.add(PackageSnapshot.fromJson(v));
      });
    }
  }
}

/// Temple info model
class TempleInfo {
  String? id;
  String? name;
  List<String>? images;
  String? fullAddress;

  TempleInfo({this.id, this.name, this.images, this.fullAddress});

  TempleInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
    fullAddress = json['fullAddress'];
  }
}

/// Status history item
class StatusHistoryItem {
  String? id;
  String? status;
  String? changedAt;

  StatusHistoryItem({this.id, this.status, this.changedAt});

  StatusHistoryItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    status = json['status'];
    changedAt = json['changedAt'];
  }
}

/// Pagination model
class PaginationModel {
  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? limit;

  PaginationModel({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.limit,
  });

  PaginationModel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    limit = json['limit'];
  }
}

/// Response model for my bookings list
class MyBookingsResponse {
  List<MyBookingItemModel>? items;
  PaginationModel? pagination;

  MyBookingsResponse({this.items, this.pagination});

  MyBookingsResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <MyBookingItemModel>[];
      json['items'].forEach((v) {
        items!.add(MyBookingItemModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? PaginationModel.fromJson(json['pagination'])
        : null;
  }
}
