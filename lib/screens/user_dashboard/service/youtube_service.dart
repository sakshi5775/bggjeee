import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  // You'll need to add your YouTube API key here
  // For now, using a public approach without API key (limited)
  static const String _channelId = 'UCNfFFRPAAvCGO5ATnwrMcVQ';
  static const int _maxResults = 10;

  /// Fetch videos from YouTube channel
  /// Note: This requires a YouTube Data API v3 key
  /// Without API key, this will use RSS feed as fallback
  Future<List<YouTubeVideo>> getChannelVideos({String? apiKey}) async {
    try {
      if (apiKey != null && apiKey.isNotEmpty) {
        // Use YouTube Data API v3
        final url = Uri.parse(
          '$_baseUrl/search?part=snippet&channelId=$_channelId&maxResults=$_maxResults&order=date&type=video&key=$apiKey',
        );

        final response = await http.get(url).timeout(
              const Duration(seconds: 10),
            );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final items = data['items'] as List<dynamic>? ?? [];

          return items.map((item) {
            final snippet = item['snippet'] as Map<String, dynamic>;
            final videoId = item['id']['videoId'] as String;
            final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;
            final highThumb = thumbnails['high'] as Map<String, dynamic>? ??
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

      // Fallback: Use YouTube RSS feed (doesn't require API key)
      return await _getVideosFromRSS();
    } catch (e) {
      debugPrint('Error fetching YouTube videos: $e');
      return _getVideosFromRSS();
    }
  }

  /// Fallback method using RSS feed
  Future<List<YouTubeVideo>> _getVideosFromRSS() async {
    try {
      final rssUrl = Uri.parse(
        'https://www.youtube.com/feeds/videos.xml?channel_id=$_channelId',
      );

      final response = await http.get(rssUrl).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final xml = response.body;
        final videos = <YouTubeVideo>[];

        // Parse XML to extract video data
        // Extract video IDs from <yt:videoId>
        final videoIdRegExp = RegExp(r'<yt:videoId>(.*?)</yt:videoId>');
        final titleRegExp = RegExp(r'<title>(.*?)</title>');
        final publishedRegExp = RegExp(r'<published>(.*?)</published>');
        final mediaThumbnailRegExp = RegExp(r'<media:thumbnail url="(.*?)"');

        final videoIdMatches = videoIdRegExp.allMatches(xml).toList();
        final titleMatches = titleRegExp.allMatches(xml).toList();
        final publishedMatches = publishedRegExp.allMatches(xml).toList();
        final thumbnailMatches = mediaThumbnailRegExp.allMatches(xml).toList();

        // Skip first title (channel title) and first published (channel update)
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
    } catch (e) {
      debugPrint('Error fetching videos from RSS: $e');
    }

    return [];
  }

  /// Get video details including view count and duration
  /// Requires YouTube Data API v3 key
  Future<YouTubeVideoDetails?> getVideoDetails(
    String videoId,
    String? apiKey,
  ) async {
    if (apiKey == null || apiKey.isEmpty) return null;

    try {
      final url = Uri.parse(
        '$_baseUrl/videos?part=statistics,contentDetails&id=$videoId&key=$apiKey',
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>?;

        if (items != null && items.isNotEmpty) {
          final item = items[0] as Map<String, dynamic>;
          final statistics = item['statistics'] as Map<String, dynamic>?;
          final contentDetails = item['contentDetails'] as Map<String, dynamic>?;

          return YouTubeVideoDetails(
            viewCount: int.tryParse(statistics?['viewCount'] as String? ?? '0') ?? 0,
            duration: contentDetails?['duration'] as String? ?? '',
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching video details: $e');
    }

    return null;
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

  YouTubeVideoDetails({
    required this.viewCount,
    required this.duration,
  });

  /// Parse ISO 8601 duration (PT15M33S) to minutes
  int get durationInMinutes {
    try {
      final match = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?')
          .firstMatch(duration);
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

  /// Format duration as MM:SS or HH:MM:SS
  String get formattedDuration {
    try {
      final match = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?')
          .firstMatch(duration);
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
