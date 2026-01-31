import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_review_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerReviewDialog {
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
    final currentFollowing = isFollowing.obs; // Make follow status reactive

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
            padding: EdgeInsets.all(24.w),
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
                        child: Text(
                          isEditing
                              ? 'Edit Your Review'
                              : 'Rate Your Experience',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: const Color(0xFF5F2221),
                            fontSize: 20.sp,
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
                  Spacing.h(12),
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
                        child: Text(
                          astrologer.displayName,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF333333),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(24),

                  // Follow Button (if not already following and callback provided)
                  // Use Obx to reactively update follow status
                  // Obx(() {
                  //   // Re-fetch follow status if needed (this will be reactive)
                  //   if (!currentFollowing.value) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(bottom: 16.h),
                  //       child: SizedBox(
                  //         width: double.infinity,
                  //         child: OutlinedButton.icon(
                  //           onPressed: () {
                  //             onFollow ??
                  //                 () {}; // Safe since we check null in Obx condition
                  //             // Update follow status after toggle
                  //             currentFollowing.value = true;
                  //           },
                  //           icon: Icon(
                  //             Icons.person_add,
                  //             size: 18.w,
                  //             color: AppColors.saffron,
                  //           ),
                  //           label: Text(
                  //             'Follow ${astrologer.displayName}',
                  //             style: MyTextTheme.mediumBCB.copyWith(
                  //               color: AppColors.saffron,
                  //               fontSize: 14.sp,
                  //             ),
                  //           ),
                  //           style: OutlinedButton.styleFrom(
                  //             side: BorderSide(
                  //               color: AppColors.saffron,
                  //               width: 1.5,
                  //             ),
                  //             padding: EdgeInsets.symmetric(vertical: 12.h),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10.r),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }
                  //   return const SizedBox.shrink();
                  // }),

                  // Rating Section
                  Text(
                    'How would you rate this experience?',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF333333),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h(12),
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
                                  size: 40.w,
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
                      () => Text(
                        _getRatingText(rating.value),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: AppColors.saffron,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Spacing.h(24),

                  // Review Text Section
                  Text(
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
                    maxLines: 6,
                    minLines: 4,
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
                                  child: Text(
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

                  Spacing.h(24),

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
                            child: Text(
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
                                              existingReview.id,
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
                                : Text(
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
