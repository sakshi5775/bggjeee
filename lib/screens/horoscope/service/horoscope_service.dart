import 'dart:convert';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HoroscopeService {
  static const String _baseUrl = 'https://api.astrobharatai.com/api/numerology/api';

  /// Get Extended Kundali (Key Points)
  Future<Map<String, dynamic>?> getExtendedKundali({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_baseUrl/${EndPoints.extendedKundali}',
      ).replace(queryParameters: queryParams);

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
        debugPrint('Extended Kundali API URL: ${uri.toString()}');
        debugPrint('Extended Kundali API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Extended Kundali API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Extended Kundali: $e');
      }
      return null;
    }
  }

  /// Get Moon Sign
  Future<Map<String, dynamic>?> getMoonSign({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.moonSign,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Sun Sign
  Future<Map<String, dynamic>?> getSunSign({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.sunSign,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Ascendant Sign
  Future<Map<String, dynamic>?> getAscendantSign({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.ascendantSign,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Current Sade Sati
  Future<Map<String, dynamic>?> getCurrentSadeSati({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.currentSadeSati,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Gem Suggestion
  Future<Map<String, dynamic>?> getGemSuggestion({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.gemSuggestion,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Rudraksh Suggestion
  Future<Map<String, dynamic>?> getRudrakshSuggestion({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.rudrakshSuggestion,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Friendship Table
  Future<Map<String, dynamic>?> getFriendshipTable({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.friendshipTable,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get Planet KP
  Future<Map<String, dynamic>?> getPlanetKp({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _callExtendedHoroscopeAPI(
      EndPoints.planetKp,
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Common method for extended horoscope APIs
  Future<Map<String, dynamic>?> _callExtendedHoroscopeAPI(
    String endpoint,
    String date,
    String time,
    double latitude,
    double longitude,
    double tz,
    String lang,
  ) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_baseUrl/$endpoint',
      ).replace(queryParameters: queryParams);

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
        debugPrint('$endpoint API URL: ${uri.toString()}');
        debugPrint('$endpoint API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            '$endpoint API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching $endpoint: $e');
      }
      return null;
    }
  }
}
