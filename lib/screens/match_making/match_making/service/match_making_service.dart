import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MatchMakingService {
  /// Base URL for match making API (port 8010)
  static const String _matchMakingBaseUrl =
      'http://3.109.91.254:8000/api/numerology/api';

  /// Get Ashtakoot matching with astro details
  Future<Map<String, dynamic>?> getAshtakootMatching({
    required String boyDob, // Format: DD/MM/YYYY
    required String boyTob, // Format: HH:MM (24-hour)
    required double boyTz, // Timezone offset
    required double boyLat,
    required double boyLon,
    required String girlDob, // Format: DD/MM/YYYY
    required String girlTob, // Format: HH:MM (24-hour)
    required double girlTz, // Timezone offset
    required double girlLat,
    required double girlLon,
    String lang = 'en',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'boyDob': boyDob,
        'boyTob': boyTob,
        'boyTz': boyTz.toString(),
        'boyLat': boyLat.toString(),
        'boyLon': boyLon.toString(),
        'girlDob': girlDob,
        'girlTob': girlTob,
        'girlTz': girlTz.toString(),
        'girlLat': girlLat.toString(),
        'girlLon': girlLon.toString(),
        'lang': lang,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_matchMakingBaseUrl/vedic/matching/ashtakoot-with-astro-details',
      ).replace(queryParameters: queryParams);

      // Get authorization token
      final currentToken = UserData().accessToken?.trim();

      // Make HTTP GET request
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (kDebugMode) {
        debugPrint('Match Making API URL: ${uri.toString()}');
        debugPrint('Match Making API Status: ${response.statusCode}');
        debugPrint('Match Making API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          return jsonData;
        } catch (e) {
          debugPrint('Error parsing Match Making response: $e');
          return null;
        }
      }

      debugPrint(
        'Match Making API returned status code: ${response.statusCode}',
      );
      return null;
    } catch (e) {
      debugPrint('Error fetching Match Making data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDashakootMatching({
    required String boyDob,
    required String boyTob,
    required double boyTz,
    required double boyLat,
    required double boyLon,
    required String girlDob,
    required String girlTob,
    required double girlTz,
    required double girlLat,
    required double girlLon,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'vedic/matching/dashakoot-with-astro-details',
      params: {
        'boyDob': boyDob,
        'boyTob': boyTob,
        'boyTz': boyTz.toString(),
        'boyLat': boyLat.toString(),
        'boyLon': boyLon.toString(),
        'girlDob': girlDob,
        'girlTob': girlTob,
        'girlTz': girlTz.toString(),
        'girlLat': girlLat.toString(),
        'girlLon': girlLon.toString(),
        'lang': lang,
      },
    );
  }

  Future<Map<String, dynamic>?> getAggregateMatch({
    required String boyDob,
    required String boyTob,
    required double boyTz,
    required double boyLat,
    required double boyLon,
    required String girlDob,
    required String girlTob,
    required double girlTz,
    required double girlLat,
    required double girlLon,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'vedic/matching/aggregate-match',
      params: {
        'boyDob': boyDob,
        'boyTob': boyTob,
        'boyTz': boyTz.toString(),
        'boyLat': boyLat.toString(),
        'boyLon': boyLon.toString(),
        'girlDob': girlDob,
        'girlTob': girlTob,
        'girlTz': girlTz.toString(),
        'girlLat': girlLat.toString(),
        'girlLon': girlLon.toString(),
        'lang': lang,
      },
    );
  }

  Future<Map<String, dynamic>?> getRajjuVedhaDetails({
    required String boyDob,
    required String boyTob,
    required double boyTz,
    required double boyLat,
    required double boyLon,
    required String girlDob,
    required String girlTob,
    required double girlTz,
    required double girlLat,
    required double girlLon,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'vedic/matching/rajju-vedha-details',
      params: {
        'boyDob': boyDob,
        'boyTob': boyTob,
        'boyTz': boyTz.toString(),
        'boyLat': boyLat.toString(),
        'boyLon': boyLon.toString(),
        'girlDob': girlDob,
        'girlTob': girlTob,
        'girlTz': girlTz.toString(),
        'girlLat': girlLat.toString(),
        'girlLon': girlLon.toString(),
        'lang': lang,
      },
    );
  }

  Future<Map<String, dynamic>?> getPapasamayaMatch({
    required String boyDob,
    required String boyTob,
    required double boyTz,
    required double boyLat,
    required double boyLon,
    required String girlDob,
    required String girlTob,
    required double girlTz,
    required double girlLat,
    required double girlLon,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'vedic/matching/papasamaya-match',
      params: {
        'boyDob': boyDob,
        'boyTob': boyTob,
        'boyTz': boyTz.toString(),
        'boyLat': boyLat.toString(),
        'boyLon': boyLon.toString(),
        'girlDob': girlDob,
        'girlTob': girlTob,
        'girlTz': girlTz.toString(),
        'girlLat': girlLat.toString(),
        'girlLon': girlLon.toString(),
        'lang': lang,
      },
    );
  }

  Future<Map<String, dynamic>?> getNakshatraMatch({
    required String boyStar,
    required String girlStar,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'vedic/matching/nakshatra-match',
      params: {'boyStar': boyStar, 'girlStar': girlStar, 'lang': lang},
    );
  }

  Future<Map<String, dynamic>?> getWesternMatch({
    required String boySign,
    required String girlSign,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'vedic/matching/western-match',
      params: {'boySign': boySign, 'girlSign': girlSign, 'lang': lang},
    );
  }

  Future<Map<String, dynamic>?> _getWithParams({
    required String path,
    required Map<String, String> params,
  }) async {
    final uri = Uri.parse(
      '$_matchMakingBaseUrl/$path',
    ).replace(queryParameters: params);
    final currentToken = UserData().accessToken?.trim();

    final response = await http
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            if (currentToken != null && currentToken.isNotEmpty)
              'Authorization': 'Bearer $currentToken',
          },
        )
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Request timeout');
          },
        );

    if (kDebugMode) {
      debugPrint('Match API ($path) URL: ${uri.toString()}');
      debugPrint('Match API ($path) Status: ${response.statusCode}');
      debugPrint('Match API ($path) Response: ${response.body}');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error parsing $path response: $e');
        return null;
      }
    }

    debugPrint(
      'Match API ($path) returned status code: ${response.statusCode}',
    );
    return null;
  }
}
