import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/all_videos_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/instagram_webview.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/media_cards.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:url_launcher/url_launcher.dart';

class AllVideosView extends BasePage<AllVideosController> {
  final bool hideHeader;

  const AllVideosView({super.key, this.hideHeader = false});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              if (!hideHeader) ...[
                CommonHeader(
                  title: 'Media Hub',
                  showDrawer: false,
                  showHome: false,
                  onBackTap: () => Get.back(),
                  customActions: [
                    Obx(() {
                      if (controller.selectedTabIndex.value != 0) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: controller.toggleViewMode,
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            controller.isGridView.value
                                ? Icons.view_list
                                : Icons.grid_view,
                            size: 17.w,
                            color: const Color(0xFF5F2221),
                          ),
                        ),
                      );
                    }),
                    SizedBox(width: 16.w),
                  ],
                ),
                SizedBox(height: 4.h),
              ],
              _buildTabBar(),
              SizedBox(height: 12.h),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildYouTubeTab(context),
                    _buildInstagramTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TabBar(
        onTap: (index) => controller.selectedTabIndex.value = index,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: '#68171E'.toColor().withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: '#5F2221'.toColor(),
        labelStyle: AppTypography.body1.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
        unselectedLabelStyle: AppTypography.body2.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
        tabs: [
          Tab(child: AutoTranslateText('YouTube')),
          Tab(child: AutoTranslateText('Instagram')),
        ],
      ),
    );
  }

  Widget _buildYouTubeTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.videos.isEmpty) {
        return _buildLoading();
      }
      if (controller.videos.isEmpty) {
        return _buildEmptyState('YouTube');
      }
      return RefreshIndicator(
        onRefresh: controller.loadVideos,
        color: AppColors.deepOrange,
        child: controller.isGridView.value
            ? _buildYouTubeGrid()
            : _buildYouTubeList(),
      );
    });
  }

  Widget _buildInstagramTab(BuildContext context) {
    // Instagram Tab - WebView doesn't need Obx since it's not reactive
    return InstagramWebView(url: InstagramConstant.instagramProfileUrl);
  }

  Widget _buildYouTubeGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.9,
      ),
      itemCount: controller.videos.length,
      itemBuilder: (context, index) {
        final video = controller.videos[index];
        return YouTubeMediaCard(
          video: video,
          isGridView: true,
          onTap: () => _launchUrl(video.videoUrl),
        );
      },
    );
  }

  Widget _buildYouTubeList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.videos.length,
      itemBuilder: (context, index) {
        final video = controller.videos[index];
        return YouTubeMediaCard(
          video: video,
          isGridView: false,
          onTap: () => _launchUrl(video.videoUrl),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
      ),
    );
  }

  Widget _buildEmptyState(String platform) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_collection_outlined,
            size: 64.w,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            'No content found for $platform',
            style: AppTypography.h3.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
