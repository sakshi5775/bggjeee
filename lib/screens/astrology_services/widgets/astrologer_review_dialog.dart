import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_review_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerReviewDialog {
  /// Show compact prompt asking if user wants to rate
  static void showPrompt({
    required BuildContext context,
    required AstrologerModel astrologer,
    required String serviceType,
    AstrologerReview? existingReview,
  }) {
    final isEditing = existingReview != null;

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.all(16.w),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: AppColors.saffron, size: 20.w),
            SizedBox(width: 8.w),
            Flexible(
              child: AutoTranslateText(
                isEditing ? 'Update Your Review' : 'Rate Your Experience',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: AutoTranslateText(
          isEditing
              ? 'You have already reviewed ${astrologer.displayName}. Would you like to update it?'
              : 'Would you like to rate your experience with ${astrologer.displayName}?',
          style: MyTextTheme.smallBCN.copyWith(
            color: const Color(0xFF666666),
            fontSize: 13.sp,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText(
              'Maybe Later',
              style: MyTextTheme.smallBCN.copyWith(
                color: const Color(0xFF666666),
                fontSize: 13.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close prompt
              // Show full review dialog
              show(
                context: context,
                astrologerId: astrologer.astrologerId,
                astrologer: astrologer,
                serviceType: serviceType,
                existingReview: existingReview,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffron,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: AutoTranslateText(
              isEditing ? 'Update Now' : 'Rate Now',
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show full review dialog
  static void show({
    required BuildContext context,
    required String astrologerId,
    required AstrologerModel astrologer,
    required String serviceType, // VIDEO, AUDIO, CHAT
    AstrologerReview? existingReview,
    bool isFollowing = false,
    VoidCallback? onFollow,
  }) {
    final reviewTextController = TextEditingController();
    final rating = 5.obs;
    final isEditing = existingReview != null;
    final isSubmitting = false.obs;
    final errorMessage = ''.obs;

    // Get or create controller
    final controller = Get.put(
      AstrologerReviewController(),
      tag: astrologerId,
      permanent: false,
    );

    if (isEditing) {
      reviewTextController.text = existingReview.reviewText;
      rating.value = existingReview.rating;
    }

    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 400.w),
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          isEditing
                              ? 'Edit Your Review'
                              : 'Rate Your Experience',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: const Color(0xFF5F2221),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                          size: 24.w,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  Row(
                    children: [
                      if (astrologer.profilePicture != null &&
                          astrologer.profilePicture!.isNotEmpty)
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: astrologer.profilePicture!,
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.saffron.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.saffron,
                            size: 24.w,
                          ),
                        ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AutoTranslateText(
                          astrologer.displayName,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF333333),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(16),

                  // Rating Section
                  AutoTranslateText(
                    'How would you rate this experience?',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF333333),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h(8),
                  Center(
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return Flexible(
                            child: GestureDetector(
                              onTap: isSubmitting.value
                                  ? null
                                  : () {
                                      rating.value = index + 1;
                                      errorMessage.value = '';
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 32.w,
                                  color: index < rating.value
                                      ? AppColors.saffron
                                      : Colors.grey[300]!,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Spacing.h(8),
                  Center(
                    child: Obx(
                      () => AutoTranslateText(
                        _getRatingText(rating.value),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: AppColors.saffron,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Spacing.h(16),

                  // Review Text Section
                  AutoTranslateText(
                    'Share your experience',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF333333),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h(8),
                  TextField(
                    controller: reviewTextController,
                    maxLines: 4,
                    minLines: 2,
                    enabled: !isSubmitting.value,
                    decoration: InputDecoration(
                      hintText:
                          'Tell others about your experience with this astrologer...',
                      hintStyle: MyTextTheme.smallBCN.copyWith(
                        color: Colors.grey[400],
                        fontSize: 13.sp,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.saffron,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                    ),
                    onChanged: (value) {
                      if (errorMessage.value.isNotEmpty) {
                        errorMessage.value = '';
                      }
                    },
                  ),

                  // Error Message
                  Obx(
                    () => errorMessage.value.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 16.w,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: AutoTranslateText(
                                    errorMessage.value,
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  Spacing.h(16),

                  // Action Buttons
                  Row(
                    children: [
                      if (isEditing)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSubmitting.value
                                ? null
                                : () async {
                                    final success = await controller
                                        .deleteReview(
                                          astrologerId,
                                          existingReview.id,
                                        );
                                    if (success) {
                                      Get.back();
                                    }
                                  },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red, width: 1.5),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: AutoTranslateText(
                              'Delete',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: Colors.red,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      if (isEditing) SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: isSubmitting.value
                                ? null
                                : () async {
                                    if (reviewTextController.text
                                        .trim()
                                        .isEmpty) {
                                      errorMessage.value =
                                          'Please share your experience in the review text';
                                      return;
                                    }

                                    isSubmitting.value = true;
                                    errorMessage.value = '';

                                    try {
                                      final success = isEditing
                                          ? await controller.updateReview(
                                              astrologerId,
                                              existingReview!.id,
                                              rating: rating.value,
                                              reviewText: reviewTextController
                                                  .text
                                                  .trim(),
                                            )
                                          : await controller.createReview(
                                              astrologerId,
                                              rating: rating.value,
                                              reviewText: reviewTextController
                                                  .text
                                                  .trim(),
                                              serviceType: serviceType,
                                            );

                                      if (success) {
                                        Get.back();
                                      }
                                    } catch (e) {
                                      // Show the actual error message from API
                                      errorMessage.value = e
                                          .toString()
                                          .replaceFirst('Exception: ', '');
                                    } finally {
                                      isSubmitting.value = false;
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.saffron,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              elevation: 0,
                            ),
                            child: isSubmitting.value
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : AutoTranslateText(
                                    isEditing
                                        ? 'Update Review'
                                        : 'Submit Review',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
