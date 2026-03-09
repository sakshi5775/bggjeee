import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_review_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Result of createReview: when user already has a review we return this so UI can open edit without showing an error.
class CreateReviewResult {
  final bool success;
  final AstrologerReview? existingReviewForEdit;
  CreateReviewResult({required this.success, this.existingReviewForEdit});
}

class AstrologerReviewController extends BaseController {
  final AstrologerReviewService _reviewService = AstrologerReviewService();

  // Reviews
  final RxList<AstrologerReview> reviews = <AstrologerReview>[].obs;
  final Rx<AstrologerReview?> myReview = Rx<AstrologerReview?>(null);
  final RxBool isLoadingReviews = false.obs;
  final RxInt currentReviewPage = 1.obs;
  final RxBool hasMoreReviews = true.obs;
  final RxInt totalReviewCount = 0.obs;

  // Review statistics (overall + byServiceType)
  final RxMap<String, dynamic> reviewStatistics = <String, dynamic>{}.obs;

  Future<void> loadReviewStatistics(String astrologerId) async {
    try {
      final data = await _reviewService.getReviewStatistics(astrologerId);
      if (data != null) reviewStatistics.value = data;
    } catch (e) {
      debugPrint('Error loading review statistics: $e');
    }
  }

  Future<void> loadReviews(
    String astrologerId, {
    bool refresh = true,
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
    int? ratingFilter,
    String? serviceTypeFilter,
  }) async {
    try {
      if (refresh) {
        currentReviewPage.value = 1;
        reviews.clear();
        hasMoreReviews.value = true;
        isLoadingReviews.value = true;
      }
      final pageToUse = refresh ? 1 : currentReviewPage.value;

      final response = await _reviewService.getReviews(
        astrologerId,
        page: pageToUse,
        limit: limit,
        sortBy: sortBy,
        ratingFilter: ratingFilter,
        serviceTypeFilter: serviceTypeFilter,
      );

      if (response != null) {
        if (refresh) {
          reviews.value = response.reviews;
          currentReviewPage.value = 1;
        } else {
          reviews.addAll(response.reviews);
        }
        hasMoreReviews.value = response.pagination.hasNextPage;
        totalReviewCount.value = response.pagination.totalReviews;
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

  /// Load the current user's review for this astrologer and [serviceType]. Use VIDEO, AUDIO, or CHAT depending on context.
  Future<void> loadMyReview(String astrologerId, {String serviceType = 'VIDEO'}) async {
    try {
      final review = await _reviewService.getMyReview(astrologerId, serviceType: serviceType);
      myReview.value = review;
    } catch (e) {
      debugPrint('Error loading my review: $e');
    }
  }

  /// Load the user's review for this astrologer by trying VIDEO, then AUDIO, then CHAT. Use on profile load so "Your review" shows regardless of service type.
  Future<void> loadMyReviewAnyServiceType(String astrologerId) async {
    for (final serviceType in ['VIDEO', 'AUDIO', 'CHAT']) {
      try {
        final review = await _reviewService.getMyReview(astrologerId, serviceType: serviceType);
        if (review != null) {
          myReview.value = review;
          return;
        }
      } catch (e) {
        debugPrint('Error loading my review ($serviceType): $e');
      }
    }
    myReview.value = null;
  }

  /// Returns [CreateReviewResult]. If user already has a review, returns success: false and existingReviewForEdit so UI can open edit without showing an error.
  Future<CreateReviewResult?> createReview(
    String astrologerId, {
    required int rating,
    required String reviewText,
    required String serviceType, // VIDEO, AUDIO, CHAT
  }) async {
    return await runWithLoading<CreateReviewResult>(
          () async {
            final result = await _reviewService.createReview(
              astrologerId,
              rating: rating,
              reviewText: reviewText,
              serviceType: serviceType,
            );

            if (result['success'] == true) {
              await Future.wait([
                loadReviews(astrologerId, refresh: true),
                loadMyReview(astrologerId, serviceType: serviceType),
              ]);
              return CreateReviewResult(success: true);
            } else {
              String message = result['message'] ?? 'Failed to submit review';
              final lower = message.toLowerCase();
              if (lower.contains('already submitted') ||
                  lower.contains('already reviewed') ||
                  lower.contains('video service') ||
                  lower.contains('audio service') ||
                  lower.contains('chat service')) {
                await loadMyReview(astrologerId, serviceType: serviceType);
                if (myReview.value == null) {
                  await loadMyReviewAnyServiceType(astrologerId);
                }
                return CreateReviewResult(
                  success: false,
                  existingReviewForEdit: myReview.value,
                );
              }
              throw message;
            }
          },
          showBusy: true,
          showError: true,
        );
  }

  /// [serviceType] must match the review's service type (VIDEO, AUDIO, or CHAT). Pass e.g. existingReview.serviceType from the dialog.
  Future<bool> updateReview(
    String astrologerId,
    String reviewId, {
    required int rating,
    required String reviewText,
    required String serviceType, // VIDEO, AUDIO, CHAT
  }) async {
    return await runWithLoading(
          () async {
            final result = await _reviewService.updateReview(
              astrologerId,
              reviewId,
              rating: rating,
              reviewText: reviewText,
            );

            if (result['success'] == true) {
              await Future.wait([
                loadReviews(astrologerId, refresh: true),
                loadMyReview(astrologerId, serviceType: serviceType),
              ]);
              return true;
            } else {
              throw result['message'] ?? 'Failed to update review';
            }
          },
          showBusy: true,
          showError: true,
        ) ??
        false;
  }

  Future<bool> deleteReview(String astrologerId, String reviewId) async {
    final result = await runWithLoading(
      () => _reviewService.deleteReview(astrologerId, reviewId),
      successMessage: 'Review deleted successfully',
    );

    if (result != null && result['success'] == true) {
      // Remove from local list
      reviews.removeWhere((r) => r.id == reviewId);
      myReview.value = null;
      return true;
    }
    return false;
  }

  Future<void> markReviewHelpful(String astrologerId, String reviewId) async {
    try {
      final result = await _reviewService.markHelpful(astrologerId, reviewId);
      if (result['success'] == true) {
        final index = reviews.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          final review = reviews[index];
          final newCount = result['helpfulCount'] as int? ?? review.helpfulCount + 1;
          reviews[index] = AstrologerReview(
            id: review.id,
            rating: review.rating,
            reviewText: review.reviewText,
            serviceType: review.serviceType,
            createdAt: review.createdAt,
            updatedAt: review.updatedAt,
            userDisplayInfo: review.userDisplayInfo,
            helpfulCount: newCount,
            reportedCount: review.reportedCount,
            status: review.status,
          );
        }
      }
    } catch (e) {
      debugPrint('Error marking review helpful: $e');
    }
  }

  Future<void> reportReview(String astrologerId, String reviewId) async {
    try {
      final result = await _reviewService.reportReview(astrologerId, reviewId);
      if (result['success'] == true) {
        final index = reviews.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          final review = reviews[index];
          final newCount = result['reportedCount'] as int? ?? review.reportedCount + 1;
          reviews[index] = AstrologerReview(
            id: review.id,
            rating: review.rating,
            reviewText: review.reviewText,
            serviceType: review.serviceType,
            createdAt: review.createdAt,
            updatedAt: review.updatedAt,
            userDisplayInfo: review.userDisplayInfo,
            helpfulCount: review.helpfulCount,
            reportedCount: newCount,
            status: review.status,
          );
        }
      }
    } catch (e) {
      debugPrint('Error reporting review: $e');
    }
  }
}
