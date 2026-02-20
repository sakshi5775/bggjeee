import 'dart:convert';
import 'dart:io';

import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/support_ticket_model.dart';
import 'package:get/get.dart';

class SupportTicketService with ApiHelperMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Create a new support ticket
  Future<SupportTicketModel?> createTicket({
    required String category,
    required String priority,
    required String subject,
    required String description,
    List<String>? tags,
    List<File>? attachments,
  }) async {
    final fields = <String, String>{
      'category': category,
      'priority': priority,
      'subject': subject,
      'description': description,
    };

    // If tags are needed as multiple fields, the current ApiClient might need adjustment.
    // However, most backends accept comma-separated strings or JSON arrays.
    // If the backend specifically requires multiple 'tags' fields, we'd need to update ApiClient.
    // Let's assume for now we can pass them or update ApiClient later if needed.
    if (tags != null && tags.isNotEmpty) {
      fields['tags'] = tags.join(','); // Fallback to comma separated
    }

    final files = <String, File?>{};
    if (attachments != null && attachments.isNotEmpty) {
      for (int i = 0; i < attachments.length; i++) {
        files['attachments'] =
            attachments[i]; // Note: ApiClient currently only supports one file per key
      }
    }

    final response = await _apiClient.postDataByFormData(
      uri: EndPoints.supportTickets,
      fields: fields,
      files: files,
    );

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['success'] == true && data['data'] != null) {
      final ticketData = data['data']['ticket'] as Map<String, dynamic>;
      return SupportTicketModel.fromJson(ticketData);
    }

    throw data['message']?.toString() ?? 'Failed to create ticket';
  }

  /// Get list of support tickets
  Future<TicketListResponse?> getTickets({
    String? status,
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, String>{};
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();

    final response = await _apiClient.getApi(
      EndPoints.supportTickets,
      query: queryParams,
    );

    if (response.body['success'] == true && response.body['data'] != null) {
      return TicketListResponse.fromJson(
        response.body['data'] as Map<String, dynamic>,
      );
    }

    throw response.body['message']?.toString() ?? 'Failed to load tickets';
  }

  /// Get ticket details by ticket ID
  Future<TicketDetailResponse?> getTicketDetails(String ticketId) async {
    final response = await _apiClient.getApi(
      EndPoints.supportTicketById(ticketId),
    );

    if (response.body['success'] == true && response.body['data'] != null) {
      return TicketDetailResponse.fromJson(
        response.body['data'] as Map<String, dynamic>,
      );
    }

    throw response.body['message']?.toString() ??
        'Failed to load ticket details';
  }

  /// Reply to a ticket
  Future<TicketActivity?> replyToTicket({
    required String ticketId,
    required String message,
    List<File>? attachments,
  }) async {
    final fields = <String, String>{'message': message};

    final files = <String, File?>{};
    if (attachments != null && attachments.isNotEmpty) {
      for (int i = 0; i < attachments.length; i++) {
        files['attachments'] = attachments[i];
      }
    }

    final response = await _apiClient.postDataByFormData(
      uri: EndPoints.supportTicketReply(ticketId),
      fields: fields,
      files: files,
    );

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['success'] == true && data['data'] != null) {
      final activityData = data['data']['activity'] as Map<String, dynamic>;
      return TicketActivity.fromJson(activityData);
    }

    throw data['message']?.toString() ?? 'Failed to send reply';
  }
}
