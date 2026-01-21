import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/svg_assets.dart' show SvgAssets;

class CelebrityAstrologerWidget extends BasePage<UserDashboardController> {
  const CelebrityAstrologerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCelebrityAstrologers.value) {
        return Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Celebrity Astrologer',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: "#8B1925".toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  AutoTranslateText(
                    'View All',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#8B1925".toColor(),
                          fontWeight: FontWeight.w400,
                        )
                        .merge(AppTypography.body1),
                  ),
                ],
              ),
              Spacing.h(16),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CircularProgressIndicator(color: AppColors.deepOrange),
                ),
              ),
            ],
          ),
        );
      }

      if (controller.celebrityAstrologers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: AppPaddings.symmetric(h: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Celebrity Astrologer',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: "#8B1925".toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.allAstrologers,
                      arguments: {'category': 'CELEBRITY_ASTROLOGER'},
                    );
                  },
                  child: AutoTranslateText(
                    'View All',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: "#8B1925".toColor(),
                          fontWeight: FontWeight.w400,
                        )
                        .merge(AppTypography.body1),
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            // Horizontal Scrollable List
            SizedBox(
              height: 270.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.celebrityAstrologers.length >= 5
                    ? 5
                    : controller.celebrityAstrologers.length,
                separatorBuilder: (context, index) => Spacing.w(12),
                itemBuilder: (context, index) {
                  final astrologer = controller.celebrityAstrologers[index];
                  return _buildAstrologerCard(astrologer);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAstrologerCard(AstrologerModel astrologer) {
    // Map astrologer data to display
    final name = astrologer.displayName;
    final expertise = astrologer.specializations.isNotEmpty
        ? '${astrologer.specializations.first} Expert'
        : 'Astrology Expert';
    final rating = astrologer.rating.toStringAsFixed(1);
    // Use totalConsultations as a proxy for followers, or default to 0
    final followersCount = astrologer.totalConsultations > 0
        ? astrologer.totalConsultations
        : (astrologer.totalRatings * 10); // Estimate based on ratings
    final followers = followersCount > 1000
        ? '${(followersCount / 1000).toStringAsFixed(0)}K+'
        : '${followersCount}+';
    final voicePricePerMin = astrologer.voicePricePerMin ?? 0.0;
    final videoPricePerMin = astrologer.videoPricePerMin ?? 0.0;
    final chatPrice = astrologer.chatPrice ?? 0.0;
    // Use the minimum price among available services
    final minPrice =
        [
          if (voicePricePerMin > 0) voicePricePerMin,
          if (videoPricePerMin > 0) videoPricePerMin,
          if (chatPrice > 0) chatPrice,
        ].isNotEmpty
        ? [
            if (voicePricePerMin > 0) voicePricePerMin,
            if (videoPricePerMin > 0) videoPricePerMin,
            if (chatPrice > 0) chatPrice,
          ].reduce((a, b) => a < b ? a : b)
        : 0.0;
    final price = minPrice > 0 ? minPrice.toInt().toString() : '0';
    final imagePath = astrologer.profilePicture ?? '';

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.astrologerDetail,
          arguments: {'astrologer': astrologer},
        );
      },
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: "#FFE0C8".toColor(), width: 2.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Section with Rating and Followers
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.goldenYellow,
                            size: 16.w,
                          ),
                          Spacing.w(4),
                          AutoTranslateText(
                            rating,
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: "#361515".toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                        ],
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        'Rating',
                        style: MyTextTheme.smallBCN
                            .copyWith(
                              color: "#909090".toColor(),
                              fontSize: 10.sp,
                            )
                            .merge(AppTypography.body2),
                      ),
                    ],
                  ),
                  // Followers Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AutoTranslateText(
                        followers,
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              color: "#361515".toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.body1),
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        'Follower',
                        style: MyTextTheme.smallBCN
                            .copyWith(
                              color: "#909090".toColor(),
                              fontSize: 10.sp,
                            )
                            .merge(AppTypography.body2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Profile Image
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.deepOrange, width: 2.w),
              ),
              child: ClipOval(
                child: imagePath.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.deepOrange,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40.w,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 40.w,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
            ),
            Spacing.h(12),
            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AutoTranslateText(
                name,
                style: MyTextTheme.mediumBCB
                    .copyWith(
                      color: "#E3B341".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(6),
            // Expertise
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AutoTranslateText(
                expertise,
                style: MyTextTheme.smallBCN
                    .copyWith(color: "#4C4C4C".toColor(), fontSize: 11.sp)
                    .merge(AppTypography.body2),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(16),
            Divider(color: "#FFE0C8".toColor(), height: 1.h),
            // Bottom Section with Price and Action Buttons
            Spacing.h(12),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Price Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'From',
                        style: MyTextTheme.smallBCN
                            .copyWith(
                              color: "#4C4C4C".toColor(),
                              fontSize: 10.sp,
                            )
                            .merge(AppTypography.body2),
                      ),
                      Spacing.h(2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            '₹',
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: "#E3B341".toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                          Spacing.w(2),
                          AutoTranslateText(
                            price,
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: "#E3B341".toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Action Buttons
                  Row(
                    children: [
                      // Phone Button
                      GestureDetector(
                        onTap: () {
                          // Handle phone call
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            shape: BoxShape.circle,
                          ),
                          child: SvgAssets(
                            path: AppConstant.callIcon,
                            width: 16.w,
                            height: 16.h,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Spacing.w(8),
                      // Chat Button
                      GestureDetector(
                        onTap: () {
                          // Handle chat
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            shape: BoxShape.circle,
                          ),
                          child: SvgAssets(
                            path: AppConstant.chatIcon,
                            width: 16.w,
                            height: 16.h,
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
}
