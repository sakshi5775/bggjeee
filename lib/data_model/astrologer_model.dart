/// Parse price-per-minute from JSON with multiple possible keys (camelCase, snake_case, etc.).
double? _parsePricePerMinute(Map<String, dynamic> json) {
  final v = json['pricePerMinute'] ?? json['price_per_minute'] ?? json['pricePerMin'] ?? json['price_per_min'] ?? json['price'];
  return _parseNum(v);
}

double? _parseNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

class AstrologerModel {
  final String id;
  final String astrologerId;
  final BasicInfo basicInfo;
  final Services services;
  final Availability availability;
  final Metrics metrics;
  final Metadata metadata;
  /// Backend category: NORMAL, KID_ASTROLOGER, CELEBRITY_ASTROLOGER (for client-side filter)
  final String? astrologerCategory;

  AstrologerModel({
    required this.id,
    required this.astrologerId,
    required this.basicInfo,
    required this.services,
    required this.availability,
    required this.metrics,
    required this.metadata,
    this.astrologerCategory,
  });

  factory AstrologerModel.fromJson(Map<String, dynamic> json) {
    return AstrologerModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      astrologerId: (json['astrologerId'] ?? json['_id'] ?? '').toString(),
      basicInfo: BasicInfo.fromJson(
        json['basicInfo'] as Map<String, dynamic>? ?? {},
      ),
      services: Services.fromJson(
        json['services'] as Map<String, dynamic>? ?? {},
      ),
      availability: Availability.fromJson(
        json['availability'] as Map<String, dynamic>? ?? {},
      ),
      metrics: Metrics.fromJson(json['metrics'] as Map<String, dynamic>? ?? {}),
      metadata: Metadata.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      astrologerCategory: json['astrologerCategory'] as String? ?? json['astrologer_category'] as String?,
    );
  }

  // Helper getters for easy access
  String get name => basicInfo.fullName;
  String get displayName => basicInfo.displayName;
  String? get profilePicture => basicInfo.profilePicture;
  String get bio => basicInfo.bio;
  List<String> get languages => basicInfo.languages;
  List<String> get specializations => basicInfo.specializations;
  int get experienceYears => basicInfo.experience.years;
  String get experienceDescription => basicInfo.experience.description;
  double get rating => metrics.rating.average;
  int get totalRatings => metrics.rating.totalRatings;
  int get totalConsultations => metrics.consultations.total;
  int get completedConsultations => metrics.consultations.completed;
  bool get isOnline => availability.status == 'ONLINE';
  bool get isFeatured => metadata.featuredAstrologer;
  bool get isPremium => metadata.premiumAstrologer;

  // Get price for voice call (per minute)
  double? get voicePricePerMin =>
      services.voice.enabled ? (services.voice.pricePerMinute ?? 0.0) : null;

  // Get price for video call (per minute)
  double? get videoPricePerMin =>
      services.video.enabled ? (services.video.pricePerMinute ?? 0.0) : null;

  // Get price for chat (per minute)
  double? get chatPricePerMin =>
      services.chat.enabled ? (services.chat.pricePerMinute ?? 0.0) : null;

  // Backward compatibility - alias for chatPricePerMin
  double? get chatPrice => chatPricePerMin;
}

class BasicInfo {
  final String fullName;
  final String displayName;
  final String? profilePicture;
  final String bio;
  final List<String> languages;
  final List<String> specializations;
  final Experience experience;

  BasicInfo({
    required this.fullName,
    required this.displayName,
    this.profilePicture,
    required this.bio,
    required this.languages,
    required this.specializations,
    required this.experience,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      fullName: (json['fullName'] ?? '').toString(),
      displayName: (json['displayName'] ?? json['fullName'] ?? '').toString(),
      profilePicture: json['profilePicture']?.toString(),
      bio: (json['bio'] ?? '').toString(),
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      specializations:
          (json['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      experience: Experience.fromJson(
        json['experience'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class Experience {
  final int years;
  final String description;

  Experience({required this.years, required this.description});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      years: (json['years'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
    );
  }
}

class Services {
  final VoiceService voice;
  final VideoService video;
  final ChatService chat;
  final ReportsService reports;

  Services({
    required this.voice,
    required this.video,
    required this.chat,
    required this.reports,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      voice: VoiceService.fromJson(
        json['voice'] as Map<String, dynamic>? ?? {},
      ),
      video: VideoService.fromJson(
        json['video'] as Map<String, dynamic>? ?? {},
      ),
      chat: ChatService.fromJson(json['chat'] as Map<String, dynamic>? ?? {}),
      reports: ReportsService.fromJson(
        json['reports'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class VoiceService {
  final bool enabled;
  final String currency;
  final int totalCalls;
  final int totalDuration;
  final double? pricePerMinute;

  VoiceService({
    required this.enabled,
    required this.currency,
    required this.totalCalls,
    required this.totalDuration,
    this.pricePerMinute,
  });

  factory VoiceService.fromJson(Map<String, dynamic> json) {
    return VoiceService(
      enabled: json['enabled'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'INR',
      totalCalls: (json['totalCalls'] as num?)?.toInt() ?? 0,
      totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
      pricePerMinute: _parsePricePerMinute(json),
    );
  }
}

class VideoService {
  final bool enabled;
  final String currency;
  final int totalCalls;
  final int totalDuration;
  final double? pricePerMinute;

  VideoService({
    required this.enabled,
    required this.currency,
    required this.totalCalls,
    required this.totalDuration,
    this.pricePerMinute,
  });

  factory VideoService.fromJson(Map<String, dynamic> json) {
    return VideoService(
      enabled: json['enabled'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'INR',
      totalCalls: (json['totalCalls'] as num?)?.toInt() ?? 0,
      totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
      pricePerMinute: _parsePricePerMinute(json),
    );
  }
}

class ChatService {
  final bool enabled;
  final String currency;
  final int totalChats;
  final double?
  pricePerMinute; // CHANGED: Now uses pricePerMinute instead of pricePerMessage

  ChatService({
    required this.enabled,
    required this.currency,
    required this.totalChats,
    this.pricePerMinute,
  });

  factory ChatService.fromJson(Map<String, dynamic> json) {
    return ChatService(
      enabled: json['enabled'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'INR',
      totalChats: (json['totalChats'] as num?)?.toInt() ?? 0,
      pricePerMinute: _parsePricePerMinute(json) ??
          _parseNum(json['pricePerMessage']),
    );
  }
}

class ReportsService {
  final bool enabled;
  final int totalReports;
  final List<String> types;

  ReportsService({
    required this.enabled,
    required this.totalReports,
    required this.types,
  });

  factory ReportsService.fromJson(Map<String, dynamic> json) {
    return ReportsService(
      enabled: json['enabled'] as bool? ?? false,
      totalReports: (json['totalReports'] as num?)?.toInt() ?? 0,
      types:
          (json['types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class Availability {
  final String status;

  Availability({required this.status});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(status: json['status'] as String? ?? 'OFFLINE');
  }
}

class Metrics {
  final Rating rating;
  final Consultations consultations;

  Metrics({required this.rating, required this.consultations});

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>? ?? {}),
      consultations: Consultations.fromJson(
        json['consultations'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class Rating {
  final RatingDistribution distribution;
  final double average;
  final int totalRatings;

  Rating({
    required this.distribution,
    required this.average,
    required this.totalRatings,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      distribution: RatingDistribution.fromJson(
        json['distribution'] as Map<String, dynamic>? ?? {},
      ),
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
    );
  }
}

class RatingDistribution {
  final int star5;
  final int star4;
  final int star3;
  final int star2;
  final int star1;

  RatingDistribution({
    required this.star5,
    required this.star4,
    required this.star3,
    required this.star2,
    required this.star1,
  });

  factory RatingDistribution.fromJson(Map<String, dynamic> json) {
    return RatingDistribution(
      star5: (json['star5'] as num?)?.toInt() ?? 0,
      star4: (json['star4'] as num?)?.toInt() ?? 0,
      star3: (json['star3'] as num?)?.toInt() ?? 0,
      star2: (json['star2'] as num?)?.toInt() ?? 0,
      star1: (json['star1'] as num?)?.toInt() ?? 0,
    );
  }
}

class Consultations {
  final int total;
  final int completed;

  Consultations({required this.total, required this.completed});

  factory Consultations.fromJson(Map<String, dynamic> json) {
    return Consultations(
      total: (json['total'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
    );
  }
}

class Metadata {
  final bool featuredAstrologer;
  final bool premiumAstrologer;

  Metadata({required this.featuredAstrologer, required this.premiumAstrologer});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      featuredAstrologer: json['featuredAstrologer'] as bool? ?? false,
      premiumAstrologer: json['premiumAstrologer'] as bool? ?? false,
    );
  }
}

class AstrologerResponse {
  final List<AstrologerModel> astrologers;
  final AstrologerPagination pagination;

  AstrologerResponse({required this.astrologers, required this.pagination});

  factory AstrologerResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final astrologersList = data['astrologers'] as List<dynamic>? ?? [];
    final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

    return AstrologerResponse(
      astrologers: astrologersList
          .map((e) => AstrologerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: AstrologerPagination.fromJson(paginationData),
    );
  }
}

class AstrologerPagination {
  final int currentPage;
  final int totalPages;
  final int totalAstrologers;
  final int limit;
  final bool hasNextPage;
  final bool hasPrevPage;

  AstrologerPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalAstrologers,
    required this.limit,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  /// Parses pagination from API. Accepts camelCase (currentPage, totalAstrologers)
  /// or common variants (page, totalItems) for backend compatibility.
  factory AstrologerPagination.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) => (v is num) ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;
    final page = toInt(json['currentPage'] ?? json['page']);
    final total = toInt(json['totalAstrologers'] ?? json['totalItems'] ?? json['total_astrologers'] ?? json['total']);
    final pages = toInt(json['totalPages'] ?? json['total_pages']);
    final lim = toInt(json['limit']);
    return AstrologerPagination(
      currentPage: page < 1 ? 1 : page,
      totalPages: pages < 1 ? 1 : pages,
      totalAstrologers: total,
      limit: lim < 1 ? 20 : lim,
      hasNextPage: json['hasNextPage'] as bool? ?? json['has_next_page'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? json['has_prev_page'] as bool? ?? false,
    );
  }
}

// User Display Info (shared model)
class UserDisplayInfo {
  final String displayName;
  final String maskedPhone;
  final String userInitials;

  UserDisplayInfo({
    required this.displayName,
    required this.maskedPhone,
    required this.userInitials,
  });

  factory UserDisplayInfo.fromJson(Map<String, dynamic> json) {
    return UserDisplayInfo(
      displayName: json['displayName'] as String? ?? '',
      maskedPhone: json['maskedPhone'] as String? ?? '',
      userInitials: json['userInitials'] as String? ?? '',
    );
  }
}

// Astrologer Review Models
class AstrologerReview {
  final String id;
  final int rating;
  final String reviewText;
  final String serviceType; // VIDEO, AUDIO, CHAT
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserDisplayInfo? userDisplayInfo;
  final int helpfulCount;
  final int reportedCount;
  final String status; // APPROVED, PENDING, etc.

  AstrologerReview({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.serviceType,
    required this.createdAt,
    this.updatedAt,
    this.userDisplayInfo,
    this.helpfulCount = 0,
    this.reportedCount = 0,
    this.status = 'APPROVED',
  });

  factory AstrologerReview.fromJson(Map<String, dynamic> json) {
    return AstrologerReview(
      id: json['id'] as String? ?? json['_id'] as String,
      rating: json['rating'] as int,
      reviewText: json['reviewText'] as String? ?? '',
      serviceType: json['serviceType'] as String? ?? 'VIDEO',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      userDisplayInfo: json['userDisplayInfo'] != null
          ? UserDisplayInfo.fromJson(
              json['userDisplayInfo'] as Map<String, dynamic>,
            )
          : null,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      reportedCount: json['reportedCount'] as int? ?? 0,
      status: json['status'] as String? ?? 'APPROVED',
    );
  }
}

class AstrologerReviewResponse {
  final List<AstrologerReview> reviews;
  final AstrologerReviewPagination pagination;
  final String? disclaimer;

  AstrologerReviewResponse({
    required this.reviews,
    required this.pagination,
    this.disclaimer,
  });

  factory AstrologerReviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final reviewsList = data['reviews'] as List<dynamic>;
    final paginationData = data['pagination'] as Map<String, dynamic>;

    return AstrologerReviewResponse(
      reviews: reviewsList
          .map((e) => AstrologerReview.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: AstrologerReviewPagination.fromJson(paginationData),
      disclaimer: data['disclaimer'] as String?,
    );
  }
}

class AstrologerReviewPagination {
  final int currentPage;
  final int totalPages;
  final int totalReviews;
  final bool hasNextPage;
  final bool hasPreviousPage;

  AstrologerReviewPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalReviews,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory AstrologerReviewPagination.fromJson(Map<String, dynamic> json) {
    return AstrologerReviewPagination(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}
