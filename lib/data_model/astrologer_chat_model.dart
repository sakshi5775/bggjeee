import 'package:flutter/foundation.dart';

class AstrologerChatSession {
  final String chatId;
  final String
  status; // CREATED, ACTIVE, PAUSED, COMPLETED, EXPIRED, CANCELLED, REFUNDED
  final String? userId;
  final String astrologerId;
  final BillingConfig billingConfig;
  final String? paymentStatus;
  final double? amountPaid; // Total amount charged
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt; // Removed expiresAt
  final MessageStats messageStats;

  // New billing fields
  final int? totalMinutesBilled;
  final double? totalAmount;
  final double? walletBalance;
  final int? availableMinutes;

  // UX Display helpers
  final int? elapsedSeconds;
  final UserRating? userRating;

  AstrologerChatSession({
    required this.chatId,
    required this.status,
    this.userId,
    required this.astrologerId,
    required this.billingConfig,
    this.paymentStatus,
    this.amountPaid,
    this.createdAt,
    this.startedAt,
    this.completedAt,
    required this.messageStats,
    this.totalMinutesBilled,
    this.totalAmount,
    this.walletBalance,
    this.availableMinutes,
    this.elapsedSeconds,
    this.userRating,
  });

  factory AstrologerChatSession.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) print('Parsing Session JSON: $json');

    // Robust ID extraction
    String extractedAstrologerId = '';
    if (json['astrologerId'] != null) {
      extractedAstrologerId = json['astrologerId'].toString();
    } else if (json['astrologer_id'] != null) {
      extractedAstrologerId = json['astrologer_id'].toString();
    } else if (json['astrologer'] != null) {
      if (json['astrologer'] is Map) {
        final astroData = json['astrologer'] as Map<String, dynamic>;
        extractedAstrologerId =
            (astroData['astrologerId'] ??
                    astroData['id'] ??
                    astroData['_id'] ??
                    '')
                .toString();
      } else {
        extractedAstrologerId = json['astrologer'].toString();
      }
    }

    // Final fallback: check for likely ID fields if still empty
    if (extractedAstrologerId.isEmpty) {
      extractedAstrologerId = (json['receiverId'] ?? json['otherPartyId'] ?? '')
          .toString();
    }

    // If still empty, use a default value (API history endpoint doesn't always include astrologerId)
    if (extractedAstrologerId.isEmpty) {
      extractedAstrologerId = 'unknown';
      if (kDebugMode) {
        print('Warning: astrologerId not found in session data, using default');
      }
    }

    return AstrologerChatSession(
      chatId: (json['chatId'] ?? json['id'] ?? json['_id'] ?? '').toString(),
      status: json['status'] as String? ?? 'CREATED',
      userId: json['userId'] as String?,
      astrologerId: extractedAstrologerId,
      billingConfig: json['billingConfig'] != null
          ? BillingConfig.fromJson(
              json['billingConfig'] as Map<String, dynamic>,
            )
          : BillingConfig(pricePerMinute: 0, currency: 'INR'),
      paymentStatus: json['paymentStatus'] as String?,
      amountPaid: (json['amountPaid'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      messageStats: json['messageStats'] != null
          ? MessageStats.fromJson(json['messageStats'] as Map<String, dynamic>)
          : MessageStats(
              totalMessages: 0,
              userMessages: 0,
              astrologerMessages: 0,
              imagesShared: 0,
            ),
      totalMinutesBilled:
          (json['totalMinutesBilled'] as num? ?? json['minutes_billed'] as num?)
              ?.toInt(),
      totalAmount:
          (json['totalAmount'] as num? ??
                  json['amount_deducted'] as num? ??
                  json['total_amount'] as num?)
              ?.toDouble(),
      walletBalance:
          (json['walletBalance'] as num? ??
                  json['wallet_balance'] as num? ??
                  json['remainingBalance'] as num? ??
                  json['remaining_balance'] as num? ??
                  json['balance'] as num? ??
                  (json['wallet'] is Map
                      ? (json['wallet'] as Map)['balance'] as num?
                      : null))
              ?.toDouble(),
      availableMinutes:
          (json['availableMinutes'] as num? ??
                  json['available_minutes'] as num? ??
                  json['minutesRemaining'] as num? ??
                  json['minutes_remaining'] as num?)
              ?.toInt(),
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt(),
      userRating:
          json['userRating'] != null &&
              (json['userRating'] is Map) &&
              (json['userRating'] as Map).isNotEmpty
          ? UserRating.fromJson(json['userRating'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BillingConfig {
  final double pricePerMinute;
  final String currency;

  BillingConfig({required this.pricePerMinute, required this.currency});

  factory BillingConfig.fromJson(Map<String, dynamic> json) {
    return BillingConfig(
      pricePerMinute:
          (json['pricePerMinute'] as num? ??
                  json['price_per_minute'] as num? ??
                  json['pricePerMessage'] as num?)
              ?.toDouble() ??
          0.0,
      currency: json['currency'] as String? ?? 'INR',
    );
  }
}

class MessageStats {
  final int totalMessages;
  final int userMessages;
  final int astrologerMessages;
  final int imagesShared;

  MessageStats({
    required this.totalMessages,
    required this.userMessages,
    required this.astrologerMessages,
    required this.imagesShared,
  });

  factory MessageStats.fromJson(Map<String, dynamic> json) {
    return MessageStats(
      totalMessages: (json['totalMessages'] as num?)?.toInt() ?? 0,
      userMessages: (json['userMessages'] as num?)?.toInt() ?? 0,
      astrologerMessages: (json['astrologerMessages'] as num?)?.toInt() ?? 0,
      imagesShared: (json['imagesShared'] as num?)?.toInt() ?? 0,
    );
  }
}

class UserRating {
  final int rating;
  final String review;
  final DateTime? ratedAt;

  UserRating({required this.rating, required this.review, this.ratedAt});

  factory UserRating.fromJson(Map<String, dynamic> json) {
    return UserRating(
      rating: (json['rating'] as num).toInt(),
      review: json['review'] as String? ?? '',
      ratedAt: json['ratedAt'] != null
          ? DateTime.parse(json['ratedAt'] as String)
          : null,
    );
  }
}

class ReplyData {
  final String messageId;
  final String? senderId;
  final String? senderType;
  final String snippet; // Preview text or "Image"
  final String? messageType; // TEXT, IMAGE

  ReplyData({
    required this.messageId,
    this.senderId,
    this.senderType,
    required this.snippet,
    this.messageType,
  });

  factory ReplyData.fromJson(Map<String, dynamic> json) {
    return ReplyData(
      messageId:
          json['messageId'] as String? ??
          json['replyToMessageId'] as String? ??
          '',
      senderId:
          json['senderId'] as String? ?? json['replyToSenderId'] as String?,
      senderType: json['senderType'] as String?,
      snippet:
          json['snippet'] as String? ?? json['replyToSnippet'] as String? ?? '',
      messageType: json['messageType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'replyToMessageId': messageId,
      if (senderId != null) 'replyToSenderId': senderId,
      'replyToSnippet': snippet,
      if (messageType != null) 'messageType': messageType,
    };
  }
}

class AstrologerChatMessage {
  final String messageId;
  final String chatId;
  final String senderId;
  final String senderType; // USER, ASTROLOGER, SYSTEM
  final String messageType; // TEXT, IMAGE
  final String? content;
  final ImageData? imageData;
  final String status; // SENDING, SENT, DELIVERED, READ, FAILED
  final DateTime sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;
  final String? clientMessageId;
  final ReplyData? replyTo; // Reply/quote data

  AstrologerChatMessage({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.senderType,
    required this.messageType,
    this.content,
    this.imageData,
    required this.status,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.metadata,
    this.clientMessageId,
    this.replyTo,
  });

  factory AstrologerChatMessage.fromJson(Map<String, dynamic> json) {
    // Determine message type
    final messageType = json['messageType'] as String? ?? 'TEXT';

    // Handle imageData - check multiple possible locations and formats
    ImageData? imageData;

    // Try direct imageData field first
    if (json['imageData'] != null) {
      if (json['imageData'] is Map) {
        try {
          imageData = ImageData.fromJson(
            json['imageData'] as Map<String, dynamic>,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing imageData: $e');
          }
        }
      }
    }

    // If messageType is IMAGE but imageData is null, try to construct from available fields
    if (messageType == 'IMAGE' && imageData == null) {
      // Check if image info is in the message itself (sometimes backend sends it directly)
      if (json['url'] != null || json['imageUrl'] != null) {
        try {
          imageData = ImageData(
            url: json['url'] as String? ?? json['imageUrl'] as String? ?? '',
            thumbnailUrl: json['thumbnailUrl'] as String?,
            filename: json['filename'] as String? ?? 'image.jpg',
            size: (json['size'] as num?)?.toInt() ?? 0,
            mimeType: json['mimeType'] as String? ?? 'image/jpeg',
            s3Key: json['s3Key'] as String?,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error constructing ImageData from direct fields: $e');
          }
        }
      }
    }

    return AstrologerChatMessage(
      messageId: json['messageId'] as String? ?? '',
      chatId: json['chatId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderType: json['senderType'] as String? ?? 'USER',
      messageType: messageType,
      content: json['content'] as String?,
      imageData: imageData,
      status: json['status'] as String? ?? 'SENT',
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : DateTime.now(),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      clientMessageId:
          json['metadata']?['clientMessageId'] as String? ??
          json['clientMessageId'] as String?,
      replyTo: json['replyTo'] != null && json['replyTo'] is Map
          ? ReplyData.fromJson(json['replyTo'] as Map<String, dynamic>)
          : (json['replyToMessageId'] != null || json['replyToSnippet'] != null)
          ? ReplyData.fromJson(json)
          : null,
    );
  }

  bool get isUser => senderType == 'USER';
  bool get isAstrologer => senderType == 'ASTROLOGER';
  bool get isText => messageType == 'TEXT';
  bool get isImage => messageType == 'IMAGE';

  AstrologerChatMessage copyWith({
    String? messageId,
    String? chatId,
    String? senderId,
    String? senderType,
    String? messageType,
    String? content,
    ImageData? imageData,
    String? status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    Map<String, dynamic>? metadata,
    String? clientMessageId,
    ReplyData? replyTo,
  }) {
    return AstrologerChatMessage(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageData: imageData ?? this.imageData,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      metadata: metadata ?? this.metadata,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}

class ImageData {
  final String url;
  final String? thumbnailUrl;
  final String filename;
  final int size;
  final String mimeType;
  final String? s3Key;

  ImageData({
    required this.url,
    this.thumbnailUrl,
    required this.filename,
    required this.size,
    required this.mimeType,
    this.s3Key,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      filename: json['filename'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      s3Key: json['s3Key'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'filename': filename,
      'size': size,
      'mimeType': mimeType,
      if (s3Key != null) 's3Key': s3Key,
    };
  }
}
