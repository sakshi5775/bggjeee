import 'dart:convert';
import 'package:astrobharataiuser/apihelper/utils/port_fallback_helper.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MatchMakingService {
  /// Base URL for match making API (port 8000/api/numerology)
  static const String _matchMakingBaseUrl =
      'https://api.astrobharatai.com/api/numerology/api/vedic/matching';

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
        '$_matchMakingBaseUrl/ashtakoot-with-astro-details',
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
      path: 'dashakoot-with-astro-details',
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
      path: 'aggregate-match',
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
      path: 'rajju-vedha-details',
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
      path: 'papasamaya-match',
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
      path: 'nakshatra-match',
      params: {'boyStar': boyStar, 'girlStar': girlStar, 'lang': lang},
    );
  }

  Future<Map<String, dynamic>?> getWesternMatch({
    required String boySign,
    required String girlSign,
    String lang = 'en',
  }) async {
    return _getWithParams(
      path: 'western-match',
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

  // ===== Matchmaking Profile CRUD (primary: 8000/api/users, fallback: 8002) =====

  static const String _profilePath = '/api/users/matchmaking-profile';

  Map<String, String> _profileHeaders(String? token) => {
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  Future<http.Response> _profileGet(String suffix) {
    final token = UserData().accessToken?.trim();
    final headers = _profileHeaders(token);
    return PortFallbackHelper.callWithFallback(
      primary: () => PortFallbackHelper.get(
          '${PortFallbackHelper.usersApiPrimary}$_profilePath$suffix',
          headers: headers),
      fallback: () => PortFallbackHelper.get(
          '${PortFallbackHelper.usersApiFallback}$_profilePath$suffix',
          headers: headers),
    );
  }

  Future<http.Response> _profilePost(String suffix, String body) {
    final token = UserData().accessToken?.trim();
    final headers = {
      ..._profileHeaders(token),
      'Content-Type': 'application/json',
    };
    return PortFallbackHelper.callWithFallback(
      primary: () => PortFallbackHelper.post(
          '${PortFallbackHelper.usersApiPrimary}$_profilePath$suffix',
          headers: headers,
          body: body),
      fallback: () => PortFallbackHelper.post(
          '${PortFallbackHelper.usersApiFallback}$_profilePath$suffix',
          headers: headers,
          body: body),
    );
  }

  Future<http.Response> _profileDelete(String suffix) {
    final token = UserData().accessToken?.trim();
    final headers = _profileHeaders(token);
    return PortFallbackHelper.callWithFallback(
      primary: () => PortFallbackHelper.delete(
          '${PortFallbackHelper.usersApiPrimary}$_profilePath$suffix',
          headers: headers),
      fallback: () => PortFallbackHelper.delete(
          '${PortFallbackHelper.usersApiFallback}$_profilePath$suffix',
          headers: headers),
    );
  }

  /// GET all saved matchmaking profiles
  Future<List<Map<String, dynamic>>> getSavedMatchmakingProfiles() async {
    try {
      final response = await _profileGet('');

      if (kDebugMode) debugPrint('GET Matchmaking Profiles Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          return List<Map<String, dynamic>>.from(body['data']);
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching saved matchmaking profiles: $e');
      return [];
    }
  }

  /// POST create a new matchmaking profile
  Future<Map<String, dynamic>?> createMatchmakingProfile({
    required Map<String, dynamic> boy,
    required Map<String, dynamic> girl,
  }) async {
    try {
      final reqBody = json.encode({'boy': boy, 'girl': girl});
      final response = await _profilePost('', reqBody);

      if (kDebugMode) debugPrint('POST Matchmaking Profile Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respBody = json.decode(response.body) as Map<String, dynamic>;
        if (respBody['success'] == true) {
          return respBody['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error creating matchmaking profile: $e');
      return null;
    }
  }

  /// DELETE a matchmaking profile by ID
  Future<bool> deleteMatchmakingProfile(String id) async {
    try {
      final response = await _profileDelete('/$id');

      if (kDebugMode) debugPrint('DELETE Matchmaking Profile Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return body['success'] == true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting matchmaking profile: $e');
      }
      return false;
    }
  }
}
