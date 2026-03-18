import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/services/share_service.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/astrologer_detail_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrologer_review_dialog.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerDetailView extends StatelessWidget {
  const AstrologerDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologerDetailController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Header with Profile title - positioned at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeaderWithDots(context, controller),
              ),

              // Main Content with Positioned widgets
              Positioned.fill(
                child: Stack(
                  children: [
                    // Scrollable content positioned after header
                    Positioned(
                      top: 110.h,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 16.h,
                        ),
                        child: Column(
                          children: [
                            // Profile Card - positioned after header
                            _buildProfileCard(context, controller),
                            Spacing.h(16),

                            // Navigation Tabs
                            _buildTabs(controller),
                            Spacing.h(16),

                            // Content based on selected tab
                            Obx(() => _buildTabContent(context, controller)),
                            Spacing.h(5), // Space for bottom bar
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Fixed Bottom Bar
        bottomNavigationBar: _buildBottomBar(controller),
      ),
    );
  }

  // Content that overlaps the header

  Widget _buildHeaderWithDots(
    BuildContext context,
    AstrologerDetailController controller,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Header (interactive) - base layer
        _buildHeader(context, controller),

        // Random positioned dots (non-interactive - decorative layer on top)
        // Using IgnorePointer to ensure dots don't block touches
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Stack(
              clipBehavior: Clip.none,
              children: _buildRandomDots(context),
            ),
          ),
        ),
      ],
    );
  }

  // Generate random positioned dots
  List<Widget> _buildRandomDots(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final headerHeight = MediaQuery.of(context).padding.top + 80.h;

    // Generate random positions for dots using a seed for consistency
    final random = DateTime.now().millisecondsSinceEpoch;
    final dots = <Widget>[];

    // Create 20-25 random dots scattered across the header
    for (int i = 0; i < 22; i++) {
      final seed = (random + i * 23) % 1000;
      // Distribute dots more evenly across the header
      final x = (seed * 4.2) % (screenWidth - 30);
      final y = 10.h + (seed * 2.8) % (headerHeight - 30);
      // Random size between 3-6 pixels (increased for visibility)
      final size = 3.0 + (seed % 4) * 0.75;
      // Random opacity between 0.4-0.8 (increased for visibility)
      final opacity = 0.4 + (seed % 5) * 0.08;

      dots.add(
        Positioned(
          left: x.w,
          top: y.h,
          child: Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              color: AppColors.templeGold.withValues(alpha: opacity),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.templeGold.withValues(alpha: 0.3),
                  blurRadius: 2,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return dots;
  }

  Widget _buildHeader(
    BuildContext context,
    AstrologerDetailController controller,
  ) {
    return CommonHeader(
      title: 'Profile',
      customActions: [
        Obx(() {
          final isFollowing = controller.isFollowing.value;
          final isToggling = controller.isTogglingFollow.value;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isToggling ? null : () => controller.toggleFollow(),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
            ),
          );
        }),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ShareService.shareAstrologer(
                astrologerId: controller.astrologer.astrologerId,
                astrologerName: controller.astrologer.displayName,
              );
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.share_outlined,
                color: AppColors.templeGold,
                size: 24.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, AstrologerDetailController controller) {
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
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture (tap to view full screen, WhatsApp-style)
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: astrologer.profilePicture != null &&
                        astrologer.profilePicture!.isNotEmpty
                    ? () {
                        FullScreenImageViewer.open(
                          context: context,
                          imageUrl: astrologer.profilePicture!,
                          heroTag:
                              'astrologer_profile_${astrologer.id}',
                          label: astrologer.displayName,
                        );
                      }
                    : null,
                child: Hero(
                  tag: 'astrologer_profile_${astrologer.id}',
                  child: Container(
                    width: 120.w,
                    height: 120.w,
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
              Flexible(
                child: AutoTranslateText(
                  astrologer.displayName,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFF5F2221),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
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

          // Statistics Row - Wrap for small screens
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 12.h,
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
    return Container(
      constraints: BoxConstraints(minWidth: 70.w, maxWidth: 90.w),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24.w),
          Spacing.h(4),
          AutoTranslateText(
            value,
            style: MyTextTheme.mediumBCB.copyWith(
              color: const Color(0xFF5F2221),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Spacing.h(2),
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: const Color(0xFF666666),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(AstrologerDetailController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: _buildTab('About', controller)),
            SizedBox(width: 4.w),
            Expanded(child: _buildTab('Expertise', controller)),
            SizedBox(width: 4.w),
            Expanded(child: _buildTab('Reviews', controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String tabName, AstrologerDetailController controller) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == tabName;
      return GestureDetector(
        onTap: () => controller.setSelectedTab(tabName),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors
                      .templeGold // Golden-yellow when selected
                : Colors.transparent, // Transparent when not selected
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: AutoTranslateText(
              tabName,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF5F2221) // Dark brown/black when selected
                    : const Color(0xFF666666), // Medium gray when not selected
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabContent(
    BuildContext context,
    AstrologerDetailController controller,
  ) {
    switch (controller.selectedTab.value) {
      case 'About':
        return _buildAboutContent(controller);
      case 'Expertise':
        return _buildExpertiseContent(controller);
      case 'Reviews':
        return _buildReviewsContent(context, controller);
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
              color: Colors.black.withValues(alpha: 0.05),
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
              color: Colors.black.withValues(alpha: 0.05),
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

  Widget _buildReviewsContent(
    BuildContext context,
    AstrologerDetailController controller,
  ) {
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
              Obx(
                () => AutoTranslateText(
                  '(${reviewController.reviewStatistics['overall']?['totalReviews'] ?? astrologer.totalRatings})',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF666666),
                  ),
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

          // Rating Distribution (from statistics API when available, else from reviews list)
          Obx(() {
            final overall = reviewController.reviewStatistics['overall'];
            if (overall != null && overall is Map) {
              return _buildRatingDistributionFromStats(
                Map<String, dynamic>.from(overall),
              );
            }
            if (reviewController.reviews.isNotEmpty) {
              return _buildRatingDistribution(reviewController.reviews);
            }
            return const SizedBox.shrink();
          }),

          Spacing.h(16),

          // Your review (only when user already has one – write is only after chat/call/video)
          Builder(
            builder: (context) => Obx(() {
              final myRev = reviewController.myReview.value;
              if (myRev == null) return const SizedBox.shrink();

              final date = myRev.updatedAt ?? myRev.createdAt;
              final dateStr =
                  '${date.day} ${_getMonthName(date.month)} ${date.year}';
              final astrologerId = astrologer.astrologerId;
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.saffron.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoTranslateText(
                          'Your review',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: AppColors.saffron,
                            fontWeight: FontWeight.bold,
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
                    Spacing.h(6),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          size: 14.w,
                          color: i < myRev.rating
                              ? AppColors.saffron
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                    if (myRev.reviewText.isNotEmpty) ...[
                      Spacing.h(6),
                      AutoTranslateText(
                        myRev.reviewText,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF666666),
                          height: 1.35,
                        ),
                      ),
                    ],
                    Spacing.h(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showReviewDialog(
                            context,
                            controller,
                            astrologer,
                            existingReview: myRev,
                          ),
                          icon: Icon(
                            Icons.edit,
                            size: 16.w,
                            color: AppColors.saffron,
                          ),
                          label: AutoTranslateText(
                            'Update',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.saffron,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final confirm = await Get.dialog<bool>(
                              AlertDialog(
                                title: AutoTranslateText('Delete review?'),
                                content: AutoTranslateText(
                                  'This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: AutoTranslateText('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: AutoTranslateText(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              final deleted = await reviewController
                                  .deleteReview(astrologerId, myRev.id);
                              if (deleted) {
                                await reviewController
                                    .loadMyReviewAnyServiceType(astrologerId);
                                reviewController.loadReviews(
                                  astrologerId,
                                  refresh: true,
                                );
                                if (context.mounted) {
                                  Get.snackbar(
                                    '',
                                    'Review deleted.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              }
                            }
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            size: 16.w,
                            color: Colors.red,
                          ),
                          label: AutoTranslateText(
                            'Delete',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
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
                        child: _buildReviewItem(context, review, controller),
                      ),
                    ),
                GestureDetector(
                  onTap: () => _showAllReviewsSheet(context, controller),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Obx(
                      () => AutoTranslateText(
                        'See all reviews (${reviewController.totalReviewCount.value})',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildRatingDistributionFromStats(Map<String, dynamic> overall) {
    final averageRating = (overall['averageRating'] as num?)?.toDouble() ?? 0.0;
    final totalReviews = (overall['totalReviews'] as num?)?.toInt() ?? 0;
    final dist = overall['distribution'] as Map<String, dynamic>? ?? {};
    final distribution = {
      5: (dist['star5'] as num?)?.toInt() ?? 0,
      4: (dist['star4'] as num?)?.toInt() ?? 0,
      3: (dist['star3'] as num?)?.toInt() ?? 0,
      2: (dist['star2'] as num?)?.toInt() ?? 0,
      1: (dist['star1'] as num?)?.toInt() ?? 0,
    };
    return _buildRatingDistributionBars(
      distribution: distribution,
      totalReviews: totalReviews,
      averageRating: averageRating,
    );
  }

  Widget _buildRatingDistributionBars({
    required Map<int, int> distribution,
    required int totalReviews,
    required double averageRating,
  }) {
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

  Widget _buildRatingDistribution(List<AstrologerReview> reviews) {
    final Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalRating = 0;
    for (var review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
      totalRating += review.rating;
    }
    final totalReviews = reviews.length;
    final averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;
    return _buildRatingDistributionBars(
      distribution: distribution,
      totalReviews: totalReviews,
      averageRating: averageRating,
    );
  }

  void _showAllReviewsSheet(
    BuildContext context,
    AstrologerDetailController controller,
  ) {
    final reviewController = controller.reviewController;
    final astrologerId = controller.astrologer.astrologerId;
    String selectedSort = 'recent';
    String selectedServiceFilter = '--';
    reviewController.loadReviews(
      astrologerId,
      refresh: true,
      limit: 20,
      sortBy: selectedSort,
      serviceTypeFilter: selectedServiceFilter == '--'
          ? null
          : selectedServiceFilter,
    );
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          void applySortFilter() {
            reviewController.loadReviews(
              astrologerId,
              refresh: true,
              limit: 20,
              sortBy: selectedSort,
              serviceTypeFilter: selectedServiceFilter == '--'
                  ? null
                  : selectedServiceFilter,
            );
          }

          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (_, scrollController) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoTranslateText(
                          'All Reviews',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.saffron,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSort,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'recent',
                                child: Text('Recent'),
                              ),
                              DropdownMenuItem(
                                value: 'helpful',
                                child: Text('Helpful'),
                              ),
                              DropdownMenuItem(
                                value: 'rating-high',
                                child: Text('Rating high'),
                              ),
                              DropdownMenuItem(
                                value: 'rating-low',
                                child: Text('Rating low'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              selectedSort = v;
                              setSheetState(() {});
                              applySortFilter();
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedServiceFilter,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: '--',
                                child: Text('All services'),
                              ),
                              DropdownMenuItem(
                                value: 'CHAT',
                                child: Text('Chat'),
                              ),
                              DropdownMenuItem(
                                value: 'AUDIO',
                                child: Text('Audio'),
                              ),
                              DropdownMenuItem(
                                value: 'VIDEO',
                                child: Text('Video'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              selectedServiceFilter = v;
                              setSheetState(() {});
                              applySortFilter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.h(8),
                  Expanded(
                    child: Obx(() {
                      if (reviewController.isLoadingReviews.value &&
                          reviewController.reviews.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.saffron,
                          ),
                        );
                      }
                      if (reviewController.reviews.isEmpty) {
                        return Center(
                          child: AutoTranslateText(
                            'No reviews yet.',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: const Color(0xFF999999),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount:
                            reviewController.reviews.length +
                            (reviewController.hasMoreReviews.value ? 1 : 0),
                        itemBuilder: (_, index) {
                          if (index == reviewController.reviews.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: reviewController.isLoadingReviews.value
                                    ? const CircularProgressIndicator(
                                        color: AppColors.saffron,
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          reviewController.loadReviews(
                                            astrologerId,
                                            refresh: false,
                                            limit: 20,
                                            sortBy: selectedSort,
                                            serviceTypeFilter:
                                                selectedServiceFilter == '--'
                                                ? null
                                                : selectedServiceFilter,
                                          );
                                        },
                                        child: AutoTranslateText(
                                          'Load more',
                                          style: MyTextTheme.smallBCB.copyWith(
                                            color: AppColors.saffron,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _buildReviewItem(
                              ctx,
                              reviewController.reviews[index],
                              controller,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showReviewDialog(
    BuildContext context,
    AstrologerDetailController controller,
    AstrologerModel astrologer, {
    AstrologerReview? existingReview,
  }) async {
    final reviewController = controller.reviewController;
    if (existingReview != null) {
      if (!context.mounted) return;
      AstrologerReviewDialog.show(
        context: context,
        astrologerId: astrologer.astrologerId,
        astrologer: astrologer,
        serviceType: existingReview.serviceType,
        existingReview: existingReview,
      );
      return;
    }
    await reviewController.loadMyReview(
      astrologer.astrologerId,
      serviceType: 'VIDEO',
    );
    if (!context.mounted) return;
    AstrologerReviewDialog.show(
      context: context,
      astrologerId: astrologer.astrologerId,
      astrologer: astrologer,
      serviceType: 'VIDEO',
      existingReview: reviewController.myReview.value,
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    AstrologerReview review,
    AstrologerDetailController detailController,
  ) {
    final userInfo = review.userDisplayInfo;
    final displayName =
        userInfo?.maskedPhone ?? userInfo?.displayName ?? 'Anonymous';
    final initials = userInfo?.userInitials ?? 'A';
    final date = review.updatedAt ?? review.createdAt;
    final dateStr = '${date.day} ${_getMonthName(date.month)} ${date.year}';
    final reviewController = detailController.reviewController;
    final astrologerId = detailController.astrologer.astrologerId;
    final astrologer = detailController.astrologer;

    return Obx(() {
      final myReviewId = reviewController.myReview.value?.id;
      final isMine = review.id == myReviewId;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.2),
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
                        if (review.serviceType.isNotEmpty) ...[
                          SizedBox(width: 6.w),
                          AutoTranslateText(
                            ' • ${review.serviceType}',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (review.reviewText.isNotEmpty) ...[
                      Spacing.h(6),
                      AutoTranslateText(
                        review.reviewText,
                        style: MyTextTheme.smallBCN
                            .copyWith(
                              color: const Color(0xFF666666),
                              height: 1.4,
                            )
                            .merge(AppTypography.body2),
                      ),
                    ],
                    Spacing.h(8),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => reviewController.markReviewHelpful(
                            astrologerId,
                            review.id,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 4.w,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.thumb_up_outlined,
                                  size: 14.w,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4.w),
                                AutoTranslateText(
                                  'Helpful${review.helpfulCount > 0 ? ' (${review.helpfulCount})' : ''}',
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        InkWell(
                          onTap: () {
                            reviewController.reportReview(
                              astrologerId,
                              review.id,
                            );
                            Get.snackbar(
                              'Reported',
                              'Review reported. Our team will review it.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 4.w,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  size: 14.w,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4.w),
                                AutoTranslateText(
                                  'Report',
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isMine) ...[
                          SizedBox(width: 12.w),
                          InkWell(
                            onTap: () async {
                              await reviewController.loadMyReview(
                                astrologerId,
                                serviceType: review.serviceType,
                              );
                              if (!context.mounted) return;
                              AstrologerReviewDialog.show(
                                context: context,
                                astrologerId: astrologerId,
                                astrologer: astrologer,
                                serviceType: review.serviceType,
                                existingReview: reviewController.myReview.value,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 4.w,
                              ),
                              child: AutoTranslateText(
                                'Edit',
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: AppColors.saffron,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: () async {
                              final confirm = await Get.dialog<bool>(
                                AlertDialog(
                                  title: const Text('Delete review?'),
                                  content: const Text(
                                    'This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final deleted = await reviewController
                                    .deleteReview(astrologerId, review.id);
                                if (deleted && context.mounted) {
                                  Get.snackbar(
                                    'Done',
                                    'Review deleted.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 4.w,
                              ),
                              child: AutoTranslateText(
                                'Delete',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
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
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Consultation price only
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Center(
                child: AutoTranslateText(
                  controller.getPrice(),
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFF5F2221),
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Row 2: Chat, Call, Video buttons
            Row(
              children: [
                Expanded(
                  child: _buildBarChip(
                    onPressed: () => controller.initiateChat(),
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    color: AppColors.templeGold,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildBarChip(
                    onPressed: () => controller.initiateVoiceCall(),
                    icon: Icons.phone_rounded,
                    label: 'Call',
                    color: AppColors.saffron,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildBarChip(
                    onPressed: () => controller.initiateVideoCall(),
                    icon: Icons.videocam_rounded,
                    label: 'Video',
                    color: AppColors.saffron,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChip({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 17.w),
              SizedBox(width: 5.w),
              Flexible(
                child: AutoTranslateText(
                  label,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 120}) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        width: size.w,
        height: size.h,
        color: Colors.grey.withValues(alpha: 0.3),
        child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImageWithLoader(
        url: imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
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
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }
}
