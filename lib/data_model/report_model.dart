class ReportPricingResponse {
  bool? success;
  List<ReportPricing>? data;

  ReportPricingResponse({this.success, this.data});

  ReportPricingResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ReportPricing>[];
      json['data'].forEach((v) {
        data!.add(ReportPricing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportPricing {
  String? key;
  String? displayName;
  int? pages;
  int? cost;
  int? priceOffer;
  String? reportType;
  String? variant;

  ReportPricing({
    this.key,
    this.displayName,
    this.pages,
    this.cost,
    this.priceOffer,
    this.reportType,
    this.variant,
  });

  ReportPricing.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    displayName = json['displayName'];
    pages = json['pages'];
    cost = json['cost'];
    priceOffer = json['priceOffer'];
    reportType = json['reportType'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['displayName'] = displayName;
    data['pages'] = pages;
    data['cost'] = cost;
    data['priceOffer'] = priceOffer;
    data['reportType'] = reportType;
    data['variant'] = variant;
    return data;
  }
}

class ReportGenerateResponse {
  int? status;
  String? downloadUrl;

  ReportGenerateResponse({this.status, this.downloadUrl});

  ReportGenerateResponse.fromJson(dynamic json) {
    if (json is Map) {
      status = json['status'];
      downloadUrl =
          json['downloadUrl']?.toString() ??
          json['url']?.toString() ??
          json['pdf_url']?.toString() ??
          json['pdfUrl']?.toString() ??
          (json['data'] is String ? json['data'] : null);
    } else if (json is String) {
      downloadUrl = json;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['downloadUrl'] = downloadUrl;
    return data;
  }
}
