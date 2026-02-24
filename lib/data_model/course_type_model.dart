/// Data model for a course type returned by the
/// `learning-portal/api/learning-portal/course-types` endpoint.
class CourseTypeModel {
  final String id;
  final String name;
  final String level;
  final String duration;
  final String investment;
  final String learningFocus;
  final String description;
  final bool isActive;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseTypeModel({
    required this.id,
    required this.name,
    required this.level,
    required this.duration,
    required this.investment,
    required this.learningFocus,
    required this.description,
    required this.isActive,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseTypeModel.fromJson(Map<String, dynamic> json) {
    return CourseTypeModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      investment: json['investment'] as String? ?? '',
      learningFocus: json['learningFocus'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      slug: json['slug'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'level': level,
    'duration': duration,
    'investment': investment,
    'learningFocus': learningFocus,
    'description': description,
    'isActive': isActive,
    'slug': slug,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Wrapper for the paginated course-types API response.
class CourseTypeResponse {
  final List<CourseTypeModel> courseTypes;
  final int totalItems;

  const CourseTypeResponse({
    required this.courseTypes,
    required this.totalItems,
  });

  factory CourseTypeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return CourseTypeResponse(
      courseTypes: data
          .map((e) => CourseTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: (json['pagination']?['totalItems'] as int?) ?? data.length,
    );
  }
}
