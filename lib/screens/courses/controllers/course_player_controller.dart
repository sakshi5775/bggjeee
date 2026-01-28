import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursePlayerController extends BaseController {
  final CoursesService _coursesService = CoursesService();
  final String courseId;

  CoursePlayerController({required this.courseId});

  // Course data
  final Rx<CourseDetailModel?> courseDetail = Rx<CourseDetailModel?>(null);
  final RxList<LectureModel> lectures = <LectureModel>[].obs;

  // Current playing content
  final Rx<LectureModel?> currentLecture = Rx<LectureModel?>(null);
  final Rx<ContentModel?> currentContent = Rx<ContentModel?>(null);
  final RxInt currentContentIndex = 0.obs;

  // Live Webinar
  final Rx<WebinarModel?> activeWebinar = Rx<WebinarModel?>(null);

  // Progress tracking
  final RxMap<String, bool> completedContent = <String, bool>{}.obs;
  final RxMap<String, double> contentProgress =
      <String, double>{}.obs; // 0.0 to 1.0
  final RxDouble courseProgress = 0.0.obs;

  // Player state
  final RxBool isPlaying = false.obs;
  final RxBool isLoadingContent = false.obs;

  // Resume position
  final RxMap<String, Duration> resumePositions = <String, Duration>{}.obs;

  // Selected tab (0: Course content, 1: Overview, 2: Q&A, 3: Notes, 4: Announcements, 5: Reviews)
  final RxInt selectedTab = 0.obs;

  // Lecture expanded states
  final RxMap<String, bool> lectureExpandedStates = <String, bool>{}.obs;

  // Autoplay settings
  final RxBool autoplayEnabled = true.obs;
  ContentModel? _pendingNextContent;
  LectureModel? _pendingNextLecture;

  void toggleLecture(String lectureId) {
    lectureExpandedStates[lectureId] =
        !(lectureExpandedStates[lectureId] ?? true);
  }

  void toggleAutoplay() {
    autoplayEnabled.value = !autoplayEnabled.value;
    if (!autoplayEnabled.value) {
      _pendingNextContent = null;
      _pendingNextLecture = null;
    }
  }

  @override
  void onClose() {
    _pendingNextContent = null;
    _pendingNextLecture = null;
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadCoursePlayerData();
  }

  // Load all course player data
  Future<void> loadCoursePlayerData() async {
    try {
      setLoadingState(true);

      // Load course detail
      final detail = await _coursesService.getCourseById(courseId);
      if (detail == null) {
        showErrorMessage(
          title: "Error",
          message: "Failed to load course details",
        );
        Get.back();
        return;
      }

      // Check enrollment via enrollment check API
      final enrollmentStatus = await _coursesService.checkEnrollment(courseId);
      final isEnrolled = enrollmentStatus?['isEnrolled'] as bool? ?? false;

      if (!isEnrolled) {
        showErrorMessage(
          title: "Access Denied",
          message: "You must be enrolled to access the course player",
        );
        Get.back();
        return;
      }

      courseDetail.value = detail;

      // CRITICAL: Use lectures from course detail (has URLs)
      // The lectures list API doesn't return all URLs, but course detail API does
      if (detail.lectures.isNotEmpty) {
        // Use lectures from course detail (has URLs)
        lectures.value = detail.lectures;

        // Initialize all lectures as expanded
        for (var lecture in detail.lectures) {
          lectureExpandedStates[lecture.id] = true;
        }

        // Load progress
        await loadProgress();

        // Check for live webinars
        await checkForLiveWebinar();

        // Auto-resume: Find last incomplete content or first content
        await _resumeLearning();
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: "Failed to load course: $e");
    } finally {
      setLoadingState(false);
    }
  }

  // Load progress for course
  Future<void> loadProgress() async {
    try {
      final progressData = await _coursesService.getCourseProgress(courseId);
      if (progressData != null) {
        // Load overall course progress percentage from API
        final apiProgress =
            (progressData['completionPercentage'] as num?)?.toDouble() ?? 0.0;
        courseProgress.value = apiProgress;

        // Load progress from lectures array (new API structure)
        final lecturesProgress = progressData['lectures'] as List<dynamic>?;
        if (lecturesProgress != null) {
          for (var lectureProgress in lecturesProgress) {
            if (lectureProgress is Map<String, dynamic>) {
              final contentProgressList =
                  lectureProgress['contentProgress'] as List<dynamic>?;
              if (contentProgressList != null) {
                for (var contentProg in contentProgressList) {
                  if (contentProg is Map<String, dynamic>) {
                    final contentId = contentProg['contentId'] as String?;
                    final isViewed = contentProg['isViewed'] as bool? ?? false;
                    final watchTime =
                        (contentProg['watchTime'] as num?)?.toDouble() ?? 0.0;
                    final totalDuration =
                        (contentProg['totalDuration'] as num?)?.toDouble() ??
                        0.0;

                    if (contentId != null) {
                      // Check if content is completed (watchTime >= totalDuration or isCompleted flag)
                      final isCompleted =
                          contentProg['isCompleted'] as bool? ??
                          (totalDuration > 0 &&
                              watchTime >= totalDuration * 0.9);

                      if (isCompleted) {
                        completedContent[contentId] = true;
                        contentProgress[contentId] = 1.0;
                      } else if (isViewed && totalDuration > 0) {
                        // Calculate progress from watchTime
                        contentProgress[contentId] = (watchTime / totalDuration)
                            .clamp(0.0, 1.0);
                      } else if (isViewed) {
                        // Just viewed, no duration info
                        contentProgress[contentId] = 0.1;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        // Fallback: Load from old API structure if new structure not available
        final completedContentIds =
            progressData['completedContentIds'] as List<dynamic>?;
        if (completedContentIds != null) {
          for (var id in completedContentIds) {
            if (id is String) {
              completedContent[id] = true;
              contentProgress[id] = 1.0;
            }
          }
        }

        final viewedContentIds =
            progressData['viewedContentIds'] as List<dynamic>?;
        if (viewedContentIds != null) {
          for (var id in viewedContentIds) {
            if (id is String && !completedContent.containsKey(id)) {
              contentProgress[id] = 0.5; // 50% viewed
            }
          }
        }

        // If API progress is 0, calculate from local state
        if (courseProgress.value == 0.0) {
          _updateCourseProgress();
        }
      } else {
        // No progress data - calculate from local state
        _updateCourseProgress();
      }
    } catch (e) {
      debugPrint('Error loading progress: $e');
      // Fallback to local calculation
      _updateCourseProgress();
    }
  }

  // Check for live webinars for this course
  Future<void> checkForLiveWebinar() async {
    try {
      final webinarService = Get.find<WebinarService>();
      final liveWebinars = await webinarService.getLiveWebinars();
      if (liveWebinars.isNotEmpty) {
        // Find if any live webinar belongs to this course
        for (var webinar in liveWebinars) {
          // Check if webinar is associated with this course
          if (webinar.courseId?.sId == courseId ||
              webinar.courseId?.id == courseId) {
            activeWebinar.value = webinar;
            print("Live webinar found for course $courseId: ${webinar.title}");
            return;
          }
        }
      }
      activeWebinar.value = null;
    } catch (e) {
      print("Error checking for live webinar: $e");
    }
  }

  // Resume learning - find last incomplete content or first content
  Future<void> _resumeLearning() async {
    if (lectures.isEmpty) return;

    // Sort lectures by order
    final sortedLectures = lectures.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    // Try to find last accessed content from progress API
    final progressData = await _coursesService.getCourseProgress(courseId);
    String? lastAccessedContentId;
    if (progressData != null) {
      lastAccessedContentId = progressData['lastAccessedContentId'] as String?;
      if (lastAccessedContentId != null && lastAccessedContentId.isNotEmpty) {
        // Find and resume from last accessed content
        for (var lecture in sortedLectures) {
          for (var content in lecture.content) {
            if (content.id == lastAccessedContentId &&
                content.url != null &&
                content.url!.isNotEmpty) {
              // Resume from this content
              selectContent(lecture, content);
              return;
            }
          }
        }
      }
    }

    // If no last accessed content, find first incomplete content
    for (var lecture in sortedLectures) {
      for (var content in lecture.content) {
        if (!isContentCompleted(content.id) &&
            content.url != null &&
            content.url!.isNotEmpty) {
          // Found incomplete content - select it (will auto-play)
          selectContent(lecture, content);
          return;
        }
      }
    }

    // All content completed or no content - select first playable content
    if (sortedLectures.isNotEmpty) {
      for (var lecture in sortedLectures) {
        if (lecture.content.isNotEmpty) {
          final firstPlayableContent = lecture.content.firstWhere(
            (c) => c.url != null && c.url!.isNotEmpty,
            orElse: () => lecture.content.first,
          );
          if (firstPlayableContent.url != null &&
              firstPlayableContent.url!.isNotEmpty) {
            selectContent(lecture, firstPlayableContent);
            return;
          }
        }
      }
    }
  }

  // Select content to play
  void selectContent(LectureModel lecture, ContentModel content) async {
    // CRITICAL: Always use content from lectures (which has URLs)
    // Find the actual content from lectures to ensure it has URL
    ContentModel? contentWithUrl;
    for (var l in lectures) {
      if (l.id == lecture.id) {
        for (var c in l.content) {
          if (c.id == content.id) {
            contentWithUrl = c;
            break;
          }
        }
        break;
      }
    }

    // Use content with URL if found, otherwise use the provided content
    final finalContent = contentWithUrl ?? content;

    // Check if content has URL - if not, try to find it in all lectures
    if (finalContent.url == null || finalContent.url!.isEmpty) {
      debugPrint(
        '⚠️ Content ${finalContent.id} has no URL, searching in all lectures...',
      );
      for (var l in lectures) {
        for (var c in l.content) {
          if (c.id == finalContent.id && c.url != null && c.url!.isNotEmpty) {
            debugPrint('✅ Found content with URL in lecture: ${l.title}');
            currentLecture.value = l;
            currentContent.value = c;

            // Mark as viewed
            await _coursesService.updateContentProgress(
              courseId: courseId,
              contentId: c.id,
              lectureId: l.id,
              isViewed: true,
            );
            return;
          }
        }
      }
      debugPrint('❌ Content ${finalContent.id} has no URL in any lecture');
      showErrorMessage(
        title: "Content Unavailable",
        message: "Content URL not available. Please try again later.",
      );
      return;
    }

    currentLecture.value = lecture;
    currentContent.value = finalContent;

    // Find content index
    final lectureIndex = lectures.indexWhere((l) => l.id == lecture.id);
    if (lectureIndex >= 0) {
      final contentIndex = lectures[lectureIndex].content.indexWhere(
        (c) => c.id == finalContent.id,
      );
      if (contentIndex >= 0) {
        currentContentIndex.value = contentIndex;
      }
    }

    // Mark as viewed when content is selected
    await _coursesService.updateContentProgress(
      courseId: courseId,
      contentId: finalContent.id,
      lectureId: lecture.id,
      isViewed: true,
      watchTime: 0,
      totalDuration: finalContent.duration.toDouble(),
    );
  }

  // Load content details from API
  Future<void> _loadContentDetails(String contentId) async {
    try {
      isLoadingContent.value = true;
      final content = await _coursesService.getContentById(contentId);
      if (content != null && currentContent.value != null) {
        // Update current content with URL
        final updatedContent = ContentModel(
          id: content.id,
          title: content.title,
          type: content.type,
          url: content.url,
          duration: content.duration,
          isPreview: content.isPreview,
        );
        currentContent.value = updatedContent;
      }
    } catch (e) {
      debugPrint('Error loading content details: $e');
    } finally {
      isLoadingContent.value = false;
    }
  }

  // Mark content as completed
  void markContentCompleted(String contentId) async {
    completedContent[contentId] = true;
    _updateCourseProgress();

    // Save progress to API
    if (currentLecture.value != null && currentContent.value != null) {
      final content = currentContent.value!;
      // Convert duration from minutes to seconds for API
      final durationInSeconds = (content.duration * 60).toDouble();
      await _coursesService.updateContentProgress(
        courseId: courseId,
        contentId: contentId,
        lectureId: currentLecture.value!.id,
        isCompleted: true,
        isViewed: true,
        watchTime: durationInSeconds, // Mark as fully watched (in seconds)
        totalDuration: durationInSeconds,
      );

      // Check if all content in lecture is completed, then mark lecture as completed
      final lecture = currentLecture.value!;
      bool allCompleted = true;
      for (var c in lecture.content) {
        if (!isContentCompleted(c.id)) {
          allCompleted = false;
          break;
        }
      }

      if (allCompleted) {
        await _coursesService.updateLectureProgress(
          courseId: courseId,
          lectureId: lecture.id,
        );
      }
    }
  }

  // Check if content is completed
  bool isContentCompleted(String contentId) {
    return completedContent[contentId] ?? false;
  }

  // Update content progress from video player (with actual position and duration)
  void updateContentProgressFromVideo(
    String contentId,
    Duration position,
    Duration duration,
  ) async {
    if (duration <= Duration.zero) return;

    final progress = position.inMilliseconds / duration.inMilliseconds;
    contentProgress[contentId] = progress.clamp(0.0, 1.0);

    // If progress > 90%, mark as completed
    if (progress >= 0.9 && !isContentCompleted(contentId)) {
      markContentCompleted(contentId);
    } else {
      // Save progress to API (throttle to avoid too many API calls)
      if (currentLecture.value != null && currentContent.value != null) {
        // Use actual video duration in seconds (more accurate than content.duration)
        final totalDurationInSeconds = duration.inSeconds.toDouble();
        final watchTimeInSeconds = position.inSeconds.toDouble();

        // Only save every 10% progress to reduce API calls
        final progressPercent = (progress * 100).round();
        if (progressPercent % 10 == 0 || progress >= 0.5) {
          await _coursesService.updateContentProgress(
            courseId: courseId,
            contentId: contentId,
            lectureId: currentLecture.value!.id,
            isViewed: true,
            watchTime: watchTimeInSeconds,
            totalDuration: totalDurationInSeconds,
          );
        }
      }
    }

    _updateCourseProgress();
  }

  // Update content progress (0.0 to 1.0) - legacy method for compatibility
  void updateContentProgress(String contentId, double progress) async {
    contentProgress[contentId] = progress.clamp(0.0, 1.0);

    // If progress > 90%, mark as completed
    if (progress >= 0.9 && !isContentCompleted(contentId)) {
      markContentCompleted(contentId);
    } else {
      // Save progress to API (throttle to avoid too many API calls)
      if (currentLecture.value != null && currentContent.value != null) {
        final content = currentContent.value!;
        // Convert duration from minutes to seconds for API
        final totalDurationInSeconds = (content.duration * 60).toDouble();
        // Only save every 10% progress to reduce API calls
        final progressPercent = (progress * 100).round();
        if (progressPercent % 10 == 0 || progress >= 0.5) {
          // Calculate watchTime in seconds
          final watchTimeInSeconds = totalDurationInSeconds * progress;
          await _coursesService.updateContentProgress(
            courseId: courseId,
            contentId: contentId,
            lectureId: currentLecture.value!.id,
            isViewed: true,
            watchTime: watchTimeInSeconds,
            totalDuration: totalDurationInSeconds,
          );
        }
      }
    }

    _updateCourseProgress();
  }

  // Update overall course progress
  void _updateCourseProgress() {
    if (lectures.isEmpty) return;

    int totalContent = 0;
    int completedCount = 0;

    // Count ALL content (including those without URLs for now)
    // Progress is based on completion, not on whether content has URL
    for (var lecture in lectures) {
      for (var content in lecture.content) {
        totalContent++;
        if (isContentCompleted(content.id)) {
          completedCount++;
        }
      }
    }

    if (totalContent > 0) {
      final calculatedProgress = (completedCount / totalContent) * 100;
      // Use calculated progress if API progress is 0 or not available
      if (courseProgress.value == 0.0) {
        courseProgress.value = calculatedProgress;
      }
    }
  }

  // Get section progress (for display: "completed/total | duration")
  Map<String, dynamic> getSectionProgress(LectureModel lecture) {
    int completedCount = 0;
    int totalCount =
        lecture.content.length; // Count ALL content, not just those with URLs
    int totalMinutes = 0;

    for (var content in lecture.content) {
      totalMinutes += content.duration;
      if (isContentCompleted(content.id)) {
        completedCount++;
      }
    }

    return {
      'completed': completedCount,
      'total': totalCount,
      'minutes': totalMinutes,
    };
  }

  // Save resume position
  void saveResumePosition(String contentId, Duration position) {
    resumePositions[contentId] = position;
  }

  // Get resume position
  Duration? getResumePosition(String contentId) {
    return resumePositions[contentId];
  }

  // Auto-play next content when current content ends
  void onContentEnded() {
    if (currentLecture.value == null || currentContent.value == null) return;

    // Mark current content as completed
    markContentCompleted(currentContent.value!.id);

    // Find next content
    final currentLectureIndex = lectures.indexWhere(
      (l) => l.id == currentLecture.value!.id,
    );
    if (currentLectureIndex < 0) return;

    final lecture = lectures[currentLectureIndex];
    final currentContentIndex = lecture.content.indexWhere(
      (c) => c.id == currentContent.value!.id,
    );

    ContentModel? nextContent;
    LectureModel? nextLecture;

    // Try next content in same lecture
    if (currentContentIndex >= 0 &&
        currentContentIndex < lecture.content.length - 1) {
      nextContent = lecture.content[currentContentIndex + 1];
      if (nextContent.url != null && nextContent.url!.isNotEmpty) {
        nextLecture = lecture;
      } else {
        nextContent = null;
      }
    }

    // Try first content in next lecture if no next content in current lecture
    if (nextContent == null && currentLectureIndex < lectures.length - 1) {
      final nextLectureCandidate = lectures[currentLectureIndex + 1];
      if (nextLectureCandidate.content.isNotEmpty) {
        nextContent = nextLectureCandidate.content.firstWhere(
          (c) => c.url != null && c.url!.isNotEmpty,
          orElse: () => nextLectureCandidate.content.first,
        );
        nextLecture = nextLectureCandidate;
      }
    }

    // If no next content, show completion message
    if (nextContent == null || nextLecture == null) {
      Get.snackbar(
        'Course Complete',
        'You have completed all content in this course!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return;
    }

    // If autoplay is enabled, play next content immediately
    if (autoplayEnabled.value) {
      // Play next content immediately without countdown
      if (nextContent.url != null && nextContent.url!.isNotEmpty) {
        selectContent(nextLecture, nextContent);
      } else {
        debugPrint('⚠️ Next content has no URL, cannot autoplay');
      }
    } else {
      // Just store next content info without auto-playing
      _pendingNextContent = nextContent;
      _pendingNextLecture = nextLecture;
    }
  }

  // Cancel autoplay and play next content immediately
  void cancelAutoplayAndPlayNext() {
    if (_pendingNextContent != null && _pendingNextLecture != null) {
      // Ensure content has URL before playing
      if (_pendingNextContent!.url != null &&
          _pendingNextContent!.url!.isNotEmpty) {
        selectContent(_pendingNextLecture!, _pendingNextContent!);
        _pendingNextContent = null;
        _pendingNextLecture = null;
      } else {
        debugPrint('⚠️ Next content has no URL, cannot play');
        _pendingNextContent = null;
        _pendingNextLecture = null;
      }
    }
  }

  // Get next content (for manual navigation)
  ContentModel? getNextContent() {
    if (currentLecture.value == null || currentContent.value == null)
      return null;

    final currentLectureIndex = lectures.indexWhere(
      (l) => l.id == currentLecture.value!.id,
    );
    if (currentLectureIndex < 0) return null;

    final lecture = lectures[currentLectureIndex];
    final currentContentIndex = lecture.content.indexWhere(
      (c) => c.id == currentContent.value!.id,
    );

    // Next in same lecture
    if (currentContentIndex >= 0 &&
        currentContentIndex < lecture.content.length - 1) {
      return lecture.content[currentContentIndex + 1];
    }

    // First in next lecture
    if (currentLectureIndex < lectures.length - 1) {
      final nextLecture = lectures[currentLectureIndex + 1];
      if (nextLecture.content.isNotEmpty) {
        return nextLecture.content.first;
      }
    }

    return null;
  }

  // Get previous content
  ContentModel? getPreviousContent() {
    if (currentLecture.value == null || currentContent.value == null)
      return null;

    final currentLectureIndex = lectures.indexWhere(
      (l) => l.id == currentLecture.value!.id,
    );
    if (currentLectureIndex < 0) return null;

    final lecture = lectures[currentLectureIndex];
    final currentContentIndex = lecture.content.indexWhere(
      (c) => c.id == currentContent.value!.id,
    );

    // Previous in same lecture
    if (currentContentIndex > 0) {
      return lecture.content[currentContentIndex - 1];
    }

    // Last in previous lecture
    if (currentLectureIndex > 0) {
      final prevLecture = lectures[currentLectureIndex - 1];
      if (prevLecture.content.isNotEmpty) {
        return prevLecture.content.last;
      }
    }

    return null;
  }

  // Refresh course data
  Future<void> refresh() async {
    await loadCoursePlayerData();
  }
}
