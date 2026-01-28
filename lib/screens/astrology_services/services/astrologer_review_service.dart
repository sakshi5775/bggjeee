import 'dart:convert';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AstrologerReviewService {
  final ApiRepository _apiRepository = Get.find();

  // Get reviews for an astrologer
  Future<AstrologerReviewResponse?> getReviews(
    String astrologerId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
        'sortBy': sortBy,
      };

      final response = await _apiRepository.getApi(
        EndPoints.astrologerReviews(astrologerId),
        query: query,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AstrologerReviewResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      return null;
    }
  }

  // Get user's own review for an astrologer
  Future<AstrologerReview?> getMyReview(String astrologerId) async {
    try {
      final currentUserId = UserData().getLoginData.user?.userId;
      if (currentUserId == null) {
        return null;
      }

      final response = await _apiRepository.getApi(
        EndPoints.astrologerReviews(astrologerId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && 
            response.body['data'] != null &&
            response.body['data']['reviews'] != null) {
          final reviewsList = response.body['data']['reviews'] as List;
          // Find the review by current user
          for (var reviewData in reviewsList) {
            final reviewMap = reviewData as Map<String, dynamic>;
            final reviewUserId = reviewMap['userId']?.toString();
            if (reviewUserId == currentUserId) {
              return AstrologerReview.fromJson(reviewMap);
            }
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching my review: $e');
      return null;
    }
  }

  // Create a review
  Future<Map<String, dynamic>> createReview(
    String astrologerId, {
    required int rating,
    required String reviewText,
    required String serviceType, // VIDEO, AUDIO, CHAT
  }) async {
    try {
      debugPrint('AstrologerReviewService.createReview -> astrologerId: $astrologerId, rating: $rating, serviceType: $serviceType, reviewText: ${reviewText.length} chars');
      final body = {
        'rating': rating,
        'reviewText': reviewText,
        'serviceType': serviceType,
      };

      final response = await _apiRepository.postApi(
        EndPoints.astrologerReviews(astrologerId),
        body,
      );

      debugPrint('AstrologerReviewService.createReview response status: ${response.statusCode} body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': response.body['message']?.toString() ?? 'Review submitted successfully'};
      } else {
        // Extract error message from response body
        String errorMessage = 'Failed to submit review. Please try again.';
        if (response.body != null) {
          if (response.body is Map) {
            final body = response.body as Map;
            errorMessage = body['message']?.toString() ?? 
                          body['error']?.toString() ?? 
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
      
      // Try to extract error message from exception
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('must have a conversation') || 
          errorString.contains('conversation')) {
        errorMessage = 'You must have a consultation with this astrologer before leaving a review.';
      } else if (errorString.contains('already reviewed') || 
                 errorString.contains('already exists')) {
        errorMessage = 'You have already reviewed this astrologer. Use the update option to modify your review.';
      } else if (errorString.contains('unauthorized') || 
                 errorString.contains('401')) {
        errorMessage = 'Please login to submit a review.';
      } else if (errorString.contains('network') || 
                 errorString.contains('connection') ||
                 errorString.contains('socket')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      } else if (errorString.contains('timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (errorString.contains('fetchdataexception')) {
        // Extract message from FetchDataException
        final match = RegExp(r'FetchDataException:\s*(.+)').firstMatch(errorString);
        if (match != null) {
          errorMessage = match.group(1) ?? errorMessage;
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

