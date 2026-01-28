import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_review_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AstrologerReviewController extends BaseController {
  final AstrologerReviewService _reviewService = AstrologerReviewService();
  final AstrologerChatService _chatService = AstrologerChatService();
  
  // Reviews
  final RxList<AstrologerReview> reviews = <AstrologerReview>[].obs;
  final Rx<AstrologerReview?> myReview = Rx<AstrologerReview?>(null);
  final RxBool isLoadingReviews = false.obs;
  final RxInt currentReviewPage = 1.obs;
  final RxBool hasMoreReviews = true.obs;

  Future<void> loadReviews(String astrologerId, {bool refresh = true}) async {
    try {
      if (refresh) {
        currentReviewPage.value = 1;
        reviews.clear();
        hasMoreReviews.value = true;
        isLoadingReviews.value = true;
      }

      final response = await _reviewService.getReviews(
        astrologerId,
        page: currentReviewPage.value,
        limit: 10,
        sortBy: 'recent',
      );

      if (response != null) {
        if (refresh) {
          reviews.value = response.reviews;
        } else {
          reviews.addAll(response.reviews);
        }

        hasMoreReviews.value = response.pagination.hasNextPage;
        if (response.pagination.hasNextPage) {
          currentReviewPage.value = response.pagination.currentPage + 1;
        }
      }
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> loadMyReview(String astrologerId) async {
    try {
      final review = await _reviewService.getMyReview(astrologerId);
      myReview.value = review;
    } catch (e) {
      debugPrint('Error loading my review: $e');
    }
  }

  Future<bool> createReview(
    String astrologerId, {
    required int rating,
    required String reviewText,
    required String serviceType, // VIDEO, AUDIO, CHAT
  }) async {
    try {
      // Pre-check: ensure user hasn't already reviewed and has had a conversation
      debugPrint('AstrologerReviewController.createReview -> checking eligibility for $astrologerId');
      await _ensureEligibleForReview(astrologerId);
      debugPrint('AstrologerReviewController.createReview -> eligibility passed for $astrologerId');

      setLoadingState(true);
      final result = await _reviewService.createReview(
        astrologerId,
        rating: rating,
        reviewText: reviewText,
        serviceType: serviceType,
      );

      if (result['success'] == true) {
        // Reload reviews
        await Future.wait([
          loadReviews(astrologerId, refresh: true),
          loadMyReview(astrologerId),
        ]);
        return true;
      } else {
        // Error message is already in result['message']
        debugPrint('AstrologerReviewController.createReview -> service returned failure: ${result['message']}');
        throw Exception(result['message'] ?? 'Failed to submit review');
      }
    } catch (e) {
      // Error will be handled by the dialog
      rethrow;
    } finally {
      setLoadingState(false);
    }
  }

  /// Ensure the current user is eligible to create a review for [astrologerId].
  /// Throws an [Exception] with a user-friendly message when not eligible.
  Future<void> _ensureEligibleForReview(String astrologerId) async {
    // Check if user has already submitted a review
    await loadMyReview(astrologerId);
    if (myReview.value != null) {
      throw Exception('You have already submitted a review for this astrologer. Use the update option to modify your review.');
    }

    // Check session history to verify user had a conversation with this astrologer
    try {
      final history = await _chatService.getSessionHistory(page: 1, limit: 100);
      final sessions = history['sessions'] as List?;
      if (sessions == null || sessions.isEmpty) {
        // Don't block review submission if history check fails - let backend validate
        debugPrint('Warning: No session history found, but allowing review submission (backend will validate)');
        return;
      }

      final bool hasConversation = sessions.any((s) {
        try {
          final session = s as dynamic;
          final sid = session.astrologerId?.toString() ?? session['astrologerId']?.toString();
          final status = session.status?.toString() ?? session['status']?.toString();
          if (sid == null) return false;
          // Consider sessions other than CREATED as valid conversations
          return sid == astrologerId && (status != null && status != 'CREATED');
        } catch (_) {
          return false;
        }
      });

      if (!hasConversation) {
        // Don't block - let backend validate. This is just a pre-check.
        debugPrint('Warning: No conversation found in local history, but allowing review submission (backend will validate)');
        return;
      }
    } catch (e) {
      // Don't block review submission if history check fails - let backend validate
      debugPrint('Warning: Error checking session history: $e. Allowing review submission (backend will validate)');
      // Don't throw - let the backend handle validation
    }
  }

  Future<bool> updateReview(
    String astrologerId,
    String reviewId, {
    required int rating,
    required String reviewText,
  }) async {
    try {
      setLoadingState(true);
      final result = await _reviewService.updateReview(
        astrologerId,
        reviewId,
        rating: rating,
        reviewText: reviewText,
      );

      if (result['success'] == true) {
        // Reload reviews
        await Future.wait([
          loadReviews(astrologerId, refresh: true),
          loadMyReview(astrologerId),
        ]);
        return true;
      } else {
        // Error message is already in result['message']
        throw Exception(result['message'] ?? 'Failed to update review');
      }
    } catch (e) {
      // Error will be handled by the dialog
      rethrow;
    } finally {
      setLoadingState(false);
    }
  }

  Future<bool> deleteReview(String astrologerId, String reviewId) async {
    try {
      setLoadingState(true);
      final result = await _reviewService.deleteReview(astrologerId, reviewId);

      if (result['success'] == true) {
        // Remove from local list
        reviews.removeWhere((r) => r.id == reviewId);
        myReview.value = null;
        
        showSuccessMessage(
          title: 'Success',
          message: 'Review deleted successfully',
        );
        return true;
      } else {
        showErrorMessage(
          title: 'Error',
          message: result['message'] ?? 'Failed to delete review',
        );
        return false;
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Failed to delete review: ${e.toString()}',
      );
      return false;
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> markReviewHelpful(String astrologerId, String reviewId) async {
    try {
      final result = await _reviewService.markHelpful(astrologerId, reviewId);
      if (result['success'] == true) {
        // Update local review
        final index = reviews.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          final review = reviews[index];
          final updatedReview = AstrologerReview(
            id: review.id,
            rating: review.rating,
            reviewText: review.reviewText,
            serviceType: review.serviceType,
            createdAt: review.createdAt,
            updatedAt: review.updatedAt,
            userDisplayInfo: review.userDisplayInfo,
            helpfulCount: result['helpfulCount'] as int? ?? review.helpfulCount + 1,
            reportedCount: review.reportedCount,
            status: review.status,
          );
          reviews[index] = updatedReview;
        }
      }
    } catch (e) {
      debugPrint('Error marking review helpful: $e');
    }
  }
}



