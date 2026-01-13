import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_detail_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrologer_review_dialog.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/utils/chat_initiation_helper.dart';
import 'package:get/get.dart';

class AstrologerDetailView extends StatelessWidget {
  const AstrologerDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologerDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFFf8f0be), // Light cream background
      body: SafeArea(
        child: Column(
          children: [
            // Header with Profile title
            _buildHeader(context, controller),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Card
                    _buildProfileCard(controller),
                    Spacing.h(16),

                    // Navigation Tabs
                    _buildTabs(controller),
                    Spacing.h(16),

                    // Content based on selected tab
                    Obx(() => _buildTabContent(controller)),
                    Spacing.h(100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Fixed Bottom Bar
      bottomNavigationBar: _buildBottomBar(controller),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AstrologerDetailController controller,
  ) {
    return AstrologyHeaderWidget(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                Spacing.w(8),
                AutoTranslateText(
                  'Profile',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Share icon and Follow button
          Row(
            children: [
              // Follow/Unfollow button
              Obx(() {
                final isFollowing = controller.isFollowing.value;
                final isToggling = controller.isTogglingFollow.value;
                return GestureDetector(
                  onTap: isToggling ? null : () => controller.toggleFollow(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isFollowing
                          ? Colors.grey[300]
                          : const Color(0xFFDFB343),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isToggling)
                          SizedBox(
                            width: 14.w,
                            height: 14.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isFollowing ? Colors.black87 : Colors.white,
                              ),
                            ),
                          )
                        else
                          Icon(
                            isFollowing ? Icons.check : Icons.person_add,
                            color: isFollowing ? Colors.black87 : Colors.white,
                            size: 16.w,
                          ),
                        SizedBox(width: 4.w),
                        AutoTranslateText(
                          isFollowing ? 'Following' : 'Follow',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: isFollowing ? Colors.black87 : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Spacing.w(8),
              // Share icon
              Icon(
                Icons.share,
                color: const Color(0xFFDFB343), // Gold color
                size: 24.w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(AstrologerDetailController controller) {
    final astrologer = controller.astrologer;
    final isOnline = astrologer.isOnline;
    final rating = astrologer.rating;
    final totalRatings = astrologer.totalRatings;
    final experience = astrologer.experienceYears;
    final totalConsultations = astrologer.totalConsultations;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDFB343), // Gold border
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: _buildImage(astrologer.profilePicture, size: 120),
                ),
              ),
              // Online indicator
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50), // Green
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
            ],
          ),
          Spacing.h(16),

          // Name and Verified Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoTranslateText(
                astrologer.displayName,
                style: MyTextTheme.largeBCB.copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.w(8),
              Icon(Icons.verified, color: Colors.blue, size: 24.w),
            ],
          ),
          Spacing.h(8),

          // Role
          AutoTranslateText(
            controller.getSpecializations(),
            style: MyTextTheme.mediumBCN.copyWith(
              color: const Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(20),

          // Statistics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.star,
                value: rating.toStringAsFixed(1),
                label: '${totalRatings} reviews',
                iconColor: const Color(0xFFDFB343),
              ),
              _buildStatItem(
                icon: Icons.access_time,
                value: '$experience years',
                label: 'experience',
                iconColor: const Color(0xFF5F2221),
              ),
              _buildStatItem(
                icon: Icons.people,
                value: controller.formatNumber(totalConsultations),
                label: 'sessions',
                iconColor: const Color(0xFF5F2221),
              ),
              Obx(
                () => _buildStatItem(
                  icon: Icons.favorite,
                  value: controller.formatNumber(
                    controller.followerCount.value,
                  ),
                  label: 'followers',
                  iconColor: const Color(0xFFDFB343),
                ),
              ),
            ],
          ),
          Spacing.h(16),

          // Languages
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 16.w,
                color: const Color(0xFF666666),
              ),
              Spacing.w(6),
              Flexible(
                child: AutoTranslateText(
                  controller.getLanguages(),
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24.w),
        Spacing.h(4),
        AutoTranslateText(
          value,
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(2),
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN.copyWith(color: const Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildTabs(AstrologerDetailController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _buildTab('About', controller),
          Spacing.w(8),
          _buildTab('Expertise', controller),
          Spacing.w(8),
          _buildTab('Reviews', controller),
        ],
      ),
    );
  }

  Widget _buildTab(String tabName, AstrologerDetailController controller) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTab.value == tabName;
        return GestureDetector(
          onTap: () => controller.setSelectedTab(tabName),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFDFB343) // Gold when selected
                  : Colors.white, // White when not selected
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFDFB343)
                    : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Center(
              child: AutoTranslateText(
                tabName,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: const Color(0xFF5F2221), // Dark maroon
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent(AstrologerDetailController controller) {
    switch (controller.selectedTab.value) {
      case 'About':
        return _buildAboutContent(controller);
      case 'Expertise':
        return _buildExpertiseContent(controller);
      case 'Reviews':
        return _buildReviewsContent(controller);
      default:
        return _buildAboutContent(controller);
    }
  }

  Widget _buildAboutContent(AstrologerDetailController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              controller.astrologer.bio.isNotEmpty
                  ? controller.astrologer.bio
                  : '${controller.astrologer.displayName} is a renowned ${controller.getSpecializations()} with over ${controller.astrologer.experienceYears} years of experience in guiding people through life\'s challenges. He specializes in Kundli analysis, relationship counseling, and career guidance. His deep understanding of ancient Vedic principles combined with modern psychological insights makes his approach unique and highly effective.',
              style: MyTextTheme.mediumBCN.copyWith(
                color: const Color(0xFF5F2221),
                height: 1.6,
              ),
            ),
            Spacing.h(20),
            // Divider
            Container(height: 1, color: const Color(0xFFE0E0E0)),
            Spacing.h(20),
            // Achievements Section
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: const Color(0xFF5F2221),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Achievements',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: const Color(0xFF5F2221),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            _buildAchievementItem('Featured in Times of India'),
            Spacing.h(12),
            _buildAchievementItem('Award: Best Astrologer 2023'),
            Spacing.h(12),
            _buildAchievementItem('Published Author'),
            Spacing.h(12),
            _buildAchievementItem('Guest Speaker at Vedic Conference'),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: const Color(0xFFDFB343),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.white, size: 16.w),
        ),
        Spacing.w(12),
        Expanded(
          child: AutoTranslateText(
            text,
            style: MyTextTheme.mediumBCN.copyWith(
              color: const Color(0xFF5F2221),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpertiseContent(AstrologerDetailController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Specializations',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5F2221),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(16),
            ...controller.astrologer.specializations.map(
              (spec) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFB343),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Spacing.w(12),
                    AutoTranslateText(
                      spec,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: const Color(0xFF5F2221),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsContent(AstrologerDetailController controller) {
    final reviewController = controller.reviewController;
    final astrologer = controller.astrologer;

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
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.saffron,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoTranslateText(
                '(${astrologer.totalRatings})',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
          Spacing.h(4),
          AutoTranslateText(
            '(Only verified purchase ratings are used for final calculation.)',
            style: MyTextTheme.smallBCN.copyWith(
              color: const Color(0xFF999999),
            ),
          ),
          Spacing.h(16),

          // Rating Distribution
          Obx(() {
            if (reviewController.reviews.isNotEmpty) {
              return _buildRatingDistribution(reviewController.reviews);
            }
            return const SizedBox.shrink();
          }),

          Spacing.h(16),

          // Write/Edit Review Button
          Builder(
            builder: (context) => Obx(() {
              if (reviewController.myReview.value == null) {
                return ElevatedButton.icon(
                  onPressed: () =>
                      _showReviewDialog(context, controller, astrologer),
                  icon: Icon(Icons.edit, size: 16.w),
                  label: AutoTranslateText(
                    'Write a Review',
                    style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                );
              } else {
                return ElevatedButton.icon(
                  onPressed: () =>
                      _showReviewDialog(context, controller, astrologer),
                  icon: Icon(Icons.edit, size: 16.w),
                  label: AutoTranslateText(
                    'Edit Your Review',
                    style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                );
              }
            }),
          ),

          Spacing.h(16),

          // Reviews List
          Obx(() {
            if (reviewController.isLoadingReviews.value &&
                reviewController.reviews.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: AppColors.saffron),
                ),
              );
            }

            if (reviewController.reviews.isEmpty) {
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
                ...reviewController.reviews
                    .take(3)
                    .map(
                      (review) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildReviewItem(review),
                      ),
                    ),
                if (reviewController.reviews.length > 3)
                  GestureDetector(
                    onTap: () {
                      // Load more reviews
                      reviewController.loadReviews(
                        controller.astrologer.astrologerId,
                        refresh: false,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: AutoTranslateText(
                        'See all reviews (${reviewController.reviews.length})',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.saffron,
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

  Widget _buildRatingDistribution(List<AstrologerReview> reviews) {
    // Calculate rating distribution
    final Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalRating = 0;

    for (var review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
      totalRating += review.rating;
    }

    final totalReviews = reviews.length;
    final averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;

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
                '${averageRating.toStringAsFixed(1)} / 5.0',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.saffron,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = distribution[rating] ?? 0;
            final percentage = totalReviews > 0
                ? (count / totalReviews * 100)
                : 0.0;

            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  AutoTranslateText(
                    '$rating',
                    style: MyTextTheme.smallBCN.copyWith(
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
                          AppColors.saffron,
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

  void _showReviewDialog(
    BuildContext context,
    AstrologerDetailController controller,
    AstrologerModel astrologer,
  ) async {
    final reviewController = controller.reviewController;
    
    // Fetch current follow status before showing dialog
    bool isFollowing = controller.isFollowing.value;
    try {
      final astrologerService = AstrologerService();
      final status = await astrologerService.getFollowStatus(astrologer.astrologerId);
      isFollowing = status?['isFollowing'] ?? false;
    } catch (e) {
      // Use current value if fetch fails
      if (kDebugMode) print('Error fetching follow status for review dialog: $e');
    }
    
    AstrologerReviewDialog.show(
      context: context,
      astrologerId: astrologer.astrologerId,
      astrologer: astrologer,
      serviceType:
          'VIDEO', // Default, can be changed based on last service used
      existingReview: reviewController.myReview.value,
      isFollowing: isFollowing,
      onFollow: () async {
        await controller.toggleFollow();
        // Refresh follow status after toggle
        await controller.loadFollowStatus();
        // Update dialog if still open (would need to pass a callback or use Get.find)
      },
    );
  }

  Widget _buildReviewItem(AstrologerReview review) {
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
            color: AppColors.saffron.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AutoTranslateText(
              initials,
              style: MyTextTheme.smallBCB.copyWith(
                color: AppColors.saffron,
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
                          ? AppColors.saffron
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
                  style: MyTextTheme.smallBCN
                      .copyWith(color: const Color(0xFF666666), height: 1.4)
                      .merge(AppTypography.body2),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildBottomBar(AstrologerDetailController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFf8f0be), // Light cream background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Consultation Rate - Use Flexible/Expanded to prevent overflow
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  AutoTranslateText(
                    'Consultation Rate:',
                    style: MyTextTheme.smallBCN
                        .copyWith(color: const Color(0xFF666666))
                        .merge(AppTypography.body2),
                    textAlign: TextAlign.center,
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    controller.getPrice(),
                    style: MyTextTheme.smallBCB.copyWith(
                      color: const Color(0xFFDFB343),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Spacing.h(12),
            // Action Buttons
            Row(
              children: [
                // Start Chat Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ChatInitiationHelper.initiateChat(controller.astrologer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDFB343), // Gold
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 16.w,
                        ),
                        Spacing.w(4),
                        Flexible(
                          child: AutoTranslateText(
                            'Chat',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacing.w(8),
                // Voice Call Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.initiateVoiceCall();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D1C21), // Dark maroon
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: Colors.white, size: 16.w),
                        Spacing.w(4),
                        Flexible(
                          child: AutoTranslateText(
                            'Call',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacing.w(8),
                // Video Call Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.initiateVideoCall();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D1C21), // Dark maroon
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam, color: Colors.white, size: 16.w),
                        Spacing.w(4),
                        Flexible(
                          child: AutoTranslateText(
                            'Video',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 120}) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        width: size.w,
        height: size.h,
        color: Colors.grey.withOpacity(0.3),
        child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withOpacity(0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withOpacity(0.3),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFFDFB343),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withOpacity(0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }
}
