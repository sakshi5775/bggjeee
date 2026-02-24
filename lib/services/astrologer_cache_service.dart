import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';

class AstrologerCacheService {
  static GetStorage get _storage => GetStorage();

  // Cache keys
  static const String _allAstrologersKey = 'cached_all_astrologers';
  static const String _liveStreamsKey = 'cached_live_streams';
  static const String _upcomingStreamsKey = 'cached_upcoming_streams';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _astrologersCacheTimestampKey =
      'astrologers_cache_timestamp';

  // Cache duration: 5 minutes
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Save astrologers to cache
  static Future<void> saveAstrologers(
    AstrologerResponse response, {
    Map<String, dynamic>? rawJson,
  }) async {
    try {
      // Store the raw JSON if provided, otherwise construct it
      final jsonData =
          rawJson ??
          {
            'success': true,
            'data': {
              'astrologers': response.astrologers
                  .map((a) => _astrologerToJson(a))
                  .toList(),
              'pagination': {
                'currentPage': response.pagination.currentPage,
                'totalPages': response.pagination.totalPages,
                'totalAstrologers': response.pagination.totalAstrologers,
                'limit': response.pagination.limit,
                'hasNextPage': response.pagination.hasNextPage,
                'hasPrevPage': response.pagination.hasPrevPage,
              },
            },
          };
      await _storage.write(_allAstrologersKey, jsonEncode(jsonData));
      await _storage.write(
        _astrologersCacheTimestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  /// Helper to convert astrologer to JSON (simplified)
  static Map<String, dynamic> _astrologerToJson(AstrologerModel astrologer) {
    return {
      '_id': astrologer.id,
      'astrologerId': astrologer.astrologerId,
      'basicInfo': {
        'fullName': astrologer.name,
        'displayName': astrologer.displayName,
        'profilePicture': astrologer.profilePicture,
        'bio': astrologer.bio,
        'languages': astrologer.languages,
        'specializations': astrologer.specializations,
        'experience': {
          'years': astrologer.experienceYears,
          'description': astrologer.experienceDescription,
        },
      },
      // Add other fields as needed
    };
  }

  /// Get astrologers from cache if available and not expired
  static AstrologerResponse? getCachedAstrologers() {
    try {
      final timestampStr = _storage.read<String>(_astrologersCacheTimestampKey);
      if (timestampStr == null) return null;

      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();

      // Check if cache is expired
      if (now.difference(timestamp) > _cacheDuration) {
        return null; // Cache expired
      }

      final cachedData = _storage.read<String>(_allAstrologersKey);
      if (cachedData == null) return null;

      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      return AstrologerResponse.fromJson(jsonData);
    } catch (e) {
      // If cache is corrupted, return null
      return null;
    }
  }

  /// Save live streams to cache
  static Future<void> saveLiveStreams(
    LiveStreamResponse response, {
    Map<String, dynamic>? rawJson,
  }) async {
    try {
      // Store the raw JSON if provided
      final jsonData =
          rawJson ??
          {
            'success': true,
            'data': response.streams.map((s) => _streamToJson(s)).toList(),
            'pagination': {
              'page': response.pagination.page,
              'limit': response.pagination.limit,
              'total': response.pagination.total,
              'totalPages': response.pagination.totalPages,
            },
          };
      await _storage.write(_liveStreamsKey, jsonEncode(jsonData));
      await _storage.write(
        _cacheTimestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Helper to convert stream to JSON (simplified)
  static Map<String, dynamic> _streamToJson(LiveStreamModel stream) {
    return {
      'streamId': stream.streamId,
      'astrologerId': stream.astrologerId,
      'title': stream.title,
      'status': stream.status,
      'astrologerName': stream.astrologerName,
      'currentViewers': stream.currentViewers,
      'totalGifts': stream.totalGifts,
      'startedAt': stream.startedAt?.toIso8601String(),
      'astrologerPhoto': stream.astrologerPhoto,
      'astrologerSpecializations': stream.astrologerSpecializations,
    };
  }

  /// Get live streams from cache if available and not expired
  static LiveStreamResponse? getCachedLiveStreams() {
    try {
      final timestampStr = _storage.read<String>(_cacheTimestampKey);
      if (timestampStr == null) return null;

      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();

      // Check if cache is expired
      if (now.difference(timestamp) > _cacheDuration) {
        return null; // Cache expired
      }

      final cachedData = _storage.read<String>(_liveStreamsKey);
      if (cachedData == null) return null;

      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      return LiveStreamResponse.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  /// Save upcoming streams to cache
  static Future<void> saveUpcomingStreams(
    UpcomingStreamsResponse response, {
    Map<String, dynamic>? rawJson,
  }) async {
    try {
      // Store the raw JSON if provided
      final jsonData =
          rawJson ??
          {
            'success': true,
            'data': response.streams
                .map((s) => _upcomingStreamToJson(s))
                .toList(),
            'pagination': {
              'page': response.pagination.page,
              'limit': response.pagination.limit,
              'total': response.pagination.total,
              'totalPages': response.pagination.totalPages,
            },
          };
      await _storage.write(_upcomingStreamsKey, jsonEncode(jsonData));
    } catch (e) {
      // Silently fail
    }
  }

  /// Helper to convert upcoming stream to JSON (simplified)
  static Map<String, dynamic> _upcomingStreamToJson(
    UpcomingStreamModel stream,
  ) {
    return {
      'streamId': stream.streamId,
      'astrologerId': stream.astrologerId,
      'astrologerName': stream.astrologerName,
      'scheduling': {
        'isScheduled': stream.scheduling.isScheduled,
        'scheduledStartTime': stream.scheduling.scheduledStartTime
            .toIso8601String(),
        'scheduledEndTime': stream.scheduling.scheduledEndTime
            .toIso8601String(),
        'title': stream.scheduling.title,
        'description': stream.scheduling.description,
        'estimatedDurationMinutes': stream.scheduling.estimatedDurationMinutes,
        'rsvpCount': stream.scheduling.rsvpCount,
      },
    };
  }

  /// Get upcoming streams from cache if available and not expired
  static UpcomingStreamsResponse? getCachedUpcomingStreams() {
    try {
      final cachedData = _storage.read<String>(_upcomingStreamsKey);
      if (cachedData == null) return null;

      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      return UpcomingStreamsResponse.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  /// Clear all cache
  static Future<void> clearCache() async {
    await _storage.remove(_allAstrologersKey);
    await _storage.remove(_liveStreamsKey);
    await _storage.remove(_upcomingStreamsKey);
    await _storage.remove(_cacheTimestampKey);
    await _storage.remove(_astrologersCacheTimestampKey);
  }

  /// Check if cache exists and is valid
  static bool hasValidCache() {
    final timestampStr = _storage.read<String>(_astrologersCacheTimestampKey);
    if (timestampStr == null) return false;

    try {
      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();
      return now.difference(timestamp) <= _cacheDuration;
    } catch (e) {
      return false;
    }
  }
}
