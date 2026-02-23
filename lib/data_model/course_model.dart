class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String? thumbnail;
  final double price;
  final bool isPublished;
  final List<String> lectureIds;
  final String slug;
  final String? courseType;
  final String? pillar;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    this.thumbnail,
    required this.price,
    required this.isPublished,
    required this.lectureIds,
    required this.slug,
    this.courseType,
    this.pillar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isPublished: json['isPublished'] as bool? ?? false,
      lectureIds:
          (json['lectures'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      slug: json['slug'] as String? ?? '',
      courseType: json['courseType'] as String?,
      pillar: json['pillar'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}

class LectureModel {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final List<ContentModel> content;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  LectureModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.content,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    // Handle course field - can be either a string (ID) or an object
    String courseId = '';
    if (json['course'] != null) {
      if (json['course'] is String) {
        courseId = json['course'] as String;
      } else if (json['course'] is Map<String, dynamic>) {
        courseId = json['course']['_id'] as String? ?? '';
      }
    }
    return LectureModel(
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      courseId: courseId,
      content:
          (json['content'] as List<dynamic>?)
              ?.map((e) => ContentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      order: (json['order'] as int?) ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}

class ContentModel {
  final String id;
  final String title;
  final String type;
  final String url;
  final int duration; // in minutes
  final bool
  isPreview; // Whether this content is preview (accessible without enrollment)

  ContentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    required this.duration,
    this.isPreview = false,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'video',
      url: json['url'] as String? ?? '',
      duration: (json['duration'] as int?) ?? 0,
      isPreview: json['isPreview'] as bool? ?? false,
    );
  }
}

class CourseDetailModel {
  final CourseModel course;
  final List<LectureModel> lectures;

  CourseDetailModel({required this.course, required this.lectures});

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    final courseData = json['data'] as Map<String, dynamic>;

    // Extract lectures first before creating course model
    List<LectureModel> lectures = [];
    List<String> lectureIds = [];
    if (courseData['lectures'] != null) {
      final lecturesList = courseData['lectures'] as List<dynamic>;
      for (var e in lecturesList) {
        if (e is Map<String, dynamic>) {
          // Full lecture object
          lectures.add(LectureModel.fromJson(e));
          lectureIds.add(e['_id'] as String);
        } else if (e is String) {
          // Just an ID
          lectureIds.add(e);
        }
      }
    }
    // Create course model with lecture IDs
    final courseJson = Map<String, dynamic>.from(courseData);
    courseJson['lectures'] = lectureIds; // Replace with IDs for CourseModel
    final course = CourseModel.fromJson(courseJson);

    return CourseDetailModel(course: course, lectures: lectures);
  }
}

class CourseResponse {
  final List<CourseModel> courses;
  final CoursePagination pagination;

  CourseResponse({required this.courses, required this.pagination});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final paginationData = json['pagination'] as Map<String, dynamic>;

    return CourseResponse(
      courses: data
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: CoursePagination.fromJson(paginationData),
    );
  }
}

class CoursePagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  CoursePagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  factory CoursePagination.fromJson(Map<String, dynamic> json) {
    return CoursePagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 10,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
      nextPage: json['nextPage'] as int?,
      prevPage: json['prevPage'] as int?,
    );
  }
}
