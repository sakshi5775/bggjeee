class CallInitiateResponse {
  final bool success;
  final String message;
  final CallData? data;

  CallInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CallInitiateResponse.fromJson(Map<String, dynamic> json) {
    return CallInitiateResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? CallData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CallData {
  final String callId;
  final String channelName;
  final String token;
  final String appId;
  final int expirySeconds;
  final int timeoutSeconds;
  final int durationMinutes;
  final double pricePerMinute;
  final String astrologerName;
  final String astrologerImage;
  final CostBreakdown? costBreakdown;
  final double? walletBalance; // NEW: Current wallet balance
  final int? availableMinutes; // NEW: Max possible minutes from wallet

  CallData({
    required this.callId,
    required this.channelName,
    required this.token,
    required this.appId,
    required this.expirySeconds,
    required this.timeoutSeconds,
    required this.durationMinutes,
    required this.pricePerMinute,
    required this.astrologerName,
    required this.astrologerImage,
    this.costBreakdown,
    this.walletBalance,
    this.availableMinutes,
  });

  factory CallData.fromJson(Map<String, dynamic> json) {
    // Parse costBreakdown first so we can use it as fallback
    final costBreakdownData = json['costBreakdown'] != null
        ? CostBreakdown.fromJson(json['costBreakdown'] as Map<String, dynamic>)
        : null;

    return CallData(
      callId: json['callId'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      token: json['token'] as String? ?? '',
      appId: json['appId'] as String? ?? '',
      expirySeconds: (json['expirySeconds'] as num?)?.toInt() ?? 3600,
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 60,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      // Try top-level pricePerMinute first, then fallback to costBreakdown.pricePerMinute
      pricePerMinute:
          (json['pricePerMinute'] as num?)?.toDouble() ??
          costBreakdownData?.pricePerMinute ??
          0.0,
      astrologerName: json['astrologerName'] as String? ?? '',
      astrologerImage: json['astrologerImage'] as String? ?? '',
      costBreakdown: costBreakdownData,
      walletBalance: (json['walletBalance'] as num?)?.toDouble(),
      availableMinutes: (json['availableMinutes'] as num?)?.toInt(),
    );
  }
}

class CostBreakdown {
  final String astrologerId;
  final String astrologerName;
  final String callType;
  final int durationMinutes;
  final double pricePerMinute; // RENAMED from ratePerMinute
  final double subtotal;
  final AppliedDiscounts discounts; // RENAMED from appliedDiscounts
  final double totalAmount;
  final double platformFee;
  final double astrologerEarnings;
  final String currency;

  CostBreakdown({
    required this.astrologerId,
    required this.astrologerName,
    required this.callType,
    required this.durationMinutes,
    required this.pricePerMinute,
    required this.subtotal,
    required this.discounts,
    required this.totalAmount,
    required this.platformFee,
    required this.astrologerEarnings,
    required this.currency,
  });

  factory CostBreakdown.fromJson(Map<String, dynamic> json) {
    return CostBreakdown(
      astrologerId: json['astrologerId'] as String? ?? '',
      astrologerName: json['astrologerName'] as String? ?? '',
      callType: json['callType'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      pricePerMinute:
          (json['pricePerMinute'] as num?)?.toDouble() ??
          (json['ratePerMinute'] as num?)?.toDouble() ??
          0.0, // Support both for backward compatibility
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discounts: json['discounts'] != null
          ? AppliedDiscounts.fromJson(json['discounts'] as Map<String, dynamic>)
          : (json['appliedDiscounts'] !=
                    null // Support both for backward compatibility
                ? AppliedDiscounts.fromJson(
                    json['appliedDiscounts'] as Map<String, dynamic>,
                  )
                : AppliedDiscounts.empty()),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      astrologerEarnings:
          (json['astrologerEarnings'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
    );
  }
}

class AppliedDiscounts {
  final FirstSessionDiscount firstSessionDiscount;
  final BulkDiscount bulkDiscount;
  final double totalDiscount;

  AppliedDiscounts({
    required this.firstSessionDiscount,
    required this.bulkDiscount,
    required this.totalDiscount,
  });

  factory AppliedDiscounts.fromJson(Map<String, dynamic> json) {
    // Handle new API structure where discounts might be nested or flat
    final firstSessionData =
        json['firstSessionDiscount'] ??
        json['discounts']?['firstSessionDiscount'];
    final bulkData = json['bulkDiscount'] ?? json['discounts']?['bulkDiscount'];

    return AppliedDiscounts(
      firstSessionDiscount: firstSessionData != null
          ? FirstSessionDiscount.fromJson(
              firstSessionData as Map<String, dynamic>,
            )
          : FirstSessionDiscount.empty(),
      bulkDiscount: bulkData != null
          ? BulkDiscount.fromJson(bulkData as Map<String, dynamic>)
          : BulkDiscount.empty(),
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory AppliedDiscounts.empty() {
    return AppliedDiscounts(
      firstSessionDiscount: FirstSessionDiscount.empty(),
      bulkDiscount: BulkDiscount.empty(),
      totalDiscount: 0.0,
    );
  }
}

class FirstSessionDiscount {
  final bool applied;
  final double percentage;
  final double amount;

  FirstSessionDiscount({
    required this.applied,
    required this.percentage,
    required this.amount,
  });

  factory FirstSessionDiscount.fromJson(Map<String, dynamic> json) {
    return FirstSessionDiscount(
      applied: json['applied'] as bool? ?? false,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory FirstSessionDiscount.empty() {
    return FirstSessionDiscount(applied: false, percentage: 0.0, amount: 0.0);
  }
}

class BulkDiscount {
  final bool applied;
  final double percentage;
  final double amount;

  BulkDiscount({
    required this.applied,
    required this.percentage,
    required this.amount,
  });

  factory BulkDiscount.fromJson(Map<String, dynamic> json) {
    return BulkDiscount(
      applied: json['applied'] as bool? ?? false,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory BulkDiscount.empty() {
    return BulkDiscount(applied: false, percentage: 0.0, amount: 0.0);
  }
}

// REMOVED: SelectedTier class - no longer used in per-minute pricing model
