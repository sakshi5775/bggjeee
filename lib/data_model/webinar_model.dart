class WebinarModel {
  String? id;
  Scheduling? scheduling;
  TokenInfo? broadcasterToken;
  ViewerStats? viewerStats;
  QaStats? qaStats;
  Recording? recording;
  CourseId? courseId;
  String? lectureId;
  String? hostId;
  String? hostName;
  String? title;
  String? description;
  String? thumbnail;
  String? status;
  String? createdBy;
  String? webinarId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? agoraChannelName;
  String? updatedBy;
  String? startedAt;
  bool? isUpcoming;
  bool? canJoin;
  String? endReason;
  String? endedAt;
  int? totalDuration;
  String? hostImage; // Added definition

  int? rsvpCount;
  int? questionCount;

  WebinarModel({
    this.id,
    this.scheduling,
    this.broadcasterToken,
    this.viewerStats,
    this.qaStats,
    this.recording,
    this.courseId,
    this.lectureId,
    this.hostId,
    this.hostName,
    this.title,
    this.description,
    this.thumbnail,
    this.status,
    this.createdBy,
    this.webinarId,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.agoraChannelName,
    this.updatedBy,
    this.startedAt,
    this.isUpcoming,
    this.canJoin,
    this.endReason,
    this.endedAt,
    this.totalDuration,
    this.hostImage,
    this.rsvpCount,
    this.questionCount,
  });

  WebinarModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    scheduling = json['scheduling'] != null
        ? Scheduling.fromJson(json['scheduling'])
        : null;
    broadcasterToken = json['broadcasterToken'] != null
        ? TokenInfo.fromJson(json['broadcasterToken'])
        : null;
    viewerStats = json['viewerStats'] != null
        ? ViewerStats.fromJson(json['viewerStats'])
        : null;
    qaStats = json['qaStats'] != null
        ? QaStats.fromJson(json['qaStats'])
        : null;
    recording = json['recording'] != null
        ? Recording.fromJson(json['recording'])
        : null;
    courseId = json['courseId'] != null
        ? CourseId.fromJson(json['courseId'])
        : null;
    lectureId = json['lectureId'];
    hostId = json['hostId'];
    hostName = json['hostName'];
    title = json['title'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    createdBy = json['createdBy'];
    webinarId = json['webinarId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    agoraChannelName = json['agoraChannelName'];
    updatedBy = json['updatedBy'];
    startedAt = json['startedAt'];
    isUpcoming = json['isUpcoming'];
    canJoin = json['canJoin'];
    endReason = json['endReason'];
    endedAt = json['endedAt'];
    totalDuration = json['totalDuration'];
    hostImage = json['hostImage'];
    rsvpCount = json['rsvpCount'];
    questionCount = json['questionCount'];
  }
}

class Scheduling {
  bool? isScheduled;
  DateTime? scheduledStartTime;
  int? estimatedDurationMinutes;
  DateTime? scheduledEndTime;

  Scheduling({
    this.isScheduled,
    this.scheduledStartTime,
    this.estimatedDurationMinutes,
    this.scheduledEndTime,
  });

  Scheduling.fromJson(Map<String, dynamic> json) {
    isScheduled = json['isScheduled'];
    scheduledStartTime = json['scheduledStartTime'] != null
        ? DateTime.tryParse(json['scheduledStartTime'])
        : null;
    estimatedDurationMinutes = json['estimatedDurationMinutes'];
    scheduledEndTime = json['scheduledEndTime'] != null
        ? DateTime.tryParse(json['scheduledEndTime'])
        : null;
  }
}

class TokenInfo {
  String? token;
  String? generatedAt;
  String? expiresAt;

  TokenInfo({this.token, this.generatedAt, this.expiresAt});

  TokenInfo.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    generatedAt = json['generatedAt'];
    expiresAt = json['expiresAt'];
  }
}

class ViewerStats {
  int? totalViewers;
  int? peakConcurrentViewers;
  int? currentViewers;

  ViewerStats({
    this.totalViewers,
    this.peakConcurrentViewers,
    this.currentViewers,
  });

  ViewerStats.fromJson(Map<String, dynamic> json) {
    totalViewers = json['totalViewers'];
    peakConcurrentViewers = json['peakConcurrentViewers'];
    currentViewers = json['currentViewers'];
  }
}

class QaStats {
  int? totalQuestions;
  int? answeredQuestions;

  QaStats({this.totalQuestions, this.answeredQuestions});

  QaStats.fromJson(Map<String, dynamic> json) {
    totalQuestions = json['totalQuestions'];
    answeredQuestions = json['answeredQuestions'];
  }
}

class Recording {
  bool? enabled;
  String? status;

  Recording({this.enabled, this.status});

  Recording.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    status = json['status'];
  }
}

class CourseId {
  String? sId;
  String? title;
  String? thumbnail;
  String? slug;
  String? id;

  CourseId({this.sId, this.title, this.thumbnail, this.slug, this.id});

  CourseId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    slug = json['slug'];
    id = json['id'];
  }
}

class JoinWebinarResponse {
  String? viewerId;
  String? agoraAppId;
  String? channelName;
  String? token;
  int? uid;
  String? tokenExpiresAt;
  WebinarShortInfo? webinar;

  JoinWebinarResponse({
    this.viewerId,
    this.agoraAppId,
    this.channelName,
    this.token,
    this.uid,
    this.tokenExpiresAt,
    this.webinar,
  });

  JoinWebinarResponse.fromJson(Map<String, dynamic> json) {
    viewerId = json['viewerId'];
    agoraAppId = json['agoraAppId'];
    channelName = json['channelName'];
    token = json['token'];
    uid = json['uid'];
    tokenExpiresAt = json['tokenExpiresAt'];
    webinar = json['webinar'] != null
        ? WebinarShortInfo.fromJson(json['webinar'])
        : null;
  }
}

class WebinarShortInfo {
  String? webinarId;
  String? title;
  String? hostName;
  String? status;

  WebinarShortInfo({this.webinarId, this.title, this.hostName, this.status});

  WebinarShortInfo.fromJson(Map<String, dynamic> json) {
    webinarId = json['webinarId'];
    title = json['title'];
    hostName = json['hostName'];
    status = json['status'];
  }
}

class QuestionModel {
  String? id;
  String? text;
  String? askedBy;
  String? askerName;
  int? upvotes;
  DateTime? createdAt;

  String? webinarId;
  String? webinar;
  String? status;
  List<String>? upvotedBy;
  bool? isPinned;
  String? questionId;
  DateTime? askedAt;
  DateTime? updatedAt;
  int? iV;
  // bool? isAnswered;

  AnswerModel? answer;

  QuestionModel({
    this.id,
    this.text,
    this.askedBy,
    this.askerName,
    this.upvotes,
    this.createdAt,
    this.webinarId,
    this.webinar,
    this.status,
    this.upvotedBy,
    this.isPinned,
    this.questionId,
    this.askedAt,
    this.updatedAt,
    this.iV,
    // this.isAnswered,
    this.answer,
  });

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    text = json['questionText'];
    askedBy = json['askerId'];
    askerName = json['askerName'];
    upvotes = json['upvotes'];
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'])
        : null;
    webinarId = json['webinarId'];
    webinar = json['webinar'];
    status = json['status'];
    if (json['upvotedBy'] != null) {
      upvotedBy = List<String>.from(json['upvotedBy']);
    }
    isPinned = json['isPinned'];
    questionId = json['questionId'];
    askedAt = json['askedAt'] != null
        ? DateTime.tryParse(json['askedAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'])
        : null;
    iV = json['__v'];
    // isAnswered = json['isAnswered'];
    answer = json['answer'] != null
        ? AnswerModel.fromJson(json['answer'])
        : null;
  }
}

class AnswerModel {
  String? text;
  String? answeredAt;
  String? answeredBy;

  AnswerModel({this.text, this.answeredAt, this.answeredBy});

  AnswerModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    answeredAt = json['answeredAt'];
    answeredBy = json['answeredBy'];
  }
}

// Chat Message Model
class ChatMessage {
  final String userName;
  final String text;
  final String timestamp;
  final bool isHost;

  ChatMessage({
    required this.userName,
    required this.text,
    required this.timestamp,
    this.isHost = false,
  });
}

class WebinarTokenRefreshResponse {
  String? token;
  int? uid;
  String? expiresAt;

  WebinarTokenRefreshResponse({this.token, this.uid, this.expiresAt});

  WebinarTokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    uid = json['uid'];
    expiresAt = json['expiresAt'];
  }
}

class RecordingStatusResponse {
  bool? success;
  String? message;
  String? recordingStatus;

  RecordingStatusResponse({this.success, this.message, this.recordingStatus});

  RecordingStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    recordingStatus = json['recordingStatus'];
  }
}
