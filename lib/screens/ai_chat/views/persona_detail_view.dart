import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/controllers/persona_detail_controller.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/chat_profile_dialog.dart';
import 'package:astrobharataiuser/services/chat_call_precheck_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonaDetailView extends StatelessWidget {
  final String personaId;
  final PersonaModel? persona; // Optional initial persona data

  const PersonaDetailView({super.key, required this.personaId, this.persona});

  @override
  Widget build(BuildContext context) {
    // Use tag to maintain separate controller instances per persona
    // Use putIfAbsent to reuse existing controller or create new one
    final controller = Get.put(
      PersonaDetailController(),
      tag: personaId,
      permanent: false,
    );

    // Check if review prompt should be shown
    final arguments = Get.arguments as Map<String, dynamic>?;
    final showReviewPrompt = arguments?['showReviewPrompt'] == true;

    // Always reload persona detail to get latest data
    // Use provided persona as initial data if available, but still reload from API
    if (persona != null) {
      controller.persona.value = persona;
      // Still reload to get latest state from server
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadPersonaDetail(personaId).then((_) {
          // Show review prompt after loading if requested
          if (showReviewPrompt && controller.myReview.value == null) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _showReviewDialog(
                context,
                controller,
                personaId,
                persona: controller.persona.value,
              );
            });
          }
        });
      });
    } else {
      controller.loadPersonaDetail(personaId).then((_) {
        // Show review prompt after loading if requested
        if (showReviewPrompt && controller.myReview.value == null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showReviewDialog(
              context,
              controller,
              personaId,
              persona: controller.persona.value,
            );
          });
        }
      });
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.persona.value == null) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.deepOrange,
                  ),
                ),
              );
            }

            final persona = controller.persona.value;
            if (persona == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    Spacing.h(16),
                    AutoTranslateText(
                      'Failed to load persona details',
                      style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
                    ),
                    Spacing.h(16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const AutoTranslateText('Go Back'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Header using CommonHeader
                _buildHeader(context, persona),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Share
                        _buildNameSection(context, persona),
                        Spacing.h(16),
                        // Profile Card
                        _buildProfileCard(context, persona, controller),
                        Spacing.h(16),
                        // Consultation Charges
                        _buildConsultationCharges(context, persona),
                        Spacing.h(24),
                        // About Astrologer
                        _buildAboutSection(context, persona, controller),
                        Spacing.h(24),
                        // Ratings and Reviews
                        _buildRatingsSection(context, persona, controller),
                        Spacing.h(100), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        bottomNavigationBar: Obx(() {
          final persona = controller.persona.value;
          if (persona == null) return const SizedBox.shrink();
          return _buildBottomButtons(context, persona, controller);
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PersonaModel persona) {
    return CommonHeader(
      title: 'Astrologer Details',
      titleColor: AppColors.templeGold,
      actions: [
        // History icon
        GestureDetector(
          onTap: () {
            Get.toNamed(
              AppRoutes.personaVoiceHistory,
              arguments: {'personaId': persona.id, 'persona': persona},
            );
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: '#F38B3B'.toColor().withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.history, color: Colors.white, size: 20.w),
          ),
        ),
        SizedBox(width: 8.w),
        // Wallet
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.wallet);
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: '#F38B3B'.toColor().withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameSection(BuildContext context, PersonaModel persona) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoTranslateText(
              persona.name.isNotEmpty ? persona.name : persona.displayName,
              style: AppTypography.h1.copyWith(color: const Color(0xFF5F2221)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.share, color: const Color(0xFF5F2221), size: 24.w),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    PersonaModel persona,
    PersonaDetailController controller,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.deepOrange, width: 2),
                ),
                child: ClipOval(
                  child: persona.image != null && persona.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: persona.image!,
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFF5F5F5),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.deepOrange,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFF5F5F5),
                            child: Icon(
                              Icons.person,
                              size: 40.w,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          color: const Color(0xFFF5F5F5),
                          child: Icon(
                            Icons.person,
                            size: 40.w,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              // Online status dot
              if (persona.isOnline ?? true)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Specialization
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.deepOrange, size: 16.w),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AutoTranslateText(
                        persona.specializations.isNotEmpty
                            ? persona.specializations
                                  .map((s) => s.replaceAll('_', ' '))
                                  .join(', ')
                            : persona.category.replaceAll('_', ' '),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF666666),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
                // Languages
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: AppColors.deepOrange,
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AutoTranslateText(
                        persona.languages.isNotEmpty
                            ? persona.languages.join(', ')
                            : 'English, Hindi',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF666666),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
                // Experience
                Row(
                  children: [
                    Icon(Icons.school, color: AppColors.deepOrange, size: 16.w),
                    SizedBox(width: 4.w),
                    AutoTranslateText(
                      '${persona.experienceYears ?? 10} Years of Experience',
                      style: AppTypography.body2.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                // Follow button and followers
                Obx(() {
                  final isFollowing = controller.isFollowing.value;
                  final isToggling = controller.isTogglingFollow.value;
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: isToggling
                            ? null
                            : () {
                                controller.toggleFollow(persona.id);
                              },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: isFollowing
                                ? null
                                : AppColors.orangeGradient,
                            color: isFollowing ? Colors.grey[300] : null,
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: isFollowing
                                ? null
                                : [
                                    BoxShadow(
                                      color: '#F38B3B'.toColor().withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: isToggling
                              ? SizedBox(
                                  width: 14.w,
                                  height: 14.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isFollowing
                                          ? Colors.black87
                                          : Colors.white,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isFollowing ? Icons.check : Icons.star,
                                      size: 14.w,
                                      color: isFollowing
                                          ? Colors.black87
                                          : Colors.white,
                                    ),
                                    SizedBox(width: 4.w),
                                    AutoTranslateText(
                                      isFollowing ? 'Following' : 'Follow',
                                      style: MyTextTheme.smallBCB.copyWith(
                                        color: isFollowing
                                            ? Colors.black87
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        '${persona.followers ?? 0} Followers',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCharges(BuildContext context, PersonaModel persona) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Charges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Consultation Charges',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                  ),
                ),
                Spacing.h(4),
                Row(
                  children: [
                    if (persona.pricePerMin == null || persona.pricePerMin == 0)
                      AutoTranslateText(
                        'FREE',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else ...[
                      AutoTranslateText(
                        '₹${persona.pricePerMin!.toInt()}/min',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Rating badge
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: '#F38B3B'.toColor().withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoTranslateText(
                  '${persona.rating?.toStringAsFixed(1) ?? "0.0"}',
                  style: AppTypography.h2.copyWith(color: Colors.white),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) =>
                        Icon(Icons.star, color: Colors.yellow, size: 12.w),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    PersonaModel persona,
    PersonaDetailController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'About Astrologer',
                style: AppTypography.h3.copyWith(color: '#68171E'.toColor()),
              ),
              Icon(
                Icons.card_giftcard,
                color: AppColors.deepOrange,
                size: 20.w,
              ),
            ],
          ),
          Spacing.h(12),
          Obx(() {
            final isExpanded = controller.isDescriptionExpanded.value;
            final description = persona.description;
            final shouldShowReadMore =
                description.isNotEmpty && description.length > 150;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty)
                  AutoTranslateText(
                    description,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF666666),
                      height: 1.5,
                    ),
                    // Only apply maxLines and overflow if we need to show "Read More"
                    // For short text, show everything without truncation
                    maxLines: shouldShowReadMore
                        ? (isExpanded ? null : 4)
                        : null,
                    overflow: shouldShowReadMore
                        ? (isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis)
                        : TextOverflow.visible,
                  )
                else
                  AutoTranslateText(
                    'No description available',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF999999),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                if (shouldShowReadMore)
                  GestureDetector(
                    onTap: controller.toggleDescription,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: AutoTranslateText(
                        isExpanded ? 'Read Less' : 'Read More',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingsSection(
    BuildContext context,
    PersonaModel persona,
    PersonaDetailController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Ratings and reviews',
                style: AppTypography.h3.copyWith(color: AppColors.deepOrange),
              ),
              AutoTranslateText(
                '(${persona.reviewStatistics?.totalReviews ?? persona.totalRatings})',
                style: AppTypography.body2.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
          Spacing.h(4),
          AutoTranslateText(
            '(Only verified purchase ratings are used for final calculation.)',
            style: AppTypography.label.copyWith(color: const Color(0xFF999999)),
          ),
          Spacing.h(16),

          // Rating Distribution
          if (persona.reviewStatistics != null)
            _buildRatingDistribution(persona.reviewStatistics!),

          Spacing.h(16),

          // Write/Edit Review Button
          // Obx(() {
          //   if (controller.myReview.value == null) {
          //     return GestureDetector(
          //       onTap: () => _showReviewDialog(
          //         context,
          //         controller,
          //         persona.id,
          //         persona: persona,
          //       ),
          //       child: Container(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: 16.w,
          //           vertical: 10.h,
          //         ),
          //         decoration: BoxDecoration(
          //           gradient: AppColors.orangeGradient,
          //           borderRadius: BorderRadius.circular(8.r),
          //           boxShadow: [
          //             BoxShadow(
          //               color: '#F38B3B'.toColor().withOpacity(0.3),
          //               blurRadius: 4,
          //               offset: const Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(Icons.edit, size: 16.w, color: Colors.white),
          //             SizedBox(width: 8.w),
          //             AutoTranslateText(
          //               'Write a Review',
          //               style: AppTypography.body2.copyWith(
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   } else {
          //     return GestureDetector(
          //       onTap: () => _showReviewDialog(
          //         context,
          //         controller,
          //         persona.id,
          //         persona: persona,
          //       ),
          //       child: Container(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: 16.w,
          //           vertical: 10.h,
          //         ),
          //         decoration: BoxDecoration(
          //           gradient: AppColors.orangeGradient,
          //           borderRadius: BorderRadius.circular(8.r),
          //           boxShadow: [
          //             BoxShadow(
          //               color: '#F38B3B'.toColor().withOpacity(0.3),
          //               blurRadius: 4,
          //               offset: const Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(Icons.edit, size: 16.w, color: Colors.white),
          //             SizedBox(width: 8.w),
          //             AutoTranslateText(
          //               'Edit Your Review',
          //               style: AppTypography.body2.copyWith(
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   }
          // }),

          // Spacing.h(16),

          // Reviews List
          Obx(() {
            if (controller.isLoadingReviews.value &&
                controller.reviews.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.deepOrange,
                    ),
                  ),
                ),
              );
            }

            if (controller.reviews.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: AutoTranslateText(
                    'No reviews yet. Be the first to review!',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF999999),
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...controller.reviews
                    .take(3)
                    .map(
                      (review) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildReviewItem(review, controller, persona.id),
                      ),
                    ),
                if (controller.reviews.length > 3)
                  GestureDetector(
                    onTap: () {
                      // TODO: Show all reviews page
                      controller.loadReviews(persona.id, refresh: false);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: AutoTranslateText(
                        'See all reviews (${controller.reviews.length})',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(PersonaReviewStatistics stats) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Rating Distribution',
                style: MyTextTheme.smallBCB.copyWith(
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
              AutoTranslateText(
                '${stats.averageRating.toStringAsFixed(1)} / 5.0',
                style: AppTypography.h3.copyWith(color: AppColors.deepOrange),
              ),
            ],
          ),
          Spacing.h(8),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = stats.ratingDistribution[rating] ?? 0;
            final percentage = stats.totalReviews > 0
                ? (count / stats.totalReviews * 100)
                : 0.0;

            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  AutoTranslateText(
                    '$rating',
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.star, size: 14.w, color: AppColors.saffron),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                        minHeight: 8.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AutoTranslateText(
                    '$count',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    PersonaReview review,
    PersonaDetailController controller,
    String personaId,
  ) {
    final userInfo = review.userDisplayInfo;
    // Show maskedPhone instead of displayName
    final displayName =
        userInfo?.maskedPhone ?? userInfo?.displayName ?? 'Anonymous';
    final initials = userInfo?.userInitials ?? 'A';
    final date = review.updatedAt ?? review.createdAt;
    final dateStr = '${date.day} ${_getMonthName(date.month)} ${date.year}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.deepOrange.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AutoTranslateText(
              initials,
              style: MyTextTheme.smallBCB.copyWith(
                color: AppColors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoTranslateText(
                      displayName,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  AutoTranslateText(
                    dateStr,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
              Spacing.h(4),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < review.rating
                          ? AppColors.deepOrange
                          : Colors.grey[300]!,
                      size: 14.w,
                    ),
                  ),
                ],
              ),
              if (review.reviewText.isNotEmpty) ...[
                Spacing.h(6),
                AutoTranslateText(
                  review.reviewText,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
              Spacing.h(6),
              Row(
                children: [
                  if (review.isVerifiedPurchase)
                    Row(
                      children: [
                        AutoTranslateText(
                          'Verified Purchase',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF999999),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.verified, size: 12.w, color: Colors.green),
                        SizedBox(width: 8.w),
                      ],
                    ),
                  GestureDetector(
                    onTap: () =>
                        controller.markReviewHelpful(personaId, review.id),
                    child: Row(
                      children: [
                        Icon(
                          Icons.thumb_up_outlined,
                          size: 14.w,
                          color: const Color(0xFF999999),
                        ),
                        SizedBox(width: 4.w),
                        AutoTranslateText(
                          'Helpful (${review.helpfulCount})',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _showReviewDialog(
    BuildContext context,
    PersonaDetailController controller,
    String personaId, {
    PersonaModel? persona,
  }) {
    final reviewTextController = TextEditingController();
    final rating = 5.obs;
    final isEditing = controller.myReview.value != null;
    final isSubmitting = false.obs;
    final errorMessage = ''.obs;

    if (isEditing) {
      final myReview = controller.myReview.value!;
      reviewTextController.text = myReview.reviewText;
      rating.value = myReview.rating;
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
                        child: AutoTranslateText(
                          isEditing
                              ? 'Edit Your Review'
                              : 'Rate Your Experience',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: const Color(0xFF5F2221),
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
                  if (persona != null) ...[
                    Spacing.h(12),
                    Row(
                      children: [
                        if (persona.image != null && persona.image!.isNotEmpty)
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: persona.image!,
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
                              color: AppColors.deepOrange.withOpacity(0.2),
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
                            persona.displayName,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  Spacing.h(24),

                  // Rating Section
                  AutoTranslateText(
                    'How would you rate this experience?',
                    style: AppTypography.body1.copyWith(
                      color: const Color(0xFF333333),
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
                                      ? AppColors.deepOrange
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
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Spacing.h(24),

                  // Review AutoTranslateText Section
                  AutoTranslateText(
                    'Share your experience',
                    style: AppTypography.body1.copyWith(
                      color: const Color(0xFF333333),
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
                          'Tell others about your experience with this persona...',
                      hintStyle: MyTextTheme.smallBCN.copyWith(
                        color: Colors.grey[400],
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
                          color: AppColors.deepOrange,
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
                                          personaId,
                                          controller.myReview.value!.id,
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
                                              personaId,
                                              controller.myReview.value!.id,
                                              rating: rating.value,
                                              reviewText: reviewTextController
                                                  .text
                                                  .trim(),
                                            )
                                          : await controller.createReview(
                                              personaId,
                                              rating: rating.value,
                                              reviewText: reviewTextController
                                                  .text
                                                  .trim(),
                                              serviceType: "CHAT",
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
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              elevation: 0,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: '#F38B3B'.toColor().withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSubmitting.value
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Center(
                                      child: AutoTranslateText(
                                        isEditing
                                            ? 'Update Review'
                                            : 'Submit Review',
                                        style: MyTextTheme.mediumBCB.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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

  String _getRatingText(int rating) {
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

  Widget _buildBottomButtons(
    BuildContext context,
    PersonaModel persona,
    PersonaDetailController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Call button
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  if (controller.persona.value != null) {
                    final persona = controller.persona.value!;
                    final precheckService = ChatCallPrecheckService();
                    final canProceed = await precheckService
                        .checkBeforeProceeding(
                          persona: persona,
                          pricePerMinute: persona.pricePerMin,
                          estimatedMinutes: 15,
                        );
                    if (canProceed) {
                      Get.toNamed(
                        AppRoutes.personaVoiceCall,
                        arguments: persona,
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: '#F38B3B'.toColor().withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 20.w, color: Colors.white),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Call',
                        style: AppTypography.h3.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Chat button
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await _handleChatTap(context, persona);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: '#F38B3B'.toColor().withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 20.w,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Chat',
                        style: AppTypography.h3.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleChatTap(
    BuildContext context,
    PersonaModel persona,
  ) async {
    final precheckService = ChatCallPrecheckService();
    final canProceed = await precheckService.checkBeforeProceeding(
      persona: persona,
      pricePerMinute: persona.pricePerMin,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final profileHelper = ProfileCheckHelper();
    final existingProfile = await profileHelper.getUserProfile();
    final profileResult = await showPersonaChatProfileDialog(
      context,
      existingProfile,
    );
    if (profileResult == null) return;

    Get.toNamed(
      AppRoutes.personaChat,
      arguments: {
        'persona': persona,
        'chatProfile': profileResult.profile,
        'languageCode': profileResult.languageCode,
      },
    );
  }
}
