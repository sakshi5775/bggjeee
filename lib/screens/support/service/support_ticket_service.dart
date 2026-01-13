import 'dart:convert';
import 'dart:io';

import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/support_ticket_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SupportTicketService with ApiHelperMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();

  String get _baseUrl => _apiClient.baseUrl ?? '';

  /// Create a new support ticket
  Future<SupportTicketModel?> createTicket({
    required String category,
    required String priority,
    required String subject,
    required String description,
    List<String>? tags,
    List<File>? attachments,
  }) async {
    try {
      final fields = <String, String>{
        'category': category,
        'priority': priority,
        'subject': subject,
        'description': description,
      };

      final files = <String, dynamic>{};
      if (attachments != null && attachments.isNotEmpty) {
        files['attachments'] = attachments;
      }

      final uri = Uri.parse('$_baseUrl${EndPoints.supportTickets}');
      final currentToken = UserData().accessToken?.trim() ?? '';

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $currentToken';
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);

      // Add tags as multiple fields with the same name (for array support in multipart)
      if (tags != null && tags.isNotEmpty) {
        for (final tag in tags) {
          request.fields.addAll({'tags': tag});
        }
      }

      if (attachments != null && attachments.isNotEmpty) {
        for (final file in attachments) {
          if (await file.exists()) {
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
            } else if (fileName.endsWith('.pdf')) {
              contentType = 'application/pdf';
            }

            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments',
                file.path,
                filename: file.path.split('/').last,
                contentType: contentType != null
                    ? http.MediaType.parse(contentType)
                    : null,
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        debugPrint('Create Ticket API URL: ${uri.toString()}');
        debugPrint('Create Ticket API Status: ${response.statusCode}');
        debugPrint('Create Ticket API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final ticketData = data['data']['ticket'] as Map<String, dynamic>;
          return SupportTicketModel.fromJson(ticketData);
        }
        // Return null - let controller handle error message
        if (kDebugMode) {
          debugPrint('Create ticket failed: ${data['message']?.toString() ?? 'Unknown error'}');
        }
      } else {
        final errorData = json.decode(response.body);
        if (kDebugMode) {
          debugPrint('Create ticket error: ${errorData['message']?.toString() ?? 'Unknown error'}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating ticket: $e');
      }
    }
    return null;
  }

  /// Get list of support tickets
  Future<TicketListResponse?> getTickets({
    String? status,
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      queryParams['page'] = page.toString();
      queryParams['limit'] = limit.toString();

      final uri = Uri.parse('$_baseUrl${EndPoints.supportTickets}').replace(
        queryParameters: queryParams,
      );

      final currentToken = UserData().accessToken?.trim() ?? '';

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (currentToken.isNotEmpty) 'Authorization': 'Bearer $currentToken',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (kDebugMode) {
        debugPrint('Get Tickets API URL: ${uri.toString()}');
        debugPrint('Get Tickets API Status: ${response.statusCode}');
        debugPrint('Get Tickets API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return TicketListResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
        showErrorMessage(
          title: 'Support',
          message: data['message']?.toString() ?? 'Failed to load tickets',
        );
      } else {
        final errorData = json.decode(response.body);
        showErrorMessage(
          title: 'Support',
          message: errorData['message']?.toString() ?? 'Failed to load tickets',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching tickets: $e');
      }
      showErrorMessage(title: 'Support', message: e.toString());
    }
    return null;
  }

  /// Get ticket details by ticket ID
  Future<TicketDetailResponse?> getTicketDetails(String ticketId) async {
    try {
      final uri = Uri.parse('$_baseUrl${EndPoints.supportTicketById(ticketId)}');

      final currentToken = UserData().accessToken?.trim() ?? '';

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (currentToken.isNotEmpty) 'Authorization': 'Bearer $currentToken',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (kDebugMode) {
        debugPrint('Get Ticket Details API URL: ${uri.toString()}');
        debugPrint('Get Ticket Details API Status: ${response.statusCode}');
        debugPrint('Get Ticket Details API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return TicketDetailResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
        showErrorMessage(
          title: 'Support',
          message: data['message']?.toString() ?? 'Failed to load ticket details',
        );
      } else {
        final errorData = json.decode(response.body);
        showErrorMessage(
          title: 'Support',
          message: errorData['message']?.toString() ?? 'Failed to load ticket details',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching ticket details: $e');
      }
      showErrorMessage(title: 'Support', message: e.toString());
    }
    return null;
  }

  /// Reply to a ticket
  Future<TicketActivity?> replyToTicket({
    required String ticketId,
    required String message,
    List<File>? attachments,
  }) async {
    try {
      final fields = <String, String>{
        'message': message,
      };

      final uri = Uri.parse('$_baseUrl${EndPoints.supportTicketReply(ticketId)}');
      final currentToken = UserData().accessToken?.trim() ?? '';

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $currentToken';
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);

      if (attachments != null && attachments.isNotEmpty) {
        for (final file in attachments) {
          if (await file.exists()) {
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
            } else if (fileName.endsWith('.pdf')) {
              contentType = 'application/pdf';
            }

            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments',
                file.path,
                filename: file.path.split('/').last,
                contentType: contentType != null
                    ? http.MediaType.parse(contentType)
                    : null,
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        debugPrint('Reply Ticket API URL: ${uri.toString()}');
        debugPrint('Reply Ticket API Status: ${response.statusCode}');
        debugPrint('Reply Ticket API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final activityData = data['data']['activity'] as Map<String, dynamic>;
          return TicketActivity.fromJson(activityData);
        }
        // Return null - let controller handle error message
        if (kDebugMode) {
          debugPrint('Reply ticket failed: ${data['message']?.toString() ?? 'Unknown error'}');
        }
      } else {
        final errorData = json.decode(response.body);
        if (kDebugMode) {
          debugPrint('Reply ticket error: ${errorData['message']?.toString() ?? 'Unknown error'}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error replying to ticket: $e');
      }
    }
    return null;
  }
}

