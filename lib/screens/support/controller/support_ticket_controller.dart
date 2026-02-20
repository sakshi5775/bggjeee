import 'dart:io';

import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/support_ticket_model.dart';
import 'package:astrobharataiuser/screens/support/service/support_ticket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportTicketController extends BaseController {
  final SupportTicketService _service = SupportTicketService();

  // Ticket list
  final tickets = <SupportTicketModel>[].obs;
  final isLoadingTickets = false.obs;
  final pagination = Rxn<Pagination>();
  final currentPage = 1.obs;
  final limit = 10;

  // Filters
  final selectedStatus = Rxn<String>();
  final selectedCategory = Rxn<String>();

  // Status options
  static const List<String> statusOptions = [
    'OPEN',
    'UNDER_REVIEW',
    'RESOLVED',
    'CLOSED',
  ];

  // Category options
  static const List<String> categoryOptions = [
    'Technical',
    'Payment',
    'Harassment',
    'General',
  ];

  // Priority options
  static const List<String> priorityOptions = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  // Create ticket form
  final formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();
  final selectedCategoryForCreate = Rxn<String>();
  final selectedPriority = Rxn<String>();
  final attachments = <File>[].obs;
  final isCreatingTicket = false.obs;

  // Ticket details
  final selectedTicket = Rxn<SupportTicketModel>();
  final ticketActivities = <TicketActivity>[].obs;
  final isLoadingTicketDetails = false.obs;

  // Reply form
  final replyFormKey = GlobalKey<FormState>();
  final replyMessageController = TextEditingController();
  final replyAttachments = <File>[].obs;
  final isSendingReply = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    replyMessageController.dispose();
    super.onClose();
  }

  /// Load tickets with filters
  Future<void> loadTickets({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
    }

    await runWithLoading(
      () async {
        final response = await _service.getTickets(
          status: selectedStatus.value,
          category: selectedCategory.value,
          page: currentPage.value,
          limit: limit,
        );

        if (response != null) {
          if (refresh || currentPage.value == 1) {
            tickets.clear();
          }
          tickets.addAll(response.items);
          pagination.value = response.pagination;
        }
      },
      showBusy: tickets.isEmpty, // Only show busy if initial load
      showError: true,
    );
  }

  /// Load more tickets (pagination)
  Future<void> loadMoreTickets() async {
    if (pagination.value?.hasNextPage == true && !isLoadingTickets.value) {
      currentPage.value++;
      await loadTickets();
    }
  }

  /// Apply filters
  void applyFilters() {
    currentPage.value = 1;
    loadTickets(refresh: true);
  }

  /// Clear filters
  void clearFilters() {
    selectedStatus.value = null;
    selectedCategory.value = null;
    applyFilters();
  }

  /// Create new ticket
  Future<bool> createTicket() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (selectedCategoryForCreate.value == null) {
      showErrorMessage(title: 'Support', message: 'Please select a category');
      return false;
    }

    if (selectedPriority.value == null) {
      showErrorMessage(title: 'Support', message: 'Please select a priority');
      return false;
    }

    // Basic validation
    if (subjectController.text.trim().length < 5 ||
        subjectController.text.trim().length > 200) {
      showErrorMessage(
        title: 'Support',
        message: 'Subject must be between 5 and 200 characters',
      );
      return false;
    }

    if (descriptionController.text.trim().length < 10 ||
        descriptionController.text.trim().length > 5000) {
      showErrorMessage(
        title: 'Support',
        message: 'Description must be between 10 and 5000 characters',
      );
      return false;
    }

    if (attachments.length > 5) {
      showErrorMessage(
        title: 'Support',
        message: 'Maximum 5 attachments allowed',
      );
      return false;
    }

    final result =
        await runWithLoading(
          () async {
            List<String>? tags;
            if (tagsController.text.trim().isNotEmpty) {
              tags = tagsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
            }

            final ticket = await _service.createTicket(
              category: selectedCategoryForCreate.value!,
              priority: selectedPriority.value!,
              subject: subjectController.text.trim(),
              description: descriptionController.text.trim(),
              tags: tags,
              attachments: attachments.toList(),
            );

            if (ticket != null) {
              // Clear form
              subjectController.clear();
              descriptionController.clear();
              tagsController.clear();
              selectedCategoryForCreate.value = null;
              selectedPriority.value = null;
              attachments.clear();

              // Reload tickets
              await loadTickets(refresh: true);
              return true;
            }
            return false;
          },
          showBusy: true,
          successMessage: 'your support ticket of the issue is submitted',
        ) ??
        false;

    if (result) {
      Get.offNamed(AppRoutes.supportTickets);
    }
    return result;
  }

  /// Load ticket details
  Future<void> loadTicketDetails(String ticketId) async {
    await runWithLoading(
      () async {
        final response = await _service.getTicketDetails(ticketId);
        if (response != null) {
          selectedTicket.value = response.ticket;
          ticketActivities.value = response.activities;
        }
      },
      showBusy: selectedTicket.value == null,
      showError: true,
    );
  }

  /// Reply to ticket
  Future<bool> replyToTicket(String ticketId) async {
    if (!replyFormKey.currentState!.validate()) {
      return false;
    }

    if (replyMessageController.text.trim().isEmpty) {
      showErrorMessage(title: 'Support', message: 'Please enter a message');
      return false;
    }

    if (replyMessageController.text.trim().length > 5000) {
      showErrorMessage(
        title: 'Support',
        message: 'Message must not exceed 5000 characters',
      );
      return false;
    }

    if (replyAttachments.length > 5) {
      showErrorMessage(
        title: 'Support',
        message: 'Maximum 5 attachments allowed',
      );
      return false;
    }

    return await runWithLoading(
          () async {
            final activity = await _service.replyToTicket(
              ticketId: ticketId,
              message: replyMessageController.text.trim(),
              attachments: replyAttachments.toList(),
            );

            if (activity != null) {
              // Add to activities list
              ticketActivities.insert(0, activity);

              // Clear form
              replyMessageController.clear();
              replyAttachments.clear();

              // Reload ticket details to get updated status
              await loadTicketDetails(ticketId);
              return true;
            }
            return false;
          },
          showBusy: true,
          successMessage: 'Reply sent successfully',
        ) ??
        false;
  }

  /// Add attachment to create form
  Future<void> addAttachment() async {
    // This will be handled by the view using image_picker or file_picker
  }

  /// Remove attachment from create form
  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
    }
  }

  /// Add attachment to reply form
  Future<void> addReplyAttachment() async {
    // This will be handled by the view using image_picker or file_picker
  }

  /// Remove attachment from reply form
  void removeReplyAttachment(int index) {
    if (index >= 0 && index < replyAttachments.length) {
      replyAttachments.removeAt(index);
    }
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return Colors.green;
      case 'UNDER_REVIEW':
        return Colors.orange;
      case 'RESOLVED':
        return Colors.blue;
      case 'CLOSED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Get priority color
  Color getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'LOW':
        return Colors.green;
      case 'MEDIUM':
        return Colors.orange;
      case 'HIGH':
        return Colors.red;
      case 'CRITICAL':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Check if ticket is closed
  bool isTicketClosed(String status) {
    return status.toUpperCase() == 'CLOSED';
  }
}
