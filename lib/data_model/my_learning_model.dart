import 'package:astrobharataiuser/data_model/course_model.dart';

// Enrollment data model
class EnrollmentData {
  final CourseModel course;
  final ProgressData progress;
  final DateTime enrolledAt;
  final DateTime? lastAccessedAt;

  EnrollmentData({
    required this.course,
    required this.progress,
    required this.enrolledAt,
    this.lastAccessedAt,
  });
}

class ProgressData {
  final double completionPercentage;
  final int totalLectures;
  final int completedLectures;
  final int totalContent;
  final int viewedContent;

  ProgressData({
    this.completionPercentage = 0.0,
    this.totalLectures = 0,
    this.completedLectures = 0,
    this.totalContent = 0,
    this.viewedContent = 0,
  });
}
