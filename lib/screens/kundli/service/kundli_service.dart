import 'dart:convert';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KundliService {
  /// Base URL for kundli API (port 8010)
  static const String _kundliBaseUrl = 'http://3.109.91.254:8010/api';

  /// Generate Kundli
  Future<Map<String, dynamic>?> generateKundli({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      // Note: Uri.replace will automatically encode # to %23, but we ensure color starts with #
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor, // Will be encoded as %23ed6f30 in URL
      };

      // Build URI with query parameters
      // Uri.replace will automatically URL-encode # to %23
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.generateKundli}',
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
        debugPrint('Kundli API URL: ${uri.toString()}');
        debugPrint('Kundli API Status: ${response.statusCode}');
        debugPrint('Kundli API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Kundli API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating kundli: $e');
      }
      return null;
    }
  }

  /// Generate Navamsha Chart
  Future<Map<String, dynamic>?> generateNavamsha({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      // Note: Uri.replace will automatically encode # to %23, but we ensure color starts with #
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor, // Will be encoded as %23ed6f30 in URL
      };

      // Build URI with query parameters
      // Uri.replace will automatically URL-encode # to %23
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.generateNavamsha}',
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
        debugPrint('Navamsha API URL: ${uri.toString()}');
        debugPrint('Navamsha API Status: ${response.statusCode}');
        debugPrint('Navamsha API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Navamsha API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating navamsha: $e');
      }
      return null;
    }
  }

  /// Generate Sun Chart
  Future<Map<String, dynamic>?> generateSun({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.generateSun}',
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
        debugPrint('Sun API URL: ${uri.toString()}');
        debugPrint('Sun API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Sun API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating sun chart: $e');
      }
      return null;
    }
  }

  /// Generate Moon Chart
  Future<Map<String, dynamic>?> generateMoon({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      // Note: Uri.replace will automatically encode # to %23, but we ensure color starts with #
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor, // Will be encoded as %23ed6f30 in URL
      };

      // Build URI with query parameters
      // Uri.replace will automatically URL-encode # to %23
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.generateMoon}',
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
        debugPrint('Moon API URL: ${uri.toString()}');
        debugPrint('Moon API Status: ${response.statusCode}');
        debugPrint('Moon API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Moon API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating moon chart: $e');
      }
      return null;
    }
  }

  /// Generate Chalit Chart
  Future<Map<String, dynamic>?> generateChalit({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      // Note: Uri.replace will automatically encode # to %23, but we ensure color starts with #
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor, // Will be encoded as %23ed6f30 in URL
      };

      // Build URI with query parameters
      // Uri.replace will automatically URL-encode # to %23
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.generateChalit}',
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
        debugPrint('Chalit API URL: ${uri.toString()}');
        debugPrint('Chalit API Status: ${response.statusCode}');
        debugPrint('Chalit API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Chalit API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating chalit chart: $e');
      }
      return null;
    }
  }

  /// Generate Transit Chart
  Future<Map<String, dynamic>?> generateTransitChart({
    required String date, // Format: dd/mm/yyyy (birth date)
    required String time, // Format: HH:mm (birth time)
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    required String transitDate, // Format: dd/mm/yyyy (current/transit date)
    required String transitTime, // Format: HH:mm (current/transit time)
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'transit_date': transitDate,
        'transit_time': transitTime,
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.generateTransit}',
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
        debugPrint('Transit Chart API URL: ${uri.toString()}');
        debugPrint('Transit Chart API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Transit Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating transit chart: $e');
      }
      return null;
    }
  }

  /// Generate Chart for any division (d2, d3, d4, d6, d7, d8, d10, d12, d16, d20, d24, d27, d30, d40, d45, d60)
  Future<Map<String, dynamic>?> generateDivisionChart({
    required String division, // e.g., 'd2', 'd3', 'd4', etc.
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    bool coloredPlanets = true,
    String color = '#ed6f30', // Orange color for SVG
  }) async {
    try {
      // Build query parameters
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': encodedColor,
      };

      // Map division to endpoint (D2 removed)
      String endpoint;
      switch (division.toUpperCase()) {
        case 'D3':
          endpoint = EndPoints.chartD3;
          break;
        case 'D4':
          endpoint = EndPoints.chartD4;
          break;
        case 'D6':
          endpoint = EndPoints.chartD6;
          break;
        case 'D7':
          endpoint = EndPoints.chartD7;
          break;
        case 'D8':
          endpoint = EndPoints.chartD8;
          break;
        case 'D10':
          endpoint = EndPoints.chartD10;
          break;
        case 'D12':
          endpoint = EndPoints.chartD12;
          break;
        case 'D16':
          endpoint = EndPoints.chartD16;
          break;
        case 'D20':
          endpoint = EndPoints.chartD20;
          break;
        case 'D24':
          endpoint = EndPoints.chartD24;
          break;
        case 'D27':
          endpoint = EndPoints.chartD27;
          break;
        case 'D30':
          endpoint = EndPoints.chartD30;
          break;
        case 'D40':
          endpoint = EndPoints.chartD40;
          break;
        case 'D45':
          endpoint = EndPoints.chartD45;
          break;
        case 'D60':
          endpoint = EndPoints.chartD60;
          break;
        default:
          if (kDebugMode) {
            debugPrint('Invalid division: $division');
          }
          return null;
      }

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_kundliBaseUrl/$endpoint',
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
        debugPrint('$division Chart API URL: ${uri.toString()}');
        debugPrint('$division Chart API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            '$division Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error generating $division chart: $e');
      }
      return null;
    }
  }

  /// Get Current Mahadasha Full Data
  Future<Map<String, dynamic>?> getCurrentMahadashaFull({
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

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.currentMahadashaFull}',
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
        debugPrint('Current Mahadasha Full API URL: ${uri.toString()}');
        debugPrint('Current Mahadasha Full API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Current Mahadasha Full API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching current mahadasha full: $e');
      }
      return null;
    }
  }

  /// Get Current Mahadasha
  Future<Map<String, dynamic>?> getCurrentMahadasha({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.currentMahadasha}',
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
        debugPrint('Current Mahadasha API URL: ${uri.toString()}');
        debugPrint('Current Mahadasha API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Current Mahadasha API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching current mahadasha: $e');
      }
      return null;
    }
  }

  /// Get Mahadasha
  Future<Map<String, dynamic>?> getMahadasha({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.mahadasha}',
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
        debugPrint('Mahadasha API URL: ${uri.toString()}');
        debugPrint('Mahadasha API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Mahadasha API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching mahadasha: $e');
      }
      return null;
    }
  }

  /// Get Yogini Dasha Main
  Future<Map<String, dynamic>?> getYoginiDashaMain({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.yoginiDashaMain}',
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
        debugPrint('Yogini Dasha Main API URL: ${uri.toString()}');
        debugPrint('Yogini Dasha Main API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Yogini Dasha Main API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching yogini dasha main: $e');
      }
      return null;
    }
  }

  /// Get Yogini Dasha Sub
  Future<Map<String, dynamic>?> getYoginiDashaSub({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.yoginiDashaSub}',
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
        debugPrint('Yogini Dasha Sub API URL: ${uri.toString()}');
        debugPrint('Yogini Dasha Sub API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Yogini Dasha Sub API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching yogini dasha sub: $e');
      }
      return null;
    }
  }

  /// Get Mangal Dosh (Classical Vedic Astrology)
  Future<Map<String, dynamic>?> getMangalDosh({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.mangalDosh}',
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
        debugPrint('Mangal Dosh API URL: ${uri.toString()}');
        debugPrint('Mangal Dosh API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Mangal Dosh API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching mangal dosh: $e');
      }
      return null;
    }
  }

  /// Get Manglik Dosh (Extended/Modern Manglik Analysis)
  Future<Map<String, dynamic>?> getManglikDosh({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.manglikDosh}',
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
        debugPrint('Manglik Dosh API URL: ${uri.toString()}');
        debugPrint('Manglik Dosh API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Manglik Dosh API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching manglik dosh: $e');
      }
      return null;
    }
  }

  /// Get Kaalsarp Dosh
  Future<Map<String, dynamic>?> getKaalsarpDosh({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.kaalsarpDosh}',
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
        debugPrint('Kaalsarp Dosh API URL: ${uri.toString()}');
        debugPrint('Kaalsarp Dosh API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Kaalsarp Dosh API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching kaalsarp dosh: $e');
      }
      return null;
    }
  }

  /// Get Pitra Dosh
  Future<Map<String, dynamic>?> getPitraDosh({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.pitraDosh}',
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
        debugPrint('Pitra Dosh API URL: ${uri.toString()}');
        debugPrint('Pitra Dosh API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Pitra Dosh API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching pitra dosh: $e');
      }
      return null;
    }
  }

  /// Get KP Chart
  Future<Map<String, dynamic>?> getKpChart({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
    String style = 'north',
    bool coloredPlanets = true,
    String color = '#ed6f30', // Double URL encoded: %25 = %, %23 = #
  }) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': color,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.kpChart}',
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
        debugPrint('KP Chart API URL: ${uri.toString()}');
        debugPrint('KP Chart API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP chart: $e');
      }
      return null;
    }
  }

  /// Get KP Rasi Chart
  Future<Map<String, dynamic>?> getKpRasiChart({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
    String style = 'north',
    bool coloredPlanets = false,
    String color = '#ed6f30', // Double URL encoded: %25 = %, %23 = #
  }) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': color,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.kpRasiChart}',
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
        debugPrint('KP Rasi Chart API URL: ${uri.toString()}');
        debugPrint('KP Rasi Chart API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP Rasi Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP Rasi chart: $e');
      }
      return null;
    }
  }

  /// Get KP Planet Details
  Future<Map<String, dynamic>?> getKpPlanetDetails({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.kpPlanetDetails}',
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
        debugPrint('KP Planet Details API URL: ${uri.toString()}');
        debugPrint('KP Planet Details API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP Planet Details API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP planet details: $e');
      }
      return null;
    }
  }

  /// Get KP Planet Significations
  Future<Map<String, dynamic>?> getKpPlanetSignifications({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.kpPlanetSignifications}',
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
        debugPrint('KP Planet Significations API URL: ${uri.toString()}');
        debugPrint(
          'KP Planet Significations API Status: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP Planet Significations API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP planet significations: $e');
      }
      return null;
    }
  }

  /// Get KP House Significators
  Future<Map<String, dynamic>?> getKpHouseSignificators({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.kpHouseSignificators}',
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
        debugPrint('KP House Significators API URL: ${uri.toString()}');
        debugPrint('KP House Significators API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP House Significators API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP house significators: $e');
      }
      return null;
    }
  }

  /// Get KP Planet Significators Level Wise
  Future<Map<String, dynamic>?> getKpPlanetSignificatorsLevelWise({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.kpPlanetSignificatorsLevelWise}',
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
        debugPrint(
          'KP Planet Significators Level Wise API URL: ${uri.toString()}',
        );
        debugPrint(
          'KP Planet Significators Level Wise API Status: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP Planet Significators Level Wise API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP planet significators level wise: $e');
      }
      return null;
    }
  }

  /// Get KP Cusps Details
  Future<Map<String, dynamic>?> getKpCuspsDetails({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.kpCuspsDetails}',
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
        debugPrint('KP Cusps Details API URL: ${uri.toString()}');
        debugPrint('KP Cusps Details API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'KP Cusps Details API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching KP cusps details: $e');
      }
      return null;
    }
  }

  /// Get Lal Kitab Horoscope
  Future<Map<String, dynamic>?> getLalKitabHoroscope({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.lalKitabHoroscope}',
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
        debugPrint('Lal Kitab Horoscope API URL: ${uri.toString()}');
        debugPrint('Lal Kitab Horoscope API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Horoscope API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab horoscope: $e');
      }
      return null;
    }
  }

  /// Get Lal Kitab Debts
  Future<Map<String, dynamic>?> getLalKitabDebts({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.lalKitabDebts}',
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
        debugPrint('Lal Kitab Debts API URL: ${uri.toString()}');
        debugPrint('Lal Kitab Debts API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Debts API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab debts: $e');
      }
      return null;
    }
  }

  /// Get Lal Kitab Remedies
  Future<Map<String, dynamic>?> getLalKitabRemedies({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.lalKitabRemedies}',
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
        debugPrint('Lal Kitab Remedies API URL: ${uri.toString()}');
        debugPrint('Lal Kitab Remedies API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Remedies API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab remedies: $e');
      }
      return null;
    }
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
        '$_kundliBaseUrl/${EndPoints.currentSadeSati}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching current sade sati: $e');
      return null;
    }
  }

  /// Get Sade Sati Table (Vedic)
  Future<Map<String, dynamic>?> getSadeSatiTableVedic({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.sadeSatiTableVedic}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching sade sati table: $e');
      return null;
    }
  }

  /// Get Gem Suggestion (personalized)
  Future<Map<String, dynamic>?> getGemSuggestion({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.gemSuggestion}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching gem suggestion: $e');
      return null;
    }
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
        '$_kundliBaseUrl/${EndPoints.rudrakshSuggestion}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching rudraksh suggestion: $e');
      return null;
    }
  }

  /// Get Gem Details (generic gem info)
  Future<Map<String, dynamic>?> getGemDetails({
    required String gem,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{'gem': gem, 'lang': lang};
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.gemDetails}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching gem details: $e');
      return null;
    }
  }

  /// Get Lal Kitab Houses
  Future<Map<String, dynamic>?> getLalKitabHouses({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.lalKitabHouses}',
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
        debugPrint('Lal Kitab Houses API URL: ${uri.toString()}');
        debugPrint('Lal Kitab Houses API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Houses API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab houses: $e');
      }
      return null;
    }
  }

  /// Get Lal Kitab Planets
  Future<Map<String, dynamic>?> getLalKitabPlanets({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.lalKitabPlanets}',
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
        debugPrint('Lal Kitab Planets API URL: ${uri.toString()}');
        debugPrint('Lal Kitab Planets API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Planets API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab planets: $e');
      }
      return null;
    }
  }

  /// Get Lal Kitab Chart
  Future<Map<String, dynamic>?> getLalKitabChart({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    String lang = 'en',
    String style = 'north',
    bool coloredPlanets = true,
    String color = '#ed6f30',
  }) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': color,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.lalKitabChart}',
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
        debugPrint('Lal Kitab Chart API URL: ${uri.toString()}');
        debugPrint('Lal Kitab Chart API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab chart: $e');
      }
      return null;
    }
  }

  /// Get Lal Kitab Varshphal Chart
  Future<Map<String, dynamic>?> getLalKitabVarshphalChart({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
    required String varshphalDate,
    String lang = 'en',
    String style = 'north',
    bool coloredPlanets = true,
    String color = '#ed6f30',
  }) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'varshphal_date': varshphalDate,
        'lang': lang,
        'style': style,
        'colored_planets': coloredPlanets.toString(),
        'color': color,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.lalKitabVarshphalChart}',
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
        debugPrint('Lal Kitab Varshphal Chart API URL: ${uri.toString()}');
        debugPrint(
          'Lal Kitab Varshphal Chart API Status: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Lal Kitab Varshphal Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        // Throw exception with error details for better error handling
        final errorBody = response.body;
        throw Exception('API Error ${response.statusCode}: $errorBody');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Lal Kitab Varshphal chart: $e');
      }
      return null;
    }
  }

  /// Get Numerology Prediction (date format: dd-mm-yyyy)
  Future<Map<String, dynamic>?> getNumerologyPrediction({
    required String date,
    required String name,
    String lang = 'en',
  }) async {
    try {
      final dateFormatted = date.contains('/')
          ? date.replaceAll('/', '-')
          : date;
      final queryParams = <String, String>{
        'date': dateFormatted,
        'name': name,
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.predictionNumerology}',
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
        debugPrint('Numerology Prediction API URL: ${uri.toString()}');
        debugPrint('Numerology Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Numerology Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Numerology Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Daily Prediction
  Future<Map<String, dynamic>?> getDailyPrediction({
    required int zodiac,
    String day = 'today',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'zodiac': zodiac.toString(),
        'day': day,
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.predictionDaily}',
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
        debugPrint('Daily Prediction API URL: ${uri.toString()}');
        debugPrint('Daily Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Daily Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Daily Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Weekly Prediction
  Future<Map<String, dynamic>?> getWeeklyPrediction({
    required int zodiac,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'zodiac': zodiac.toString(),
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.predictionWeekly}',
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
        debugPrint('Weekly Prediction API URL: ${uri.toString()}');
        debugPrint('Weekly Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Weekly Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Weekly Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Monthly Prediction
  Future<Map<String, dynamic>?> getMonthlyPrediction({
    required int zodiac,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'zodiac': zodiac.toString(),
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.predictionMonthly}',
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
        debugPrint('Monthly Prediction API URL: ${uri.toString()}');
        debugPrint('Monthly Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Monthly Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Monthly Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Yearly Prediction
  Future<Map<String, dynamic>?> getYearlyPrediction({
    required int zodiac,
    required int year,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'zodiac': zodiac.toString(),
        'year': year.toString(),
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.predictionYearly}',
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
        debugPrint('Yearly Prediction API URL: ${uri.toString()}');
        debugPrint('Yearly Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Yearly Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Yearly Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Ascendant Prediction
  Future<Map<String, dynamic>?> getAscendantPrediction({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.predictionAscendant}',
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
        debugPrint('Ascendant Prediction API URL: ${uri.toString()}');
        debugPrint('Ascendant Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Ascendant Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Ascendant Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Moon Sign Prediction
  Future<Map<String, dynamic>?> getMoonSignPrediction({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.predictionMoon}',
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
        debugPrint('Moon Sign Prediction API URL: ${uri.toString()}');
        debugPrint('Moon Sign Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Moon Sign Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Moon Sign Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Nakshatra Prediction
  Future<Map<String, dynamic>?> getNakshatraPrediction({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.predictionNakshatra}',
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
        debugPrint('Nakshatra Prediction API URL: ${uri.toString()}');
        debugPrint('Nakshatra Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Nakshatra Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Nakshatra Prediction: $e');
      }
      rethrow;
    }
  }

  /// Get Panchang Prediction
  Future<Map<String, dynamic>?> getPanchangPrediction({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.predictionPanchang}',
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
        debugPrint('Panchang Prediction API URL: ${uri.toString()}');
        debugPrint('Panchang Prediction API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Panchang Prediction API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Panchang Prediction: $e');
      }
      rethrow;
    }
  }

  /// Prokerala Daily Horoscope (sign: aries, taurus, etc.)
  Future<Map<String, dynamic>?> getProkeralaDaily({
    required String datetime,
    required String sign,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'datetime': datetime,
        'sign': sign,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.prokeralaDaily}',
      ).replace(queryParameters: queryParams);
      final currentToken = UserData().accessToken?.trim();
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error Prokerala daily: $e');
      return null;
    }
  }

  /// Prokerala Advanced Daily Horoscope
  Future<Map<String, dynamic>?> getProkeralaDailyAdvanced({
    required String datetime,
    required String sign,
    String type = 'all',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'datetime': datetime,
        'sign': sign,
        'type': type,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.prokeralaDailyAdvanced}',
      ).replace(queryParameters: queryParams);
      final currentToken = UserData().accessToken?.trim();
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error Prokerala daily advanced: $e');
      return null;
    }
  }

  /// Prokerala Love Compatibility
  Future<Map<String, dynamic>?> getProkeralaLoveCompatibility({
    required String datetime,
    required String signOne,
    required String signTwo,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'datetime': datetime,
        'sign_one': signOne,
        'sign_two': signTwo,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.prokeralaLoveCompatibility}',
      ).replace(queryParameters: queryParams);
      final currentToken = UserData().accessToken?.trim();
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error Prokerala love compatibility: $e');
      return null;
    }
  }

  /// Get Planet Details
  Future<Map<String, dynamic>?> getPlanetDetails({
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
        '$_kundliBaseUrl/${EndPoints.planetDetails}',
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
        debugPrint('Planet Details API URL: ${uri.toString()}');
        debugPrint('Planet Details API Status: ${response.statusCode}');
        debugPrint('Planet Details API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Planet Details API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Planet Details: $e');
      }
      return null;
    }
  }

  /// Get Planet Transit Dates
  Future<Map<String, dynamic>?> getPlanetTransitDates({
    required String planet,
    required int year,
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'planet': planet,
        'year': year.toString(),
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.planetTransitDates}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching planet transit dates: $e');
      return null;
    }
  }

  /// Get Detailed Planet Report (house + zodiac content)
  Future<Map<String, dynamic>?> getDetailedPlanetReport({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    required double tz,
    required String planet,
    String houseType = 'placidus',
    String zodiacType = 'sidereal',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'dob': dob,
        'tob': tob,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'tz': tz.toString(),
        'planet': planet,
        'house_type': houseType,
        'zodiac_type': zodiacType,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.detailedPlanetReport}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching detailed planet report: $e');
      return null;
    }
  }

  /// Get Western Planet Details
  Future<Map<String, dynamic>?> getWesternPlanetDetails({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    required double tz,
    String houseType = 'placidus',
    String zodiacType = 'sidereal',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'dob': dob,
        'tob': tob,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'tz': tz.toString(),
        'house_type': houseType,
        'zodiac_type': zodiacType,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.westernPlanetDetails}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching western planet details: $e');
      return null;
    }
  }

  /// Get Aspects (conjunction, opposition, trine, square, etc.)
  Future<Map<String, dynamic>?> getAspects({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    required double tz,
    String houseType = 'placidus',
    String zodiacType = 'sidereal',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'dob': dob,
        'tob': tob,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'tz': tz.toString(),
        'house_type': houseType,
        'zodiac_type': zodiacType,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.aspects}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching aspects: $e');
      return null;
    }
  }

  /// Western Transit Chart (returns SVG string)
  Future<String?> getWesternTransitChart({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    required double tz,
    required String transitDate,
    required String transitTime,
    required double transitLat,
    required double transitLon,
    required double transitTz,
    String houseType = 'placidus',
    String zodiacType = 'sidereal',
    String lang = 'en',
    int size = 400,
    String format = 'svg',
    String natalColor = '%2300ced1',
  }) async {
    try {
      final queryParams = <String, String>{
        'dob': dob,
        'tob': tob,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'tz': tz.toString(),
        'transit_date': transitDate,
        'transit_time': transitTime,
        'transit_lat': transitLat.toString(),
        'transit_lon': transitLon.toString(),
        'transit_tz': transitTz.toString(),
        'house_type': houseType,
        'zodiac_type': zodiacType,
        'lang': lang,
        'size': size.toString(),
        'format': format,
        'natal_color': natalColor,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.westernTransitChart}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        final body = response.body.trim();
        try {
          final decoded = json.decode(body);
          if (decoded is String) return decoded;
          if (decoded is Map && decoded['response'] != null)
            return decoded['response'] as String?;
          if (decoded is Map && decoded['data'] != null)
            return decoded['data'] as String?;
        } catch (_) {}
        if (body.startsWith('<svg')) return body;
        return body;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching western transit chart: $e');
      return null;
    }
  }

  /// Daily Transits (transit events for a date/planet)
  Future<Map<String, dynamic>?> getDailyTransits({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    required double tz,
    required String startDate,
    required String planet,
    String houseType = 'placidus',
    String zodiacType = 'sidereal',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'dob': dob,
        'tob': tob,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'tz': tz.toString(),
        'start_date': startDate,
        'planet': planet,
        'house_type': houseType,
        'zodiac_type': zodiacType,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.dailyTransits}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching daily transits: $e');
      return null;
    }
  }

  /// Daily Transit Prediction (scores for physique, health, etc.)
  Future<Map<String, dynamic>?> getDailyTransitPrediction({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    required double tz,
    required String transitDate,
    required String transitTime,
    required double transitLat,
    required double transitLon,
    required double transitTz,
    String houseType = 'placidus',
    String zodiacType = 'sidereal',
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'dob': dob,
        'tob': tob,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'tz': tz.toString(),
        'transit_date': transitDate,
        'transit_time': transitTime,
        'transit_lat': transitLat.toString(),
        'transit_lon': transitLon.toString(),
        'transit_tz': transitTz.toString(),
        'house_type': houseType,
        'zodiac_type': zodiacType,
        'lang': lang,
      };
      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.dailyTransitPrediction}',
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
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200)
        return json.decode(response.body) as Map<String, dynamic>;
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching daily transit prediction: $e');
      return null;
    }
  }

  /// Get Ashtakvarga
  Future<Map<String, dynamic>?> getAshtakvarga({
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
        '$_kundliBaseUrl/${EndPoints.ashtakvarga}',
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
        debugPrint('Ashtakvarga API URL: ${uri.toString()}');
        debugPrint('Ashtakvarga API Status: ${response.statusCode}');
        debugPrint('Ashtakvarga API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Ashtakvarga API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Ashtakvarga: $e');
      }
      return null;
    }
  }

  /// Get Binnashtakvarga
  Future<Map<String, dynamic>?> getBinnashtakvarga({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    required String
    planet, // Planet name (e.g., "Jupiter", "Sun", "Moon", etc.)
    String lang = 'en',
  }) async {
    try {
      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'planet': planet,
        'lang': lang,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.binnashtakvarga}',
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
        debugPrint('Binnashtakvarga API URL: ${uri.toString()}');
        debugPrint('Binnashtakvarga API Status: ${response.statusCode}');
        debugPrint('Binnashtakvarga API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Binnashtakvarga API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Binnashtakvarga: $e');
      }
      return null;
    }
  }

  /// Get Ashtakvarga Chart (SVG)
  Future<Map<String, dynamic>?> getAshtakvargaChart({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    String lang = 'en',
    String style = 'north', // north, south, east
    String color = '#ed6f30', // Color for SVG
  }) async {
    try {
      // Ensure color starts with #
      final encodedColor = color.startsWith('#') ? color : '#$color';

      final queryParams = <String, String>{
        'date': date,
        'time': time,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'tz': tz.toString(),
        'lang': lang,
        'style': style,
        'color': encodedColor,
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.ashtakvargaChart}',
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
        debugPrint('Ashtakvarga Chart API URL: ${uri.toString()}');
        debugPrint('Ashtakvarga Chart API Status: ${response.statusCode}');
        debugPrint('Ashtakvarga Chart API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        // The API returns the SVG as a JSON-encoded string (wrapped in quotes)
        final responseBody = response.body.trim();
        try {
          // Try to decode as JSON - it might be a string or an object
          final decoded = json.decode(responseBody);

          if (decoded is String) {
            // Direct SVG string
            return {'data': decoded};
          } else if (decoded is Map<String, dynamic>) {
            // JSON object - check for common fields
            return decoded;
          } else {
            // Fallback: treat as string
            return {'data': responseBody};
          }
        } catch (e) {
          // If JSON decode fails, treat as direct SVG string
          if (kDebugMode) {
            debugPrint('Response is not JSON, treating as direct SVG string');
          }
          return {'data': responseBody};
        }
      } else {
        if (kDebugMode) {
          debugPrint(
            'Ashtakvarga Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Ashtakvarga Chart: $e');
      }
      return null;
    }
  }

  /// Get Divisional Chart data
  Future<Map<String, dynamic>?> getDivisionalChart({
    required String date, // Format: dd/mm/yyyy
    required String time, // Format: HH:mm
    required double latitude,
    required double longitude,
    required double tz, // Timezone offset
    required String division, // e.g., "D1", "D2", "D9", etc.
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
        'division': division, // e.g., "D9"
      };

      final uri = Uri.parse(
        '$_kundliBaseUrl/${EndPoints.divisionalChart}',
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
        debugPrint('Divisional Chart API URL: ${uri.toString()}');
        debugPrint('Divisional Chart API Status: ${response.statusCode}');
        debugPrint('Divisional Chart API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Divisional Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Divisional Chart: $e');
      }
      return null;
    }
  }

  /// Get Ascendant Report
  Future<Map<String, dynamic>?> getAscendantReport({
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
        '$_kundliBaseUrl/${EndPoints.ascendantReport}',
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
        debugPrint('Ascendant Report API URL: ${uri.toString()}');
        debugPrint('Ascendant Report API Status: ${response.statusCode}');
        debugPrint('Ascendant Report API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Ascendant Report API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Ascendant Report: $e');
      }
      return null;
    }
  }

  /// Get Varshphal Details
  Future<Map<String, dynamic>?> getVarshphalDetails({
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
        '$_kundliBaseUrl/${EndPoints.varshaphalDetails}',
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
        debugPrint('Varshphal Details API URL: ${uri.toString()}');
        debugPrint('Varshphal Details API Status: ${response.statusCode}');
        debugPrint('Varshphal Details API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Varshphal Details API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Varshphal Details: $e');
      }
      return null;
    }
  }

  /// Get Varshphal Yearly Chart
  Future<Map<String, dynamic>?> getVarshphalYearlyChart({
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
        '$_kundliBaseUrl/${EndPoints.varshaphalYearlyChart}',
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
        debugPrint('Varshphal Yearly Chart API URL: ${uri.toString()}');
        debugPrint('Varshphal Yearly Chart API Status: ${response.statusCode}');
        debugPrint('Varshphal Yearly Chart API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Varshphal Yearly Chart API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Varshphal Yearly Chart: $e');
      }
      return null;
    }
  }

  /// Get Shad Bala (Vedic)
  Future<Map<String, dynamic>?> getShadBalaVedic({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.shadBalaVedic}',
      ).replace(queryParameters: queryParams);
      final currentToken = UserData().accessToken?.trim();
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      if (kDebugMode) {
        debugPrint(
          'Shad Bala API Error: ${response.statusCode} - ${response.body}',
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching Shad Bala: $e');
      return null;
    }
  }

  /// Get Avkahada Chakra (for Nakshatra)
  Future<Map<String, dynamic>?> getAvkahadaChakra({
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required double tz,
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
        '$_kundliBaseUrl/${EndPoints.avkahadaChakra}',
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
        debugPrint('Avkahada Chakra API URL: ${uri.toString()}');
        debugPrint('Avkahada Chakra API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Avkahada API Error: ${response.statusCode} - ${response.body}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching Avkahada Chakra: $e');
      }
      return null;
    }
  }
}
