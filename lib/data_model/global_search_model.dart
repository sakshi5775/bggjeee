/// Unified model for global search results across the app.
/// Each result type maps to a route and optional payload for navigation.
/// Use [GlobalSearchSection] to group results by type in the UI.
library;

enum GlobalSearchResultType {
  astrologer,
  aiAstrologer,
  blog,
  course,
  product,
  category,
  puja,
  appPage,
}

/// Single search result item: type, display fields, and navigation data.
class GlobalSearchResultItem {
  final GlobalSearchResultType type;
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  /// Route to open when user taps (e.g. AppRoutes.astrologerDetail).
  final String route;
  /// Arguments for Get.toNamed(route, arguments: arguments).
  final dynamic arguments;
  /// If true, show login popup before navigating when user is not logged in.
  final bool requiresAuth;

  const GlobalSearchResultItem({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.route,
    this.arguments,
    this.requiresAuth = false,
  });

  String get sectionLabel {
    switch (type) {
      case GlobalSearchResultType.astrologer:
        return 'Astrologers';
      case GlobalSearchResultType.aiAstrologer:
        return 'AI Astrologers';
      case GlobalSearchResultType.blog:
        return 'Blogs';
      case GlobalSearchResultType.course:
        return 'Courses';
      case GlobalSearchResultType.product:
        return 'Products';
      case GlobalSearchResultType.category:
        return 'Categories';
      case GlobalSearchResultType.puja:
        return 'Pooja';
      case GlobalSearchResultType.appPage:
        return 'App pages';
    }
  }
}

/// A section of results of the same type (e.g. all astrologers).
class GlobalSearchSection {
  final GlobalSearchResultType type;
  final List<GlobalSearchResultItem> items;

  const GlobalSearchSection({
    required this.type,
    required this.items,
  });

  String get sectionLabel => items.isNotEmpty ? items.first.sectionLabel : '';

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

/// Full response from global search: all sections.
class GlobalSearchResponse {
  final List<GlobalSearchSection> sections;
  final String query;

  const GlobalSearchResponse({
    required this.sections,
    required this.query,
  });

  List<GlobalSearchSection> get nonEmptySections =>
      sections.where((s) => s.isNotEmpty).toList();

  bool get hasResults => nonEmptySections.isNotEmpty;
}
