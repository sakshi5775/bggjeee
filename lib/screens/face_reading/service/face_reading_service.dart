import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FaceReadingService {
  final ApiRepository _apiRepository = Get.find();

  /// Make face reading request to port 8002 (temporary endpoint)
  Future<http.Response> _makeFaceReadingRequest({
    required Map<String, String> fields,
    required Map<String, File?> files,
  }) async {
    // Using port 8002 temporarily
    final url = Uri.parse(
      'http://3.109.91.254:8002/api/users/face-reading/analyze',
    );
    final request = http.MultipartRequest('POST', url);

    // Add authorization header
    final currentToken = UserData().accessToken?.trim();
    if (currentToken != null && currentToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $currentToken';
    }

    // Add form fields
    request.fields.addAll(fields);

    // Add files
    for (var entry in files.entries) {
      final file = entry.value;
      if (file != null) {
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
            entry.key,
            file.path,
            filename: file.path.split('/').last,
            contentType: contentType != null
                ? MediaType.parse(contentType)
                : null,
          ),
        );
      }
    }

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  /// Analyze face reading with image and optional user data
  ///
  /// Required: faceImage (File)
  /// Optional: name, dateOfBirth, gender, age, language
  Future<FaceReadingData> analyzeFaceReading({
    required File faceImage,
    String? name,
    String? dateOfBirth,
    String? gender,
    int? age,
    String? language,
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
      if (age != null) {
        fields['age'] = age.toString();
      }
      if (language != null && language.isNotEmpty) {
        fields['language'] = language;
      }

      // Prepare files
      final Map<String, File?> files = {'faceImage': faceImage};

      // Make API call
      // Using port 8002 temporarily - will switch back to 8000 later
      final response = await _makeFaceReadingRequest(
        fields: fields,
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);

        final faceReadingResponse = FaceReadingResponse.fromJson(jsonData);

        if (faceReadingResponse.success && faceReadingResponse.data != null) {
          return faceReadingResponse.data!;
        } else {
          throw Exception(
            faceReadingResponse.message.isNotEmpty
                ? faceReadingResponse.message
                : 'Face reading analysis failed',
          );
        }
      } else {
        throw Exception(
          'Failed to analyze face reading: ${response.statusCode}',
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
      throw Exception('Error analyzing face reading: ${e.toString()}');
    }
  }

  /// Get face reading history
  Future<FaceReadingHistoryResponse> getFaceReadingHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.faceReadingHistory,
        query: {'page': page.toString(), 'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return FaceReadingHistoryResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to get face reading history: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting face reading history: ${e.toString()}');
    }
  }

  /// Get face reading by ID
  Future<FaceReadingData> getFaceReadingById(String readingId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.faceReadingGetById(readingId),
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final faceReadingResponse = FaceReadingResponse.fromJson(jsonData);

        if (faceReadingResponse.success && faceReadingResponse.data != null) {
          return faceReadingResponse.data!;
        } else {
          throw Exception(
            faceReadingResponse.message.isNotEmpty
                ? faceReadingResponse.message
                : 'Face reading not found',
          );
        }
      } else {
        throw Exception('Failed to get face reading: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting face reading: ${e.toString()}');
    }
  }

  /// Delete face reading by ID
  Future<bool> deleteFaceReading(String readingId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.faceReadingDeleteById(readingId),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
