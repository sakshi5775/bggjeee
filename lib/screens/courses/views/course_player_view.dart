import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/controllers/course_player_controller.dart';
import 'package:astrobharataiuser/screens/courses/views/live_webinar_session_view.dart';
import 'package:astrobharataiuser/screens/courses/widgets/video_player_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/services/share_service.dart';

class CoursePlayerView extends StatelessWidget {
  final String courseId;

  const CoursePlayerView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoursePlayerController(courseId: courseId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Show loading while data is being fetched
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryGradient.colors.first,
              ),
            ),
          );
        }

        // Only show error if loading is complete and still no data
        if (!controller.isLoading.value &&
            (controller.courseDetail.value == null ||
                controller.lectures.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: AppColors.primaryGradient.colors.first,
                ),
                SizedBox(height: 16.h),
                const AutoTranslateText(
                  'No content available',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ).copyWith(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColors.primaryGradient.colors.first,
                        ),
                      ),
                  child: const AutoTranslateText('Go Back'),
                ),
              ],
            ),
          );
        }

        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout(controller);
            } else {
              return _buildPortraitLayout(controller);
            }
          },
        );
      }),
    );
  }

  // Portrait layout: Video on top, tabs, then content
  Widget _buildPortraitLayout(CoursePlayerController controller) {
    return Column(
      children: [
        // Header with course title, share, menu, autoplay toggle
        _buildHeader(controller),

        // Progress Bar (Overall Course Progress)
        Obx(() {
          final progress = controller.courseProgress.value.clamp(0.0, 100.0);
          return Container(
            height: 4.h,
            color: Colors.white,
            child: progress > 0
                ? LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGradient.colors.first,
                    ),
                    minHeight: 4.h,
                  )
                : Container(
                    height: 4.h,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
          );
        }),

        // Live Webinar Banner
        _buildLiveWebinarBanner(controller),

        // Video Player Area
        _buildVideoPlayerSection(controller),

        // Navigation Tabs (Course content, Overview, etc.)
        _buildNavigationTabs(controller),

        // Main Content Area (Course content list or tab content)
        Expanded(child: _buildMainContent(controller)),
      ],
    );
  }

  // Landscape layout: Video on left, sidebar on right
  Widget _buildLandscapeLayout(CoursePlayerController controller) {
    return Row(
      children: [
        // Video Player Area (Left)
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildHeader(controller),
              _buildLiveWebinarBanner(controller),
              Expanded(child: _buildVideoPlayerSection(controller)),
              _buildNavigationTabs(controller),
            ],
          ),
        ),

        // Sidebar with Course Content (Right)
        Container(
          width: 400.w,
          color: Colors.white,
          child: _buildCourseContentSidebar(controller),
        ),
      ],
    );
  }

  // Header with course title, share, menu
  Widget _buildHeader(CoursePlayerController controller) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.w,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: 12.w),

            // Course Title
            Expanded(
              child: AutoTranslateText(
                controller.courseDetail.value?.course.title ?? '',
                style: AppTypography.h3.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: 12.w),

            // Autoplay Toggle Button
            Obx(
              () => IconButton(
                onPressed: () => controller.toggleAutoplay(),
                icon: Icon(
                  controller.autoplayEnabled.value
                      ? Icons.autorenew
                      : Icons.autorenew_outlined,
                  color: controller.autoplayEnabled.value
                      ? AppColors.templeGold
                      : Colors.white70,
                  size: 20.w,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: controller.autoplayEnabled.value
                    ? 'Autoplay ON'
                    : 'Autoplay OFF',
              ),
            ),

            SizedBox(width: 8.w),

            // Share button
            IconButton(
              onPressed: () {
                ShareService.shareCourse(
                  courseId: controller.courseDetail.value?.course.id ?? '',
                  courseTitle:
                      controller.courseDetail.value?.course.title ?? '',
                );
              },
              icon: Icon(Icons.share_outlined, color: Colors.white, size: 20.w),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  // Video Player Section
  Widget _buildVideoPlayerSection(CoursePlayerController controller) {
    return Obx(() {
      final content = controller.currentContent.value;

      if (content == null) {
        return Container(
          height: 220.h,
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 64.w,
                  color: Colors.white54,
                ),
                SizedBox(height: 16.h),
                const AutoTranslateText(
                  'Select content to play',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      }

      if (content.url == null || content.url!.isEmpty) {
        return Container(
          height: 220.h,
          color: Colors.black,
          child: Center(
            child: controller.isLoadingContent.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.w,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 16.h),
                      const AutoTranslateText(
                        'Content URL not available',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
          ),
        );
      }

      // Show video or PDF
      if (content.type == 'video') {
        return Stack(
          children: [
            Container(
              height: 220.h,
              color: Colors.black,
              child: VideoPlayerWidget(
                key: ValueKey(content.id), // Force rebuild when content changes
                videoUrl: content.url!,
                autoPlay: true,
                showControls: true,
                onProgress: (position, duration) {
                  // Update progress as video plays
                  // position and duration are Duration objects
                  controller.updateContentProgressFromVideo(
                    content.id,
                    position,
                    duration,
                  );
                },
                onEnded: () {
                  controller.markContentCompleted(content.id);
                  controller.onContentEnded();
                },
              ),
            ),
          ],
        );
      } else {
        // For PDFs/images, show message to click on content item to open in separate screen
        return Container(
          height: 220.h,
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  content.type == 'pdf' ? Icons.picture_as_pdf : Icons.image,
                  size: 64.w,
                  color: Colors.white54,
                ),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  content.type == 'pdf'
                      ? 'Click on the content item below to view PDF'
                      : 'Click on the content item below to view image',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  // Navigation Tabs (Course content, Overview)
  Widget _buildNavigationTabs(CoursePlayerController controller) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: _buildTabItem('Course Content', 0, controller)),
          Expanded(child: _buildTabItem('Overview', 1, controller)),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    String label,
    int index,
    CoursePlayerController controller,
  ) {
    return Obx(() {
      final isActive = controller.selectedTab.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectedTab.value = index;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.orangeGradient : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: AutoTranslateText(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  // Main Content Area
  Widget _buildMainContent(CoursePlayerController controller) {
    return Obx(() {
      switch (controller.selectedTab.value) {
        case 0:
          return _buildCourseContentList(controller);
        case 1:
          return _buildOverviewTab(controller);
        default:
          return _buildCourseContentList(controller);
      }
    });
  }

  // Course Content List (Main view)
  Widget _buildCourseContentList(CoursePlayerController controller) {
    final sortedLectures = controller.lectures.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: sortedLectures.length,
        itemBuilder: (context, index) {
          final lecture = sortedLectures[index];
          return _buildLectureSection(lecture, controller, index);
        },
      ),
    );
  }

  // Lecture Section with progress
  Widget _buildLectureSection(
    LectureModel lecture,
    CoursePlayerController controller,
    int index,
  ) {
    return Obx(() {
      final isExpanded = controller.lectureExpandedStates[lecture.id] ?? true;
      final currentContentId = controller.currentContent.value?.id;

      // Get section progress from controller
      final sectionProgress = controller.getSectionProgress(lecture);
      final completedCount = sectionProgress['completed'] as int;
      final totalCount = sectionProgress['total'] as int;
      final totalMinutes = sectionProgress['minutes'] as int;

      final progressText =
          '$completedCount/$totalCount | ${_formatDuration(totalMinutes)}';

      return Container(
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            GestureDetector(
              onTap: () {
                controller.toggleLecture(lecture.id);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textSecondary,
                      size: 24.w,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Section ${index + 1}: ${lecture.title}',
                            style: AppTypography.h3.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          AutoTranslateText(
                            progressText,
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Items (when expanded)
            if (isExpanded)
              ...lecture.content.asMap().entries.map((entry) {
                final contentIndex = entry.key;
                final content = entry.value;
                final isCurrent = content.id == currentContentId;
                final isCompleted = controller.isContentCompleted(content.id);

                return _buildContentListItem(
                  content,
                  lecture,
                  controller,
                  contentIndex + 1,
                  isCurrent,
                  isCompleted,
                );
              }),
          ],
        ),
      );
    });
  }

  // Content List Item (Udemy style)
  Widget _buildContentListItem(
    ContentModel content,
    LectureModel lecture,
    CoursePlayerController controller,
    int itemNumber,
    bool isCurrent,
    bool isCompleted,
  ) {
    return GestureDetector(
      onTap: () {
        // For videos, show inline in player
        // For PDFs/images, open in separate screen
        if (content.type == 'video') {
          controller.selectContent(lecture, content);
        } else {
          // Open PDF/image in separate screen
          Get.toNamed(
            AppRoutes.contentPlayer,
            arguments: {
              'contentId': content.id,
              'lectureId': lecture.id,
              'content': content, // Pass full content object with URL
              'isEnrolled': true, // User is enrolled if they're in player
              'isPreview': content.isPreview,
              'courseId': controller.courseId,
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(left: 52.w),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primaryGradient.colors.first.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isCurrent
                  ? AppColors.primaryGradient.colors.first
                  : Colors.transparent,
              width: 3.w,
            ),
          ),
        ),
        child: Row(
          children: [
            // Checkbox (Udemy style - purple when completed)
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                gradient: isCompleted ? AppColors.primaryGradient : null,
                color: isCompleted ? null : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.primaryGradient.colors.first
                      : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 16.w)
                  : null,
            ),
            SizedBox(width: 12.w),

            // Content Title and Duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    '$itemNumber. ${content.title}',
                    style: AppTypography.body1.copyWith(
                      color: isCurrent
                          ? AppColors.primaryGradient.colors.first
                          : AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: isCurrent
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        content.type == 'video'
                            ? Icons.play_circle_outline
                            : Icons.picture_as_pdf,
                        size: 14.w,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        '${content.duration}min',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                      if (content.isPreview) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.templeGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: AutoTranslateText(
                            'Preview',
                            style: AppTypography.label.copyWith(
                              color: AppColors.templeGold,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Resources button (if available)
            if (content.type == 'pdf') ...[
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () {
                  // TODO: Show resources
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoTranslateText(
                      'Resources',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.primaryGradient.colors.first,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryGradient.colors.first,
                      size: 16.w,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Course Content Sidebar (for landscape mode)
  Widget _buildCourseContentSidebar(CoursePlayerController controller) {
    return Column(
      children: [
        // Sidebar Header
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: AutoTranslateText(
                  'Course content',
                  style: AppTypography.h3.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Close sidebar in landscape (or navigate back)
                  Get.back();
                },
                icon: Icon(Icons.close, color: Colors.white, size: 20.w),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Progress Section
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_border,
                        color: Colors.white70,
                        size: 16.w,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Leave a rating',
                        style: AppTypography.body2.copyWith(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => CircularProgressIndicator(
                          value: controller.courseProgress.value / 100,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGradient.colors.first,
                          ),
                          strokeWidth: 4,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Your progress',
                        style: AppTypography.body2.copyWith(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white70,
                        size: 16.w,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Row(
                    children: [
                      AutoTranslateText(
                        'Share',
                        style: AppTypography.body2.copyWith(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white70,
                        size: 16.w,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Course Content List
        Expanded(child: _buildCourseContentList(controller)),
      ],
    );
  }

  // Overview Tab
  Widget _buildOverviewTab(CoursePlayerController controller) {
    final course = controller.courseDetail.value?.course;
    if (course == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: AutoTranslateText(
          course.description,
          style: AppTypography.body1.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  // Helper to format duration
  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '${hours}hr';
    }
    return '${hours}hr ${mins}min';
  }

  // Live Webinar Banner
  Widget _buildLiveWebinarBanner(CoursePlayerController controller) {
    return Obx(() {
      final webinar = controller.activeWebinar.value;
      if (webinar == null) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.orangeGradient.colors.first.withValues(
                alpha: 0.3,
              ),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Live pulsing dot
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.1, end: 1.0),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
              onEnd: () {},
            ),
            SizedBox(width: 12.w),

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    'Live Webinar in Progress!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoTranslateText(
                    webinar.title ?? 'Join the session now',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Join Button
            ElevatedButton(
              onPressed: () {
                Get.to(
                  () => LiveWebinarSessionView(
                    webinarId: webinar.webinarId ?? webinar.id ?? '',
                    courseId: controller.courseId,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.orangeGradient.colors.first,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                'JOIN',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }
}
