import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/services/astrologer_cache_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AstrologerService {
  final ApiRepository _apiRepository = Get.find();

  /// Get astrologers with filtering and pagination
  /// 
  /// Filter Parameters:
  /// - [specialization]: VEDIC, KP, NADI, NUMEROLOGY, TAROT, PALMISTRY, VASTU, GEMOLOGY, HORARY, PRASHNA
  ///   Can be single value, comma-separated list, or multiple query params
  /// - [language]: Filter by language spoken (e.g., "Hindi", "English")
  ///   Can be single value, comma-separated list, or multiple query params
  /// - [availability]: ONLINE, OFFLINE, BUSY, ON_BREAK
  /// - [sortBy]: rating (default), experience, price_low, price_high, consultations
  /// - [astrologerCategory]: KID_ASTROLOGER, CELEBRITY_ASTROLOGER, NORMAL
  /// - [minRating]: Minimum average rating (number)
  /// - [maxPrice]: Maximum voice call price per minute in INR (number)
  /// - [experience]: Minimum years of experience (integer)
  /// - [search]: Search by astrologer name (full name or display name)
  /// - [page]: Page number for pagination (default: 1)
  /// - [limit]: Number of astrologers per page, max 100 (default: 20)
  /// - [useCache]: Whether to use cached data if available (default: true)
  Future<AstrologerResponse?> getAstrologers({
    int page = 1,
    int limit = 20,
    String? specialization,
    String? language,
    double? minRating,
    double? maxPrice,
    String? availability,
    int? experience,
    String? sortBy,
    String? search,
    String? astrologerCategory,
    bool useCache = true,
  }) async {
    // Try cache first (only for basic queries without filters)
    if (useCache && 
        specialization == null && 
        language == null && 
        minRating == null && 
        maxPrice == null && 
        availability == null && 
        experience == null && 
        search == null && 
        astrologerCategory == null &&
        page == 1) {
      final cached = AstrologerCacheService.getCachedAstrologers();
      if (cached != null) {
        debugPrint('Using cached astrologers data');
        // Try to fetch fresh data in background
        _fetchAndCacheAstrologers();
        return cached;
      }
    }
    
    // Fetch from API
    return await _fetchAndCacheAstrologers(
      page: page,
      limit: limit,
      specialization: specialization,
      language: language,
      minRating: minRating,
      maxPrice: maxPrice,
      availability: availability,
      experience: experience,
      sortBy: sortBy,
      search: search,
      astrologerCategory: astrologerCategory,
    );
  }
  
  /// Internal method to fetch and cache astrologers
  Future<AstrologerResponse?> _fetchAndCacheAstrologers({
    int page = 1,
    int limit = 20,
    String? specialization,
    String? language,
    double? minRating,
    double? maxPrice,
    String? availability,
    int? experience,
    String? sortBy,
    String? search,
    String? astrologerCategory,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (specialization != null && specialization.isNotEmpty) {
        query['specialization'] = specialization;
      }

      if (language != null && language.isNotEmpty) {
        query['language'] = language;
      }

      if (minRating != null) {
        query['minRating'] = minRating.toString();
      }

      if (maxPrice != null) {
        query['maxPrice'] = maxPrice.toString();
      }

      if (availability != null && availability.isNotEmpty) {
        query['availability'] = availability;
      }

      if (experience != null) {
        query['experience'] = experience.toString();
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        query['sortBy'] = sortBy;
      }

      if (search != null && search.isNotEmpty) {
        query['search'] = search;
      }

      if (astrologerCategory != null && astrologerCategory.isNotEmpty) {
        query['astrologerCategory'] = astrologerCategory;
      }

      final response = await _apiRepository.getApi(
        EndPoints.astrologersPublic,
        query: query,
        useAuthHeader: false, // Public endpoint, no auth required
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          final astrologerResponse = AstrologerResponse.fromJson(response.body);
          
          // Cache only basic queries (no filters, page 1)
          if (specialization == null && 
              language == null && 
              minRating == null && 
              maxPrice == null && 
              availability == null && 
              experience == null && 
              search == null && 
              astrologerCategory == null &&
              page == 1) {
            await AstrologerCacheService.saveAstrologers(
              astrologerResponse,
              rawJson: response.body,
            );
          }
          
          return astrologerResponse;
        }
      }
      
      // If API fails, try to return cached data
      if (specialization == null && 
          language == null && 
          minRating == null && 
          maxPrice == null && 
          availability == null && 
          experience == null && 
          search == null && 
          astrologerCategory == null &&
          page == 1) {
        final cached = AstrologerCacheService.getCachedAstrologers();
        if (cached != null) {
          debugPrint('API failed, using cached astrologers data');
          return cached;
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error fetching astrologers: $e');
      
      // On error, try to return cached data
      if (specialization == null && 
          language == null && 
          minRating == null && 
          maxPrice == null && 
          availability == null && 
          experience == null && 
          search == null && 
          astrologerCategory == null &&
          page == 1) {
        final cached = AstrologerCacheService.getCachedAstrologers();
        if (cached != null) {
          debugPrint('Error occurred, using cached astrologers data');
          return cached;
        }
      }
      
      return null;
    }
  }

  // Follow an astrologer
  Future<Map<String, dynamic>> followAstrologer(String astrologerId, {String source = 'PROFILE'}) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.astrologerFollow(astrologerId),
        {'source': source},
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          return {
            'success': true,
            'followerCount': data['data']?['followerCount'] as int?,
          };
        }
      }
      return {'success': false};
    } catch (e) {
      debugPrint('Error following astrologer: $e');
      return {'success': false};
    }
  }

  // Unfollow an astrologer
  Future<Map<String, dynamic>> unfollowAstrologer(String astrologerId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.astrologerUnfollow(astrologerId),
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          return {
            'success': true,
            'followerCount': data['data']?['followerCount'] as int?,
          };
        }
      }
      return {'success': false};
    } catch (e) {
      debugPrint('Error unfollowing astrologer: $e');
      return {'success': false};
    }
  }

  // Get follow status
  Future<Map<String, dynamic>?> getFollowStatus(String astrologerId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.astrologerFollowStatus(astrologerId),
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          return {
            'isFollowing': data['data']?['isFollowing'] as bool? ?? false,
            'followDetails': data['data']?['followDetails'],
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting follow status: $e');
      return null;
    }
  }

  // Update notification preferences
  Future<bool> updateNotificationPreferences(
    String astrologerId, {
    bool? liveStream,
    bool? newContent,
    bool? specialOffers,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (liveStream != null) body['liveStream'] = liveStream;
      if (newContent != null) body['newContent'] = newContent;
      if (specialOffers != null) body['specialOffers'] = specialOffers;

      final response = await _apiRepository.putApiCall(
        EndPoints.astrologerFollowNotifications(astrologerId),
        body,
        useAuthHeader: true,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error updating notification preferences: $e');
      return false;
    }
  }

  // Get followers count
  Future<int?> getFollowersCount(String astrologerId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.astrologerFollowersCount(astrologerId),
        useAuthHeader: false, // Public endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          return data['data']?['followerCount'] as int?;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting followers count: $e');
      return null;
    }
  }

  /// Get a single astrologer by ID
  /// This is more efficient than searching through lists
  Future<AstrologerModel?> getAstrologerById(String astrologerId) async {
    try {
      if (astrologerId.isEmpty) return null;
      
      // Try using search parameter with the ID - backend might support it
      var response = await getAstrologers(
        limit: 1,
        search: astrologerId,
      );
      
      var astrologer = response?.astrologers.firstWhereOrNull(
        (a) =>
            a.astrologerId == astrologerId ||
            a.id == astrologerId,
      );
      
      // If not found via search, try fetching batches
      if (astrologer == null) {
        // Try first 100
        response = await getAstrologers(limit: 100);
        astrologer = response?.astrologers.firstWhereOrNull(
          (a) =>
              a.astrologerId == astrologerId ||
              a.id == astrologerId,
        );
        
        // If still not found and there are more, try page 2
        if (astrologer == null && response != null && response.astrologers.length >= 100) {
          response = await getAstrologers(page: 2, limit: 100);
          astrologer = response?.astrologers.firstWhereOrNull(
            (a) =>
                a.astrologerId == astrologerId ||
                a.id == astrologerId,
          );
        }
      }
      
      return astrologer;
    } catch (e) {
      debugPrint('Error fetching astrologer by ID: $e');
      return null;
    }
  }

  // Get list of astrologers the user is following
  Future<Map<String, dynamic>?> getFollowingAstrologers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiRepository.getApi(
        EndPoints.astrologerFollowing,
        query: query,
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (kDebugMode) {
          print('Following API Response: ${data.toString()}');
        }
        
        if (data['success'] == true) {
          final followingList = data['data']?['following'] as List<dynamic>? ?? [];
          final astrologersList = <AstrologerModel>[];
          
          for (var item in followingList) {
            try {
              final astrologerData = item is Map<String, dynamic> ? item['astrologer'] : null;
              if (astrologerData != null && astrologerData is Map<String, dynamic>) {
                // Ensure all required fields are present with defaults
                final completeAstrologerData = Map<String, dynamic>.from(astrologerData);
                
                // Add missing fields with defaults if not present
                if (!completeAstrologerData.containsKey('services') || completeAstrologerData['services'] == null) {
                  completeAstrologerData['services'] = {
                    'voice': {'enabled': false, 'currency': 'INR', 'totalCalls': 0, 'totalDuration': 0},
                    'video': {'enabled': false, 'currency': 'INR', 'totalCalls': 0, 'totalDuration': 0},
                    'chat': {'enabled': false, 'currency': 'INR', 'totalChats': 0},
                    'reports': {'enabled': false, 'totalReports': 0, 'types': []},
                  };
                }
                
                if (!completeAstrologerData.containsKey('metadata') || completeAstrologerData['metadata'] == null) {
                  completeAstrologerData['metadata'] = {
                    'featuredAstrologer': false,
                    'premiumAstrologer': false,
                  };
                }
                
                // Ensure basicInfo has all required fields
                final basicInfoValue = completeAstrologerData['basicInfo'];
                if (basicInfoValue != null && basicInfoValue is Map<String, dynamic>) {
                  final basicInfo = basicInfoValue;
                  if (!basicInfo.containsKey('bio') || basicInfo['bio'] == null) {
                    basicInfo['bio'] = '';
                  }
                  if (!basicInfo.containsKey('languages') || basicInfo['languages'] == null) {
                    basicInfo['languages'] = [];
                  }
                  if (!basicInfo.containsKey('experience') || basicInfo['experience'] == null) {
                    basicInfo['experience'] = {'years': 0, 'description': ''};
                  }
                } else {
                  // If basicInfo is missing entirely, create it
                  completeAstrologerData['basicInfo'] = {
                    'fullName': completeAstrologerData['basicInfo']?['fullName'] ?? '',
                    'displayName': completeAstrologerData['basicInfo']?['displayName'] ?? '',
                    'profilePicture': completeAstrologerData['basicInfo']?['profilePicture'],
                    'bio': '',
                    'languages': [],
                    'specializations': completeAstrologerData['basicInfo']?['specializations'] ?? [],
                    'experience': {'years': 0, 'description': ''},
                  };
                }
                
                // Ensure metrics has consultations if missing
                final metricsValue = completeAstrologerData['metrics'];
                if (metricsValue != null && metricsValue is Map<String, dynamic>) {
                  final metrics = metricsValue;
                  if (!metrics.containsKey('consultations') || metrics['consultations'] == null) {
                    metrics['consultations'] = {'total': 0, 'completed': 0};
                  }
                  // Ensure rating exists
                  if (!metrics.containsKey('rating') || metrics['rating'] == null) {
                    metrics['rating'] = {
                      'average': 0.0,
                      'totalRatings': 0,
                      'distribution': {'star5': 0, 'star4': 0, 'star3': 0, 'star2': 0, 'star1': 0}
                    };
                  }
                } else {
                  // If metrics is missing entirely, create it
                  completeAstrologerData['metrics'] = {
                    'rating': {
                      'average': 0.0,
                      'totalRatings': 0,
                      'distribution': {'star5': 0, 'star4': 0, 'star3': 0, 'star2': 0, 'star1': 0}
                    },
                    'consultations': {'total': 0, 'completed': 0},
                  };
                }
                
                // Ensure availability exists
                if (!completeAstrologerData.containsKey('availability') || completeAstrologerData['availability'] == null) {
                  completeAstrologerData['availability'] = {'status': 'OFFLINE'};
                }
                
                // Ensure _id and astrologerId exist
                if (!completeAstrologerData.containsKey('_id') || completeAstrologerData['_id'] == null) {
                  completeAstrologerData['_id'] = '';
                }
                if (!completeAstrologerData.containsKey('astrologerId') || completeAstrologerData['astrologerId'] == null) {
                  completeAstrologerData['astrologerId'] = '';
                }
                
                final astrologer = AstrologerModel.fromJson(completeAstrologerData);
                astrologersList.add(astrologer);
              } else {
                if (kDebugMode) {
                  print('Astrologer data is null or not a map: $astrologerData');
                }
              }
            } catch (e, stackTrace) {
              debugPrint('Error parsing astrologer: $e');
              debugPrint('Stack trace: $stackTrace');
              debugPrint('Item data: $item');
            }
          }
          
          if (kDebugMode) {
            print('Parsed ${astrologersList.length} astrologers');
          }
          
          return {
            'following': astrologersList,
            'pagination': data['data']?['pagination'],
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting following astrologers: $e');
      if (kDebugMode) {
        print('Full error: ${e.toString()}');
      }
      return null;
    }
  }
}




