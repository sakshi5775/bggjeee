class CoinActionsResponse {
  final bool success;
  final String message;
  final List<CoinAction> coinActions;

  CoinActionsResponse({
    required this.success,
    required this.message,
    required this.coinActions,
  });

  factory CoinActionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return CoinActionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      coinActions:
          (data?['coinActions'] as List<dynamic>?)
              ?.map((e) => CoinAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CoinAction {
  final String id;
  final String actionKey;
  final String actionName;
  final String description;
  final int coins;

  CoinAction({
    required this.id,
    required this.actionKey,
    required this.actionName,
    required this.description,
    required this.coins,
  });

  factory CoinAction.fromJson(Map<String, dynamic> json) {
    return CoinAction(
      id: json['_id'] ?? '',
      actionKey: json['actionKey'] ?? '',
      actionName: json['actionName'] ?? '',
      description: json['description'] ?? '',
      coins: json['coins'] ?? 0,
    );
  }
}
