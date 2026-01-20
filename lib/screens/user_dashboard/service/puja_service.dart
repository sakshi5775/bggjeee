import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PujaService {
  /// Base URL for Pujas API
  static const String _baseUrl = 'http://3.109.91.254:8005/api';

  /// Get all pujas with filters
  Future<PujaResponse?> getPujas({
    int page = 1,
    int limit = 10,
    String? search,
    String? templeId,
    bool? featured,
    bool? popular,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (templeId != null && templeId.isNotEmpty) {
        queryParams['templeId'] = templeId;
      }

      // Only add featured filter if explicitly provided (not null)
      if (featured != null) {
        queryParams['featured'] = featured.toString();
      }

      // Only add popular filter if explicitly provided (not null)
      if (popular != null) {
        queryParams['popular'] = popular.toString();
      }

      final uri = Uri.parse('$_baseUrl/pujas').replace(queryParameters: queryParams);

      final currentToken = UserData().accessToken?.trim();

      if (kDebugMode) {
        debugPrint('Puja API URL: ${uri.toString()}');
      }

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          if (currentToken != null && currentToken.isNotEmpty)
            'Authorization': 'Bearer $currentToken',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (kDebugMode) {
        debugPrint('Puja API Status: ${response.statusCode}');
        debugPrint('Puja API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (kDebugMode) {
          debugPrint('Puja API Response Data: $jsonData');
        }
        
        try {
          final pujaResponse = PujaResponse.fromJson(jsonData);
          
          if (kDebugMode) {
            debugPrint('Puja Response Success: ${pujaResponse.success}');
            debugPrint('Puja Items Count: ${pujaResponse.data?.items?.length ?? 0}');
          }
          
          return pujaResponse;
        } catch (e, stackTrace) {
          if (kDebugMode) {
            debugPrint('Error parsing PujaResponse: $e');
            debugPrint('Stack trace: $stackTrace');
            debugPrint('Response body: ${response.body}');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          debugPrint('Puja API Error: ${response.statusCode} - ${response.body}');
        }
        return null;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Error fetching pujas: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      return null;
    }
  }
}
