import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/all_videos_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/youtube_service.dart'
    show YouTubeVideo;
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AllVideosView extends BasePage<AllVideosController> {
  final bool hideHeader;

  const AllVideosView({super.key, this.hideHeader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: !hideHeader,
          child: Column(
            children: [
              if (!hideHeader) ...[
                _buildHeader(),
                SizedBox(height: 4.h),
              ],
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.videos.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                      ),
                    );
                  }
                  if (controller.videos.isEmpty) {
                    return _buildEmptyState();
                  }
                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    color: AppColors.deepOrange,
                    child: Obx(
                      () => controller.isGridView.value
                          ? _buildGridView(context)
                          : _buildListView(context),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: '#68171E'.toColor().withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 17.w,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          AutoTranslateText(
            'Videos',
            style: AppTypography.h2.copyWith(
              color: '#3D0C11'.toColor(),
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
            ),
          ),
          const Spacer(),
          GestureDetector(
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
              child: Obx(
                () => Icon(
                  controller.isGridView.value
                      ? Icons.view_list
                      : Icons.grid_view,
                  size: 17.w,
                  color: const Color(0xFF5F2221),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.deepOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 48.h,
                color: AppColors.deepOrange,
              ),
            ),
            SizedBox(height: 14.h),
            AutoTranslateText(
              'No Videos Available',
              style: AppTypography.h2.copyWith(
                color: '#3D0C11'.toColor(),
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 4.h),
            AutoTranslateText(
              'Videos will appear here when available',
              style: AppTypography.body2.copyWith(
                color: '#666666'.toColor(),
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
        childAspectRatio: 1.05,
      ),
      itemCount: controller.videos.length,
      itemBuilder: (context, index) {
        final video = controller.videos[index];
        return _VideoGridCard(
          video: video,
          onTap: () => _launchVideo(video),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      itemCount: controller.videos.length,
      itemBuilder: (context, index) {
        final video = controller.videos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: _VideoListCard(
            video: video,
            onTap: () => _launchVideo(video),
          ),
        );
      },
    );
  }

  Future<void> _launchVideo(YouTubeVideo video) async {
    final url = Uri.parse(video.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _VideoGridCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onTap;

  const _VideoGridCard({
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // IMAGE (shorter height)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                    child: CachedNetworkImage(
                      imageUrl: video.thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _placeholder(),
                      errorWidget: (_, __, ___) => _placeholder(),
                    ),
                  ),
                  _playButton(22.w),
                ],
              ),
            ),

            // TEXT (compact)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body2.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5F2221),
                    ),
                  ),
                  if (video.channelTitle.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: AutoTranslateText(
                        video.channelTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body2.copyWith(
                          fontSize: 9.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playButton(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: size * 0.7),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          color: AppColors.deepOrange.withOpacity(0.5),
        ),
      ),
    );
  }
}

class _VideoListCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onTap;

  const _VideoListCard({
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // IMAGE SMALLER HEIGHT
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    width: 100.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _placeholder(),
                    errorWidget: (_, __, ___) => _placeholder(),
                  ),
                  _playButton(20.w),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body2.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5F2221),
                    ),
                  ),
                  if (video.channelTitle.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: AutoTranslateText(
                        video.channelTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body2.copyWith(
                          fontSize: 9.5.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playButton(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: size * 0.7),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 100.w,
      height: 60.h,
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 20.w,
          color: AppColors.deepOrange.withOpacity(0.5),
        ),
      ),
    );
  }


 
}
