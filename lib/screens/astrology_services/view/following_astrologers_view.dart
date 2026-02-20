import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/following_astrologers_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FollowingAstrologersView extends StatelessWidget {
  const FollowingAstrologersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FollowingAstrologersController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              CommonHeader(
                title: 'Following',
                customActions: [
                  Obx(() {
                    final controller =
                        Get.find<FollowingAstrologersController>();
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFB343),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: AutoTranslateText(
                        '${controller.totalFollowing.value}',
                        style: MyTextTheme.smallBCB
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.body1),
                      ),
                    );
                  }),
                ],
              ),

              // Astrologer List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.followingAstrologers.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFDFB343),
                      ),
                    );
                  }

                  if (controller.followingAstrologers.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.refreshFollowing,
                      color: const Color(0xFFDFB343),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 64.w,
                                  color: const Color(0xFFDFB343),
                                ),
                                Spacing.h(16),
                                AutoTranslateText(
                                  'No Following Astrologers',
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: const Color(0xFF5F2221),
                                  ),
                                ),
                                Spacing.h(8),
                                AutoTranslateText(
                                  'Start following astrologers to see them here',
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: const Color(0xFF666666),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshFollowing,
                    color: const Color(0xFFDFB343),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount:
                          controller.followingAstrologers.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.followingAstrologers.length) {
                          // Load more when reaching the end
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.loadMore();
                          });
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFFDFB343),
                              ),
                            ),
                          );
                        }
                        final astrologer =
                            controller.followingAstrologers[index];
                        return _buildAstrologerCard(astrologer);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAstrologerCard(AstrologerModel astrologer) {
    final isOnline = astrologer.isOnline;
    final rating = astrologer.rating;
    final totalRatings = astrologer.totalRatings;
    final specializations = astrologer.specializations.take(2).join(', ');
    final languages = astrologer.languages.take(2).join(', ');
    final experience = '${astrologer.experienceYears} years';

    // Get price
    String price = 'N/A';
    if (astrologer.voicePricePerMin != null &&
        astrologer.voicePricePerMin! > 0) {
      price = '₹${astrologer.voicePricePerMin!.toStringAsFixed(0)}/min';
    } else if (astrologer.videoPricePerMin != null &&
        astrologer.videoPricePerMin! > 0) {
      price = '₹${astrologer.videoPricePerMin!.toStringAsFixed(0)}/min';
    } else if (astrologer.chatPrice != null && astrologer.chatPrice! > 0) {
      price = '₹${astrologer.chatPrice!.toStringAsFixed(0)}/msg';
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.astrologerDetail, arguments: astrologer);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Profile Picture and Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFDFB343), // Gold border
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: _buildImage(astrologer.profilePicture, size: 80),
                      ),
                    ),
                    // Online indicator
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50), // Green
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                      ),
                  ],
                ),
                Spacing.h(8),
                // Rating Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFB343),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 12.w),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        rating.toStringAsFixed(1),
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.w(12),
            // Right Side: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Verified Badge
                  Row(
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          astrologer.displayName,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF5F2221),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.verified, color: Colors.blue, size: 18.w),
                    ],
                  ),
                  Spacing.h(4),
                  // Specializations
                  if (specializations.isNotEmpty)
                    AutoTranslateText(
                      specializations,
                      style: MyTextTheme.smallBCN
                          .copyWith(color: const Color(0xFF666666))
                          .merge(AppTypography.body2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Spacing.h(8),
                  // Stats Row
                  Row(
                    children: [
                      // Experience
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.w,
                            color: const Color(0xFF666666),
                          ),
                          SizedBox(width: 4.w),
                          AutoTranslateText(
                            experience,
                            style: MyTextTheme.smallBCN
                                .copyWith(color: const Color(0xFF666666))
                                .merge(AppTypography.label),
                          ),
                        ],
                      ),
                      Spacing.w(12),
                      // Reviews
                      Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: 14.w,
                            color: const Color(0xFF666666),
                          ),
                          SizedBox(width: 4.w),
                          AutoTranslateText(
                            '$totalRatings reviews',
                            style: MyTextTheme.smallBCN
                                .copyWith(color: const Color(0xFF666666))
                                .merge(AppTypography.label),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  // Languages
                  if (languages.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14.w,
                          color: const Color(0xFF666666),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: AutoTranslateText(
                            languages,
                            style: MyTextTheme.smallBCN
                                .copyWith(color: const Color(0xFF666666))
                                .merge(AppTypography.label),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  Spacing.h(12),
                  // Price and Chat Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoTranslateText(
                        price,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: const Color(0xFFDFB343),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.astrologerDetail,
                            arguments: astrologer,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDFB343),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: AutoTranslateText(
                          'View',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 80}) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        width: size.w,
        height: size.h,
        color: Colors.grey.withValues(alpha: 0.3),
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
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withValues(alpha: 0.3),
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
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }
}

