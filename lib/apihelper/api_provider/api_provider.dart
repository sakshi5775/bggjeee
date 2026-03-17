// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:astrobharataiuser/app_manager/user_data.dart';
// import 'package:astrobharataiuser/core/base/navigation_service.dart';
// import 'package:astrobharataiuser/core/services/auth_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:astrobharataiuser/core/services/login_guard.dart';

// import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';
// import 'package:astrobharataiuser/apihelper/error_handler.dart';
// import 'package:astrobharataiuser/apihelper/api_response.dart';
// import 'package:astrobharataiuser/apihelper/network_service/network_service.dart';
// import 'package:astrobharataiuser/core/services/api_cache_service.dart';
// import 'package:astrobharataiuser/core/services/global_api_store.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// class ApiClient extends GetConnect
//     with NavigationService
//     implements GetxService {
//   late String? token;
//   final String? appBaseUrl;

//   // Response<dynamic> ?response;
//   bool _isRefreshing = false;
//   Completer<void>? _refreshCompleter;

//   ApiClient({required this.appBaseUrl}) {
//     baseUrl = appBaseUrl;
//     timeout = const Duration(seconds: 30);
//     token = UserData().getLoginData.accessToken;
//   }
//   @override
//   void onInit() {
//     token = UserData().getLoginData.accessToken;
//     if (kDebugMode) {
//       print('User token:> $token');
//     }
//     super.onInit();
//   }

//   Map<String, String> _buildHeaders({
//     bool useAuthHeader = true,
//     Map<String, String>? extra,
//   }) {
//     final headers = <String, String>{'Content-Type': 'application/json'};
//     if (useAuthHeader) {
//       _syncTokenHeader();
//       if (token != null && token!.isNotEmpty) {
//         headers['Authorization'] = "Bearer $token";
//       }
//     }
//     if (extra != null) {
//       headers.addAll(extra);
//     }
//     return headers;
//   }

//   void _syncTokenHeader() {
//     token = UserData().accessToken?.trim();
//   }

//   bool _isUnauthorized(int? status) =>
//       status ==
//       401; // Only 401 means unauthorized, 403 is forbidden (no access)

//   AuthService get _authService => Get.isRegistered<AuthService>()
//       ? Get.find<AuthService>()
//       : Get.put(AuthService());

//   Future<bool> _tryRefreshToken() async {
//     final refreshToken = UserData().refreshToken;
//     if (refreshToken == null || refreshToken.isEmpty) {
//       return false;
//     }

//     if (_isRefreshing) {
//       try {
//         await _refreshCompleter?.future;
//       } catch (_) {}
//       _syncTokenHeader();
//       return UserData().accessToken?.isNotEmpty ?? false;
//     }

//     _isRefreshing = true;
//     _refreshCompleter = Completer<void>();

//     try {
//       final refreshed = await _authService.refreshAccessToken();
//       if (refreshed) {
//         _syncTokenHeader();
//         _refreshCompleter?.complete();
//         return true;
//       } else {
//         _refreshCompleter?.complete();
//         return false;
//       }
//     } catch (e) {
//       _refreshCompleter?.completeError(e);
//       return false;
//     } finally {
//       _isRefreshing = false;
//     }
//   }

//   void _handleSessionExpired() {
//     final hasToken = UserData().accessToken?.isNotEmpty ?? false;
//     if (!hasToken) {
//       // Guest users: do not force logout/navigate; just return.
//       return;
//     }
//     _authService.forceLogout(message: 'Session expired. Please login again.');
//   }

//   Future<void> _ensureAuthForWrite(bool useAuthHeader) async {
//     if (!useAuthHeader) return;
//     final token = UserData().accessToken;
//     if (token != null && token.isNotEmpty) return;
//     await LoginGuard.showLoginRequiredModal(
//       message: 'Please login to continue.',
//     );
//     throw FetchDataException(
//       "Authentication required. Please login to continue.",
//     );
//   }

//   Future<Response<T>> getApi<T>(
//     String uri, {
//     Map<String, dynamic>? query,
//     String? contentType,
//     T Function(dynamic)? decoder,
//     bool useAuthHeader = true,
//     Duration? timeout,
//     bool useCache = true,
//     int? maxCacheAge,
//   }) async {
//     final cacheKey = uri + (query?.toString() ?? '');

//     if (useCache) {
//       // 1. Check in-memory cache
//       if (GlobalApiStore.has(cacheKey)) {
//         if (kDebugMode) print('Cache: Memory hit for $uri');
//         final data = GlobalApiStore.get(cacheKey);
//         return Response<T>(
//           body: decoder != null ? decoder(data) : data as T,
//           statusCode: 200,
//         );
//       }

//       // 2. Check persistent cache
//       final cachedData = ApiCacheService.get(
//         cacheKey,
//         maxAgeMinutes: maxCacheAge ?? 30,
//       );
//       if (cachedData != null) {
//         if (kDebugMode) print('Cache: Persistent hit for $uri');
//         GlobalApiStore.set(cacheKey, cachedData);
//         return Response<T>(
//           body: decoder != null ? decoder(cachedData) : cachedData as T,
//           statusCode: 200,
//         );
//       }
//     }

//     return _withRetry(() async {
//       Future<Response<T>> _sendRequest() => get<T>(
//         uri,
//         query: query,
//         headers: _buildHeaders(useAuthHeader: useAuthHeader),
//         contentType: contentType ?? 'application/json',
//         decoder: decoder,
//       ).timeout(timeout ?? const Duration(seconds: 30));

//       // 3. Check internet
//       final isOnline = await NetworkService.instance.checkConnectivity();
//       if (!isOnline) {
//         if (kDebugMode) print('Cache: Offline and no cache for $uri');
//         throw FetchDataException(
//           "No internet connection and no cached data available.",
//         );
//       }

//       Response<T> response = await _sendRequest();

//       if (kDebugMode) {
//         print('Urlll: ${response.request?.url}');
//         print('body: $query');
//         print('Status code: ${response.statusCode}');
//       }

//       if (useAuthHeader &&
//           response.statusCode == 401 &&
//           await _tryRefreshToken()) {
//         response = await _sendRequest();
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (useCache && response.body != null) {
//           // 4. Update caches
//           GlobalApiStore.set(cacheKey, response.body);
//           await ApiCacheService.save(cacheKey, response.body);
//         }
//         return response;
//       }

//       if (response.statusCode == 403) {
//         return response;
//       }

//       if (useAuthHeader && response.statusCode == 401) {
//         _handleSessionExpired();
//       }

//       if (kDebugMode &&
//           response.statusCode != 200 &&
//           response.statusCode != 201) {
//         print('Error Response Body: ${response.bodyString}');
//       }

//       throw returnException(response);
//     });
//   }

//   /// Helper to wrap requests with retry logic for temporary failures.
//   Future<R> _withRetry<R>(
//     Future<R> Function() request, {
//     int maxRetries = 2,
//   }) async {
//     int attempts = 0;
//     while (true) {
//       attempts++;
//       try {
//         return await request();
//       } catch (e) {
//         final errorType = ErrorHandler.getErrorType(e);
//         final isRetryable =
//             errorType == ErrorType.timeout ||
//             errorType == ErrorType.server ||
//             (e is Response && e.statusCode != null && e.statusCode! >= 500);

//         if (isRetryable && attempts <= maxRetries) {
//           if (kDebugMode) print('Retrying request (attempt $attempts)...');
//           await Future.delayed(Duration(seconds: attempts * 2));
//           continue;
//         }

//         if (e is Response ||
//             e is NetworkException ||
//             e is SocketException ||
//             e is TimeoutException) {
//           throw ErrorHandler.handle(e);
//         }
//         rethrow;
//       }
//     }
//   }

//   /// Multipart form data POST API
//   Future<http.Response> postDataByFormData({
//     required String uri,
//     required Map<String, String> fields,
//     required Map<String, File?> files,
//     Map<String, dynamic>? query,
//     Duration? timeout,
//   }) async {
//     await _ensureAuthForWrite(true);

//     Future<http.Response> _sendRequest() async {
//       http.MultipartRequest request;

//       if (query != null) {
//         final uriWithQuery = Uri.parse(baseUrl! + uri).replace(
//           queryParameters: query.map(
//             (key, value) => MapEntry(key, value.toString()),
//           ),
//         );
//         request = http.MultipartRequest("POST", uriWithQuery);
//       } else {
//         request = http.MultipartRequest("POST", Uri.parse(baseUrl! + uri));
//       }

//       final currentToken = UserData().accessToken?.trim();
//       if (currentToken != null && currentToken.isNotEmpty) {
//         request.headers['Authorization'] = "Bearer $currentToken";
//       }

//       request.fields.addAll(fields);

//       for (var entry in files.entries) {
//         final file = entry.value;
//         if (file != null) {
//           // Determine MIME type based on file extension
//           final fileName = file.path.split('/').last.toLowerCase();
//           String? contentType;

//           if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
//             contentType = 'image/jpeg';
//           } else if (fileName.endsWith('.png')) {
//             contentType = 'image/png';
//           } else if (fileName.endsWith('.gif')) {
//             contentType = 'image/gif';
//           } else if (fileName.endsWith('.webp')) {
//             contentType = 'image/webp';
//           } else if (fileName.endsWith('.bmp')) {
//             contentType = 'image/bmp';
//           }

//           request.files.add(
//             await http.MultipartFile.fromPath(
//               entry.key,
//               file.path,
//               filename: file.path.split('/').last,
//               contentType: contentType != null
//                   ? MediaType.parse(contentType)
//                   : null,
//             ),
//           );
//         }
//       }

//       final streamedResponse = await request.send().timeout(
//         timeout ?? const Duration(seconds: 60),
//       );
//       return http.Response.fromStream(streamedResponse);
//     }

//     try {
//       http.Response response = await _sendRequest();

//       if (kDebugMode) {
//         print('Url: ${baseUrl! + uri}');
//         print('Response status: ${response.statusCode}');
//       }

//       if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
//         response = await _sendRequest();
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       } else {
//         throw response;
//       }
//     } catch (e) {
//       if (e is http.Response) {
//         // Wrap http.Response to GetX Response for ErrorHandler
//         throw ErrorHandler.handle(
//           Response(
//             statusCode: e.statusCode,
//             bodyString: e.body,
//             statusText: e.reasonPhrase,
//           ),
//         );
//       }
//       throw ErrorHandler.handle(e);
//     }
//   }

//   Future<http.Response> putDataByFormData({
//     required String uri,
//     required Map<String, String> fields,
//     required Map<String, File?> files,
//     Map<String, dynamic>? query,
//     Duration? timeout,
//   }) async {
//     await _ensureAuthForWrite(true);

//     Future<http.Response> _sendRequest() async {
//       http.MultipartRequest request;

//       if (query != null) {
//         final uriWithQuery = Uri.parse(baseUrl! + uri).replace(
//           queryParameters: query.map(
//             (key, value) => MapEntry(key, value.toString()),
//           ),
//         );
//         request = http.MultipartRequest("PUT", uriWithQuery);
//       } else {
//         request = http.MultipartRequest("PUT", Uri.parse(baseUrl! + uri));
//       }

//       final currentToken = UserData().accessToken?.trim();
//       if (currentToken != null && currentToken.isNotEmpty) {
//         request.headers['Authorization'] = "Bearer $currentToken";
//       }

//       request.fields.addAll(fields);

//       for (final entry in files.entries) {
//         final file = entry.value;
//         if (file != null) {
//           // Determine MIME type based on file extension
//           final fileName = file.path.split('/').last.toLowerCase();
//           String? contentType;

//           if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
//             contentType = 'image/jpeg';
//           } else if (fileName.endsWith('.png')) {
//             contentType = 'image/png';
//           } else if (fileName.endsWith('.gif')) {
//             contentType = 'image/gif';
//           } else if (fileName.endsWith('.webp')) {
//             contentType = 'image/webp';
//           } else if (fileName.endsWith('.bmp')) {
//             contentType = 'image/bmp';
//           }

//           request.files.add(
//             await http.MultipartFile.fromPath(
//               entry.key,
//               file.path,
//               filename: file.path.split('/').last,
//               contentType: contentType != null
//                   ? MediaType.parse(contentType)
//                   : null,
//             ),
//           );
//         }
//       }

//       final streamedResponse = await request.send().timeout(
//         timeout ?? const Duration(seconds: 60),
//       );
//       return http.Response.fromStream(streamedResponse);
//     }

//     try {
//       final response = await _sendRequest();

//       if (kDebugMode) {
//         print('Url: ${baseUrl! + uri}');
//         print('Status code: ${response.statusCode}');
//       }

//       if (_isUnauthorized(response.statusCode)) {
//         final refreshed = await _tryRefreshToken();
//         if (refreshed) {
//           return await _sendRequest();
//         } else {
//           _handleSessionExpired();
//         }
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       } else {
//         throw response;
//       }
//     } catch (e) {
//       if (e is http.Response) {
//         throw ErrorHandler.handle(
//           Response(
//             statusCode: e.statusCode,
//             bodyString: e.body,
//             statusText: e.reasonPhrase,
//           ),
//         );
//       }
//       throw ErrorHandler.handle(e);
//     }
//   }

//   /// PATCH multipart form data request
//   Future<http.Response> patchDataByFormData({
//     required String uri,
//     required Map<String, String> fields,
//     required Map<String, File?> files,
//     Map<String, dynamic>? query,
//   }) async {
//     await _ensureAuthForWrite(true);

//     Future<http.Response> _sendRequest() async {
//       http.MultipartRequest request;

//       if (query != null) {
//         final uriWithQuery = Uri.parse(baseUrl! + uri).replace(
//           queryParameters: query.map(
//             (key, value) => MapEntry(key, value.toString()),
//           ),
//         );
//         request = http.MultipartRequest("PATCH", uriWithQuery);
//       } else {
//         request = http.MultipartRequest("PATCH", Uri.parse(baseUrl! + uri));
//       }

//       final currentToken = UserData().accessToken?.trim();
//       if (currentToken != null && currentToken.isNotEmpty) {
//         request.headers['Authorization'] = "Bearer $currentToken";
//       }
//       request.headers['Accept'] = 'application/json';

//       request.fields.addAll(fields);

//       for (final entry in files.entries) {
//         final file = entry.value;
//         if (file != null) {
//           // Determine MIME type based on file extension
//           final fileName = file.path.split('/').last.toLowerCase();
//           String? contentType;

//           if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
//             contentType = 'image/jpeg';
//           } else if (fileName.endsWith('.png')) {
//             contentType = 'image/png';
//           } else if (fileName.endsWith('.gif')) {
//             contentType = 'image/gif';
//           } else if (fileName.endsWith('.webp')) {
//             contentType = 'image/webp';
//           } else if (fileName.endsWith('.bmp')) {
//             contentType = 'image/bmp';
//           }

//           request.files.add(
//             await http.MultipartFile.fromPath(
//               entry.key,
//               file.path,
//               filename: file.path.split('/').last,
//               contentType: contentType != null
//                   ? MediaType.parse(contentType)
//                   : null,
//             ),
//           );
//         }
//       }

//       final streamedResponse = await request.send();
//       return http.Response.fromStream(streamedResponse);
//     }

//     try {
//       final response = await _sendRequest();

//       if (kDebugMode) {
//         print('Url: ${baseUrl! + uri}');
//         print('Response status: ${response.statusCode}');
//       }

//       if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
//         return await _sendRequest();
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       } else {
//         throw response;
//       }
//     } catch (e) {
//       if (e is http.Response) {
//         throw ErrorHandler.handle(
//           Response(
//             statusCode: e.statusCode,
//             bodyString: e.body,
//             statusText: e.reasonPhrase,
//           ),
//         );
//       }
//       throw ErrorHandler.handle(e);
//     }
//   }

//   /// post request
//   Future<Response> postApi(
//     String uri,
//     dynamic body, {
//     bool useAuthHeader = true,
//     Duration? timeout,
//   }) async {
//     await _ensureAuthForWrite(useAuthHeader);

//     return _withRetry(() async {
//       // Convert body to JSON string
//       final jsonBodyString = body is String ? body : jsonEncode(body);
//       final headers = _buildHeaders(useAuthHeader: useAuthHeader);
//       headers['Content-Type'] = 'application/json';
//       headers['Accept'] = 'application/json';

//       // Use raw http package to send JSON correctly
//       Future<http.Response> _sendRawRequest() async {
//         final url = Uri.parse(baseUrl! + uri);
//         return await http
//             .post(url, headers: headers, body: jsonBodyString, encoding: utf8)
//             .timeout(timeout ?? const Duration(seconds: 30));
//       }

//       final httpResponse = await _sendRawRequest();

//       // Parse response body as JSON
//       dynamic responseBody;
//       try {
//         responseBody = jsonDecode(httpResponse.body);
//       } catch (e) {
//         responseBody = httpResponse.body;
//       }

//       // Convert http.Response to GetX Response
//       final response = Response(
//         body: responseBody,
//         statusCode: httpResponse.statusCode,
//         statusText: httpResponse.reasonPhrase,
//         headers: httpResponse.headers,
//       );

//       if (kDebugMode) {
//         print('Url:${baseUrl.toString() + uri}');
//         print('body:$body');
//         print('statusCode:${response.statusCode}');
//       }

//       if (response.hasError) {
//         throw returnException(response);
//       }

//       if (useAuthHeader &&
//           _isUnauthorized(response.statusCode) &&
//           await _tryRefreshToken()) {
//         final retryResponse = await _sendRawRequest();
//         dynamic retryBody;
//         try {
//           retryBody = jsonDecode(retryResponse.body);
//         } catch (e) {
//           retryBody = retryResponse.body;
//         }
//         final retryGetxResponse = Response(
//           body: retryBody,
//           statusCode: retryResponse.statusCode,
//           statusText: retryResponse.reasonPhrase,
//           headers: retryResponse.headers,
//         );
//         if (retryGetxResponse.hasError) {
//           throw returnException(retryGetxResponse);
//         }
//         return retryGetxResponse;
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       }

//       if (useAuthHeader && _isUnauthorized(response.statusCode)) {
//         _handleSessionExpired();
//         return response;
//       }

//       throw returnException(response);
//     });
//   }

//   /// delete api request
//   Future<Response> deleteRequest(
//     String uri,
//     dynamic query, {
//     bool useAuthHeader = true,
//     Duration? timeout,
//   }) async {
//     await _ensureAuthForWrite(useAuthHeader);

//     return _withRetry(() async {
//       Future<Response> _sendRequest() => delete(
//         uri,
//         query: query,
//         headers: _buildHeaders(useAuthHeader: useAuthHeader),
//         contentType: "application/json",
//       ).timeout(timeout ?? const Duration(seconds: 30));

//       Response response = await _sendRequest();

//       if (kDebugMode) {
//         print('responsebody:${response.request?.url}');
//         print('body:$query');
//         print('statusCode:${response.statusCode}');
//       }

//       if (useAuthHeader &&
//           _isUnauthorized(response.statusCode) &&
//           await _tryRefreshToken()) {
//         response = await _sendRequest();
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       }

//       if (useAuthHeader && _isUnauthorized(response.statusCode)) {
//         _handleSessionExpired();
//       }

//       throw returnException(response);
//     });
//   }

//   /// put api request
//   Future<Response> putApi(
//     String uri,
//     dynamic body, {
//     Map<String, dynamic>? query,
//     bool useAuthHeader = true,
//     Duration? timeout,
//   }) async {
//     await _ensureAuthForWrite(useAuthHeader);

//     return _withRetry(() async {
//       Future<Response> _sendRequest() => put(
//         uri,
//         body,
//         headers: _buildHeaders(useAuthHeader: useAuthHeader),
//         query: query,
//       ).timeout(timeout ?? const Duration(seconds: 30));

//       Response response = await _sendRequest();

//       if (kDebugMode) {
//         print('Url:${response.request?.url}');
//         print('statusCode:${response.statusCode}');
//       }

//       if (useAuthHeader &&
//           _isUnauthorized(response.statusCode) &&
//           await _tryRefreshToken()) {
//         response = await _sendRequest();
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       }

//       if (useAuthHeader && _isUnauthorized(response.statusCode)) {
//         _handleSessionExpired();
//       }

//       throw returnException(response);
//     });
//   }

//   // Future<http.Response> putMultipartApi({
//   //   required String url,
//   //   required Map<String, String> fields,
//   //   required Map<String, File?> files,
//   // }) async {
//   //   final uri = Uri.parse(baseUrl! + url);
//   //   final token = UserData().getLoginData.token.toString();
//   //
//   //   final request = http.MultipartRequest("PUT", uri);
//   //   request.headers['Authorization'] = "Bearer $token";
//   //
//   //   // Add text fields
//   //   request.fields.addAll(fields);
//   //
//   //   // Add files (if not null)
//   //   for (var entry in files.entries) {
//   //     if (entry.value != null) {
//   //       final file = entry.value!;
//   //       request.files.add(await http.MultipartFile.fromPath(
//   //         entry.key,
//   //         file.path,
//   //         filename: file.path.split('/').last,
//   //       ));
//   //     }
//   //   }
//   //
//   //   final streamedResponse = await request.send();
//   //   final response = await http.Response.fromStream(streamedResponse);
//   //
//   //   return response;
//   // }

//   Future<http.Response> putMultipartApi({
//     required String url,
//     required Map<String, String> fields,
//     required Map<String, dynamic> files, // dynamic: can be File or List<File>
//     Duration? timeout,
//   }) async {
//     return _withRetry(() async {
//       final uri = Uri.parse(baseUrl! + url);
//       final currentToken = UserData().getLoginData.accessToken.toString();

//       final request = http.MultipartRequest("PUT", uri);
//       if (currentToken.isNotEmpty) {
//         request.headers['Authorization'] = "Bearer $currentToken";
//       }

//       // Add text fields
//       request.fields.addAll(fields);

//       // Handle both File and List<File>
//       for (var entry in files.entries) {
//         var value = entry.value;

//         if (value is File) {
//           // Single file
//           request.files.add(
//             await http.MultipartFile.fromPath(
//               entry.key,
//               value.path,
//               filename: value.path.split('/').last,
//             ),
//           );
//         } else if (value is List<File>) {
//           for (var file in value) {
//             request.files.add(
//               await http.MultipartFile.fromPath(
//                 entry.key,
//                 file.path,
//                 filename: file.path.split('/').last,
//               ),
//             );
//           }
//         }
//       }

//       final streamedResponse = await request.send().timeout(
//         timeout ?? const Duration(seconds: 60),
//       );
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         return response;
//       }

//       if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
//         // Retry happens via _withRetry if we throw after second fail,
//         // but local retry for token refresh is cleaner here.
//         // Actually _withRetry handles the main loop.
//         // For multipart, we should probably just throw and let _withRetry or caller decide.
//       }

//       throw response;
//     });
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/navigation_service.dart';
import 'package:astrobharataiuser/core/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';

import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';
import 'package:astrobharataiuser/apihelper/error_handler.dart';
import 'package:astrobharataiuser/apihelper/api_response.dart';
import 'package:hive_ce/hive.dart';
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
  // Hive Box Reference (reserved for API caching; currently disabled)
  // ignore: unused_field
  final _cacheBox = Hive.box('api_cache');
  @override
  void onInit() {
    token = UserData().getLoginData.accessToken;
    if (kDebugMode) {
      print('User token:> $token');
    }

    super.onInit();
  }

  /// Recursively replaces S3 image URLs with CloudFront CDN URL in API response.
  /// Returns Map<String, dynamic> and List so decoders get the expected types.
  dynamic _replaceImageUrls(dynamic data) {
    const newUrl = 'https://d3c2un7ipdye89.cloudfront.net/';
    const oldUrls = <String>[
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/',
      'http://astrobharatai.s3.ap-south-1.amazonaws.com/',
      // Some backends return without trailing slash
      'https://astrobharatai.s3.ap-south-1.amazonaws.com',
      'http://astrobharatai.s3.ap-south-1.amazonaws.com',
    ];

    if (data is String) {
      var out = data;
      for (final oldUrl in oldUrls) {
        out = out.replaceAll(oldUrl, newUrl);
      }
      return out;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(
        data.map(
          (key, value) => MapEntry(key.toString(), _replaceImageUrls(value)),
        ),
      );
    }
    if (data is List) {
      return data.map((e) => _replaceImageUrls(e)).toList();
    }
    return data;
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

  /// Modified getApi with Caching & Background Refresh
  // Future<Response<T>> getApi<T>(
  //   String uri, {
  //   Map<String, dynamic>? query,
  //   String? contentType,
  //   T Function(dynamic)? decoder,
  //   bool useAuthHeader = true,
  //   bool useCache = true, // Caching control karne ke liye
  // }) async {
  //   final cacheKey = (baseUrl ?? "") + uri + (query?.toString() ?? "");

  //   return _withRetry(() async {
  //     // 1. CHECK CACHE FIRST (Fast Response)
  //     if (useCache && _cacheBox.containsKey(cacheKey)) {
  //       final cachedData = _getFormattedCache(cacheKey);
  //       if (cachedData != null) {
  //         if (kDebugMode) print('Serving from Cache: $uri');

  //         // Background mein fresh data mangwao (Silent Update)
  //         _refreshDataInBackground<T>(
  //           uri,
  //           query: query,
  //           contentType: contentType,
  //           decoder: decoder,
  //           useAuthHeader: useAuthHeader,
  //           cacheKey: cacheKey,
  //         );

  //         // Turant cached data return karo
  //         return Response<T>(
  //           body: decoder != null ? decoder(cachedData) : cachedData as T,
  //           statusCode: 200,
  //           statusText: "Cached Data",
  //         );
  //       }
  //     }

  //     // 2. ACTUAL NETWORK REQUEST (If no cache or first time)
  //     Future<Response<T>> _sendRequest() => get<T>(
  //       uri,
  //       query: query,
  //       headers: _buildHeaders(useAuthHeader: useAuthHeader),
  //       contentType: contentType ?? 'application/json',
  //       decoder: decoder,
  //     );

  //     Response<T> response = await _sendRequest();

  //     // ... (Debug prints & 401 Refresh Token Logic same rahegi)
  //     if (useAuthHeader &&
  //         response.statusCode == 401 &&
  //         await _tryRefreshToken()) {
  //       response = await _sendRequest();
  //     }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Image URL replacement (Aapka existing logic)
  //       final updatedBody = _replaceImageUrls(response.body);

  //       // 3. SAVE TO CACHE (Save raw body for future use)
  //       if (useCache) {
  //         _cacheBox.put(cacheKey, updatedBody);
  //       }

  //       return Response<T>(
  //         body: updatedBody as T,
  //         statusCode: response.statusCode,
  //         statusText: response.statusText,
  //         headers: response.headers,
  //         request: response.request,
  //       );
  //     }

  //     // ... (403, 401 session expired, and exception throwing same rahegi)
  //     if (response.statusCode == 403) return response;
  //     if (useAuthHeader && response.statusCode == 401) _handleSessionExpired();

  //     throw returnException(response);
  //   });
  // }

  // --------------------------------------------------------------------------
  // HELPERS FOR CACHING
  // --------------------------------------------------------------------------

  /// Hive ke dynamic Map ko String key wale Map mein convert karta hai (Fixes Casting Error)
  // dynamic _getFormattedCache(String key) {
  //   final data = _cacheBox.get(key);
  //   if (data == null) return null;
  //   return _recursiveConvert(data);
  // }

  // dynamic _recursiveConvert(dynamic item) {
  //   if (item is Map) {
  //     return item.map((k, v) => MapEntry(k.toString(), _recursiveConvert(v)));
  //   } else if (item is List) {
  //     return item.map(_recursiveConvert).toList();
  //   }
  //   return item;
  // }

  // /// Background Refresh Logic
  // void _refreshDataInBackground<T>(
  //   String uri, {
  //   Map<String, dynamic>? query,
  //   String? contentType,
  //   T Function(dynamic)? decoder,
  //   bool useAuthHeader = true,
  //   required String cacheKey,
  // }) async {
  //   try {
  //     final response = await get<T>(
  //       uri,
  //       query: query,
  //       headers: _buildHeaders(useAuthHeader: useAuthHeader),
  //       contentType: contentType ?? 'application/json',
  //       decoder: decoder,
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final updatedBody = _replaceImageUrls(response.body);
  //       _cacheBox.put(cacheKey, updatedBody); // Cache update ho jayega
  //       if (kDebugMode) print('Cache Updated in Background: $uri');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) print('Background Refresh Failed: $e');
  //   }
  // }

  Future<Response<T>> getApi<T>(
    String uri, {
    Map<String, dynamic>? query,
    String? contentType,
    T Function(dynamic)? decoder,
    bool useAuthHeader = true,
  }) async {
    return _withRetry(() async {
      // 1. NETWORK REQUEST
      Future<Response<T>> _sendRequest() => get<T>(
        uri,
        query: query,
        headers: _buildHeaders(useAuthHeader: useAuthHeader),
        contentType: contentType ?? 'application/json',
        decoder: decoder,
      );

      Response<T> response = await _sendRequest();

      // Debug Logs
      if (kDebugMode) {
        print('Urlll: ${response.request?.url}');
        print('body: $query');
        print('Status code: ${response.statusCode}');
      }

      // 2. REFRESH TOKEN LOGIC (Agar 401 aaye)
      if (useAuthHeader &&
          response.statusCode == 401 &&
          await _tryRefreshToken()) {
        response = await _sendRequest();
      }

      // 3. SUCCESS RESPONSE (200 ya 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Aapka image URL replacement logic
        final updatedBody = _replaceImageUrls(response.body);

        return Response<T>(
          body: updatedBody as T,
          statusCode: response.statusCode,
          statusText: response.statusText,
          headers: response.headers,
          request: response.request,
        );
      }

      // 4. ERROR HANDLING
      if (response.statusCode == 403) {
        return response;
      }

      if (useAuthHeader && response.statusCode == 401) {
        _handleSessionExpired();
      }

      if (kDebugMode &&
          response.statusCode != 200 &&
          response.statusCode != 201) {
        print('Error Response Body: ${response.bodyString}');
      }

      throw returnException(response);
    });
  }

  /// Helper to wrap requests with retry logic for temporary failures.
  Future<R> _withRetry<R>(
    Future<R> Function() request, {
    int maxRetries = 2,
  }) async {
    int attempts = 0;
    while (true) {
      attempts++;
      try {
        return await request();
      } catch (e) {
        final errorType = ErrorHandler.getErrorType(e);
        final isRetryable =
            errorType == ErrorType.timeout ||
            errorType == ErrorType.server ||
            (e is Response && e.statusCode != null && e.statusCode! >= 500);

        if (isRetryable && attempts <= maxRetries) {
          if (kDebugMode) print('Retrying request (attempt $attempts)...');
          await Future.delayed(Duration(seconds: attempts * 2));
          continue;
        }

        if (e is Response ||
            e is NetworkException ||
            e is SocketException ||
            e is TimeoutException) {
          throw ErrorHandler.handle(e);
        }
        rethrow;
      }
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
        print('Response status: ${response.statusCode}');
      }

      if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
        response = await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw response;
      }
    } catch (e) {
      if (e is http.Response) {
        // Wrap http.Response to GetX Response for ErrorHandler
        throw ErrorHandler.handle(
          Response(
            statusCode: e.statusCode,
            bodyString: e.body,
            statusText: e.reasonPhrase,
          ),
        );
      }
      throw ErrorHandler.handle(e);
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
        throw response;
      }
    } catch (e) {
      if (e is http.Response) {
        throw ErrorHandler.handle(
          Response(
            statusCode: e.statusCode,
            bodyString: e.body,
            statusText: e.reasonPhrase,
          ),
        );
      }
      throw ErrorHandler.handle(e);
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
        print('Response status: ${response.statusCode}');
      }

      if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
        return await _sendRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw response;
      }
    } catch (e) {
      if (e is http.Response) {
        throw ErrorHandler.handle(
          Response(
            statusCode: e.statusCode,
            bodyString: e.body,
            statusText: e.reasonPhrase,
          ),
        );
      }
      throw ErrorHandler.handle(e);
    }
  }

  /// post request
  Future<Response> postApi(
    String uri,
    dynamic body, {
    bool useAuthHeader = true,
  }) async {
    await _ensureAuthForWrite(useAuthHeader);

    return _withRetry(() async {
      // Convert body to JSON string
      final jsonBodyString = body is String ? body : jsonEncode(body);
      final headers = _buildHeaders(useAuthHeader: useAuthHeader);
      headers['Content-Type'] = 'application/json';
      headers['Accept'] = 'application/json';

      // Use raw http package to send JSON correctly
      Future<http.Response> _sendRawRequest() async {
        final url = Uri.parse(baseUrl! + uri);
        return await http.post(
          url,
          headers: headers,
          body: jsonBodyString,
          encoding: utf8,
        );
      }

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
        print('statusCode:${response.statusCode}');
      }

      if (response.hasError) {
        throw returnException(response);
      }

      if (useAuthHeader &&
          _isUnauthorized(response.statusCode) &&
          await _tryRefreshToken()) {
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
          throw returnException(retryGetxResponse);
        }
        return retryGetxResponse;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final updatedBody = _replaceImageUrls(response.body);
        return Response(
          body: updatedBody,
          statusCode: response.statusCode,
          statusText: response.statusText,
          headers: response.headers,
          request: response.request,
        );
      }

      if (useAuthHeader && _isUnauthorized(response.statusCode)) {
        _handleSessionExpired();
        return response;
      }

      throw returnException(response);
    });
  }

  /// delete api request
  Future<Response> deleteRequest(
    String uri,
    dynamic query, {
    bool useAuthHeader = true,
  }) async {
    await _ensureAuthForWrite(useAuthHeader);

    return _withRetry(() async {
      Future<Response> _sendRequest() => delete(
        uri,
        query: query,
        headers: _buildHeaders(useAuthHeader: useAuthHeader),
        contentType: "application/json",
      );

      Response response = await _sendRequest();

      if (kDebugMode) {
        print('responsebody:${response.request?.url}');
        print('body:$query');
        print('statusCode:${response.statusCode}');
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
    });
  }

  /// put api request
  Future<Response> putApi(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    bool useAuthHeader = true,
  }) async {
    await _ensureAuthForWrite(useAuthHeader);

    return _withRetry(() async {
      Future<Response> _sendRequest() => put(
        uri,
        body,
        headers: _buildHeaders(useAuthHeader: useAuthHeader),
        query: query,
      );

      Response response = await _sendRequest();

      if (kDebugMode) {
        print('Url:${response.request?.url}');
        print('statusCode:${response.statusCode}');
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
    });
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
    return _withRetry(() async {
      final uri = Uri.parse(baseUrl! + url);
      final currentToken = UserData().getLoginData.accessToken.toString();

      final request = http.MultipartRequest("PUT", uri);
      if (currentToken.isNotEmpty) {
        request.headers['Authorization'] = "Bearer $currentToken";
      }

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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }

      if (_isUnauthorized(response.statusCode) && await _tryRefreshToken()) {
        // Retry happens via _withRetry if we throw after second fail,
        // but local retry for token refresh is cleaner here.
        // Actually _withRetry handles the main loop.
        // For multipart, we should probably just throw and let _withRetry or caller decide.
      }

      throw response;
    });
  }
}
