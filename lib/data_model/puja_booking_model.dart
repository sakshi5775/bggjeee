/// Model for participant details in puja booking
class ParticipantModel {
  String? name;
  String? gotra;
  String? mobile;
  String? whatsApp;
  String? nakshatra;
  String? rashi;
  String? relation;

  ParticipantModel({
    this.name,
    this.gotra,
    this.mobile,
    this.whatsApp,
    this.nakshatra,
    this.rashi,
    this.relation,
  });

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gotra = json['gotra'];
    mobile = json['mobile'];
    whatsApp = json['whatsApp'];
    nakshatra = json['nakshatra'];
    rashi = json['rashi'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (gotra != null) data['gotra'] = gotra;
    if (mobile != null) data['mobile'] = mobile;
    if (whatsApp != null) data['whatsApp'] = whatsApp;
    if (nakshatra != null) data['nakshatra'] = nakshatra;
    if (rashi != null) data['rashi'] = rashi;
    if (relation != null) data['relation'] = relation;
    return data;
  }
}

/// Model for puja booking request
class PujaBookingRequest {
  String? puja;
  int? packageIndex;
  List<ParticipantModel>? participants;
  String? sankalpNotes;
  String? savedAddressId;

  PujaBookingRequest({
    this.puja,
    this.packageIndex,
    this.participants,
    this.sankalpNotes,
    this.savedAddressId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['puja'] = puja ?? '';
    data['packageIndex'] = packageIndex ?? 0;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    if (sankalpNotes != null && sankalpNotes!.isNotEmpty) {
      data['sankalpNotes'] = sankalpNotes;
    }
    data['savedAddressId'] = savedAddressId ?? '';
    return data;
  }
}

/// Model for puja booking response
class PujaBookingResponse {
  String? id;
  String? bookingNumber;
  String? status;
  String? message;

  PujaBookingResponse({this.id, this.bookingNumber, this.status, this.message});

  PujaBookingResponse.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    bookingNumber = json['bookingNumber'];
    status = json['status'];
    message = json['message'];
  }
}
