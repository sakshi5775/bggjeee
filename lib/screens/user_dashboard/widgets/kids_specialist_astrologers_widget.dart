import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidsSpecialistAstrologersWidget
    extends BasePage<UserDashboardController> {
  const KidsSpecialistAstrologersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKidsSpecialistAstrologers.value) {
        return Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Kids Specialist Astrologer',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  AutoTranslateText(
                    'View all',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: Colors.black,
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

      if (controller.kidsSpecialistAstrologers.isEmpty) {
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
                  'Kids Specialist Astrologer',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.allAstrologers,
                      arguments: {'category': 'KID_ASTROLOGER'},
                    );
                  },
                  child: AutoTranslateText(
                    'View all',
                    style: MyTextTheme.mediumBCN
                        .copyWith(
                          color: Colors.black,
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
              height: 280.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.kidsSpecialistAstrologers.length >= 5
                    ? 5
                    : controller.kidsSpecialistAstrologers.length,
                separatorBuilder: (context, index) => Spacing.w(12),
                itemBuilder: (context, index) {
                  final astrologer =
                      controller.kidsSpecialistAstrologers[index];
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
    final experience = 'Experience : ${astrologer.experienceYears} years';
    final languages = astrologer.languages.isNotEmpty
        ? astrologer.languages.join('/')
        : 'Hindi/English';
    final voicePricePerMin = astrologer.voicePricePerMin ?? 0.0;
    final videoPricePerMin = astrologer.videoPricePerMin ?? 0.0;
    final chatPrice = astrologer.chatPrice ?? 0.0;
    final voicePrice = voicePricePerMin > 0
        ? '${voicePricePerMin.toInt()}/Min'
        : 'Free';
    final videoPrice = videoPricePerMin > 0
        ? '${videoPricePerMin.toInt()}/Min'
        : 'Free';
    final chatPriceText = chatPrice > 0 ? '${chatPrice.toInt()}/Msg' : 'Free';

    final videoPriceHighlight = videoPrice;
    final voicePriceHighlight = voicePrice;
    final chatPriceHighlight = chatPriceText;

    final imagePath = astrologer.profilePicture ?? '';
    final isOnline = astrologer.isOnline;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.astrologerDetail,
          arguments: {'astrologer': astrologer},
        );
      },
      child: Container(
        width: 260.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: '#FFC89E'.toColor(), width: 1.w),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.h(20),
            // Profile Image with Online Status
            Stack(
              alignment: Alignment.center,
              children: [
                // Background decorative circle
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                ),
                // Profile Image
                Container(
                  width: 85.w,
                  height: 85.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.w),
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
                // Online Status Indicator
                if (isOnline)
                  Positioned(
                    top: 5.h,
                    right: 5.w,
                    child: Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: "#08A44F".toColor(),
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                    ),
                  ),
              ],
            ),
            Spacing.h(12),
            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AutoTranslateText(
                name,
                style: AppTypography.h3.copyWith(
                  color: '#68171E'.toColor(),
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(6),
            // Experience
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AutoTranslateText(
                experience,
                style: MyTextTheme.smallBCN
                    .copyWith(color: '#909090'.toColor(), fontSize: 11.sp)
                    .merge(AppTypography.body2),
                textAlign: TextAlign.center,
              ),
            ),
            Spacing.h(8),
            // Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '₹  Video: $videoPriceHighlight ',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                  Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '₹  Voice: $voicePriceHighlight ',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                  Container(
                    padding: AppPaddings.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '₹  Chat: $chatPriceHighlight ',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                ],
              ),
            ),

            Spacing.h(8),
            // Languages with icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 14.w,
                    color: '#909090'.toColor(),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      ': $languages',
                      style: MyTextTheme.smallBCN
                          .copyWith(color: '#909090'.toColor(), fontSize: 11.sp)
                          .merge(AppTypography.body2),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // REPLACE your bottom Container with this:
            const Spacer(), // Pushes the shape to the very bottom
            ClipPath(
              clipper: BottomShapeClipper(),
              child: Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  // Matching the orange/yellow gradient in your image
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFF9933), const Color(0xFFFFAB40)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  // Ensure the bottom corners match the parent card
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
  Path getPath(Size size) {
    Path path = Path();
    // Start from the bottom-left
    path.moveTo(0, size.height);
    // Line to bottom-right
    path.lineTo(size.width, size.height);
    // Line up to the right side (where the orange starts)
    path.lineTo(size.width, size.height * 0.3);
    // Draw a line/curve to the left side higher up
    path.lineTo(0, size.height * 0.9);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    return getPath(size);
  }
}
