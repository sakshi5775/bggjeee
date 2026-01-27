import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/youtube_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturesAndVideosWidget extends BasePage<UserDashboardController> {
  const FeaturesAndVideosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYoutubeVideos.value) {
        return Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Spacing.h(2),
              SizedBox(
                height: 100.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.deepOrange,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (controller.youtubeVideos.isEmpty) {
        return const SizedBox.shrink();
      }

      final videos = controller.youtubeVideos;
      final count = videos.length >= 8 ? 8 : videos.length;

      return Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Spacing.h(2),
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => Spacing.w(8),
                itemCount: count,
                itemBuilder: (context, index) {
                  return _buildVideoCard(videos[index]);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoTranslateText(
          'Videos',
          style: AppTypography.h2.copyWith(
            color: '#820B17'.toColor(),
            letterSpacing: -0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.allVideos),
          child: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: AutoTranslateText(
              'View All',
              style: AppTypography.body1.copyWith(
                color: '#9D4807'.toColor(),
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(YouTubeVideo video) {
    const double cardWidth = 120;
    const double listHeight = 100;

    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(video.videoUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: SizedBox(
        width: cardWidth.w,
        height: listHeight.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: video.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            _thumbnailPlaceholder(cardWidth.w, 68.h),
                        errorWidget: (_, __, ___) =>
                            _thumbnailPlaceholder(cardWidth.w, 68.h),
                      ),
                    ),
                    Container(
                      width: 28.w,
                      height: 28.w,
                      // decoration: BoxDecoration(
                      //   color: AppColors.deepOrange.withValues(alpha: 0.92),
                      //   borderRadius: BorderRadius.circular(8.r),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.black.withOpacity(0.25),
                      //       blurRadius: 4,
                      //       offset: const Offset(0, 2),
                      //     ),
                      //   ],
                      // ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 18.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: AutoTranslateText(
                video.title,
                style: AppTypography.body2.copyWith(
                  color: '#3D0C11'.toColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [
            '#FCE5AA'.toColor(),
            AppColors.deepOrange.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          size: 26.w,
          color: AppColors.deepOrange.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
