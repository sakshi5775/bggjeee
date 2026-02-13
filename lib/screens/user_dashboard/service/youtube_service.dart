import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _channelId = 'UCNfFFRPAAvCGO5ATnwrMcVQ';
  static const int _maxResults = 10;

  /// Fetch videos from YouTube channel
  Future<List<YouTubeVideo>> getChannelVideos({String? apiKey}) async {
    if (apiKey != null && apiKey.isNotEmpty) {
      final url = Uri.parse(
        '$_baseUrl/search?part=snippet&channelId=$_channelId&maxResults=$_maxResults&order=date&type=video&key=$apiKey',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];

        return items.map((item) {
          final snippet = item['snippet'] as Map<String, dynamic>;
          final videoId = item['id']['videoId'] as String;
          final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;
          final highThumb =
              thumbnails['high'] as Map<String, dynamic>? ??
              thumbnails['medium'] as Map<String, dynamic>? ??
              thumbnails['default'] as Map<String, dynamic>;

          return YouTubeVideo(
            videoId: videoId,
            title: snippet['title'] as String? ?? '',
            description: snippet['description'] as String? ?? '',
            thumbnailUrl: highThumb['url'] as String? ?? '',
            channelTitle: snippet['channelTitle'] as String? ?? '',
            publishedAt: snippet['publishedAt'] as String? ?? '',
          );
        }).toList();
      }
    }

    // Fallback: Use YouTube RSS feed
    return await _getVideosFromRSS();
  }

  /// Fallback method using RSS feed
  Future<List<YouTubeVideo>> _getVideosFromRSS() async {
    final rssUrl = Uri.parse(
      'https://www.youtube.com/feeds/videos.xml?channel_id=$_channelId',
    );

    final response = await http
        .get(
          rssUrl,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final xml = response.body;
      final videos = <YouTubeVideo>[];

      // Check if XML is valid feed
      if (!xml.contains('<feed')) {
        debugPrint('Invalid RSS feed format');
        throw 'Invalid RSS feed format';
      }

      // Parse XML to extract video data
      final videoIdRegExp = RegExp(r'<yt:videoId>(.*?)</yt:videoId>');
      final titleRegExp = RegExp(r'<title>(.*?)</title>');
      final publishedRegExp = RegExp(r'<published>(.*?)</published>');
      final mediaThumbnailRegExp = RegExp(r'<media:thumbnail url="(.*?)"');

      final videoIdMatches = videoIdRegExp.allMatches(xml).toList();
      final titleMatches = titleRegExp.allMatches(xml).toList();
      final publishedMatches = publishedRegExp.allMatches(xml).toList();
      final thumbnailMatches = mediaThumbnailRegExp.allMatches(xml).toList();

      for (int i = 0; i < videoIdMatches.length && i < _maxResults; i++) {
        final videoId = videoIdMatches[i].group(1) ?? '';
        final title = i + 1 < titleMatches.length
            ? titleMatches[i + 1].group(1) ?? 'Untitled'
            : 'Untitled';
        final published = i + 1 < publishedMatches.length
            ? publishedMatches[i + 1].group(1) ?? ''
            : '';
        final thumbnail = i < thumbnailMatches.length
            ? thumbnailMatches[i].group(1) ?? ''
            : '';

        videos.add(
          YouTubeVideo(
            videoId: videoId,
            title: title,
            description: '',
            thumbnailUrl: thumbnail.isNotEmpty
                ? thumbnail
                : 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
            channelTitle: 'AstroBharatai',
            publishedAt: published,
          ),
        );
      }

      return videos;
    }

    throw 'Failed to load videos from RSS feed';
  }

  /// Get video details
  Future<YouTubeVideoDetails?> getVideoDetails(
    String videoId,
    String? apiKey,
  ) async {
    if (apiKey == null || apiKey.isEmpty) return null;

    final url = Uri.parse(
      '$_baseUrl/videos?part=statistics,contentDetails&id=$videoId&key=$apiKey',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>?;

      if (items != null && items.isNotEmpty) {
        final item = items[0] as Map<String, dynamic>;
        final statistics = item['statistics'] as Map<String, dynamic>?;
        final contentDetails = item['contentDetails'] as Map<String, dynamic>?;

        return YouTubeVideoDetails(
          viewCount:
              int.tryParse(statistics?['viewCount'] as String? ?? '0') ?? 0,
          duration: contentDetails?['duration'] as String? ?? '',
        );
      }
    }

    throw 'Failed to load video details';
  }
}

class YouTubeVideo {
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
  });

  String get videoUrl => 'https://www.youtube.com/watch?v=$videoId';
  String get embedUrl => 'https://www.youtube.com/embed/$videoId';
}

class YouTubeVideoDetails {
  final int viewCount;
  final String duration;

  YouTubeVideoDetails({required this.viewCount, required this.duration});

  int get durationInMinutes {
    try {
      final match = RegExp(
        r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?',
      ).firstMatch(duration);
      if (match != null) {
        final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
        final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
        final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
        return hours * 60 + minutes + (seconds > 0 ? 1 : 0);
      }
    } catch (e) {
      debugPrint('Error parsing duration: $e');
    }
    return 0;
  }

  String get formattedDuration {
    try {
      final match = RegExp(
        r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?',
      ).firstMatch(duration);
      if (match != null) {
        final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
        final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
        final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

        if (hours > 0) {
          return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      }
    } catch (e) {
      debugPrint('Error formatting duration: $e');
    }
    return '0:00';
  }
}
