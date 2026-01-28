import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PanchangService {
  /// Base URL for panchang API (port 8010)
  static const String _panchangBaseUrl =
      'http://3.109.91.254:8000/api/numerology/api';

  /// Get daily panchang data
  Future<Map<String, dynamic>?> getDailyPanchang({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:MM (24-hour)
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_panchangBaseUrl/panchang/panchang',
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
        debugPrint('Panchang API URL: ${uri.toString()}');
        debugPrint('Panchang API Status: ${response.statusCode}');
        debugPrint('Panchang API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Panchang API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Panchang API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching panchang: $e');
      return null;
    }
  }

  /// Get monthly calendar data
  Future<Map<String, dynamic>?> getMonthlyCalendar({
    required int month, // 1-12
    required int year, // e.g., 2025
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'month': month.toString(),
        'year': year.toString(),
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_panchangBaseUrl/panchang/monthly-calender',
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
        debugPrint('Monthly Calendar API URL: ${uri.toString()}');
        debugPrint('Monthly Calendar API Status: ${response.statusCode}');
        debugPrint('Monthly Calendar API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Monthly Calendar API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Monthly Calendar API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching monthly calendar: $e');
      return null;
    }
  }

  /// Get hora muhurta data
  Future<Map<String, dynamic>?> getHoraMuhurta({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:MM (24-hour)
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_panchangBaseUrl/panchang/hora-muhurta',
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
        debugPrint('Hora Muhurta API URL: ${uri.toString()}');
        debugPrint('Hora Muhurta API Status: ${response.statusCode}');
        debugPrint('Hora Muhurta API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Hora Muhurta API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Hora Muhurta API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching hora muhurta: $e');
      return null;
    }
  }

  /// Get choghadiya muhurta data
  Future<Map<String, dynamic>?> getChoghadiyaMuhurta({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:MM (24-hour)
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_panchangBaseUrl/panchang/choghadiya-muhurta',
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
        debugPrint('Choghadiya Muhurta API URL: ${uri.toString()}');
        debugPrint('Choghadiya Muhurta API Status: ${response.statusCode}');
        debugPrint('Choghadiya Muhurta API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint(
            'Choghadiya Muhurta API error: ${responseData?['message']}',
          );
        }
      } else {
        debugPrint(
          'Choghadiya Muhurta API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching choghadiya muhurta: $e');
      return null;
    }
  }

  /// Get sunrise time
  Future<Map<String, dynamic>?> getSunrise({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _getSunMoonTime(
      'sunrise',
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get sunset time
  Future<Map<String, dynamic>?> getSunset({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _getSunMoonTime('sunset', date, time, latitude, longitude, tz, lang);
  }

  /// Get moonrise time
  Future<Map<String, dynamic>?> getMoonrise({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _getSunMoonTime(
      'moonrise',
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get moonset time
  Future<Map<String, dynamic>?> getMoonset({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _getSunMoonTime(
      'moonset',
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Helper method to get sun/moon times
  Future<Map<String, dynamic>?> _getSunMoonTime(
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
        '$_panchangBaseUrl/panchang/$endpoint',
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
        debugPrint('$endpoint API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('$endpoint API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          '$endpoint API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching $endpoint: $e');
      return null;
    }
  }

  /// Get Jain Navkarshi data
  Future<Map<String, dynamic>?> getJainNavkarshi({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:MM (24-hour)
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
        '$_panchangBaseUrl/panchang/jain-navkarshi',
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
        debugPrint('Jain Navkarshi API URL: ${uri.toString()}');
        debugPrint('Jain Navkarshi API Status: ${response.statusCode}');
        debugPrint('Jain Navkarshi API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Jain Navkarshi API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Jain Navkarshi API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching jain navkarshi: $e');
      return null;
    }
  }

  /// Get Jain Kalyanak data
  Future<Map<String, dynamic>?> getJainKalyanak({
    required int year,
    required int month, // 1-12
    required String section, // 'digambar' or 'shvetambar'
  }) async {
    try {
      final queryParams = <String, String>{
        'year': year.toString(),
        'month': month.toString(),
        'section': section,
      };

      final uri = Uri.parse(
        '$_panchangBaseUrl/panchang/jain-kalyanak',
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
        debugPrint('Jain Kalyanak API URL: ${uri.toString()}');
        debugPrint('Jain Kalyanak API Status: ${response.statusCode}');
        debugPrint('Jain Kalyanak API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Jain Kalyanak API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Jain Kalyanak API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching jain kalyanak: $e');
      return null;
    }
  }

  /// Get monthly panchang data
  Future<Map<String, dynamic>?> getMonthlyPanchang({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:MM (24-hour)
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
        '$_panchangBaseUrl/panchang/monthly-panchang',
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
        debugPrint('Monthly Panchang API URL: ${uri.toString()}');
        debugPrint('Monthly Panchang API Status: ${response.statusCode}');
        debugPrint('Monthly Panchang API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Monthly Panchang API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Monthly Panchang API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching monthly panchang: $e');
      return null;
    }
  }

  /// Get moon calendar data
  Future<Map<String, dynamic>?> getMoonCalendar({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:MM (24-hour)
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
        '$_panchangBaseUrl/panchang/moon-calender',
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
        debugPrint('Moon Calendar API URL: ${uri.toString()}');
        debugPrint('Moon Calendar API Status: ${response.statusCode}');
        debugPrint('Moon Calendar API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Moon Calendar API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Moon Calendar API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching moon calendar: $e');
      return null;
    }
  }

  /// Get solar noon time
  Future<Map<String, dynamic>?> getSolarNoon({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _getSunMoonTime(
      'solar-noon',
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }

  /// Get moon phase
  Future<Map<String, dynamic>?> getMoonPhase({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
  }) async {
    return _getSunMoonTime(
      'moon-phase',
      date,
      time,
      latitude,
      longitude,
      tz,
      lang,
    );
  }
}
