import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/navigation_service.dart';
import 'package:astrobharataiuser/core/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';

import 'networkException/exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiClient extends GetConnect
    with NavigationService
    implements GetxService {
  late String? token;
  final String? appBaseUrl;

  // Response<dynamic> ?response;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = UserData().getLoginData.accessToken;
  }
  @override
  void onInit() {
    token = UserData().getLoginData.accessToken;
    if (kDebugMode) {
      print('User token:> $token');
    }
    super.onInit();
  }

  Map<String, String> _buildHeaders({
    bool useAuthHeader = true,
    Map<String, String>? extra,
  }) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (useAuthHeader) {
      _syncTokenHeader();
      if (token != null && token!.isNotEmpty) {
        headers['Authorization'] = "Bearer $token";
      }
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  void _syncTokenHeader() {
    token = UserData().accessToken?.trim();
  }

  bool _isUnauthorized(int? status) =>
      status ==
      401; // Only 401 means unauthorized, 403 is forbidden (no access)

  AuthService get _authService => Get.isRegistered<AuthService>()
      ? Get.find<AuthService>()
      : Get.put(AuthService());

  Future<bool> _tryRefreshToken() async {
    final refreshToken = UserData().refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    if (_isRefreshing) {
      try {
        await _refreshCompleter?.future;
      } catch (_) {}
      _syncTokenHeader();
      return UserData().accessToken?.isNotEmpty ?? false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshed = await _authService.refreshAccessToken();
      if (refreshed) {
        _syncTokenHeader();
        _refreshCompleter?.complete();
        return true;
      } else {
        _refreshCompleter?.complete();
        return false;
      }
    } catch (e) {
      _refreshCompleter?.completeError(e);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  void _handleSessionExpired() {
    final hasToken = UserData().accessToken?.isNotEmpty ?? false;
    if (!hasToken) {
      // Guest users: do not force logout/navigate; just return.
      return;
    }
    _authService.forceLogout(message: 'Session expired. Please login again.');
  }

  Future<void> _ensureAuthForWrite(bool useAuthHeader) async {
    if (!useAuthHeader) return;
    final token = UserData().accessToken;
    if (token != null && token.isNotEmpty) return;
    await LoginGuard.showLoginRequiredModal(
      message: 'Please login to continue.',
    );
    throw FetchDataException(
      "Authentication required. Please login to continue.",
    );
  }

  Future<Response<T>> getApi<T>(
    String uri, {
    Map<String, dynamic>? query,
    String? contentType,
    T Function(dynamic)? decoder,
    bool useAuthHeader = true,
  }) async {
    Future<Response<T>> _sendRequest() => get<T>(
      uri,
      query: query,
      headers: _buildHeaders(useAuthHeader: useAuthHeader),
      contentType: contentType ?? 'application/json',
      decoder: decoder,
    );

    try {
      Response<T> response = await _sendRequest();

      if (kDebugMode) {
        print('Urlll: ${response.request?.url}');
        print('body: $query');
        print('Status code: ${response.statusCode}');
        print('User token:> $token');
      }

      // Handle 401 (Unauthorized) - try to refresh token
      // Don't treat 403 (Forbidden) as session expired - it just means no access to resource
      if (useAuthHeader &&
          response.statusCode == 401 &&
          await _tryRefreshToken()) {
        response = await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }

      // For 403 (Forbidden), don't throw exception - just return the response
      // The caller can handle it gracefully without showing error messages
      if (response.statusCode == 403) {
        return response;
      }

      // Only treat 401 (not 403) as session expired after refresh attempt
      if (useAuthHeader && response.statusCode == 401) {
        _handleSessionExpired();
      }

      throw returnException(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on FormatException {
      throw FetchDataException("Bad response format");
    } on TimeoutException catch (e) {
      throw TimeoutException("Request timeout ${e.message}");
    }
  }

  /// Multipart form data POST API
  Future<http.Response> postDataByFormData({
    required String uri,
    required Map<String, String> fields,
    required Map<String, File?> files,
    Map<String, dynamic>? query,
  }) async {
    await _ensureAuthForWrite(true);

    Future<http.Response> _sendRequest() async {
      http.MultipartRequest request;

      if (query != null) {
        final uriWithQuery = Uri.parse(baseUrl! + uri).replace(
          queryParameters: query.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        );
        request = http.MultipartRequest("POST", uriWithQuery);
      } else {
        request = http.MultipartRequest("POST", Uri.parse(baseUrl! + uri));
      }

      final currentToken = UserData().accessToken?.trim();
      if (currentToken != null && currentToken.isNotEmpty) {
        request.headers['Authorization'] = "Bearer $currentToken";
      }

      request.fields.addAll(fields);

      for (var entry in files.entries) {
        final file = entry.value;
        if (file != null) {
          // Determine MIME type based on file extension
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
          } else if (fileName.endsWith('.bmp')) {
            contentType = 'image/bmp';
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

    try {
      http.Response response = await _sendRequest();

      if (kDebugMode) {
        print('Url: ${baseUrl! + uri}');
        print('Fields: $fields');
        print(
          'Files: ${files.keys.where((key) => files[key] != null).toList()}',
        );
        print('User token: $token');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
        response = await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        // Try to extract error message from response body
        String errorMessage = "Error occurred while communicating with server";
        try {
          final body = response.body;
          if (body.isNotEmpty) {
            final decoded = json.decode(body);
            if (decoded is Map<String, dynamic>) {
              final message = decoded['message'];
              final error = decoded['error'];
              if (message != null) {
                errorMessage = message.toString();
              } else if (error != null) {
                errorMessage = error.toString();
              }
            }
          }
        } catch (e) {
          // If parsing fails, use default message with status code
          errorMessage = "Server error (${response.statusCode})";
        }
        throw FetchDataException(errorMessage);
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on FormatException {
      throw FetchDataException("Bad response format");
    } on TimeoutException catch (e) {
      throw TimeoutException("Request timeout ${e.message}");
    } catch (e) {
      if (kDebugMode) {
        print('Error in postDataByFormData: $e');
      }
      rethrow;
    }
  }

  Future<http.Response> putDataByFormData({
    required String uri,
    required Map<String, String> fields,
    required Map<String, File?> files,
    Map<String, dynamic>? query,
  }) async {
    await _ensureAuthForWrite(true);

    Future<http.Response> _sendRequest() async {
      http.MultipartRequest request;

      if (query != null) {
        final uriWithQuery = Uri.parse(baseUrl! + uri).replace(
          queryParameters: query.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        );
        request = http.MultipartRequest("PUT", uriWithQuery);
      } else {
        request = http.MultipartRequest("PUT", Uri.parse(baseUrl! + uri));
      }

      final currentToken = UserData().accessToken?.trim();
      if (currentToken != null && currentToken.isNotEmpty) {
        request.headers['Authorization'] = "Bearer $currentToken";
      }

      request.fields.addAll(fields);

      for (final entry in files.entries) {
        final file = entry.value;
        if (file != null) {
          // Determine MIME type based on file extension
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
          } else if (fileName.endsWith('.bmp')) {
            contentType = 'image/bmp';
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

    try {
      final response = await _sendRequest();

      if (kDebugMode) {
        print('Url: ${baseUrl! + uri}');
        print('Fields: $fields');
        print('Files: ${files.keys.toList()}');
        print('Status code: ${response.statusCode}');
      }

      if (_isUnauthorized(response.statusCode)) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return await _sendRequest();
        } else {
          _handleSessionExpired();
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        // Try to extract error message from response body
        String errorMessage = "Error occurred while communicating with server";
        try {
          final body = response.body;
          if (body.isNotEmpty) {
            final decoded = json.decode(body);
            if (decoded is Map<String, dynamic>) {
              final message = decoded['message'];
              final error = decoded['error'];
              if (message != null) {
                errorMessage = message.toString();
              } else if (error != null) {
                errorMessage = error.toString();
              }
            }
          }
        } catch (e) {
          // If parsing fails, use default message with status code
          errorMessage = "Server error (${response.statusCode})";
        }
        throw FetchDataException(errorMessage);
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on FormatException {
      throw FetchDataException("Bad response format");
    } on TimeoutException catch (e) {
      throw TimeoutException("Request timeout ${e.message}");
    } catch (e) {
      if (kDebugMode) {
        print('Error in putDataByFormData: $e');
      }
      rethrow;
    }
  }

  /// PATCH multipart form data request
  Future<http.Response> patchDataByFormData({
    required String uri,
    required Map<String, String> fields,
    required Map<String, File?> files,
    Map<String, dynamic>? query,
  }) async {
    await _ensureAuthForWrite(true);

    Future<http.Response> _sendRequest() async {
      http.MultipartRequest request;

      if (query != null) {
        final uriWithQuery = Uri.parse(baseUrl! + uri).replace(
          queryParameters: query.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        );
        request = http.MultipartRequest("PATCH", uriWithQuery);
      } else {
        request = http.MultipartRequest("PATCH", Uri.parse(baseUrl! + uri));
      }

      final currentToken = UserData().accessToken?.trim();
      if (currentToken != null && currentToken.isNotEmpty) {
        request.headers['Authorization'] = "Bearer $currentToken";
      }
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);

      for (final entry in files.entries) {
        final file = entry.value;
        if (file != null) {
          // Determine MIME type based on file extension
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
          } else if (fileName.endsWith('.bmp')) {
            contentType = 'image/bmp';
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

    try {
      final response = await _sendRequest();

      if (kDebugMode) {
        print('Url: ${baseUrl! + uri}');
        print('Fields: $fields');
        print(
          'Files: ${files.keys.where((key) => files[key] != null).toList()}',
        );
        print('User token: $token');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
        return await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        // Try to extract error message from response body
        String errorMessage = "Error occurred while communicating with server";
        try {
          final body = response.body;
          if (body.isNotEmpty) {
            final decoded = json.decode(body);
            if (decoded is Map<String, dynamic>) {
              final message = decoded['message'];
              final error = decoded['error'];
              if (message != null) {
                errorMessage = message.toString();
              } else if (error != null) {
                errorMessage = error.toString();
              }
            }
          }
        } catch (e) {
          // If parsing fails, use default message with status code
          errorMessage = "Server error (${response.statusCode})";
        }
        throw FetchDataException(errorMessage);
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on FormatException {
      throw FetchDataException("Bad response format");
    } on TimeoutException catch (e) {
      throw TimeoutException("Request timeout ${e.message}");
    } catch (e) {
      if (kDebugMode) {
        print('Error in patchDataByFormData: $e');
      }
      rethrow;
    }
  }

  /// post request
  Future<Response> postApi(
    String uri,
    dynamic body, {
    bool useAuthHeader = true,
  }) async {
    await _ensureAuthForWrite(useAuthHeader);

    // Convert body to JSON string
    final jsonBodyString = body is String ? body : jsonEncode(body);
    final headers = _buildHeaders(useAuthHeader: useAuthHeader);
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';

    // Use raw http package to send JSON correctly
    Future<http.Response> _sendRawRequest() async {
      final url = Uri.parse(baseUrl! + uri);

      // Send as string with utf8 encoding - this is the most reliable way
      final response = await http.post(
        url,
        headers: headers,
        body: jsonBodyString,
        encoding: utf8,
      );

      return response;
    }

    try {
      final httpResponse = await _sendRawRequest();

      // Parse response body as JSON
      dynamic responseBody;
      try {
        responseBody = jsonDecode(httpResponse.body);
      } catch (e) {
        responseBody = httpResponse.body;
      }

      // Convert http.Response to GetX Response
      final response = Response(
        body: responseBody,
        statusCode: httpResponse.statusCode,
        statusText: httpResponse.reasonPhrase,
        headers: httpResponse.headers,
      );

      if (kDebugMode) {
        print('Url:${baseUrl.toString() + uri}');
        print('body:$body');
        print('JSON String Sent: $jsonBodyString');
        print('responsebody:${response.body}');
        print('statusCode:${response.statusCode}');
        print('hasError:${response.hasError}');
        print('status:${response.status}');
        print('statusText:${response.statusText}');
        print('User token:> $token');
      }

      // Check if response has errors (GetX specific)
      if (response.hasError) {
        // Try to extract the actual error message from response body first
        String errorMessage = "Server error occurred";

        try {
          // Check if response body contains error message
          if (response.body != null) {
            if (response.body is Map) {
              final body = response.body as Map;
              final message = body['message'] as String?;
              if (message != null && message.isNotEmpty) {
                errorMessage = message;
              } else {
                // Fall back to statusText or bodyString
                errorMessage =
                    response.statusText ?? response.bodyString ?? errorMessage;
              }
            } else if (response.bodyString != null &&
                response.bodyString!.isNotEmpty) {
              // Try to parse bodyString as JSON
              try {
                final decoded = jsonDecode(response.bodyString!);
                if (decoded is Map && decoded['message'] != null) {
                  errorMessage = decoded['message'].toString();
                } else {
                  errorMessage =
                      response.statusText ??
                      response.bodyString ??
                      errorMessage;
                }
              } catch (e) {
                errorMessage =
                    response.statusText ?? response.bodyString ?? errorMessage;
              }
            } else {
              errorMessage = response.statusText ?? errorMessage;
            }
          } else {
            errorMessage =
                response.statusText ?? response.bodyString ?? errorMessage;
          }
        } catch (e) {
          // If extraction fails, use statusText or bodyString
          errorMessage =
              response.statusText ??
              response.bodyString ??
              "Server error occurred";
        }

        if (kDebugMode) {
          print('Response has error: $errorMessage');
        }
        throw FetchDataException(errorMessage);
      }

      // Check if response is valid
      if (response.statusCode == null) {
        // Try to get more information about the error
        final errorInfo =
            response.statusText ??
            response.bodyString ??
            "No response from server";
        if (kDebugMode) {
          print('Null statusCode. Error info: $errorInfo');
          print('Response object: ${response.toString()}');
        }
        throw FetchDataException("Connection error: $errorInfo");
      }

      if (useAuthHeader &&
          _isUnauthorized(response.statusCode) &&
          await _tryRefreshToken()) {
        // Retry with refreshed token
        final retryResponse = await _sendRawRequest();
        dynamic retryBody;
        try {
          retryBody = jsonDecode(retryResponse.body);
        } catch (e) {
          retryBody = retryResponse.body;
        }
        final retryGetxResponse = Response(
          body: retryBody,
          statusCode: retryResponse.statusCode,
          statusText: retryResponse.reasonPhrase,
          headers: retryResponse.headers,
        );
        if (retryGetxResponse.hasError) {
          final errorMessage =
              retryGetxResponse.statusText ??
              retryGetxResponse.bodyString ??
              "Server error occurred";
          throw FetchDataException(errorMessage);
        }
        if (retryGetxResponse.statusCode == null) {
          throw FetchDataException(
            "Invalid response from server. Please try again.",
          );
        }
        return retryGetxResponse;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }

      if (useAuthHeader && _isUnauthorized(response.statusCode)) {
        _handleSessionExpired();
        return response; // Return response even if unauthorized to allow error handling
      }

      throw returnException(response);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('SocketException in postApi: $e');
      }
      throw FetchDataException(
        "No Internet Connection. Please check your network and try again.",
      );
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('FormatException in postApi: $e');
      }
      throw FetchDataException(
        "Invalid response format from server. Please try again.",
      );
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('TimeoutException in postApi: $e');
      }
      throw TimeoutException(
        "Request timeout. Please check your connection and try again.",
      );
    } on HttpException catch (e) {
      if (kDebugMode) {
        print('HttpException in postApi: $e');
      }
      throw FetchDataException(
        "Network error: ${e.message}. Please try again.",
      );
    } catch (e) {
      if (e is FetchDataException || e is TimeoutException) {
        rethrow;
      }
      if (kDebugMode) {
        print('Unexpected error in postApi: $e');
        print('Error type: ${e.runtimeType}');
      }
      // Check for common error patterns
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socket') ||
          errorStr.contains('network') ||
          errorStr.contains('connection')) {
        throw FetchDataException(
          "Network connection error. Please check your internet connection and try again.",
        );
      } else if (errorStr.contains('timeout')) {
        throw FetchDataException("Request timed out. Please try again.");
      } else if (errorStr.contains('failed host lookup') ||
          errorStr.contains('name resolution')) {
        throw FetchDataException(
          "Cannot reach server. Please check your internet connection.",
        );
      }
      throw FetchDataException("An error occurred: ${e.toString()}");
    }
  }

  /// delete api request
  Future<Response> deleteRequest(
    String uri,
    dynamic query, {
    bool useAuthHeader = true,
  }) async {
    await _ensureAuthForWrite(useAuthHeader);

    Future<Response> _sendRequest() => delete(
      uri,
      query: query,
      headers: _buildHeaders(useAuthHeader: useAuthHeader),
      contentType: "application/json",
    );

    try {
      Response response = await _sendRequest();

      if (kDebugMode) {
        print('responsebody:${response.request?.url}');
        print('body:$query');
        print('responsebody:${response.body}');
        print('User token:> $token');
      }

      if (useAuthHeader &&
          _isUnauthorized(response.statusCode) &&
          await _tryRefreshToken()) {
        response = await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }

      if (useAuthHeader && _isUnauthorized(response.statusCode)) {
        _handleSessionExpired();
      }

      throw returnException(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on FormatException {
      throw FetchDataException("Bad response format");
    } on TimeoutException catch (e) {
      throw TimeoutException("Request timeout ${e.message}");
    }
  }

  /// put api request
  Future<Response> putApi(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    bool useAuthHeader = true,
  }) async {
    await _ensureAuthForWrite(useAuthHeader);

    Future<Response> _sendRequest() => put(
      uri,
      body,
      headers: _buildHeaders(useAuthHeader: useAuthHeader),
      query: query,
    );

    try {
      if (kDebugMode) {
        print('body:$body');
      }

      Response response = await _sendRequest();

      if (kDebugMode) {
        print('Url:${response.request?.url}');
        print('responsebody:${response.body}');
        print('User token:> $token');
      }

      if (useAuthHeader &&
          _isUnauthorized(response.statusCode) &&
          await _tryRefreshToken()) {
        response = await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }

      if (useAuthHeader && _isUnauthorized(response.statusCode)) {
        _handleSessionExpired();
      }

      throw returnException(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on FormatException {
      throw FetchDataException("Bad response format");
    } on TimeoutException catch (e) {
      throw TimeoutException("Request timeout ${e.message}");
    } catch (e) {
      rethrow;
    }
  }

  // Future<http.Response> putMultipartApi({
  //   required String url,
  //   required Map<String, String> fields,
  //   required Map<String, File?> files,
  // }) async {
  //   final uri = Uri.parse(baseUrl! + url);
  //   final token = UserData().getLoginData.token.toString();
  //
  //   final request = http.MultipartRequest("PUT", uri);
  //   request.headers['Authorization'] = "Bearer $token";
  //
  //   // Add text fields
  //   request.fields.addAll(fields);
  //
  //   // Add files (if not null)
  //   for (var entry in files.entries) {
  //     if (entry.value != null) {
  //       final file = entry.value!;
  //       request.files.add(await http.MultipartFile.fromPath(
  //         entry.key,
  //         file.path,
  //         filename: file.path.split('/').last,
  //       ));
  //     }
  //   }
  //
  //   final streamedResponse = await request.send();
  //   final response = await http.Response.fromStream(streamedResponse);
  //
  //   return response;
  // }

  Future<http.Response> putMultipartApi({
    required String url,
    required Map<String, String> fields,
    required Map<String, dynamic> files, // dynamic: can be File or List<File>
  }) async {
    final uri = Uri.parse(baseUrl! + url);
    final token = UserData().getLoginData.accessToken.toString();

    final request = http.MultipartRequest("PUT", uri);
    request.headers['Authorization'] = "Bearer $token";

    // Add text fields
    request.fields.addAll(fields);

    // Handle both File and List<File>
    for (var entry in files.entries) {
      var value = entry.value;

      if (value is File) {
        // Single file
        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            value.path,
            filename: value.path.split('/').last,
          ),
        );
      } else if (value is List<File>) {
        for (var file in value) {
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              file.path,
              filename: file.path.split('/').last,
            ),
          );
        }
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response;
  }
}
