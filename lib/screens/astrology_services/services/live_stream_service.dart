import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/services/astrologer_cache_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LiveStreamService {
  final ApiRepository _apiRepository = Get.find();

  // Get live streams
  Future<LiveStreamResponse?> getLiveStreams({
    int page = 1,
    int limit = 20,
    bool useCache = false, // Changed to false: live streams must be real-time
  }) async {
    // Try cache first (only for page 1)
    if (useCache && page == 1) {
      final cached = AstrologerCacheService.getCachedLiveStreams();
      if (cached != null) {
        debugPrint('Using cached live streams data');
        // Try to fetch fresh data in background
        _fetchAndCacheLiveStreams(page: page, limit: limit, useCache: useCache);
        return cached;
      }
    }

    // Fetch from API
    return await _fetchAndCacheLiveStreams(
      page: page,
      limit: limit,
      useCache: useCache,
    );
  }

  /// Internal method to fetch and cache live streams
  Future<LiveStreamResponse?> _fetchAndCacheLiveStreams({
    int page = 1,
    int limit = 20,
    bool useCache = false,
  }) async {
    final query = <String, dynamic>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await _apiRepository.getApi(
      EndPoints.liveStreams,
      query: query,
      useAuthHeader: false,
      useCache: false, // Force no network-level caching here
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        final liveStreamResponse = LiveStreamResponse.fromJson(response.body);
        if (page == 1) {
          await AstrologerCacheService.saveLiveStreams(
            liveStreamResponse,
            rawJson: response.body,
          );
        }
        return liveStreamResponse;
      }
    }

    if (useCache && page == 1) {
      final cached = AstrologerCacheService.getCachedLiveStreams();
      if (cached != null) return cached;
    }

    throw response.body?['message']?.toString() ??
        'Failed to load live streams';
  }

  // Join a live stream
  Future<JoinStreamResponse?> joinStream(String streamId) async {
    final response = await _apiRepository.postApi(
      EndPoints.joinStream(streamId),
      {},
      useAuthHeader: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return JoinStreamResponse.fromJson(response.body);
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to join stream';
  }

  // Get gifts catalog
  Future<GiftCatalog?> getGiftsCatalog() async {
    final response = await _apiRepository.getApi(
      EndPoints.giftsCatalog,
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return GiftCatalog.fromJson(response.body);
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to load gifts catalog';
  }

  // RSVP for a scheduled stream
  Future<bool> rsvpStream(String streamId) async {
    final response = await _apiRepository.postApi(
      EndPoints.streamRsvp(streamId),
      {},
      useAuthHeader: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body['success'] == true;
    }
    throw response.body?['message']?.toString() ?? 'Failed to RSVP stream';
  }

  // Get RSVP count
  Future<int?> getRsvpCount(String streamId) async {
    final response = await _apiRepository.getApi(
      EndPoints.streamRsvpCount(streamId),
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return (response.body['data']?['rsvpCount'] as num?)?.toInt();
      }
    }
    return null;
  }

  // Get upcoming/scheduled streams
  Future<UpcomingStreamsResponse?> getUpcomingStreams({
    int page = 1,
    int limit = 20,
    bool useCache = true,
  }) async {
    if (useCache && page == 1) {
      final cached = AstrologerCacheService.getCachedUpcomingStreams();
      if (cached != null) {
        _fetchAndCacheUpcomingStreams(page: page, limit: limit);
        return cached;
      }
    }
    return await _fetchAndCacheUpcomingStreams(page: page, limit: limit);
  }

  Future<UpcomingStreamsResponse?> _fetchAndCacheUpcomingStreams({
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await _apiRepository.getApi(
      EndPoints.upcomingStreams,
      query: query,
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        final upcomingResponse = UpcomingStreamsResponse.fromJson(
          response.body,
        );
        if (page == 1) {
          await AstrologerCacheService.saveUpcomingStreams(
            upcomingResponse,
            rawJson: response.body,
          );
        }
        return upcomingResponse;
      }
    }

    if (page == 1) {
      final cached = AstrologerCacheService.getCachedUpcomingStreams();
      if (cached != null) return cached;
    }

    throw response.body?['message']?.toString() ??
        'Failed to load upcoming streams';
  }

  // Get astrologer's scheduled streams
  Future<AstrologerScheduleResponse?> getAstrologerSchedule(
    String astrologerId,
  ) async {
    final response = await _apiRepository.getApi(
      EndPoints.astrologerSchedule(astrologerId),
      useAuthHeader: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return AstrologerScheduleResponse.fromJson(response.body);
      }
    }
    throw response.body?['message']?.toString() ??
        'Failed to load astrologer schedule';
  }

  // Cancel RSVP
  Future<bool> cancelRsvp(String streamId) async {
    final response = await _apiRepository.deleteReq(
      EndPoints.streamRsvp(streamId),
      useAuthHeader: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body['success'] == true;
    }
    throw response.body?['message']?.toString() ?? 'Failed to cancel RSVP';
  }

  // Get user's RSVPs
  Future<List<Map<String, dynamic>>?> getUserRsvps() async {
    final response = await _apiRepository.getApi(
      EndPoints.userRsvps,
      useAuthHeader: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        final data = response.body['data'] as List<dynamic>?;
        return data?.map((e) => e as Map<String, dynamic>).toList();
      }
    }
    throw response.body?['message']?.toString() ?? 'Failed to load user RSVPs';
  }

  // Report a stream
  Future<StreamReportResponse?> reportStream(
    String streamId,
    String category,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.streamReport(streamId),
        {'category': category},
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return StreamReportResponse.fromJson(response.body);
        }
      }
      throw response.body?['message']?.toString() ?? 'Failed to report stream';
    } on FetchDataException catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('already reported')) {
        throw AlreadyReportedException('You have already reported this stream');
      }
      rethrow;
    }
  }

  // Get my reports
  Future<StreamReportsResponse?> getMyReports({
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await _apiRepository.getApi(
      EndPoints.streamReportsMyReports,
      query: query,
      useAuthHeader: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return StreamReportsResponse.fromJson(response.body);
      }
    }
    throw response.body?['message']?.toString() ?? 'Failed to load my reports';
  }
}
