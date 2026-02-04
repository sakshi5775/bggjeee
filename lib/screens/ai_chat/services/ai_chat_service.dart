import 'dart:convert';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AiChatService {
  final ApiRepository _apiRepository = Get.find();

  // Get personas with pagination
  Future<PersonaResponse?> getPersonas({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null && category.isNotEmpty) {
        query['category'] = category;
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        query['sortBy'] = sortBy;
      }

      final response = await _apiRepository.getApi(
        EndPoints.personaAi,
        query: query,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return PersonaResponse.fromJson(response.body);
        } catch (e) {
          debugPrint('Error parsing PersonaResponse: $e');
          debugPrint('Response body: ${response.body}');
          return null;
        }
      }
      debugPrint('API returned status code: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Error fetching personas: $e');
      return null;
    }
  }

  // Get categories
  Future<List<PersonaCategory>> getCategories() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.personaAiCategories,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          final data = response.body['data'] as List<dynamic>;
          return data
              .map((e) => PersonaCategory.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  // Get single persona by ID
  Future<PersonaModel?> getPersonaById(String id) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.personaAiById(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'] as Map<String, dynamic>;
        return PersonaModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get user's personas
  Future<PersonaResponse?> getMyPersonas({int page = 1, int limit = 20}) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiRepository.getApi(
        EndPoints.personaAiMyPersonas,
        query: query,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PersonaResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get reviews for a persona
  Future<PersonaReviewResponse?> getPersonaReviews(
    String personaId, {
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
        EndPoints.personaAiReviews(personaId),
        query: query,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PersonaReviewResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      return null;
    }
  }

  // Get user's own review for a persona
  Future<PersonaReview?> getMyReview(String personaId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.personaAiMyReview(personaId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true &&
            response.body['data'] != null &&
            response.body['data']['review'] != null) {
          final reviewData = response.body['data']['review'];
          if (reviewData is Map<String, dynamic>) {
            return PersonaReview.fromJson(reviewData);
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
    String personaId, {
    required int rating,
    required String reviewText,
    required String serviceType,
  }) async {
    try {
      final body = {
        'rating': rating,
        'reviewText': reviewText,
        "serviceType": serviceType,
      };

      final response = await _apiRepository.postApi(
        EndPoints.personaAiReviews(personaId),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message':
              response.body['message']?.toString() ??
              'Review submitted successfully',
        };
      } else {
        // Extract error message from response body
        String errorMessage = 'Failed to submit review. Please try again.';
        if (response.body != null) {
          if (response.body is Map) {
            final body = response.body as Map;
            errorMessage =
                body['message']?.toString() ??
                body['error']?.toString() ??
                errorMessage;
          } else if (response.body is String) {
            try {
              final decoded = json.decode(response.body as String);
              if (decoded is Map) {
                errorMessage =
                    decoded['message']?.toString() ??
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
      rethrow;
    }
  }

  // Update a review
  Future<Map<String, dynamic>> updateReview(
    String personaId,
    String reviewId, {
    required int rating,
    required String reviewText,
  }) async {
    try {
      final body = {'rating': rating, 'reviewText': reviewText};

      final response = await _apiRepository.putApiCall(
        EndPoints.personaAiReviewById(personaId, reviewId),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message':
              response.body['message']?.toString() ??
              'Review updated successfully',
        };
      } else {
        final errorMessage =
            response.body['message']?.toString() ??
            'Failed to update review. Please try again.';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('Error updating review: $e');
      String errorMessage = 'Failed to update review. Please try again.';
      if (e.toString().contains('not found')) {
        errorMessage = 'Review not found. Please try again.';
      }
      return {'success': false, 'message': errorMessage};
    }
  }

  // Delete a review
  Future<bool> deleteReview(String personaId, String reviewId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.personaAiReviewById(personaId, reviewId),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error deleting review: $e');
      return false;
    }
  }

  // Mark review as helpful
  Future<bool> markReviewHelpful(String personaId, String reviewId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.personaAiReviewHelpful(personaId, reviewId),
        {},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error marking review helpful: $e');
      return false;
    }
  }

  // Report a review
  Future<bool> reportReview(String personaId, String reviewId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.personaAiReviewReport(personaId, reviewId),
        {},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error reporting review: $e');
      return false;
    }
  }

  // Follow a persona
  Future<Map<String, dynamic>> followPersona(String personaId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.personaAiFollow(personaId),
        {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final followerCount = response.body['data']?['followerCount'] as int?;
        return {'success': true, 'followerCount': followerCount};
      }
      return {'success': false};
    } catch (e) {
      debugPrint('Error following persona: $e');
      return {'success': false};
    }
  }

  // Unfollow a persona
  Future<Map<String, dynamic>> unfollowPersona(String personaId) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.personaAiUnfollow(personaId),
        {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final followerCount = response.body['data']?['followerCount'] as int?;
        return {'success': true, 'followerCount': followerCount};
      }
      return {'success': false};
    } catch (e) {
      debugPrint('Error unfollowing persona: $e');
      return {'success': false};
    }
  }
}
