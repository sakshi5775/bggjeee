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
    return data;
  }
}

class ReportHistoryResponse {
  bool? success;
  ReportHistoryData? data;

  ReportHistoryResponse({this.success, this.data});

  ReportHistoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? ReportHistoryData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReportHistoryData {
  List<ReportHistoryItem>? reports;
  ReportPagination? pagination;

  ReportHistoryData({this.reports, this.pagination});

  ReportHistoryData.fromJson(Map<String, dynamic> json) {
    if (json['reports'] != null) {
      reports = <ReportHistoryItem>[];
      json['reports'].forEach((v) {
        reports!.add(ReportHistoryItem.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? ReportPagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ReportHistoryItem {
  String? id;
  String? reportType;
  String? reportKey;
  String? reportName;
  String? generatedAt;

  ReportHistoryItem({
    this.id,
    this.reportType,
    this.reportKey,
    this.reportName,
    this.generatedAt,
  });

  ReportHistoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportType = json['reportType'];
    reportKey = json['reportKey'];
    reportName = json['reportName'];
    generatedAt = json['generatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reportType'] = reportType;
    data['reportKey'] = reportKey;
    data['reportName'] = reportName;
    data['generatedAt'] = generatedAt;
    return data;
  }
}

class ReportPagination {
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  bool? hasMore;

  ReportPagination({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasMore,
  });

  ReportPagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPages'] = totalPages;
    data['hasMore'] = hasMore;
    return data;
  }
}
