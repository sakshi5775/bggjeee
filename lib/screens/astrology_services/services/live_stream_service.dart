import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LiveStreamService {
  final ApiRepository _apiRepository = Get.find();

  // Get live streams
  Future<LiveStreamResponse?> getLiveStreams({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiRepository.getApi(
        EndPoints.liveStreams,
        query: query,
        useAuthHeader: false, // Public endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return LiveStreamResponse.fromJson(response.body);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching live streams: $e');
      return null;
    }
  }

  // Join a live stream
  Future<JoinStreamResponse?> joinStream(String streamId) async {
    try {
      debugPrint('=== Join Stream API Call ===');
      debugPrint('Endpoint: ${EndPoints.joinStream(streamId)}');
      debugPrint('Stream ID: $streamId');
      
      final response = await _apiRepository.postApi(
        EndPoints.joinStream(streamId),
        {},
        useAuthHeader: true,
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          debugPrint('✓ Join API response parsed successfully');
          final joinResponse = JoinStreamResponse.fromJson(response.body);
          debugPrint('Parsed Join Response:');
          debugPrint('  - Stream ID: ${joinResponse.streamId}');
          debugPrint('  - Channel: ${joinResponse.channelName}');
          debugPrint('  - App ID: ${joinResponse.appId}');
          return joinResponse;
        } else {
          debugPrint('✗ Join API returned success=false');
          debugPrint('Response: ${response.body}');
        }
      } else {
        debugPrint('✗ Join API returned status: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
      return null;
    } catch (e) {
      debugPrint('✗✗✗ Error joining stream: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  // Get gifts catalog
  Future<GiftCatalog?> getGiftsCatalog() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.giftsCatalog,
        useAuthHeader: false, // Public endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return GiftCatalog.fromJson(response.body);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching gifts catalog: $e');
      return null;
    }
  }

  // RSVP for a scheduled stream
  Future<bool> rsvpStream(String streamId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.streamRsvp(streamId),
        {},
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error RSVPing stream: $e');
      return false;
    }
  }

  // Get RSVP count
  Future<int?> getRsvpCount(String streamId) async {
    try {
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
    } catch (e) {
      debugPrint('Error fetching RSVP count: $e');
      return null;
    }
  }

  // Get upcoming/scheduled streams
  Future<UpcomingStreamsResponse?> getUpcomingStreams({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiRepository.getApi(
        EndPoints.upcomingStreams,
        query: query,
        useAuthHeader: false, // Public endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return UpcomingStreamsResponse.fromJson(response.body);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching upcoming streams: $e');
      return null;
    }
  }

  // Get astrologer's scheduled streams
  Future<AstrologerScheduleResponse?> getAstrologerSchedule(String astrologerId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.astrologerSchedule(astrologerId),
        useAuthHeader: false, // Public endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return AstrologerScheduleResponse.fromJson(response.body);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching astrologer schedule: $e');
      return null;
    }
  }

  // Cancel RSVP
  Future<bool> cancelRsvp(String streamId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.streamRsvp(streamId),
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error cancelling RSVP: $e');
      return false;
    }
  }

  // Get user's RSVPs
  Future<List<Map<String, dynamic>>?> getUserRsvps() async {
    try {
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
      return null;
    } catch (e) {
      debugPrint('Error fetching user RSVPs: $e');
      return null;
    }
  }

  // Report a stream
  // Returns StreamReportResponse on success, null on failure
  // Throws AlreadyReportedException if stream was already reported (409 Conflict)
  Future<StreamReportResponse?> reportStream(String streamId, String category) async {
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
      return null;
    } on FetchDataException catch (e) {
      // Check if this is a 409 Conflict (already reported) error
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('already reported') || 
          errorMessage.contains('already reported this stream')) {
        // Throw a specific exception that can be caught and handled gracefully
        throw AlreadyReportedException('You have already reported this stream');
      }
      debugPrint('Error reporting stream: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error reporting stream: $e');
      return null;
    }
  }

  // Get my reports
  Future<StreamReportsResponse?> getMyReports({
    int page = 1,
    int limit = 20,
  }) async {
    try {
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
      return null;
    } catch (e) {
      debugPrint('Error fetching my reports: $e');
      return null;
    }
  }
}

