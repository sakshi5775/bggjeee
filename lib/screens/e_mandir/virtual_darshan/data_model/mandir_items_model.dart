class MandirItemsResponse {
  final bool success;
  final String message;
  final MandirItemsData? data;

  MandirItemsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MandirItemsResponse.fromJson(Map<String, dynamic> json) {
    return MandirItemsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? MandirItemsData.fromJson(json['data'])
          : null,
    );
  }
}

class MandirItemsData {
  final List<BellItem> bells;
  final List<UpperMandirFrontItem> upperMandirFront;
  final int total;

  MandirItemsData({
    required this.bells,
    required this.upperMandirFront,
    required this.total,
  });

  factory MandirItemsData.fromJson(Map<String, dynamic> json) {
    return MandirItemsData(
      bells:
          (json['bells'] as List<dynamic>?)
              ?.map((e) => BellItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      upperMandirFront:
          (json['upperMandirFront'] as List<dynamic>?)
              ?.map(
                (e) => UpperMandirFrontItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}

class BellItem {
  final String id;
  final String leftBell;
  final String rightBell;

  BellItem({required this.id, required this.leftBell, required this.rightBell});

  factory BellItem.fromJson(Map<String, dynamic> json) {
    return BellItem(
      id: json['_id'] ?? '',
      leftBell: json['leftBell'] ?? '',
      rightBell: json['rightBell'] ?? '',
    );
  }
}

class UpperMandirFrontItem {
  final String id;
  final String image;

  UpperMandirFrontItem({required this.id, required this.image});

  factory UpperMandirFrontItem.fromJson(Map<String, dynamic> json) {
    return UpperMandirFrontItem(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
