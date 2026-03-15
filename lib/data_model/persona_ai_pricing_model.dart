/// Persona AI pricing from user-management-service (GET /api/users/voice-persona/{personaId}/pricing).
/// Used for display and wallet pre-check per PersonaAIPricing doc.
class PersonaAIPricingModel {
  final String personaId;
  final String personaName;
  final double callPricePerMinute;
  final double chatPricePerMinute;
  final String currency;
  final bool isOfferActive;
  /// Aggregated offer price (first non-null of offerChat/offerCall)
  final double? offerPricePerMinute;
  /// Aggregated original price (for strike-through UI)
  final double? originalPricePerMinute;
  final double? offerChatPricePerMinute;
  final double? offerCallPricePerMinute;
  final double? originalChatPricePerMinute;
  final double? originalCallPricePerMinute;

  PersonaAIPricingModel({
    required this.personaId,
    required this.personaName,
    required this.callPricePerMinute,
    required this.chatPricePerMinute,
    this.currency = 'INR',
    this.isOfferActive = false,
    this.offerPricePerMinute,
    this.originalPricePerMinute,
    this.offerChatPricePerMinute,
    this.offerCallPricePerMinute,
    this.originalChatPricePerMinute,
    this.originalCallPricePerMinute,
  });

  factory PersonaAIPricingModel.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] as Map<String, dynamic>? ?? json;
    return PersonaAIPricingModel(
      personaId: (json['personaId'] ?? json['persona_id'])?.toString() ?? '',
      personaName: (json['personaName'] ?? json['persona_name'])?.toString() ?? '',
      callPricePerMinute: (pricing['callPricePerMinute'] as num?)?.toDouble() ?? 0,
      chatPricePerMinute: (pricing['chatPricePerMinute'] as num?)?.toDouble() ?? 0,
      currency: (pricing['currency'] ?? 'INR') as String,
      isOfferActive: pricing['isOfferActive'] as bool? ?? false,
      offerPricePerMinute: (pricing['offerPricePerMinute'] as num?)?.toDouble(),
      originalPricePerMinute: (pricing['originalPricePerMinute'] as num?)?.toDouble(),
      offerChatPricePerMinute: (pricing['offerChatPricePerMinute'] as num?)?.toDouble(),
      offerCallPricePerMinute: (pricing['offerCallPricePerMinute'] as num?)?.toDouble(),
      originalChatPricePerMinute: (pricing['originalChatPricePerMinute'] as num?)?.toDouble(),
      originalCallPricePerMinute: (pricing['originalCallPricePerMinute'] as num?)?.toDouble(),
    );
  }

  /// Effective chat price (offer if active, else base)
  double get effectiveChatPricePerMinute {
    if (isOfferActive && (offerChatPricePerMinute ?? offerPricePerMinute) != null) {
      return (offerChatPricePerMinute ?? offerPricePerMinute)!;
    }
    return chatPricePerMinute;
  }

  /// Effective call price (offer if active, else base)
  double get effectiveCallPricePerMinute {
    if (isOfferActive && (offerCallPricePerMinute ?? offerPricePerMinute) != null) {
      return (offerCallPricePerMinute ?? offerPricePerMinute)!;
    }
    return callPricePerMinute;
  }

  bool get isChatFree => effectiveChatPricePerMinute <= 0;
  bool get isCallFree => effectiveCallPricePerMinute <= 0;
}
