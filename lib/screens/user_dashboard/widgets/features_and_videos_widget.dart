import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/screens/courses/widgets/video_player_widget.dart';

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
    // Static video data
    final videoData = {
      'videoUrl': '', // Will be added later
      'title': 'Complete Guide to Jupiter Transit 2025 & Its Effects',
      'author': 'Dr. Priya Sharma',
      'viewsCount': 45000,
      'duration': 15, // minutes
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVideosHeader(),
        Spacing.h(16),
        _buildLargeVideoCard(videoData),
        Spacing.h(16),
        _videosList(),
      ],
    );
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
        GestureDetector(
          onTap: () {
            // Navigate to all videos
            // Get.toNamed(AppRoutes.videos);
          },
          child: AutoTranslateText(
            'View All',
            style: MyTextTheme.mediumBCN
                .copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  height: 1.5,
                )
                .merge(AppTypography.body1),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeVideoCard(Map<String, dynamic> videoData) {
    final videoUrl = videoData['videoUrl'] as String;
    final title = videoData['title'] as String;
    final author = videoData['author'] as String;
    final viewsCount = videoData['viewsCount'] as int;
    final duration = videoData['duration'] as int;

    return GestureDetector(
      onTap: () {
        // Handle video tap - navigate to video detail or play video
        // Get.toNamed(AppRoutes.videoDetail, arguments: videoData);
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
                height: 200.h,
                color: Colors.black,
                child: videoUrl.isNotEmpty
                    ? VideoPlayerWidget(
                        videoUrl: videoUrl,
                        autoPlay: false,
                        showControls: false,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.video_library,
                          size: 60.w,
                          color: Colors.grey[600],
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

              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: AppPaddings.symmetric(h: 8.w, v: 8.h),
                  decoration: BoxDecoration(
                    color: "#E3B341".toColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AutoTranslateText(
                    _formatDuration(duration),
                    style: MyTextTheme.smallBCN
                        .copyWith(color: Colors.white)
                        .merge(AppTypography.label),
                  ),
                ),
              ),
              Spacing.h(16),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: AppPaddings.symmetric(h: 12.w),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AutoTranslateText(
                        title,
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              color: "#DFB343".toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Creator Name and Views
                      Row(
                        children: [
                          AutoTranslateText(
                            author,
                            style: MyTextTheme.smallBCN
                                .copyWith(color: Colors.white)
                                .merge(AppTypography.body2),
                          ),
                          Spacing.w(12),
                          Icon(
                            Icons.visibility_outlined,
                            size: 14.w,
                            color: Colors.white,
                          ),
                          Spacing.w(4),
                          AutoTranslateText(
                            '${_formatViews(viewsCount)} views',
                            style: MyTextTheme.smallBCN
                                .copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12.sp,
                                )
                                .merge(AppTypography.body2),
                          ),
                        ],
                      ),

                      Spacing.h(4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes:00';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}:${mins.toString().padLeft(2, '0')}';
  }

  String _formatViews(int views) {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}K';
    return views.toString();
  }

  Widget _videosList() {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 168,
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
              bottom: Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Video
              Container(
                width: 168,
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
                    Image.asset(
                      'assets/app/video_thumbnail.png',
                      width: 168,
                      height: 96.h,
                      fit: BoxFit.cover,
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
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: AppPaddings.symmetric(h: 8.w, v: 8.h),
                        child: AutoTranslateText(
                          '12:00',
                          style: MyTextTheme.smallBCN
                              .copyWith(color: Colors.white)
                              .merge(AppTypography.label),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(11.99.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Untitled',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#DFB343".toColor(),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Baloo Bhai 2',
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(3.99),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 11.99.w,
                          color: "#F38B3B".toColor(),
                        ),
                        Spacing.w(3.99),
                        AutoTranslateText(
                          '99k views',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#F38B3B".toColor(),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            height: 1.33,
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
      ),
    );
  }
}
