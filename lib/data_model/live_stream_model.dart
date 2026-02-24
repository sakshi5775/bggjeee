import 'dart:convert';

class LiveStreamModel {
  final String streamId;
  final String astrologerId;
  final String status;
  final String astrologerName;
  final String title;
  final int currentViewers;
  final int totalGifts;
  final DateTime? startedAt;
  final String? astrologerPhoto;
  final List<String>? astrologerSpecializations;

  LiveStreamModel({
    required this.streamId,
    required this.astrologerId,
    required this.status,
    required this.astrologerName,
    required this.title,
    required this.currentViewers,
    required this.totalGifts,
    this.startedAt,
    this.astrologerPhoto,
    this.astrologerSpecializations,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      streamId: json['streamId'] as String? ?? '',
      astrologerId: json['astrologerId'] as String? ?? '',
      status: json['status'] as String? ?? 'PREPARING',
      astrologerName: json['astrologerName'] as String? ?? 'Unknown',
      title: json['title'] as String? ?? '',
      currentViewers: (json['currentViewers'] as num?)?.toInt() ?? 0,
      totalGifts: (json['totalGifts'] as num?)?.toInt() ?? 0,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      astrologerPhoto: json['astrologerPhoto'] as String?,
      astrologerSpecializations:
          (json['astrologerSpecializations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );
  }
}

class LiveStreamResponse {
  final List<LiveStreamModel> streams;
  final LiveStreamPagination pagination;

  LiveStreamResponse({required this.streams, required this.pagination});

  factory LiveStreamResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final paginationData = json['pagination'] as Map<String, dynamic>;

    return LiveStreamResponse(
      streams: data
          .map((e) => LiveStreamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: LiveStreamPagination.fromJson(paginationData),
    );
  }
}

class LiveStreamPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  LiveStreamPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory LiveStreamPagination.fromJson(Map<String, dynamic> json) {
    return LiveStreamPagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}

// Join Stream Response
class JoinStreamResponse {
  final String streamId;
  final String channelName;
  final String viewerToken;
  final String appId;
  final DateTime tokenExpiresAt;
  final String astrologerId;
  final StreamInfo streamInfo;

  JoinStreamResponse({
    required this.streamId,
    required this.channelName,
    required this.viewerToken,
    required this.appId,
    required this.tokenExpiresAt,
    required this.astrologerId,
    required this.streamInfo,
  });

  factory JoinStreamResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return JoinStreamResponse(
      streamId: data['streamId'] as String,
      channelName: data['channelName'] as String,
      viewerToken: data['viewerToken'] as String,
      appId: data['appId'] as String,
      tokenExpiresAt: DateTime.parse(data['tokenExpiresAt'] as String),
      astrologerId: data['astrologer']?['astrologerId'] as String? ?? '',
      streamInfo: StreamInfo.fromJson(
        data['streamInfo'] as Map<String, dynamic>,
      ),
    );
  }
}

class StreamInfo {
  final String title;
  final DateTime startedAt;
  final int currentViewers;

  StreamInfo({
    required this.title,
    required this.startedAt,
    required this.currentViewers,
  });

  factory StreamInfo.fromJson(Map<String, dynamic> json) {
    return StreamInfo(
      title: json['title'] as String? ?? '',
      startedAt: DateTime.parse(json['startedAt'] as String),
      currentViewers: (json['currentViewers'] as num?)?.toInt() ?? 0,
    );
  }
}

// Gift Catalog
class GiftCatalog {
  final List<Gift> gifts;
  final List<Reaction> reactions;

  GiftCatalog({required this.gifts, required this.reactions});

  factory GiftCatalog.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GiftCatalog(
      gifts:
          (data['gifts'] as List<dynamic>?)
              ?.map((e) => Gift.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reactions:
          (data['reactions'] as List<dynamic>?)
              ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Gift {
  final String type;
  final int value;
  final String icon;
  final String name;
  final String description;

  Gift({
    required this.type,
    required this.value,
    required this.icon,
    required this.name,
    required this.description,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      type: json['type'] as String,
      value: (json['value'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );
  }
}

class Reaction {
  final String type;
  final String icon;
  final String name;

  Reaction({required this.type, required this.icon, required this.name});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      type: json['type'] as String,
      icon: json['icon'] as String,
      name: json['name'] as String,
    );
  }
}

// Chat Message
class StreamMessage {
  final String messageId;
  final String senderId;
  final String senderName;
  final String senderType;
  final String messageType; // TEXT or REACTION
  final String? content;
  final String? reactionType;
  final DateTime sentAt;

  StreamMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.messageType,
    this.content,
    this.reactionType,
    required this.sentAt,
  });

  factory StreamMessage.fromJson(Map<String, dynamic> json) {
    return StreamMessage(
      messageId: json['messageId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? 'Anonymous',
      senderType: json['senderType'] as String? ?? 'USER',
      messageType: json['messageType'] as String? ?? 'TEXT',
      content: json['content'] as String?,
      reactionType: json['reactionType'] as String?,
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : DateTime.now(),
    );
  }
}

// Gift Received Event
class GiftReceived {
  final String giftId;
  final String senderId;
  final String? senderName;
  final String giftType;
  final int giftValue;
  final String giftIcon;
  final String giftName;
  final Map<String, dynamic>? animation;

  GiftReceived({
    required this.giftId,
    required this.senderId,
    this.senderName,
    required this.giftType,
    required this.giftValue,
    required this.giftIcon,
    required this.giftName,
    this.animation,
  });

  factory GiftReceived.fromJson(Map<String, dynamic> json) {
    return GiftReceived(
      giftId: json['giftId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String?,
      giftType: json['giftType'] as String,
      giftValue: (json['giftValue'] as num?)?.toInt() ?? 0,
      giftIcon: json['giftIcon'] as String,
      giftName: json['giftName'] as String,
      animation: _parseAnimation(json['animation']),
    );
  }

  static Map<String, dynamic>? _parseAnimation(dynamic anim) {
    try {
      if (anim is Map<String, dynamic>) return anim;
      if (anim is Map) return Map<String, dynamic>.from(anim);
      if (anim is String) {
        final decoded = jsonDecode(anim);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
    return null;
  }
}

// Scheduled Stream Models
class StreamScheduling {
  final bool isScheduled;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  final String title;
  final String description;
  final int estimatedDurationMinutes;
  final int rsvpCount;

  StreamScheduling({
    required this.isScheduled,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.title,
    required this.description,
    required this.estimatedDurationMinutes,
    required this.rsvpCount,
  });

  factory StreamScheduling.fromJson(Map<String, dynamic> json) {
    return StreamScheduling(
      isScheduled: json['isScheduled'] as bool? ?? false,
      scheduledStartTime: DateTime.parse(json['scheduledStartTime'] as String),
      scheduledEndTime: DateTime.parse(json['scheduledEndTime'] as String),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num?)?.toInt() ?? 60,
      rsvpCount: (json['rsvpCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class UpcomingStreamModel {
  final String streamId;
  final String astrologerId;
  final String astrologerName;
  final StreamScheduling scheduling;

  UpcomingStreamModel({
    required this.streamId,
    required this.astrologerId,
    required this.astrologerName,
    required this.scheduling,
  });

  factory UpcomingStreamModel.fromJson(Map<String, dynamic> json) {
    return UpcomingStreamModel(
      streamId: json['streamId'] as String,
      astrologerId: json['astrologerId'] as String,
      astrologerName: json['astrologerName'] as String? ?? 'Unknown',
      scheduling: StreamScheduling.fromJson(
        json['scheduling'] as Map<String, dynamic>,
      ),
    );
  }
}

class UpcomingStreamsResponse {
  final List<UpcomingStreamModel> streams;
  final LiveStreamPagination pagination;

  UpcomingStreamsResponse({required this.streams, required this.pagination});

  factory UpcomingStreamsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final paginationData = json['pagination'] as Map<String, dynamic>;

    return UpcomingStreamsResponse(
      streams: data
          .map((e) => UpcomingStreamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: LiveStreamPagination.fromJson(paginationData),
    );
  }
}

class ScheduledStreamModel {
  final String streamId;
  final String status;
  final StreamScheduling scheduling;
  final int currentViewers;

  ScheduledStreamModel({
    required this.streamId,
    required this.status,
    required this.scheduling,
    required this.currentViewers,
  });

  factory ScheduledStreamModel.fromJson(Map<String, dynamic> json) {
    return ScheduledStreamModel(
      streamId: json['streamId'] as String,
      status: json['status'] as String? ?? 'SCHEDULED',
      scheduling: StreamScheduling.fromJson(
        json['scheduling'] as Map<String, dynamic>,
      ),
      currentViewers: (json['currentViewers'] as num?)?.toInt() ?? 0,
    );
  }
}

class AstrologerScheduleResponse {
  final String astrologerId;
  final List<ScheduledStreamModel> streams;

  AstrologerScheduleResponse({
    required this.astrologerId,
    required this.streams,
  });

  factory AstrologerScheduleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final astrologerData = data['astrologer'] as Map<String, dynamic>;
    final streamsData = data['streams'] as List<dynamic>;

    return AstrologerScheduleResponse(
      astrologerId: astrologerData['astrologerId'] as String,
      streams: streamsData
          .map((e) => ScheduledStreamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// Report Models
class StreamReportResponse {
  final String reportId;
  final String category;
  final String status;
  final DateTime reportedAt;

  StreamReportResponse({
    required this.reportId,
    required this.category,
    required this.status,
    required this.reportedAt,
  });

  factory StreamReportResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return StreamReportResponse(
      reportId: data['reportId'] as String,
      category: data['category'] as String,
      status: data['status'] as String,
      reportedAt: DateTime.parse(data['reportedAt'] as String),
    );
  }
}

class StreamReportModel {
  final String id;
  final String streamId;
  final String category;
  final String status;
  final String reportId;
  final DateTime reportedAt;
  final StreamSnapshot? streamSnapshot;

  StreamReportModel({
    required this.id,
    required this.streamId,
    required this.category,
    required this.status,
    required this.reportId,
    required this.reportedAt,
    this.streamSnapshot,
  });

  factory StreamReportModel.fromJson(Map<String, dynamic> json) {
    return StreamReportModel(
      id: json['_id'] as String,
      streamId: json['streamId'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      reportId: json['reportId'] as String,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      streamSnapshot: json['streamSnapshot'] != null
          ? StreamSnapshot.fromJson(
              json['streamSnapshot'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class StreamSnapshot {
  final String? title;
  final bool wasLive;
  final DateTime reportedAt;
  final int viewerCount;

  StreamSnapshot({
    this.title,
    required this.wasLive,
    required this.reportedAt,
    required this.viewerCount,
  });

  factory StreamSnapshot.fromJson(Map<String, dynamic> json) {
    return StreamSnapshot(
      title: json['title'] as String?,
      wasLive: json['wasLive'] as bool? ?? false,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      viewerCount: (json['viewerCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class StreamReportsResponse {
  final List<StreamReportModel> reports;
  final LiveStreamPagination pagination;

  StreamReportsResponse({required this.reports, required this.pagination});

  factory StreamReportsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final paginationData = json['pagination'] as Map<String, dynamic>;

    return StreamReportsResponse(
      reports: data
          .map((e) => StreamReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: LiveStreamPagination.fromJson(paginationData),
    );
  }
}
