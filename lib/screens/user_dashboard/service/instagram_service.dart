import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/instagram_media_model.dart';

class InstagramService {
  static const String _baseUrl = 'https://graph.instagram.com';

  /// Fetch media for the authorized Instagram account
  Future<List<InstagramMedia>> getUserMedia({
    required String accessToken,
  }) async {
    if (accessToken.isEmpty) {
      if (kDebugMode) {
        print(
          'InstagramService: Access token is empty. Returning sample media.',
        );
      }
      return _getSampleMedia();
    }

    try {
      // Use 'me' for the primary endpoint as it's more reliable for Basic Display API
      final url = Uri.parse(
        '$_baseUrl/me/media?fields=id,caption,media_type,media_url,permalink,thumbnail_url,timestamp&access_token=$accessToken',
      );

      if (kDebugMode) {
        print('InstagramService: Fetching from $url');
      }

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['data'] as List<dynamic>? ?? [];

        if (kDebugMode) {
          print('InstagramService: Successfully fetched ${items.length} items');
        }

        if (items.isEmpty) return _getSampleMedia();

        return items
            .map(
              (item) => InstagramMedia.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        if (kDebugMode) {
          print(
            'InstagramService Error: ${response.statusCode} - ${response.body}',
          );
        }
        return _getSampleMedia();
      }
    } catch (e) {
      if (kDebugMode) {
        print('InstagramService Exception: $e');
      }
      return _getSampleMedia();
    }
  }

  List<InstagramMedia> _getSampleMedia() {
    return [
      InstagramMedia(
        id: 'sample1',
        caption:
            'Daily Astrology Insights for a better life. #astrobharatai #astrology',
        mediaType: InstagramMediaType.IMAGE,
        mediaUrl:
            'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/gemstone_card.png',
        permalink: 'https://www.instagram.com/astrobharatai',
        timestamp: DateTime.now(),
      ),
      InstagramMedia(
        id: 'sample2',
        caption: 'Know your planetary positions today! #kundli #vedic',
        mediaType: InstagramMediaType.VIDEO,
        mediaUrl:
            'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/guru_horoscope-4a9362.png',
        permalink: 'https://www.instagram.com/astrobharatai',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstagramMedia(
        id: 'sample3',
        caption: 'Weekly Horoscope: What do the stars say? #horoscope',
        mediaType: InstagramMediaType.IMAGE,
        mediaUrl:
            'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/quote_background.png',
        permalink: 'https://www.instagram.com/astrobharatai',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
