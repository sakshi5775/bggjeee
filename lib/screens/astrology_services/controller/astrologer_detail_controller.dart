import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_review_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrologer_review_dialog.dart';
import 'package:astrobharataiuser/utils/call_initiation_helper.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerDetailController extends GetxController {
  late AstrologerModel astrologer;
  final RxString selectedTab = 'About'.obs; // About, Expertise, Reviews
  late AstrologerReviewController reviewController;
  final AstrologerService _astrologerService = AstrologerService();

  // Follow state
  final RxBool isFollowing = false.obs;
  final RxBool isTogglingFollow = false.obs;
  final RxInt followerCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get astrologer from arguments
    final args = Get.arguments;
    if (args is AstrologerModel) {
      astrologer = args;
    } else if (args is Map<String, dynamic> && args['astrologer'] != null) {
      astrologer = args['astrologer'] as AstrologerModel;
    } else {
      // Handle error case
      Get.back();
      return;
    }
    
    // Initialize review controller
    reviewController = Get.put(AstrologerReviewController(), tag: astrologer.astrologerId, permanent: false);
    // Load reviews and my review
    reviewController.loadReviews(astrologer.astrologerId);
    reviewController.loadMyReview(astrologer.astrologerId);
    
    // Load follow status and follower count
    loadFollowStatus();
    loadFollowersCount();
    
    // Check if review prompt should be shown
    if (args is Map<String, dynamic> && args['showReviewPrompt'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (reviewController.myReview.value == null) {
            // Show review dialog
            Get.dialog(
              barrierDismissible: false,
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                title: Row(
                  children: [
                    Icon(Icons.star, color: AppColors.saffron, size: 24.w),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: AutoTranslateText(
                        'Rate Your Experience',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: const Color(0xFF5F2221),
                        ).merge(AppTypography.h2),
                      ),
                    ),
                  ],
                ),
                content: AutoTranslateText(
                  'Would you like to rate your experience with ${astrologer.displayName}?',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                  ).merge(AppTypography.body1),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText(
                      'Maybe Later',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close prompt dialog
                      // Show review dialog
                      Future.delayed(const Duration(milliseconds: 300), () async {
                        // Fetch current follow status before showing dialog
                        bool currentFollowing = isFollowing.value;
                        try {
                          final status = await _astrologerService.getFollowStatus(astrologer.astrologerId);
                          currentFollowing = status?['isFollowing'] ?? false;
                        } catch (e) {
                          // Use current value if fetch fails
                          if (kDebugMode) print('Error fetching follow status for review dialog: $e');
                        }
                        
                        AstrologerReviewDialog.show(
                          context: Get.context!,
                          astrologerId: astrologer.astrologerId,
                          astrologer: astrologer,
                          serviceType: args['serviceType'] as String? ?? 'VIDEO',
                          isFollowing: currentFollowing,
                          onFollow: () async {
                            await toggleFollow();
                            // Refresh follow status after toggle
                            await loadFollowStatus();
                          },
                        );
                      });
                    },
                    child: AutoTranslateText(
                      'Rate Now',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.saffron,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
      });
    }
  }

  void setSelectedTab(String tab) {
    selectedTab.value = tab;
  }

  // Helper methods - Get all prices formatted
  String getPrice() {
    List<String> prices = [];
    
    if (astrologer.chatPricePerMin != null && astrologer.chatPricePerMin! > 0) {
      prices.add('Chat: ₹${astrologer.chatPricePerMin!.toStringAsFixed(0)}/min');
    }
    if (astrologer.voicePricePerMin != null && astrologer.voicePricePerMin! > 0) {
      prices.add('Call: ₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min');
    }
    if (astrologer.videoPricePerMin != null && astrologer.videoPricePerMin! > 0) {
      prices.add('Video: ₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min');
    }
    
    if (prices.isEmpty) {
      return 'N/A';
    }
    return prices.join(' • ');
  }
  
  // Get individual prices for detailed display
  Map<String, String?> getDetailedPrices() {
    return {
      'chat': astrologer.chatPricePerMin != null && astrologer.chatPricePerMin! > 0
          ? '₹${astrologer.chatPricePerMin!.toStringAsFixed(0)}/min'
          : null,
      'voice': astrologer.voicePricePerMin != null && astrologer.voicePricePerMin! > 0
          ? '₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min'
          : null,
      'video': astrologer.videoPricePerMin != null && astrologer.videoPricePerMin! > 0
          ? '₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min'
          : null,
    };
  }

  String getSpecializations() {
    if (astrologer.specializations.isEmpty) {
      return 'Astrologer';
    }
    return astrologer.specializations.join(' & ');
  }

  String getLanguages() {
    if (astrologer.languages.isEmpty) {
      return 'Hindi';
    }
    return astrologer.languages.join(', ');
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  // Load follow status
  Future<void> loadFollowStatus() async {
    try {
      final status = await _astrologerService.getFollowStatus(astrologer.astrologerId);
      if (status != null) {
        isFollowing.value = status['isFollowing'] as bool? ?? false;
      }
    } catch (e) {
      debugPrint('Error loading follow status: $e');
    }
  }

  // Load followers count
  Future<void> loadFollowersCount() async {
    try {
      final count = await _astrologerService.getFollowersCount(astrologer.astrologerId);
      if (count != null) {
        followerCount.value = count;
      }
    } catch (e) {
      debugPrint('Error loading followers count: $e');
    }
  }

  // Toggle follow/unfollow
  Future<void> toggleFollow() async {
    if (isTogglingFollow.value) return;

    final currentState = isFollowing.value;
    try {
      isTogglingFollow.value = true;
      final result = currentState
          ? await _astrologerService.unfollowAstrologer(astrologer.astrologerId)
          : await _astrologerService.followAstrologer(astrologer.astrologerId, source: 'PROFILE');

      if (result['success'] == true) {
        // Update follow state
        isFollowing.value = !currentState;
        
        // Update follower count
        final newFollowerCount = result['followerCount'] as int?;
        if (newFollowerCount != null) {
          followerCount.value = newFollowerCount;
        } else {
          // Fallback: increment/decrement locally
          followerCount.value = currentState 
              ? (followerCount.value - 1).clamp(0, double.infinity).toInt()
              : followerCount.value + 1;
        }

        Get.snackbar(
          'Success',
          currentState ? 'Unfollowed ${astrologer.displayName}' : 'Following ${astrologer.displayName}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to ${currentState ? 'unfollow' : 'follow'} astrologer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${currentState ? 'unfollow' : 'follow'}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isTogglingFollow.value = false;
    }
  }

  /// Initiate voice call directly (bypasses booking screen)
  Future<void> initiateVoiceCall() async {
    await CallInitiationHelper.initiateVoiceCall(astrologer);
  }

  /// Initiate video call directly (bypasses booking screen)
  Future<void> initiateVideoCall() async {
    await CallInitiationHelper.initiateVideoCall(astrologer);
  }
}


