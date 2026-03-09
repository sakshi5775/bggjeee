import 'package:astrobharataiuser/data_model/global_search_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/puja_service.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/foundation.dart';

/// Ensures string is safe for UTF-8 display (strips invalid/replacement chars).
String _safeString(String? value) {
  if (value == null || value.isEmpty) return '';
  try {
    return value.replaceAll(RegExp(r'[\uFFFD\u0000-\u001F]'), '').trim();
  } catch (_) {
    return '';
  }
}

/// Local app page entry for search (no API).
class _AppPageEntry {
  final String title;
  final String? subtitle;
  final String route;
  final List<String> keywords;

  const _AppPageEntry({
    required this.title,
    this.subtitle,
    required this.route,
    required this.keywords,
  });
}

/// Global search across astrologers, AI personas, blogs, courses, products, categories, pujas, and app pages (local).
/// API searches run in parallel; app pages are matched locally by keywords.
class GlobalSearchService {
  final AstrologerService _astrologerService = AstrologerService();
  final BlogService _blogService = BlogService();
  final PujaService _pujaService = PujaService();
  final AiChatService _aiChatService = AiChatService();
  final CoursesService _coursesService = CoursesService();
  final EcommerceService _ecommerceService = EcommerceService();

  static const int _perSectionLimit = 10;

  static const List<_AppPageEntry> _appPages = [
    _AppPageEntry(title: 'Kundli', subtitle: 'Birth chart & kundli', route: AppRoutes.kundliForm, keywords: ['kundli', 'chart', 'birth', 'janmakundli', 'janm kundli', 'कुंडली', 'कुण्डली', 'जन्मपत्री', 'जन्म कुंडली']),
    _AppPageEntry(title: 'Kundli Milan', subtitle: 'Match making', route: AppRoutes.matchMakingForm, keywords: ['match', 'milan', 'compatibility', 'kundli milan', 'मिलान', 'कुंडली मिलान', 'matching']),
    _AppPageEntry(title: 'Horoscope', subtitle: 'Daily rashifal', route: AppRoutes.horoscope, keywords: ['horoscope', 'rashifal', 'rashi', 'राशिफल', 'होरोस्कोप']),
    _AppPageEntry(title: 'Tarot Reading', route: AppRoutes.tarotReading, keywords: ['tarot', 'card', 'तारो', 'तारो कार्ड']),
    _AppPageEntry(title: 'Panchang', subtitle: 'Hindu calendar', route: AppRoutes.panchang, keywords: ['panchang', 'पंचांग', 'calendar', 'panchangam']),
    _AppPageEntry(title: 'Numerology', route: AppRoutes.numerology, keywords: ['numerology', 'अंक ज्योतिष', 'न्यूमेरोलॉजी', 'number']),
    _AppPageEntry(title: 'Palm Reading', route: AppRoutes.palmReading, keywords: ['palm', 'hast', 'hand', 'हस्त', 'हस्त रेखा', 'palmistry']),
    _AppPageEntry(title: 'Face Reading', route: AppRoutes.faceReading, keywords: ['face', 'mukh', 'मुख', 'मुख रेखा', 'physiognomy']),
    _AppPageEntry(title: 'Handwriting Astrology', route: AppRoutes.handwritingAstrology, keywords: ['handwriting', 'signature', 'हस्तलेख', 'graphology']),
    _AppPageEntry(title: 'Live Astrologers', subtitle: 'Talk to astrologers', route: AppRoutes.liveAstrologers, keywords: ['astrologer', 'live', 'consult', 'consultation', 'ज्योतिषी', 'एस्ट्रोलॉजर', 'लाइव']),
    _AppPageEntry(title: 'Astrology Services', route: AppRoutes.astrologyServices, keywords: ['service', 'services', 'सेवा', 'astrology service']),
    _AppPageEntry(title: 'All Astrologers', route: AppRoutes.allAstrologers, keywords: ['astrologers', 'all astrologer', 'list']),
    _AppPageEntry(title: 'AI Chat', subtitle: 'Chat with AI astrologers', route: AppRoutes.aichat, keywords: ['ai', 'chat', 'ai chat', 'persona']),
    _AppPageEntry(title: 'Courses', route: AppRoutes.courses, keywords: ['course', 'education', 'learn', 'पाठ्यक्रम', 'learning']),
    _AppPageEntry(title: 'Blogs', route: AppRoutes.allBlogs, keywords: ['blog', 'article', 'ब्लॉग', 'articles']),
    _AppPageEntry(title: 'Wallet', route: AppRoutes.wallet, keywords: ['wallet', 'balance', 'पर्स', 'balance']),
    _AppPageEntry(title: 'Profile', route: AppRoutes.profile, keywords: ['profile', 'account', 'प्रोफ़ाइल']),
    _AppPageEntry(title: 'Cart', route: AppRoutes.cart, keywords: ['cart', 'basket', 'टोकरी']),
    _AppPageEntry(title: 'My Orders', route: AppRoutes.orders, keywords: ['order', 'purchase', 'ऑर्डर', 'orders', 'my orders']),
    _AppPageEntry(title: 'E-commerce', subtitle: 'Shop products', route: AppRoutes.ecommerceHome, keywords: ['shop', 'store', 'ecommerce', 'e-commerce', 'products', 'buy']),
    _AppPageEntry(title: 'Vastu', route: AppRoutes.vastuReading, keywords: ['vastu', 'वास्तु', 'vastu shastra']),
    _AppPageEntry(title: 'Divya Darshan', route: AppRoutes.divyaDarshan, keywords: ['divya', 'darshan', 'दिव्य दर्शन']),
    _AppPageEntry(title: 'Chalisa', route: AppRoutes.chalisa, keywords: ['chalisa', 'चालीसा']),
    _AppPageEntry(title: 'Digital Mandir', subtitle: 'Puja & devotion', route: AppRoutes.namasteHome, keywords: ['mandir', 'puja', 'pooja', 'digital mandir', 'e-mandir', 'devotion', 'भक्ति']),
    _AppPageEntry(title: 'Book Puja', route: AppRoutes.bookPuja, keywords: ['book puja', 'puja booking']),
    _AppPageEntry(title: 'Prashna Kundali', route: AppRoutes.prashnaKundali, keywords: ['prashna', 'prashna kundali', 'प्रश्न कुंडली']),
    _AppPageEntry(title: 'Ramal Shastra', route: AppRoutes.ramalShastraIntro, keywords: ['ramal', 'ramal shastra', 'रमल']),
    _AppPageEntry(title: 'Carrot Astrology', route: AppRoutes.carrotAstrology, keywords: ['carrot', 'carrot astrology']),
    _AppPageEntry(title: 'Dasha', subtitle: 'Planetary periods', route: AppRoutes.dasha, keywords: ['dasha', 'दशा', 'planetary period']),
    _AppPageEntry(title: 'Sade Sati', route: AppRoutes.sadeSati, keywords: ['sade sati', 'sadesati', 'शनि']),
    _AppPageEntry(title: 'Varshphal', route: AppRoutes.varshphal, keywords: ['varshphal', 'वर्षफल', 'yearly']),
    _AppPageEntry(title: 'Remedies', route: AppRoutes.remedies, keywords: ['remedy', 'remedies', 'उपाय']),
    _AppPageEntry(title: 'Support', route: AppRoutes.supportTickets, keywords: ['support', 'ticket', 'help']),
    _AppPageEntry(title: 'Panchang Daily', route: AppRoutes.dailyPanchang, keywords: ['daily panchang']),
    _AppPageEntry(title: 'Hindu Calendar', route: AppRoutes.hinduCalendar, keywords: ['hindu calendar', 'calendar']),
    _AppPageEntry(title: 'AI Guider', route: AppRoutes.aiGuider, keywords: ['ai guider', 'guider', 'guide']),
  ];

  /// Performs search across all modules and returns grouped results.
  Future<GlobalSearchResponse> search(String query) async {
    final q = _safeString(query);
    if (q.isEmpty) {
      return GlobalSearchResponse(sections: [], query: '');
    }

    final results = await Future.wait<List<GlobalSearchResultItem>>([
      _searchAstrologers(q),
      _searchAiAstrologers(q),
      _searchBlogs(q),
      _searchCourses(q),
      _searchProducts(q),
      _searchCategories(q),
      _searchPujas(q),
    ]);

    final appPageItems = _searchAppPages(q);

    final sections = <GlobalSearchSection>[
      GlobalSearchSection(
        type: GlobalSearchResultType.astrologer,
        items: results[0],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.aiAstrologer,
        items: results[1],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.blog,
        items: results[2],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.course,
        items: results[3],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.product,
        items: results[4],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.category,
        items: results[5],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.puja,
        items: results[6],
      ),
      GlobalSearchSection(
        type: GlobalSearchResultType.appPage,
        items: appPageItems,
      ),
    ];

    return GlobalSearchResponse(sections: sections, query: q);
  }

  /// Local search: match query against app page titles and keywords (no API).
  List<GlobalSearchResultItem> _searchAppPages(String q) {
    final lower = q.toLowerCase().trim();
    if (lower.isEmpty) return [];
    final matched = <GlobalSearchResultItem>[];
    for (final page in _appPages) {
      final titleMatch = page.title.toLowerCase().contains(lower);
      final subtitleMatch = page.subtitle != null && page.subtitle!.toLowerCase().contains(lower);
      final keywordMatch = page.keywords.any((k) => k.toLowerCase().contains(lower) || lower.contains(k.toLowerCase()));
      if (titleMatch || subtitleMatch || keywordMatch) {
        matched.add(GlobalSearchResultItem(
          type: GlobalSearchResultType.appPage,
          id: page.route,
          title: page.title,
          subtitle: page.subtitle,
          imageUrl: null,
          route: page.route,
          arguments: null,
          requiresAuth: false,
        ));
        if (matched.length >= _perSectionLimit) break;
      }
    }
    return matched;
  }

  Future<List<GlobalSearchResultItem>> _searchAstrologers(String q) async {
    try {
      final res = await _astrologerService.getAstrologers(
        page: 1,
        limit: _perSectionLimit,
        search: q,
        useCache: false,
      );
      final list = res?.astrologers ?? [];
      return list.map((a) {
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.astrologer,
          id: _safeString(a.astrologerId),
          title: _safeString(a.displayName),
          subtitle: a.specializations.isNotEmpty ? _safeString(a.specializations.join(', ')) : null,
          imageUrl: _safeString(a.profilePicture).isEmpty ? null : _safeString(a.profilePicture),
          route: AppRoutes.astrologerDetail,
          arguments: a,
          requiresAuth: true,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch astrologers: $e');
      return [];
    }
  }

  Future<List<GlobalSearchResultItem>> _searchAiAstrologers(String q) async {
    try {
      final res = await _aiChatService.getPersonas(
        page: 1,
        limit: 50,
      );
      final list = res?.personas ?? [];
      final lower = q.toLowerCase();
      final filtered = list.where((p) {
        return p.name.toLowerCase().contains(lower) ||
            (p.displayName.toLowerCase().contains(lower)) ||
            (p.description.toLowerCase().contains(lower)) ||
            (p.category.toLowerCase().contains(lower));
      }).take(_perSectionLimit).toList();
      return filtered.map((p) {
        final desc = _safeString(p.description);
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.aiAstrologer,
          id: _safeString(p.id),
          title: _safeString(p.displayName),
          subtitle: desc.length > 60 ? '${desc.substring(0, 60)}...' : desc,
          imageUrl: _safeString(p.image).isEmpty ? null : _safeString(p.image),
          route: AppRoutes.personaDetail,
          arguments: p,
          requiresAuth: true,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch AI astrologers: $e');
      return [];
    }
  }

  Future<List<GlobalSearchResultItem>> _searchBlogs(String q) async {
    try {
      final res = await _blogService.getBlogs(
        page: 1,
        search: q,
        status: 'published',
        useAuthHeader: false,
      );
      final list = res?.data ?? [];
      final limited = list.take(_perSectionLimit).toList();
      return limited.map((b) {
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.blog,
          id: _safeString(b.id),
          title: _safeString(b.title),
          subtitle: _safeString(b.excerpt).isEmpty ? null : _safeString(b.excerpt),
          imageUrl: _safeString(b.featuredImage).isEmpty ? null : _safeString(b.featuredImage),
          route: AppRoutes.blogDetail,
          arguments: b,
          requiresAuth: false,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch blogs: $e');
      return [];
    }
  }

  Future<List<GlobalSearchResultItem>> _searchCourses(String q) async {
    try {
      final res = await _coursesService.getCourses(
        page: 1,
        limit: _perSectionLimit,
        isPublished: true,
        search: q,
      );
      final list = res?.courses ?? [];
      return list.map((c) {
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.course,
          id: _safeString(c.id),
          title: _safeString(c.title),
          subtitle: _safeString(c.instructor).isEmpty ? null : _safeString(c.instructor),
          imageUrl: _safeString(c.thumbnail).isEmpty ? null : _safeString(c.thumbnail),
          route: AppRoutes.courseDetail,
          arguments: c.id,
          requiresAuth: true,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch courses: $e');
      return [];
    }
  }

  Future<List<GlobalSearchResultItem>> _searchProducts(String q) async {
    try {
      final res = await _ecommerceService.searchProducts(
        query: q,
        page: 1,
        limit: _perSectionLimit,
      );
      final list = res?.items ?? [];
      return list.map((p) {
        String? img;
        if (p.images != null && p.images!.isNotEmpty) {
          final primary = p.images!.where((i) => i.isPrimary == true).firstOrNull ?? p.images!.first;
          img = primary.url;
        }
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.product,
          id: _safeString(p.id),
          title: _safeString(p.name),
          subtitle: _safeString(p.shortDescription).isEmpty ? null : _safeString(p.shortDescription),
          imageUrl: img == null || _safeString(img).isEmpty ? null : _safeString(img),
          route: AppRoutes.productDetail,
          arguments: {'product': p},
          requiresAuth: false,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch products: $e');
      return [];
    }
  }

  Future<List<GlobalSearchResultItem>> _searchCategories(String q) async {
    try {
      final res = await _ecommerceService.searchCategories(
        q: q,
        type: 'all',
        page: 1,
        limit: _perSectionLimit,
      );
      final list = res?.items ?? [];
      return list.map((c) {
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.category,
          id: _safeString(c.id),
          title: _safeString(c.name),
          subtitle: _safeString(c.description).isEmpty ? null : _safeString(c.description),
          imageUrl: _safeString(c.image).isEmpty ? null : _safeString(c.image),
          route: AppRoutes.productList,
          arguments: {
            if (c.slug != null && c.slug!.isNotEmpty) 'categorySlug': c.slug,
            if (c.id != null) 'categoryId': c.id,
            'title': c.name,
          },
          requiresAuth: false,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch categories: $e');
      return [];
    }
  }

  Future<List<GlobalSearchResultItem>> _searchPujas(String q) async {
    try {
      final res = await _pujaService.getPujas(
        page: 1,
        limit: _perSectionLimit,
        search: q,
      );
      final list = res?.data?.items ?? [];
      return list.map((p) {
        return GlobalSearchResultItem(
          type: GlobalSearchResultType.puja,
          id: _safeString(p.id),
          title: _safeString(p.title),
          subtitle: _safeString(p.subheading).isEmpty ? null : _safeString(p.subheading),
          imageUrl: _safeString(p.image).isEmpty ? null : _safeString(p.image),
          route: AppRoutes.pujaDetail,
          arguments: p.id,
          requiresAuth: true,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('GlobalSearch pujas: $e');
      return [];
    }
  }
}
