import 'package:share_plus/share_plus.dart';

/// Global sharing service for the AstroBharatAI app.
///
/// Provides static helper methods to share content (text, links)
/// via the native platform share sheet using the `share_plus` package.
///
/// ### Deep-link base URL
/// All shareable links are generated under `https://astrobharatai.com/`.
///
/// ### Usage
/// ```dart
/// ShareService.shareKundli(kundliId: '60b8d7...');
/// ShareService.share(
///   title: 'Check out this course!',
///   message: 'I found an amazing course on AstroBharatAI.',
///   path: 'courses',
///   queryParams: {'id': courseId},
/// );
/// ```
class ShareService {
  ShareService._(); // prevent instantiation

  // ── Constants ──────────────────────────────────
  static const String _baseUrl = 'https://astrobharatai.com';

  // ── Generic share ─────────────────────────────

  /// Share a custom message with an optional deep link.
  ///
  /// [title]  – Used as the share-sheet subject (email subject, etc.).
  /// [message] – Body text that appears in the shared content.
  /// [path]   – URL path segment appended to the base URL (e.g. `kundli`).
  /// [queryParams] – Key-value pairs appended as query params.
  ///
  /// If both [path] and [queryParams] are null the message is shared as-is.
  static Future<void> share({
    required String title,
    String? message,
    String? path,
    Map<String, String>? queryParams,
  }) async {
    final link = _buildLink(path: path, queryParams: queryParams);
    final body = _composeBody(message: message, link: link);

    await SharePlus.instance.share(ShareParams(text: body, subject: title));
  }

  /// Share only a link (no extra message).
  static Future<void> shareLink({
    required String path,
    Map<String, String>? queryParams,
    String? subject,
  }) async {
    final link = _buildLink(path: path, queryParams: queryParams);
    await SharePlus.instance.share(ShareParams(text: link, subject: subject));
  }

  // ── Feature-specific helpers ──────────────────

  /// Share a Kundli report link.
  static Future<void> shareKundli({
    required String kundliId,
    String? userName,
  }) {
    final msg = userName != null && userName.isNotEmpty
        ? 'Check out $userName\'s Kundli on AstroBharatAI 🔮'
        : 'Check out this Kundli on AstroBharatAI 🔮';

    return share(
      title: 'Kundli Report – AstroBharatAI',
      message: msg,
      path: 'kundli',
      queryParams: {'id': kundliId},
    );
  }

  /// Share a course link.
  static Future<void> shareCourse({
    required String courseId,
    String? courseTitle,
  }) {
    final msg = courseTitle != null && courseTitle.isNotEmpty
        ? 'Check out "$courseTitle" on AstroBharatAI 📚'
        : 'Check out this course on AstroBharatAI 📚';

    return share(
      title: 'Course – AstroBharatAI',
      message: msg,
      path: 'courses',
      queryParams: {'id': courseId},
    );
  }

  /// Share an astrologer profile link.
  static Future<void> shareAstrologer({
    required String astrologerId,
    String? astrologerName,
  }) {
    final msg = astrologerName != null && astrologerName.isNotEmpty
        ? 'Consult $astrologerName on AstroBharatAI ⭐'
        : 'Consult this astrologer on AstroBharatAI ⭐';

    return share(
      title: 'Astrologer – AstroBharatAI',
      message: msg,
      path: 'astrologer',
      queryParams: {'id': astrologerId},
    );
  }

  /// Share an AI Astrologer / AI Guru profile link.
  static Future<void> shareAiAstrologer({
    required String personaId,
    String? personaName,
  }) {
    final msg = personaName != null && personaName.isNotEmpty
        ? 'Chat with $personaName – AI Astrologer on AstroBharatAI 🔮✨'
        : 'Chat with this AI Astrologer on AstroBharatAI 🔮✨';

    return share(
      title: 'AI Astrologer – AstroBharatAI',
      message: msg,
      path: 'ai-astrologer',
      queryParams: {'id': personaId},
    );
  }

  /// Share a blog post link.
  static Future<void> shareBlog({required String blogId, String? blogTitle}) {
    final msg = blogTitle != null && blogTitle.isNotEmpty
        ? 'Read "$blogTitle" on AstroBharatAI 📝'
        : 'Read this article on AstroBharatAI 📝';

    return share(
      title: 'Blog – AstroBharatAI',
      message: msg,
      path: 'blog',
      queryParams: {'id': blogId},
    );
  }

  /// Share a product link (e-commerce).
  static Future<void> shareProduct({
    required String productId,
    String? productName,
    String? price,
  }) {
    String msg;
    if (productName != null && productName.isNotEmpty) {
      msg = price != null && price.isNotEmpty
          ? 'Check out "$productName" for ₹$price on AstroBharatAI 🛒'
          : 'Check out "$productName" on AstroBharatAI 🛒';
    } else {
      msg = 'Check out this product on AstroBharatAI 🛒';
    }

    return share(
      title: 'Product – AstroBharatAI',
      message: msg,
      path: 'product',
      queryParams: {'id': productId},
    );
  }

  /// Share the app download link.
  static Future<void> shareApp() {
    return share(
      title: 'AstroBharatAI – Your Astrology Companion',
      message:
          'I\'m using AstroBharatAI for astrology consultations, kundli, and more! Download it now 🌟',
      path: 'download',
    );
  }

  /// Share a festival link (Digital Mandir).
  static Future<void> shareFestival({
    required String festivalId,
    String? festivalName,
  }) {
    final msg = festivalName != null && festivalName.isNotEmpty
        ? 'Learn about "$festivalName" on AstroBharatAI 🪔🙏'
        : 'Check out this festival on AstroBharatAI 🪔🙏';

    return share(
      title: 'Festival – AstroBharatAI',
      message: msg,
      path: 'festival',
      queryParams: {'id': festivalId},
    );
  }

  // ── Private helpers ───────────────────────────

  /// Build a full URL from a path and optional query parameters.
  static String _buildLink({String? path, Map<String, String>? queryParams}) {
    if (path == null) return _baseUrl;

    final uri = Uri.parse('$_baseUrl/$path').replace(
      queryParameters: queryParams != null && queryParams.isNotEmpty
          ? queryParams
          : null,
    );
    return uri.toString();
  }

  /// Compose the share body from a message and a link.
  static String _composeBody({String? message, required String link}) {
    if (message == null || message.isEmpty) return link;
    return '$message\n\n$link';
  }
}
