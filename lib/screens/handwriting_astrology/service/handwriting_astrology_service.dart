import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/handwriting_astrology_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HandwritingAstrologyService {
  final ApiRepository _apiRepository = Get.find();

  /// Make handwriting analysis request using base URL from ApiClient
  Future<http.Response> _makeHandwritingRequest({
    required Map<String, String> fields,
    required List<File> files,
    Duration? timeout,
  }) async {
    // Get base URL from ApiClient (baseUrl already includes trailing slash)
    final baseUrl =
        _apiRepository.apiClient.baseUrl ?? 'https://api.astrobharatai.com/api/';
    final endpoint = EndPoints.handwritingAnalyze;
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', url);

    // Add authorization header
    final currentToken = UserData().accessToken?.trim();
    if (currentToken != null && currentToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $currentToken';
    }

    // Add form fields
    request.fields.addAll(fields);

    // Add files - API expects multiple files with the same field name 'handwritingImages'
    for (var file in files) {
      final fileName = file.path.split('/').last.toLowerCase();
      String? contentType;

      if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (fileName.endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (fileName.endsWith('.webp')) {
        contentType = 'image/webp';
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'handwritingImages',
          file.path,
          filename: file.path.split('/').last,
          contentType: contentType != null
              ? MediaType.parse(contentType)
              : null,
        ),
      );
    }

    final streamedResponse = await request.send().timeout(
      timeout ?? const Duration(minutes: 5),
    );
    return http.Response.fromStream(streamedResponse);
  }

  /// Analyze handwriting with image and optional user data
  Future<HandwritingData> analyzeHandwriting({
    required List<File> handwritingImages,
    String? name,
    String? dateOfBirth,
    String? gender,
    String? language,
    String? additionalNotes,
    Duration? timeout,
  }) async {
    try {
      // Prepare form fields
      final Map<String, String> fields = {};
      if (name != null && name.isNotEmpty) {
        fields['name'] = name;
      }
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        fields['dateOfBirth'] = dateOfBirth;
      }
      if (gender != null && gender.isNotEmpty) {
        fields['gender'] = gender;
      }
      if (language != null && language.isNotEmpty) {
        fields['language'] = language;
      }
      if (additionalNotes != null && additionalNotes.isNotEmpty) {
        fields['additionalNotes'] = additionalNotes;
      }

      // Make API call
      final response = await _makeHandwritingRequest(
        fields: fields,
        files: handwritingImages,
        timeout: timeout,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);

        final handwritingResponse = HandwritingResponse.fromJson(jsonData);

        if (handwritingResponse.success && handwritingResponse.data != null) {
          return handwritingResponse.data!;
        } else {
          throw Exception(
            handwritingResponse.message.isNotEmpty
                ? handwritingResponse.message
                : 'Handwriting analysis failed',
          );
        }
      } else {
        throw Exception(
          'Failed to analyze handwriting: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } on TimeoutException {
      throw Exception(
        'Request timeout. The server took too long to respond. Please try again.',
      );
    } on http.ClientException catch (e) {
      if (e.message.contains('Connection closed') ||
          e.toString().contains('Connection closed')) {
        throw Exception(
          'Connection error. The server closed the connection. Please try again with a smaller image or check your internet connection.',
        );
      }
      throw Exception('Network error: ${e.message}. Please try again.');
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('Connection closed')) {
        throw Exception(
          'Connection error. Please try again with a smaller image or check your internet connection.',
        );
      } else if (errorMessage.contains('timeout') ||
          errorMessage.contains('Timeout')) {
        throw Exception('Request timeout. Please try again.');
      } else if (errorMessage.contains('SocketException') ||
          errorMessage.contains('network')) {
        throw Exception(
          'Network error. Please check your internet connection and try again.',
        );
      }
      throw Exception('Error analyzing handwriting: ${e.toString()}');
    }
  }

  /// Get handwriting history
  Future<HandwritingHistoryResponse> getHandwritingHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.handwritingHistory,
        query: {'page': page.toString(), 'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return HandwritingHistoryResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to get handwriting history: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting handwriting history: ${e.toString()}');
    }
  }

  /// Get handwriting by ID
  Future<HandwritingData> getHandwritingById(String readingId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.handwritingGetById(readingId),
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final handwritingResponse = HandwritingResponse.fromJson(jsonData);

        if (handwritingResponse.success && handwritingResponse.data != null) {
          return handwritingResponse.data!;
        } else {
          throw Exception(
            handwritingResponse.message.isNotEmpty
                ? handwritingResponse.message
                : 'Handwriting reading not found',
          );
        }
      } else {
        throw Exception(
          'Failed to get handwriting reading: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting handwriting reading: ${e.toString()}');
    }
  }

  /// Delete handwriting by ID
  Future<bool> deleteHandwriting(String readingId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.handwritingDeleteById(readingId),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        try {
          final jsonData = response.body;
          if (jsonData != null && jsonData.toString().isNotEmpty) {
            final result = json.decode(jsonData.toString());
            return result['success'] == true || result['success'] == null;
          }
          // If response body is empty but status is 200, consider it successful
          return true;
        } catch (e) {
          // If parsing fails but status is 200, consider it successful
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      // Check if it's a NOT_FOUND error (item already deleted)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('not_found') ||
          errorString.contains('not found') ||
          errorString.contains('404')) {
        return true; // Consider it successful if already deleted
      }
      return false;
    }
  }
}
