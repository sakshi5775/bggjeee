import 'dart:convert';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AstrologerReviewService {
  final ApiRepository _apiRepository = Get.find();

  /// sortBy: optional; when provided use one of: recent, helpful, rating-high, rating-low (do not send if empty or "--")
  /// serviceTypeFilter: optional; when provided use one of: CHAT, AUDIO, VIDEO (do not send if empty or "--")
  Future<AstrologerReviewResponse?> getReviews(
    String astrologerId, {
    int page = 1,
    int limit = 10,
    String? sortBy,
    int? ratingFilter,
    String? serviceTypeFilter,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      final validSortBy = ['recent', 'helpful', 'rating-high', 'rating-low'];
      if (sortBy != null &&
          sortBy.isNotEmpty &&
          sortBy != '--' &&
          validSortBy.contains(sortBy)) {
        query['sortBy'] = sortBy;
      }
      if (ratingFilter != null && ratingFilter > 0) {
        query['ratingFilter'] = ratingFilter.toString();
      }
      final validServiceTypes = ['CHAT', 'AUDIO', 'VIDEO'];
      if (serviceTypeFilter != null &&
          serviceTypeFilter.isNotEmpty &&
          serviceTypeFilter != '--' &&
          validServiceTypes.contains(serviceTypeFilter.toUpperCase())) {
        query['serviceTypeFilter'] = serviceTypeFilter.toUpperCase();
      }

      final response = await _apiRepository.getApi(
        EndPoints.astrologerReviews(astrologerId),
        query: query,
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map<String, dynamic> &&
            body['success'] == true &&
            body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          final reviewsList = data['reviews'] as List<dynamic>? ?? [];
          final paginationMap = data['pagination'] as Map<String, dynamic>? ?? {};
          return AstrologerReviewResponse(
            reviews: reviewsList
                .map((e) => AstrologerReview.fromJson(e as Map<String, dynamic>))
                .toList(),
            pagination: AstrologerReviewPagination.fromJson(paginationMap),
            disclaimer: data['disclaimer'] as String?,
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      return null;
    }
  }

  // Get review statistics for an astrologer
  Future<Map<String, dynamic>?> getReviewStatistics(String astrologerId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.astrologerReviewStatistics(astrologerId),
        useAuthHeader: false,
      );
      if (response.statusCode == 200 && response.body is Map) {
        final body = response.body as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          return body['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching review statistics: $e');
      return null;
    }
  }

  // Get user's own review for an astrologer and service type (VIDEO, AUDIO, CHAT)
  Future<AstrologerReview?> getMyReview(
    String astrologerId, {
    required String serviceType,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.astrologerReviewMe(astrologerId),
        query: {'serviceType': serviceType},
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map<String, dynamic> &&
            body['success'] == true &&
            body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          final reviewMap = data['review'] as Map<String, dynamic>?;
          if (reviewMap != null) {
            return AstrologerReview.fromJson(reviewMap);
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching my review: $e');
      return null;
    }
  }

  // Create a review (POST; one review per user per astrologer per service type)
  Future<Map<String, dynamic>> createReview(
    String astrologerId, {
    required int rating,
    required String reviewText,
    required String serviceType, // VIDEO, AUDIO, CHAT
  }) async {
    try {
      debugPrint('AstrologerReviewService.createReview -> astrologerId: $astrologerId, rating: $rating, serviceType: $serviceType');
      final body = {
        'rating': rating,
        'reviewText': reviewText,
        'serviceType': serviceType,
      };

      final response = await _apiRepository.postApi(
        EndPoints.astrologerReviews(astrologerId),
        body,
        useAuthHeader: true,
      );

      debugPrint('AstrologerReviewService.createReview response status: ${response.statusCode} body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resBody = response.body;
        final msg = resBody is Map ? (resBody['message']?.toString() ?? 'Review submitted successfully') : 'Review submitted successfully';
        return {'success': true, 'message': msg};
      } else {
        String errorMessage = 'Failed to submit review. Please try again.';
        if (response.body != null) {
          if (response.body is Map) {
            final resBody = response.body as Map;
            errorMessage = resBody['message']?.toString() ??
                resBody['error']?.toString() ??
                errorMessage;
          } else if (response.body is String) {
            try {
              final decoded = json.decode(response.body as String);
              if (decoded is Map) {
                errorMessage = decoded['message']?.toString() ?? 
                              decoded['error']?.toString() ?? 
                              errorMessage;
              }
            } catch (_) {
              // Use default message if parsing fails
            }
          }
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('Error creating review: $e');
      String errorMessage = 'Failed to submit review. Please try again.';
      final errorString = e.toString();

      // Preserve API message for "already submitted" so controller can open edit without showing error
      if (errorString.toLowerCase().contains('already submitted') ||
          errorString.toLowerCase().contains('already reviewed') ||
          errorString.toLowerCase().contains('video service') && errorString.toLowerCase().contains('review') ||
          errorString.toLowerCase().contains('audio service') && errorString.toLowerCase().contains('review') ||
          errorString.toLowerCase().contains('chat service') && errorString.toLowerCase().contains('review') ||
          errorString.toLowerCase().contains('already exists')) {
        final stripped = errorString.replaceFirst(RegExp(r'^[^:]+:\s*'), '').trim();
        if (stripped.isNotEmpty) {
          errorMessage = stripped;
        } else {
          errorMessage = 'You have already submitted a review for this service. You can update it below.';
        }
      } else if (errorString.toLowerCase().contains('must have a conversation') ||
          errorString.toLowerCase().contains('conversation')) {
        errorMessage = 'You must have a consultation with this astrologer before leaving a review.';
      } else if (errorString.toLowerCase().contains('unauthorized') ||
          errorString.toLowerCase().contains('401')) {
        errorMessage = 'Please login to submit a review.';
      } else if (errorString.toLowerCase().contains('network') ||
          errorString.toLowerCase().contains('connection') ||
          errorString.toLowerCase().contains('socket')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      } else if (errorString.toLowerCase().contains('timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (errorString.toLowerCase().contains('fetchdataexception')) {
        final match = RegExp(r'FetchDataException:\s*(.+)').firstMatch(errorString);
        if (match != null) {
          errorMessage = match.group(1)?.trim() ?? errorMessage;
        }
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  // Update a review
  Future<Map<String, dynamic>> updateReview(
    String astrologerId,
    String reviewId, {
    required int rating,
    required String reviewText,
  }) async {
    try {
      final body = {
        'rating': rating,
        'reviewText': reviewText,
      };

      final response = await _apiRepository.putApiCall(
        EndPoints.astrologerReviewById(astrologerId, reviewId),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': response.body['message']?.toString() ?? 'Review updated successfully'};
      } else {
        String errorMessage = 'Failed to update review. Please try again.';
        if (response.body != null && response.body is Map) {
          final body = response.body as Map;
          errorMessage = body['message']?.toString() ?? 
                        body['error']?.toString() ?? 
                        errorMessage;
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('Error updating review: $e');
      return {'success': false, 'message': 'Failed to update review. Please try again.'};
    }
  }

  // Delete a review
  Future<Map<String, dynamic>> deleteReview(
    String astrologerId,
    String reviewId,
  ) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.astrologerReviewById(astrologerId, reviewId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': response.body['message']?.toString() ?? 'Review deleted successfully'};
      } else {
        String errorMessage = 'Failed to delete review. Please try again.';
        if (response.body != null && response.body is Map) {
          final body = response.body as Map;
          errorMessage = body['message']?.toString() ?? 
                        body['error']?.toString() ?? 
                        errorMessage;
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('Error deleting review: $e');
      return {'success': false, 'message': 'Failed to delete review. Please try again.'};
    }
  }

  // Mark review as helpful
  Future<Map<String, dynamic>> markHelpful(
    String astrologerId,
    String reviewId,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.astrologerReviewHelpful(astrologerId, reviewId),
        {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true, 
          'message': response.body['message']?.toString() ?? 'Review marked as helpful',
          'helpfulCount': response.body['data']?['helpfulCount'] ?? 0,
        };
      } else {
        return {'success': false, 'message': 'Failed to mark review as helpful'};
      }
    } catch (e) {
      debugPrint('Error marking review as helpful: $e');
      return {'success': false, 'message': 'Failed to mark review as helpful'};
    }
  }

  // Report a review
  Future<Map<String, dynamic>> reportReview(
    String astrologerId,
    String reviewId,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.astrologerReviewReport(astrologerId, reviewId),
        {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true, 
          'message': response.body['message']?.toString() ?? 'Review reported successfully',
          'reportedCount': response.body['data']?['reportedCount'] ?? 0,
        };
      } else {
        return {'success': false, 'message': 'Failed to report review'};
      }
    } catch (e) {
      debugPrint('Error reporting review: $e');
      return {'success': false, 'message': 'Failed to report review'};
    }
  }
}

