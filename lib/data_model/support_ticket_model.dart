class SupportTicketModel {
  final String? id;
  final String ticketId;
  final String reporterId;
  final String reporterModel;
  final String reporterObjectId;
  final String category;
  final String priority;
  final String status;
  final String? assignedTo;
  final String? assignedToUserId;
  final List<String> tags;
  final String subject;
  final String description;
  final List<Attachment> attachments;
  final bool unreadByReporter;
  final bool unreadByAdmin;
  final String? lastReplyAt;
  final String? lastReplyBy;
  final String? resolvedAt;
  final String? closedAt;
  final List<StatusHistory> statusHistory;
  final String createdAt;
  final String updatedAt;

  SupportTicketModel({
    this.id,
    required this.ticketId,
    required this.reporterId,
    required this.reporterModel,
    required this.reporterObjectId,
    required this.category,
    required this.priority,
    required this.status,
    this.assignedTo,
    this.assignedToUserId,
    required this.tags,
    required this.subject,
    required this.description,
    required this.attachments,
    required this.unreadByReporter,
    required this.unreadByAdmin,
    this.lastReplyAt,
    this.lastReplyBy,
    this.resolvedAt,
    this.closedAt,
    required this.statusHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['_id']?.toString(),
      ticketId: json['ticketId']?.toString() ?? '',
      reporterId: json['reporterId']?.toString() ?? '',
      reporterModel: json['reporterModel']?.toString() ?? '',
      reporterObjectId: json['reporterObjectId']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      assignedTo: json['assignedTo']?.toString(),
      assignedToUserId: json['assignedToUserId']?.toString(),
      tags: json['tags'] != null
          ? List<String>.from(json['tags'].map((x) => x.toString()))
          : [],
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((x) => Attachment.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
      unreadByReporter: json['unreadByReporter'] == true,
      unreadByAdmin: json['unreadByAdmin'] == true,
      lastReplyAt: json['lastReplyAt']?.toString(),
      lastReplyBy: json['lastReplyBy']?.toString(),
      resolvedAt: json['resolvedAt']?.toString(),
      closedAt: json['closedAt']?.toString(),
      statusHistory: json['statusHistory'] != null
          ? (json['statusHistory'] as List)
              .map((x) => StatusHistory.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ticketId': ticketId,
      'reporterId': reporterId,
      'reporterModel': reporterModel,
      'reporterObjectId': reporterObjectId,
      'category': category,
      'priority': priority,
      'status': status,
      'assignedTo': assignedTo,
      'assignedToUserId': assignedToUserId,
      'tags': tags,
      'subject': subject,
      'description': description,
      'attachments': attachments.map((x) => x.toJson()).toList(),
      'unreadByReporter': unreadByReporter,
      'unreadByAdmin': unreadByAdmin,
      'lastReplyAt': lastReplyAt,
      'lastReplyBy': lastReplyBy,
      'resolvedAt': resolvedAt,
      'closedAt': closedAt,
      'statusHistory': statusHistory.map((x) => x.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Attachment {
  final String? id;
  final String url;
  final String originalName;
  final String mimeType;
  final int size;
  final String uploadedAt;

  Attachment({
    this.id,
    required this.url,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.uploadedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['_id']?.toString(),
      url: json['url']?.toString() ?? '',
      originalName: json['originalName']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      size: json['size'] is int ? json['size'] : int.tryParse(json['size']?.toString() ?? '0') ?? 0,
      uploadedAt: json['uploadedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'originalName': originalName,
      'mimeType': mimeType,
      'size': size,
      'uploadedAt': uploadedAt,
    };
  }
}

class StatusHistory {
  final String? status;
  final String? changedAt;
  final String? changedBy;

  StatusHistory({
    this.status,
    this.changedAt,
    this.changedBy,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      status: json['status']?.toString(),
      changedAt: json['changedAt']?.toString(),
      changedBy: json['changedBy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'changedAt': changedAt,
      'changedBy': changedBy,
    };
  }
}

class TicketActivity {
  final String? id;
  final String activityId;
  final String ticketId;
  final String ticketObjectId;
  final String senderId;
  final String senderModel;
  final String senderObjectId;
  final String activityType;
  final String message;
  final List<Attachment> attachments;
  final bool isInternal;
  final Map<String, dynamic>? metadata;
  final String createdAt;
  final String updatedAt;

  TicketActivity({
    this.id,
    required this.activityId,
    required this.ticketId,
    required this.ticketObjectId,
    required this.senderId,
    required this.senderModel,
    required this.senderObjectId,
    required this.activityType,
    required this.message,
    required this.attachments,
    required this.isInternal,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketActivity.fromJson(Map<String, dynamic> json) {
    return TicketActivity(
      id: json['_id']?.toString(),
      activityId: json['activityId']?.toString() ?? '',
      ticketId: json['ticketId']?.toString() ?? '',
      ticketObjectId: json['ticketObjectId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderModel: json['senderModel']?.toString() ?? '',
      senderObjectId: json['senderObjectId']?.toString() ?? '',
      activityType: json['activityType']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((x) => Attachment.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
      isInternal: json['isInternal'] == true,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'activityId': activityId,
      'ticketId': ticketId,
      'ticketObjectId': ticketObjectId,
      'senderId': senderId,
      'senderModel': senderModel,
      'senderObjectId': senderObjectId,
      'activityType': activityType,
      'message': message,
      'attachments': attachments.map((x) => x.toJson()).toList(),
      'isInternal': isInternal,
      'metadata': metadata,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class TicketListResponse {
  final List<SupportTicketModel> items;
  final Pagination pagination;

  TicketListResponse({
    required this.items,
    required this.pagination,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) {
    return TicketListResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((x) => SupportTicketModel.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : Pagination(
              totalItems: 0,
              currentPage: 1,
              totalPages: 1,
              hasNextPage: false,
              hasPrevPage: false,
              limit: 10,
            ),
    );
  }
}

class Pagination {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int limit;

  Pagination({
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['totalItems'] is int ? json['totalItems'] : int.tryParse(json['totalItems']?.toString() ?? '0') ?? 0,
      currentPage: json['currentPage'] is int ? json['currentPage'] : int.tryParse(json['currentPage']?.toString() ?? '1') ?? 1,
      totalPages: json['totalPages'] is int ? json['totalPages'] : int.tryParse(json['totalPages']?.toString() ?? '1') ?? 1,
      hasNextPage: json['hasNextPage'] == true,
      hasPrevPage: json['hasPrevPage'] == true,
      limit: json['limit'] is int ? json['limit'] : int.tryParse(json['limit']?.toString() ?? '10') ?? 10,
    );
  }
}

class TicketDetailResponse {
  final SupportTicketModel ticket;
  final List<TicketActivity> activities;

  TicketDetailResponse({
    required this.ticket,
    required this.activities,
  });

  factory TicketDetailResponse.fromJson(Map<String, dynamic> json) {
    return TicketDetailResponse(
      ticket: SupportTicketModel.fromJson(json['ticket'] as Map<String, dynamic>),
      activities: json['activities'] != null
          ? (json['activities'] as List)
              .map((x) => TicketActivity.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}




