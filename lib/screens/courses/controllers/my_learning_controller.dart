import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/data_model/my_learning_model.dart';
import 'package:get/get.dart';

class MyLearningController extends BaseController {
  final CoursesService _coursesService = CoursesService();

  // Enrolled courses with progress
  final RxList<EnrollmentData> enrolledCourses = <EnrollmentData>[].obs;

  // Overall stats
  final RxInt totalEnrollments = 0.obs;
  final RxInt completedCourses = 0.obs;
  final RxInt inProgressCourses = 0.obs;
  final RxDouble overallCompletionPercentage = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadEnrollments();
  }

  Future<void> loadEnrollments() async {
    try {
      setLoadingState(true);

      // Get progress overview first (has aggregated stats)
      final progressOverview = await _coursesService.getProgressOverview();

      if (progressOverview != null) {
        // Use overview stats
        totalEnrollments.value =
            progressOverview['totalEnrollments'] as int? ?? 0;
        completedCourses.value =
            progressOverview['completedCourses'] as int? ?? 0;
        inProgressCourses.value =
            progressOverview['inProgressCourses'] as int? ?? 0;
        overallCompletionPercentage.value =
            (progressOverview['overallCompletionPercentage'] as num?)
                ?.toDouble() ??
            0.0;

        // Extract courses from overview
        final coursesList = progressOverview['courses'] as List<dynamic>? ?? [];
        final enrollments = <EnrollmentData>[];

        for (var courseJson in coursesList) {
          final courseMap = courseJson as Map<String, dynamic>;

          // Create course model from course data
          final course = CourseModel.fromJson({
            '_id': courseMap['courseId'] as String? ?? '',
            'title': courseMap['courseTitle'] as String? ?? '',
            'description': '',
            'instructor': courseMap['instructor'] as String? ?? '',
            'thumbnail': courseMap['thumbnail'] as String?,
            'price': 0.0,
            'isPublished': true,
            'lectures': [],
            'slug': courseMap['slug'] as String? ?? '',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });

          final progress = ProgressData(
            completionPercentage:
                (courseMap['completionPercentage'] as num?)?.toDouble() ?? 0.0,
            totalLectures: 0, // Not in overview, will get from detail if needed
            completedLectures: 0,
            totalContent: 0,
            viewedContent: 0,
          );

          enrollments.add(
            EnrollmentData(
              course: course,
              progress: progress,
              enrolledAt: courseMap['enrolledAt'] != null
                  ? DateTime.parse(courseMap['enrolledAt'] as String)
                  : DateTime.now(),
              lastAccessedAt: courseMap['lastAccessedAt'] != null
                  ? DateTime.parse(courseMap['lastAccessedAt'] as String)
                  : null,
            ),
          );
        }

        enrolledCourses.value = enrollments;
      } else {
        // Fallback: Get enrollments directly
        final enrollmentsData = await _coursesService.getEnrollments(page: 1);

        if (enrollmentsData != null) {
          final enrollmentsList =
              enrollmentsData['data'] as List<dynamic>? ?? [];

          final enrollments = <EnrollmentData>[];

          for (var enrollmentJson in enrollmentsList) {
            final enrollmentMap = enrollmentJson as Map<String, dynamic>;

            // Extract course data
            final courseData = enrollmentMap['course'] as Map<String, dynamic>?;
            if (courseData == null) continue;

            // Create course model
            final course = CourseModel.fromJson(courseData);

            // Get progress for this course
            final progressData = await _coursesService.getCourseProgress(
              course.id,
            );

            final progress = ProgressData(
              completionPercentage:
                  (progressData?['completionPercentage'] as num?)?.toDouble() ??
                  0.0,
              totalLectures: progressData?['totalLectures'] as int? ?? 0,
              completedLectures:
                  progressData?['completedLectures'] as int? ?? 0,
              totalContent: progressData?['totalContent'] as int? ?? 0,
              viewedContent: progressData?['viewedContent'] as int? ?? 0,
            );

            enrollments.add(
              EnrollmentData(
                course: course,
                progress: progress,
                enrolledAt: enrollmentMap['enrolledAt'] != null
                    ? DateTime.parse(enrollmentMap['enrolledAt'] as String)
                    : DateTime.now(),
                lastAccessedAt: enrollmentMap['lastAccessedAt'] != null
                    ? DateTime.parse(enrollmentMap['lastAccessedAt'] as String)
                    : null,
              ),
            );
          }

          enrolledCourses.value = enrollments;
          _updateStats();
        }
      }
    } catch (e) {
      showErrorMessage(
        title: "Error",
        message: "Failed to load enrollments: $e",
      );
    } finally {
      setLoadingState(false);
    }
  }

  void _updateStats() {
    totalEnrollments.value = enrolledCourses.length;

    completedCourses.value = enrolledCourses.where((e) {
      return e.progress.completionPercentage >= 100;
    }).length;

    inProgressCourses.value = enrolledCourses.where((e) {
      return e.progress.completionPercentage > 0 &&
          e.progress.completionPercentage < 100;
    }).length;

    if (enrolledCourses.isNotEmpty) {
      final totalProgress = enrolledCourses.fold<double>(
        0.0,
        (sum, enrollment) => sum + enrollment.progress.completionPercentage,
      );
      overallCompletionPercentage.value =
          totalProgress / enrolledCourses.length;
    } else {
      overallCompletionPercentage.value = 0.0;
    }
  }

  Future<void> refresh() async {
    await loadEnrollments();
  }
}
