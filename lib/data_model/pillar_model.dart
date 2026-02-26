/// Data model for a pillar returned by the
/// `learning-portal/api/learning-portal/pillars` endpoint.
class PillarModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String image;
  final bool isActive;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PillarModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.image,
    required this.isActive,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PillarModel.fromJson(Map<String, dynamic> json) {
    return PillarModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      image: json['image'] as String? ?? '',
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
    'description': description,
    'icon': icon,
    'image': image,
    'isActive': isActive,
    'slug': slug,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Wrapper for the paginated pillars API response.
class PillarResponse {
  final List<PillarModel> pillars;
  final int totalItems;

  const PillarResponse({required this.pillars, required this.totalItems});

  factory PillarResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return PillarResponse(
      pillars: data
          .map((e) => PillarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: (json['pagination']?['totalItems'] as int?) ?? data.length,
    );
  }
}
