import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';

class ApiRepository {
  final ApiClient apiClient;

  ApiRepository({required this.apiClient});

  /// Generic GET API
  Future<Response<T>> getApi<T>(
    String endPoint, {
    Map<String, dynamic>? query,
    String? contentType,
    T Function(dynamic)? decoder,
    bool useAuthHeader = true,
    Duration? timeout,
    bool useCache = true,
    int? maxCacheAge,
  }) async {
    return await apiClient.getApi<T>(
      endPoint,
      query: query,
      contentType: contentType,
      decoder: decoder,
      useAuthHeader: useAuthHeader,
      timeout: timeout,
      useCache: useCache,
      maxCacheAge: maxCacheAge,
    );
  }

  /// Normal POST API
  Future<Response> postApi(
    String endPoint,
    dynamic body, {
    bool useAuthHeader = true,
    Duration? timeout,
  }) async {
    return await apiClient.postApi(
      endPoint,
      body,
      useAuthHeader: useAuthHeader,
      timeout: timeout,
    );
  }

  /// DELETE API
  Future<Response> deleteReq(
    String endPoint, {
    dynamic query,
    bool useAuthHeader = true,
  }) async {
    return await apiClient.deleteRequest(
      endPoint,
      query,
      useAuthHeader: useAuthHeader,
    );
  }

  /// PUT API
  Future<Response> putApiCall(
    String endPoint,
    dynamic body, {
    Map<String, dynamic>? query,
    bool useAuthHeader = true,
  }) async {
    return await apiClient.putApi(
      endPoint,
      body,
      query: query,
      useAuthHeader: useAuthHeader,
    );
  }

  /// Multipart POST API
  Future<http.Response> multiPartApiCall(
    String endPoint,
    Map<String, String> body,
    dynamic files, {
    Map<String, dynamic>? query,
  }) async {
    return await apiClient.postDataByFormData(
      uri: endPoint,
      fields: body,
      files: files,
      query: query,
    );
  }

  /// Multipart PUT API
  // Future<http.Response> putMultipartApi(
  //   String endPoint,
  //   Map<String, String> body,
  //   dynamic files, {
  //   Map<String, dynamic>? query,
  // }) async {
  //   return await apiClient.putMultipartApi(
  //     url: endPoint,
  //     fields: body,
  //     files: files,
  //   );
  // }

  Future<http.Response> postDataByFormData({
    required String uri,
    required Map<String, String> fields,
    required Map<String, File?> files,
    Map<String, dynamic>? query,
    Duration? timeout,
  }) async {
    return await apiClient.postDataByFormData(
      uri: uri,
      fields: fields,
      files: files,
      query: query,
      timeout: timeout,
    );
  }

  Future<http.Response> putDataByFormData({
    required String uri,
    required Map<String, String> fields,
    required Map<String, File?> files,
    Map<String, dynamic>? query,
  }) async {
    return await apiClient.putDataByFormData(
      uri: uri,
      fields: fields,
      files: files,
      query: query,
    );
  }
}
