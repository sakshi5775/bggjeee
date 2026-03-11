class PersonaModel {
  final String id;
  final String displayName;
  final String name; // Full name from basicInfo.name
  final String? image;
  final String description;
  final String category;
  final List<String> tags;
  final List<String> specializations;
  final double? rating;
  final int totalRatings;
  final double? price;
  /// Chat price per minute (from API pricing.chatPricePerMinute). 0 = free.
  final double? chatPricePerMinute;
  /// Call price per minute (from API pricing.callPricePerMinute). 0 = free.
  final double? callPricePerMinute;
  /// Alias for chatPricePerMinute for backward compatibility.
  final double? pricePerMin;
  final List<String> languages;
  final int? followers; // Number of followers
  final int? experienceYears; // Years of experience
  final bool? isOnline; // Online status
  final PersonaReviewStatistics? reviewStatistics; // Review statistics
  final bool? isFollowing; // Whether current user is following

  PersonaModel({
    required this.id,
    required this.displayName,
    required this.name,
    this.image,
    required this.description,
    required this.category,
    required this.tags,
    required this.specializations,
    this.rating,
    this.totalRatings = 0,
    this.price,
    this.chatPricePerMinute,
    this.callPricePerMinute,
    this.pricePerMin,
    this.languages = const [],
    this.followers,
    this.experienceYears,
    this.isOnline,
    this.reviewStatistics,
    this.isFollowing,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    final basicInfo = json['basicInfo'] as Map<String, dynamic>;
    final categorization = json['categorization'] as Map<String, dynamic>;
    final analytics = json['analytics'] as Map<String, dynamic>?;
    final pricing = json['pricing'] as Map<String, dynamic>?;

    // Extract rating from analytics
    double? rating;
    int totalRatings = 0;
    if (analytics != null && analytics['rating'] != null) {
      final ratingData = analytics['rating'] as Map<String, dynamic>;
      rating = (ratingData['average'] as num?)?.toDouble();
      totalRatings = (ratingData['totalRatings'] as int?) ?? 0;
    }

    // Extract price (will be added later in API)
    double? price;
    if (basicInfo['price'] != null) {
      price = (basicInfo['price'] as num?)?.toDouble();
    }

    // Extract languages (will be added later in API, default to common ones)
    List<String> languages = [];
    if (basicInfo['languages'] != null) {
      languages = (basicInfo['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
    } else {
      // Default languages based on description
      languages = ['English', 'Hindi'];
    }

    // Extract experience years (will be added later in API, default to 10)
    int? experienceYears;
    if (basicInfo['experienceYears'] != null) {
      experienceYears = (basicInfo['experienceYears'] as num?)?.toInt();
    } else if (basicInfo['experience'] != null) {
      // Handle experience as object with years property
      if (basicInfo['experience'] is Map<String, dynamic>) {
        final experienceObj = basicInfo['experience'] as Map<String, dynamic>;
        experienceYears = (experienceObj['years'] as num?)?.toInt();
      } else if (basicInfo['experience'] is num) {
        // Handle experience as number (backward compatibility)
        experienceYears = (basicInfo['experience'] as num).toInt();
      }
    }

    // Extract followers (will be added later in API)
    int? followers;
    if (analytics != null) {
      // Try followerCount first (from follow/unfollow API response), then followers
      if (analytics['followerCount'] != null) {
        followers = (analytics['followerCount'] as num?)?.toInt();
      } else if (analytics['followers'] != null) {
        followers = (analytics['followers'] as num?)?.toInt();
      }
    }
    // Also check top-level followerCount (from follow/unfollow response)
    if (followers == null && json['followerCount'] != null) {
      followers = (json['followerCount'] as num?)?.toInt();
    }

    // Extract online status (will be added later in API, default to true)
    bool isOnline = basicInfo['isOnline'] as bool? ?? true;

    // Extract chat and call price per minute from API pricing object
    double? chatPricePerMinute;
    double? callPricePerMinute;
    if (pricing != null) {
      chatPricePerMinute = (pricing['chatPricePerMinute'] as num?)?.toDouble();
      callPricePerMinute = (pricing['callPricePerMinute'] as num?)?.toDouble();
    }
    if (chatPricePerMinute == null && basicInfo['pricePerMin'] != null) {
      chatPricePerMinute = (basicInfo['pricePerMin'] as num?)?.toDouble();
    }
    if (chatPricePerMinute == null && basicInfo['consultationCharge'] != null) {
      chatPricePerMinute = (basicInfo['consultationCharge'] as num?)?.toDouble();
    }
    final pricePerMin = chatPricePerMinute;

    // Extract review statistics
    PersonaReviewStatistics? reviewStatistics;
    if (json['reviewStatistics'] != null) {
      reviewStatistics = PersonaReviewStatistics.fromJson(
          json['reviewStatistics'] as Map<String, dynamic>);
    }

    // Extract isFollowing (if provided)
    bool? isFollowing = json['isFollowing'] as bool?;

    return PersonaModel(
      id: json['_id'] as String,
      name: basicInfo['name'] as String? ?? basicInfo['displayName'] as String? ?? '',
      displayName: basicInfo['displayName'] as String? ?? basicInfo['name'] as String? ?? '',
      image: basicInfo['image'] as String?,
      description: basicInfo['description'] as String? ?? '',
      category: categorization['category'] as String? ?? '',
      tags: (categorization['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      specializations: (categorization['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: rating,
      totalRatings: totalRatings,
      price: price,
      chatPricePerMinute: chatPricePerMinute,
      callPricePerMinute: callPricePerMinute,
      pricePerMin: pricePerMin,
      languages: languages,
      followers: followers ?? 0,
      experienceYears: experienceYears ?? 10,
      isOnline: isOnline,
      reviewStatistics: reviewStatistics,
      isFollowing: isFollowing,
    );
  }
}

class PersonaCategory {
  final String value;
  final String label;
  final String description;

  PersonaCategory({
    required this.value,
    required this.label,
    required this.description,
  });

  factory PersonaCategory.fromJson(Map<String, dynamic> json) {
    return PersonaCategory(
      value: json['value'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
    );
  }
}

class PersonaResponse {
  final List<PersonaModel> personas;
  final PaginationInfo pagination;

  PersonaResponse({
    required this.personas,
    required this.pagination,
  });

  factory PersonaResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Response data is null');
      }
      
      final personasList = data['personas'] as List<dynamic>?;
      if (personasList == null) {
        throw Exception('Personas list is null');
      }
      
      final paginationData = data['pagination'] as Map<String, dynamic>?;
      if (paginationData == null) {
        throw Exception('Pagination data is null');
      }

      // Parse personas with error handling for individual items
      final parsedPersonas = <PersonaModel>[];
      for (var i = 0; i < personasList.length; i++) {
        try {
          final personaJson = personasList[i] as Map<String, dynamic>;
          parsedPersonas.add(PersonaModel.fromJson(personaJson));
        } catch (e) {
          // Log error but continue parsing other personas
          print('Error parsing persona at index $i: $e');
          print('Persona JSON: ${personasList[i]}');
        }
      }

      return PersonaResponse(
        personas: parsedPersonas,
        pagination: PaginationInfo.fromJson(paginationData),
      );
    } catch (e) {
      print('Error in PersonaResponse.fromJson: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      pages: json['pages'] as int? ?? 1,
    );
  }

  bool get hasNextPage => page < pages;
  int? get nextPage => hasNextPage ? page + 1 : null;
}

// Persona Review Models
class PersonaReview {
  final String id;
  final int rating;
  final String reviewText;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserDisplayInfo? userDisplayInfo;
  final int helpfulCount;
  final bool isVerifiedPurchase;

  PersonaReview({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    this.updatedAt,
    this.userDisplayInfo,
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
  });

  factory PersonaReview.fromJson(Map<String, dynamic> json) {
    return PersonaReview(
      id: json['id'] as String? ?? json['_id'] as String,
      rating: json['rating'] as int,
      reviewText: json['reviewText'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      userDisplayInfo: json['userDisplayInfo'] != null
          ? UserDisplayInfo.fromJson(
              json['userDisplayInfo'] as Map<String, dynamic>)
          : null,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
    );
  }
}

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

class PersonaReviewResponse {
  final List<PersonaReview> reviews;
  final PaginationInfo pagination;
  final String? disclaimer;

  PersonaReviewResponse({
    required this.reviews,
    required this.pagination,
    this.disclaimer,
  });

  factory PersonaReviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final reviewsList = data['reviews'] as List<dynamic>;
    final paginationData = data['pagination'] as Map<String, dynamic>;

    return PersonaReviewResponse(
      reviews: reviewsList
          .map((e) => PersonaReview.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfo.fromJson(paginationData),
      disclaimer: data['disclaimer'] as String?,
    );
  }
}

class PersonaReviewStatistics {
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final int verifiedReviewsCount;
  final double percentageVerified;

  PersonaReviewStatistics({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.verifiedReviewsCount,
    required this.percentageVerified,
  });

  factory PersonaReviewStatistics.fromJson(Map<String, dynamic> json) {
    final distribution = json['ratingDistribution'] as Map<String, dynamic>;
    final ratingDist = <int, int>{};
    distribution.forEach((key, value) {
      ratingDist[int.parse(key)] = value as int;
    });

    return PersonaReviewStatistics(
      totalReviews: json['totalReviews'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingDistribution: ratingDist,
      verifiedReviewsCount: json['verifiedReviewsCount'] as int? ?? 0,
      percentageVerified: (json['percentageVerified'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

