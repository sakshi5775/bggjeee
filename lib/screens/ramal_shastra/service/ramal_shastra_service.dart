import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/ramal_shastra_model.dart';
import 'package:http/http.dart' as http;

class RamalShastraService {
  static const String baseUrl = 'https://api.astrobharatai.com';

  /// Analyze Ramal Shastra with question and points
  Future<RamalShastraData> analyzeRamalShastra({
    required String question,
    required List<int> points,
    required String category,
    String? language,
    String? name,
    String? dateOfBirth,
    Duration? timeout,
  }) async {
    try {
      // Backend expects: /api/users/api/users/ramal/analyze
      final url = Uri.parse('$baseUrl/api/users/api/users/ramal/analyze');

      final requestBody = {
        'question': question,
        'points': points,
        'category': category,
        if (language != null && language.isNotEmpty) 'language': language,
        if (name != null && name.isNotEmpty) 'name': name,
        if (dateOfBirth != null && dateOfBirth.isNotEmpty)
          'dateOfBirth': dateOfBirth,
      };

      final currentToken = UserData().accessToken?.trim();

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'accept': 'application/json',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
            },
            body: json.encode(requestBody),
          )
          .timeout(timeout ?? const Duration(minutes: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonData = json.decode(response.body);
          final ramalResponse = RamalShastraResponse.fromJson(jsonData);

          if (ramalResponse.success && ramalResponse.data != null) {
            return ramalResponse.data!;
          } else {
            final errorMsg = ramalResponse.message.isNotEmpty
                ? ramalResponse.message
                : 'Ramal Shastra analysis failed';
            throw Exception(errorMsg);
          }
        } catch (parseError) {
          // If parsing fails, show response body for debugging
          throw Exception(
            'Failed to parse response: ${parseError.toString()}\nResponse: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
          );
        }
      } else {
        // Try to parse error message from response
        String errorMsg =
            'Failed to analyze Ramal Shastra: ${response.statusCode}';
        try {
          final errorJson = json.decode(response.body);
          if (errorJson['message'] != null) {
            errorMsg = errorJson['message'];
          } else if (errorJson['error'] != null) {
            errorMsg = errorJson['error'];
          }
        } catch (_) {
          // If parsing fails, use default message
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      // If it's already an Exception, rethrow it
      if (e is Exception) {
        rethrow;
      }
      // Otherwise wrap it
      throw Exception('Error analyzing Ramal Shastra: ${e.toString()}');
    }
  }

  /// Get Ramal Shastra history
  Future<RamalHistoryResponse> getRamalHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/api/users/ramal/history')
          .replace(
            queryParameters: {
              'page': page.toString(),
              'limit': limit.toString(),
            },
          );
      final currentToken = UserData().accessToken?.trim();

      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          if (currentToken != null && currentToken.isNotEmpty)
            'Authorization': 'Bearer $currentToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Backend returns: {success: true, message: "...", data: [], pagination: {...}}
        // Handle case where data is a list directly
        if (jsonData is Map<String, dynamic>) {
          if (jsonData['data'] is List) {
            // Convert list to proper structure
            jsonData['data'] = {'readings': jsonData['data']};
          }
        }

        try {
          return RamalHistoryResponse.fromJson(
            jsonData as Map<String, dynamic>,
          );
        } catch (e) {
          throw Exception('Failed to parse history response: $e');
        }
      } else {
        String errorMsg =
            'Failed to get Ramal Shastra history: ${response.statusCode}';
        try {
          final errorJson = json.decode(response.body);
          if (errorJson['message'] != null) {
            errorMsg = errorJson['message'];
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception('Error getting Ramal Shastra history: ${e.toString()}');
    }
  }

  /// Get Ramal Shastra by ID
  Future<RamalShastraData> getRamalById(String readingId) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/api/users/ramal/$readingId');
      final currentToken = UserData().accessToken?.trim();

      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          if (currentToken != null && currentToken.isNotEmpty)
            'Authorization': 'Bearer $currentToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final ramalResponse = RamalShastraResponse.fromJson(jsonData);

        if (ramalResponse.success && ramalResponse.data != null) {
          return ramalResponse.data!;
        } else {
          throw Exception(
            ramalResponse.message.isNotEmpty
                ? ramalResponse.message
                : 'Ramal Shastra reading not found',
          );
        }
      } else {
        throw Exception('Failed to get Ramal Shastra: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting Ramal Shastra: ${e.toString()}');
    }
  }

  /// Delete Ramal Shastra by ID
  Future<bool> deleteRamal(String readingId) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/api/users/ramal/$readingId');
      final currentToken = UserData().accessToken?.trim();

      final response = await http.delete(
        url,
        headers: {
          'accept': '*/*',
          if (currentToken != null && currentToken.isNotEmpty)
            'Authorization': 'Bearer $currentToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['success'] == true;
      } else {
        throw Exception(
          'Failed to delete Ramal Shastra: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting Ramal Shastra: ${e.toString()}');
    }
  }

  /// Get Ramal Shastra statistics
  Future<RamalStatsData> getRamalStats() async {
    try {
      final url = Uri.parse('$baseUrl/api/users/api/users/ramal/stats');
      final currentToken = UserData().accessToken?.trim();

      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          if (currentToken != null && currentToken.isNotEmpty)
            'Authorization': 'Bearer $currentToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final statsResponse = RamalStatsResponse.fromJson(jsonData);

        if (statsResponse.success && statsResponse.data != null) {
          return statsResponse.data!;
        } else {
          throw Exception(
            statsResponse.message.isNotEmpty
                ? statsResponse.message
                : 'Failed to get statistics',
          );
        }
      } else {
        throw Exception(
          'Failed to get Ramal Shastra stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting Ramal Shastra stats: ${e.toString()}');
    }
  }
}
