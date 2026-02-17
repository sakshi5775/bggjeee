class AiPricingResponse {
  final bool success;
  final List<AiPricingData> data;

  AiPricingResponse({required this.success, required this.data});

  factory AiPricingResponse.fromJson(Map<String, dynamic> json) {
    return AiPricingResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => AiPricingData.fromJson(e))
          .toList(),
    );
  }
}

class AiPricingData {
  final String key;
  final double cost;
  final String displayName;
  final double priceOffer;
  final String serviceType;

  AiPricingData({
    required this.key,
    required this.cost,
    required this.displayName,
    required this.priceOffer,
    required this.serviceType,
  });

  factory AiPricingData.fromJson(Map<String, dynamic> json) {
    return AiPricingData(
      key: json['key'] ?? '',
      cost: (json['cost'] ?? 0).toDouble(),
      displayName: json['displayName'] ?? '',
      priceOffer: (json['priceOffer'] ?? 0).toDouble(),
      serviceType: json['serviceType'] ?? '',
    );
  }
}
