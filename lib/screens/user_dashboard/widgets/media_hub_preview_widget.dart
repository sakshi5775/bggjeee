import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/media_cards.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaHubPreviewWidget extends StatelessWidget {
  const MediaHubPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserDashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // YouTube Section
        _buildSectionHeader(
          title: 'Media Hub',
          onViewAll: () => _navigateToTab(0),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: Get.width > 600 ? 240.h : 210.h,
          child: Obx(() {
            if (controller.isLoadingYoutubeVideos.value &&
                controller.youtubeVideos.isEmpty) {
              return _buildLoading();
            }
            if (controller.youtubeVideos.isEmpty) {
              return _buildEmpty('YouTube');
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.youtubeVideos.length.clamp(0, 5),
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final video = controller.youtubeVideos[index];
                return SizedBox(
                  width: 220.w,
                  child: YouTubeMediaCard(
                    video: video,
                    isGridView: true,
                    onTap: () => _launchUrl(video.videoUrl),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            title,
            style: AppTypography.h2.copyWith(
              color: '#820B17'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Row(
              children: [
                AutoTranslateText(
                  'View All',
                  style: AppTypography.body1.copyWith(
                    color: '#9D4807'.toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: '#9D4807'.toColor(),
                  size: 18.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(width: 12.w),
      itemBuilder: (_, __) => Container(
        width: 180.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildEmpty(String platform) {
    return Center(
      child: AutoTranslateText(
        'No $platform content',
        style: AppTypography.body2.copyWith(color: Colors.grey),
      ),
    );
  }

  void _navigateToTab(int index) {
    // Navigate to AllVideosView and tell it which tab to select
    // Assuming AllVideosView is part of a PageView or we can just go to the route
    UserMainController.pushInCurrentTab(AppRoutes.allVideos, arguments: {'tab': index});
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
