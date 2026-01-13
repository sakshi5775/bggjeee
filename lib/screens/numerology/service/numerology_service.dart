import 'dart:convert';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NumerologyService {
  /// Base URL for numerology API (port 8010)
  static const String _numerologyBaseUrl =
      'http://3.109.91.254:8000/api/numerology/api';

  /// Get Lo Shu Grid data
  Future<Map<String, dynamic>?> getLoShuGrid({
    required String date, // Format: DD/MM/YYYY
    required String gender, // male or female
    String lang = 'en',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'date': date,
        'gender': gender,
        'lang': lang,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_numerologyBaseUrl/numerology/loshu-grid',
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
        debugPrint('Lo Shu Grid API URL: ${uri.toString()}');
        debugPrint('Lo Shu Grid API Status: ${response.statusCode}');
        debugPrint('Lo Shu Grid API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Lo Shu Grid API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Lo Shu Grid API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching Lo Shu Grid: $e');
      return null;
    }
  }

  /// Get Plane Details data
  Future<Map<String, dynamic>?> getPlaneDetails({
    required String date, // Format: DD/MM/YYYY
    required String gender, // male or female
    String lang = 'en',
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'date': date,
        'gender': gender,
        'lang': lang,
      };

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_numerologyBaseUrl/numerology/plane-details',
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
        debugPrint('Plane Details API URL: ${uri.toString()}');
        debugPrint('Plane Details API Status: ${response.statusCode}');
        debugPrint('Plane Details API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          return responseData?['data'] as Map<String, dynamic>?;
        } else {
          debugPrint('Plane Details API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Plane Details API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching Plane Details: $e');
      return null;
    }
  }

  /// Generic method to make numerology API calls
  Future<Map<String, dynamic>?> _makeNumerologyApiCall(
    String endpoint,
    Map<String, String> queryParams,
  ) async {
    try {
      final uri = Uri.parse(
        '$_numerologyBaseUrl/$endpoint',
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

  /// Number Analysis
  Future<Map<String, dynamic>?> getNumberAnalysis({
    required String name,
    required String date,
    required String phone,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.numberAnalysis, {
      'name': name,
      'date': date,
      'phone': phone,
      'lang': lang,
    });
  }

  /// Missing Numbers
  Future<Map<String, dynamic>?> getMissingNumbers({
    required String date,
    required String gender,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.missingNumbers, {
      'date': date,
      'gender': gender,
      'lang': lang,
    });
  }

  /// Available Numbers
  Future<Map<String, dynamic>?> getAvailableNumbers({
    required String date,
    required String gender,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.availableNumbers, {
      'date': date,
      'gender': gender,
      'lang': lang,
    });
  }

  /// Mobile Analysis
  Future<Map<String, dynamic>?> getMobileAnalysis({
    required String phone,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.mobileAnalysis, {
      'phone': phone,
      'lang': lang,
    });
  }

  /// Numerology Suggestion
  Future<Map<String, dynamic>?> getNumerologySuggestion({
    required String date,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.numerologySuggestion, {
      'date': date,
      'lang': lang,
    });
  }

  /// Name Analysis
  Future<Map<String, dynamic>?> getNameAnalysis({
    required String name,
    required String date,
    required String gender,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.nameAnalysis, {
      'name': name,
      'date': date,
      'gender': gender,
      'lang': lang,
    });
  }

  /// Vehicle Analysis
  Future<Map<String, dynamic>?> getVehicleAnalysis({
    required String vehicle,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.vehicleAnalysis, {
      'vehicle': vehicle,
      'lang': lang,
    });
  }

  /// Lucky Things
  Future<Map<String, dynamic>?> getLuckyThings({
    required String date,
    required String gender,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.luckyThings, {
      'date': date,
      'gender': gender,
      'lang': lang,
    });
  }

  /// Personal Year
  Future<Map<String, dynamic>?> getPersonalYear({
    required String date,
    required String gender,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.personalYear, {
      'date': date,
      'gender': gender,
      'lang': lang,
    });
  }

  /// Karmic Number
  Future<Map<String, dynamic>?> getKarmicNumber({
    required String date,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.karmicNumber, {
      'date': date,
      'lang': lang,
    });
  }

  /// Master Numbers
  Future<Map<String, dynamic>?> getMasterNumbers({
    required String date,
    String lang = 'en',
  }) async {
    return _makeNumerologyApiCall(EndPoints.masterNumbers, {
      'date': date,
      'lang': lang,
    });
  }

  /// Get Reports List
  Future<Map<String, dynamic>?> getReports({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      final uri = Uri.parse(
        '$_numerologyBaseUrl/numerology/reports',
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
        debugPrint('numerology/reports API URL: ${uri.toString()}');
        debugPrint('numerology/reports API Status: ${response.statusCode}');
        debugPrint('numerology/reports API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData?['success'] == true) {
          // API returns: {success: true, data: [...], pagination: {...}}
          // Return the whole responseData so controller can access both data and pagination
          return responseData;
        } else {
          debugPrint('Reports API error: ${responseData?['message']}');
        }
      } else {
        debugPrint(
          'Reports API error: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching Reports: $e');
      return null;
    }
  }

  /// Get Report by ID
  Future<Map<String, dynamic>?> getReportById(String reportId) async {
    return _makeNumerologyApiCall(EndPoints.numerologyReportById(reportId), {});
  }
}
