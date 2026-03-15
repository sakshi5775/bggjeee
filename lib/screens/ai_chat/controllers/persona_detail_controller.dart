import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PersonaDetailController extends BaseController {
  final AiChatService _aiChatService = AiChatService();
  GetStorage get _followStorage => GetStorage('personaFollows');

  final Rx<PersonaModel?> persona = Rx<PersonaModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isDescriptionExpanded = false.obs;

  // Reviews
  final RxList<PersonaReview> reviews = <PersonaReview>[].obs;
  final Rx<PersonaReview?> myReview = Rx<PersonaReview?>(null);
  final RxBool isLoadingReviews = false.obs;
  final RxInt currentReviewPage = 1.obs;
  final RxBool hasMoreReviews = true.obs;
  final RxInt totalReviewCount = 0.obs;

  // Follow state
  final RxBool isFollowing = false.obs;
  final RxBool isTogglingFollow = false.obs;

  // Track selected service type for review
  final RxString selectedServiceType = "CHAT".obs;

  // Get follow state from storage
  bool _getFollowStateFromStorage(String personaId) {
    try {
      return _followStorage.read('follow_$personaId') == true;
    } catch (e) {
      debugPrint('Error reading follow state from storage: $e');
      return false;
    }
  }

  // Save follow state to storage
  void _saveFollowStateToStorage(String personaId, bool isFollowing) {
    try {
      _followStorage.write('follow_$personaId', isFollowing);
    } catch (e) {
      debugPrint('Error saving follow state to storage: $e');
    }
  }

  // Get follower count from storage
  int? _getFollowerCountFromStorage(String personaId) {
    try {
      return _followStorage.read('followers_$personaId') as int?;
    } catch (e) {
      debugPrint('Error reading follower count from storage: $e');
      return null;
    }
  }

  // Save follower count to storage
  void _saveFollowerCountToStorage(String personaId, int followerCount) {
    try {
      _followStorage.write('followers_$personaId', followerCount);
    } catch (e) {
      debugPrint('Error saving follower count to storage: $e');
    }
  }

  Future<void> loadPersonaDetail(String personaId) async {
    try {
      isLoading.value = true;
      var loadedPersona = await _aiChatService.getPersonaById(personaId);
      if (loadedPersona != null) {
        // Fetch Persona AI pricing from user-service (source of truth per doc)
        final pricing = await _aiChatService.getPersonaPricing(personaId);
        if (pricing != null) {
          loadedPersona = PersonaModel(
            id: loadedPersona.id,
            displayName: loadedPersona.displayName,
            name: loadedPersona.name,
            image: loadedPersona.image,
            description: loadedPersona.description,
            category: loadedPersona.category,
            tags: loadedPersona.tags,
            specializations: loadedPersona.specializations,
            rating: loadedPersona.rating,
            totalRatings: loadedPersona.totalRatings,
            price: loadedPersona.price,
            chatPricePerMinute: pricing.effectiveChatPricePerMinute,
            callPricePerMinute: pricing.effectiveCallPricePerMinute,
            pricePerMin: pricing.effectiveChatPricePerMinute,
            languages: loadedPersona.languages,
            followers: loadedPersona.followers,
            experienceYears: loadedPersona.experienceYears,
            isOnline: loadedPersona.isOnline,
            reviewStatistics: loadedPersona.reviewStatistics,
            isFollowing: loadedPersona.isFollowing,
          );
        }

        // Get follow state from storage (since API doesn't return it)
        // If API returns isFollowing, use it; otherwise use storage
        final storedFollowState = _getFollowStateFromStorage(personaId);
        isFollowing.value = loadedPersona.isFollowing ?? storedFollowState;

        // Get follower count from storage
        final storedFollowerCount = _getFollowerCountFromStorage(personaId);
        int? finalFollowerCount = loadedPersona.followers;

        // If API returns null or 0, but we have a stored value, use stored value
        // This handles the case where API doesn't return accurate follower count
        if ((finalFollowerCount == null || finalFollowerCount == 0) &&
            storedFollowerCount != null &&
            storedFollowerCount > 0) {
          finalFollowerCount = storedFollowerCount;
        } else if (finalFollowerCount != null && finalFollowerCount > 0) {
          // API returned a valid follower count, save it to storage
          _saveFollowerCountToStorage(personaId, finalFollowerCount);
        }

        // Update persona with final follower count if it differs from API response
        if (finalFollowerCount != loadedPersona.followers) {
          final updatedPersona = PersonaModel(
            id: loadedPersona.id,
            displayName: loadedPersona.displayName,
            name: loadedPersona.name,
            image: loadedPersona.image,
            description: loadedPersona.description,
            category: loadedPersona.category,
            tags: loadedPersona.tags,
            specializations: loadedPersona.specializations,
            rating: loadedPersona.rating,
            totalRatings: loadedPersona.totalRatings,
            price: loadedPersona.price,
            chatPricePerMinute: loadedPersona.chatPricePerMinute,
            callPricePerMinute: loadedPersona.callPricePerMinute,
            pricePerMin: loadedPersona.pricePerMin,
            languages: loadedPersona.languages,
            followers: finalFollowerCount,
            experienceYears: loadedPersona.experienceYears,
            isOnline: loadedPersona.isOnline,
            reviewStatistics: loadedPersona.reviewStatistics,
            isFollowing: loadedPersona.isFollowing ?? storedFollowState,
          );
          persona.value = updatedPersona;
        } else {
          persona.value = loadedPersona;
        }

        // Load reviews and user's review
        await Future.wait([loadReviews(personaId), loadMyReview(personaId)]);
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to load persona details',
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Failed to load persona details: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadReviews(String personaId, {bool refresh = true}) async {
    try {
      if (refresh) {
        currentReviewPage.value = 1;
        reviews.clear();
        hasMoreReviews.value = true;
        isLoadingReviews.value = true;
      }

      final response = await _aiChatService.getPersonaReviews(
        personaId,
        page: currentReviewPage.value,
        limit: 10,
        sortBy: 'recent',
      );

      if (response != null) {
        totalReviewCount.value = response.pagination.total;
        if (refresh) {
          reviews.value = response.reviews;
        } else {
          reviews.addAll(response.reviews);
        }

        hasMoreReviews.value = response.pagination.hasNextPage;
        if (response.pagination.hasNextPage) {
          currentReviewPage.value = response.pagination.page + 1;
        }
      }
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> loadMyReview(String personaId) async {
    try {
      final review = await _aiChatService.getMyReview(personaId);
      myReview.value = review;
    } catch (e) {
      debugPrint('Error loading my review: $e');
    }
  }

  Future<bool> createReview(
    String personaId, {
    required int rating,
    required String reviewText,
    required String serviceType,
  }) async {
    try {
      setLoadingState(true);
      final result = await _aiChatService.createReview(
        personaId,
        rating: rating,
        reviewText: reviewText,
        serviceType: serviceType,
      );

      if (result['success'] == true) {
        // Reload reviews and persona details
        await Future.wait([
          loadReviews(personaId, refresh: true),
          loadMyReview(personaId),
          loadPersonaDetail(personaId),
        ]);
        return true;
      } else {
        // Error message is already in result['message']
        throw Exception(result['message'] ?? 'Failed to submit review');
      }
    } catch (e) {
      // Error will be handled by the dialog
      rethrow;
    } finally {
      setLoadingState(false);
    }
  }

  Future<bool> updateReview(
    String personaId,
    String reviewId, {
    required int rating,
    required String reviewText,
  }) async {
    try {
      setLoadingState(true);
      final result = await _aiChatService.updateReview(
        personaId,
        reviewId,
        rating: rating,
        reviewText: reviewText,
      );

      if (result['success'] == true) {
        // Reload reviews and persona details
        await Future.wait([
          loadReviews(personaId, refresh: true),
          loadMyReview(personaId),
          loadPersonaDetail(personaId),
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

  Future<bool> deleteReview(String personaId, String reviewId) async {
    final result = await runWithLoading(
      () async {
        final success = await _aiChatService.deleteReview(personaId, reviewId);

        if (success) {
          reviews.removeWhere((r) => r.id == reviewId);
          myReview.value = null;
          await loadPersonaDetail(personaId);
          return true;
        }
        return false;
      },
      successMessage: 'Review deleted successfully',
      useDialog: true,
    );
    return result ?? false;
  }

  Future<void> toggleFollow(String personaId) async {
    if (isTogglingFollow.value) return;

    final currentState = isFollowing.value;
    try {
      isTogglingFollow.value = true;
      final result = currentState
          ? await _aiChatService.unfollowPersona(personaId)
          : await _aiChatService.followPersona(personaId);

      if (result['success'] == true) {
        // Update follow state
        final newFollowState = !currentState;
        isFollowing.value = newFollowState;

        // Save follow state to storage for persistence
        _saveFollowStateToStorage(personaId, newFollowState);

        // Update persona model with new follower count and follow state
        if (persona.value != null) {
          final newFollowerCount = result['followerCount'] as int?;
          final updatedFollowerCount =
              newFollowerCount ??
              ((persona.value!.followers ?? 0) + (currentState ? -1 : 1));

          // Save follower count to storage for persistence
          _saveFollowerCountToStorage(personaId, updatedFollowerCount);

          final updatedPersona = PersonaModel(
            id: persona.value!.id,
            displayName: persona.value!.displayName,
            name: persona.value!.name,
            image: persona.value!.image,
            description: persona.value!.description,
            category: persona.value!.category,
            tags: persona.value!.tags,
            specializations: persona.value!.specializations,
            rating: persona.value!.rating,
            totalRatings: persona.value!.totalRatings,
            price: persona.value!.price,
            chatPricePerMinute: persona.value!.chatPricePerMinute,
            callPricePerMinute: persona.value!.callPricePerMinute,
            pricePerMin: persona.value!.pricePerMin,
            languages: persona.value!.languages,
            followers: updatedFollowerCount,
            experienceYears: persona.value!.experienceYears,
            isOnline: persona.value!.isOnline,
            reviewStatistics: persona.value!.reviewStatistics,
            isFollowing: newFollowState, // Update follow state
          );
          persona.value = updatedPersona;
        }
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to ${currentState ? 'unfollow' : 'follow'} persona',
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message:
            'Failed to ${currentState ? 'unfollow' : 'follow'}: ${e.toString()}',
      );
    } finally {
      isTogglingFollow.value = false;
    }
  }

  Future<void> markReviewHelpful(String personaId, String reviewId) async {
    try {
      final success = await _aiChatService.markReviewHelpful(
        personaId,
        reviewId,
      );
      if (success) {
        // Update local review
        final index = reviews.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          final review = reviews[index];
          final updatedReview = PersonaReview(
            id: review.id,
            rating: review.rating,
            reviewText: review.reviewText,
            createdAt: review.createdAt,
            updatedAt: review.updatedAt,
            userDisplayInfo: review.userDisplayInfo,
            helpfulCount: review.helpfulCount + 1,
            isVerifiedPurchase: review.isVerifiedPurchase,
          );
          reviews[index] = updatedReview;
        }
      }
    } catch (e) {
      debugPrint('Error marking review helpful: $e');
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }
}
