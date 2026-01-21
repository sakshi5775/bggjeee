import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/youtube_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
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
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Feature Icons Section
          _buildFeatureIconsSection(),
          Spacing.h(24),
          // Videos Section
          _buildVideosSection(),
        ],
      ),
    );
  }

  Widget _buildFeatureIconsSection() {
    final features = [
      {
        'icon': AppConstant.trustedIcon,
        'text': "India's most trusted private guidance",
      },
      {
        'icon': AppConstant.verifiedAstrologersIcon,
        'text': 'Selected Verified Astrologers',
      },
      {
        'icon': AppConstant.securePaymentOptionIcon,
        'text': 'Highly Secure Payments',
      },
    ];

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with orange circular border
                Padding(
                  padding: EdgeInsets.only(left: 18.w, right: 18.w),
                  child: Image.asset(
                    feature['icon'] as String,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.info_outline,
                        color: AppColors.deepOrange,
                        size: 24.w,
                      );
                    },
                  ),
                ),
                Spacing.h(8),
                // Feature Text with fixed minimum height
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SizedBox(
                    height: 48.h, // Fixed height to accommodate 3 lines
                    child: AutoTranslateText(
                      feature['text'] as String,
                      style: MyTextTheme.smallBCN
                          .copyWith(
                            color: "#820B17".toColor(),
                            fontWeight: FontWeight.w400,
                          )
                          .merge(AppTypography.body2),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVideosSection() {
    return Obx(() {
      if (controller.isLoadingYoutubeVideos.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideosHeader(),
            Spacing.h(16),
            Center(
              child: Padding(
                padding: EdgeInsets.all(40.w),
                child: CircularProgressIndicator(
                  color: AppColors.deepOrange,
                ),
              ),
            ),
          ],
        );
      }

      if (controller.youtubeVideos.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideosHeader(),
            Spacing.h(16),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: AutoTranslateText(
                  'No videos available',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: "#6F221E".toColor(),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      final firstVideo = controller.youtubeVideos.first;
      final otherVideos = controller.youtubeVideos.skip(1).take(5).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideosHeader(),
          Spacing.h(16),
          _buildLargeVideoCard(firstVideo),
          Spacing.h(16),
          _videosList(otherVideos),
        ],
      );
    });
  }

  Widget _buildVideosHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(17801400.r),
              ),
              child: Icon(Icons.play_arrow, color: Colors.white, size: 20.w),
            ),
            Spacing.w(8),
            AutoTranslateText(
              'Videos',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baloo Bhai 2',
                    height: 1.5,
                  )
                  .merge(AppTypography.h3),
            ),
          ],
        ),
       
      ],
    );
  }

  Widget _buildLargeVideoCard(YouTubeVideo video) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(video.videoUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // Video Thumbnail
              Container(
                width: double.infinity,
                height: 170.h,
                color: Colors.black,
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.deepOrange,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.video_library,
                      size: 60.w,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Large Semi-transparent Orange Play Button in Center
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: '#E3B341'.toColor(),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.w,
                    ),
                  ),
                ),
              ),
              // Title and Channel at bottom
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AutoTranslateText(
                      video.title,
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: "#DFB343".toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(4),
                    // Creator Name
                    AutoTranslateText(
                      video.channelTitle,
                      style: MyTextTheme.smallBCN
                          .copyWith(color: Colors.white.withOpacity(0.9))
                          .merge(AppTypography.body2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _videosList(List<YouTubeVideo> videos) {
    if (videos.isEmpty) return SizedBox.shrink();

    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        separatorBuilder: (context, index) => Spacing.w(12),
        itemBuilder: (context, index) {
          final video = videos[index];
          return GestureDetector(
            onTap: () async {
              final url = Uri.parse(video.videoUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: SizedBox(
              width: 168.w,
              child: Card(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Thumbnail
                    Container(
                      width: double.infinity,
                      height: 96.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: video.thumbnailUrl,
                            width: double.infinity,
                            height: 96.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.deepOrange,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.video_library,
                                size: 30.w,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 18.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: AutoTranslateText(
                                video.title,
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: "#DFB343".toColor(),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Baloo Bhai 2',
                                  height: 1.0,
                                  fontSize: 11.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
