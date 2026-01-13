import 'dart:io';

import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/support_ticket_model.dart';
import 'package:astrobharataiuser/screens/support/service/support_ticket_service.dart';
import 'package:flutter/foundation.dart';
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

    try {
      isLoadingTickets.value = true;
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
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tickets: $e');
      }
    } finally {
      isLoadingTickets.value = false;
    }
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

    if (subjectController.text.trim().length < 5) {
      showErrorMessage(
        title: 'Support',
        message: 'Subject must be at least 5 characters',
      );
      return false;
    }

    if (subjectController.text.trim().length > 200) {
      showErrorMessage(
        title: 'Support',
        message: 'Subject must not exceed 200 characters',
      );
      return false;
    }

    if (descriptionController.text.trim().length < 10) {
      showErrorMessage(
        title: 'Support',
        message: 'Description must be at least 10 characters',
      );
      return false;
    }

    if (descriptionController.text.trim().length > 5000) {
      showErrorMessage(
        title: 'Support',
        message: 'Description must not exceed 5000 characters',
      );
      return false;
    }

    // Validate attachments
    if (attachments.length > 5) {
      showErrorMessage(
        title: 'Support',
        message: 'Maximum 5 attachments allowed',
      );
      return false;
    }

    for (final file in attachments) {
      if (await file.exists()) {
        final sizeInMB = await file.length() / (1024 * 1024);
        if (sizeInMB > 5) {
          showErrorMessage(
            title: 'Support',
            message: 'File ${file.path.split('/').last} exceeds 5MB limit',
          );
          return false;
        }
      }
    }

    try {
      isCreatingTicket.value = true;

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

        // Show success message - ensure it's visible
        showSuccessMessage(
          title: 'Success',
          message: 'Ticket created successfully',
        );
        // Wait a bit to ensure snackbar is shown
        await Future.delayed(const Duration(milliseconds: 300));
        return true;
      } else {
        // Show error if ticket creation failed
        showErrorMessage(
          title: 'Error',
          message: 'Failed to create ticket. Please try again.',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating ticket: $e');
      }
      // Show error message for exceptions
      showErrorMessage(
        title: 'Error',
        message: 'An error occurred while creating the ticket. Please try again.',
      );
    } finally {
      isCreatingTicket.value = false;
    }
    return false;
  }

  /// Load ticket details
  Future<void> loadTicketDetails(String ticketId) async {
    try {
      isLoadingTicketDetails.value = true;
      final response = await _service.getTicketDetails(ticketId);

      if (response != null) {
        selectedTicket.value = response.ticket;
        ticketActivities.value = response.activities;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading ticket details: $e');
      }
    } finally {
      isLoadingTicketDetails.value = false;
    }
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

    // Validate attachments
    if (replyAttachments.length > 5) {
      showErrorMessage(
        title: 'Support',
        message: 'Maximum 5 attachments allowed',
      );
      return false;
    }

    for (final file in replyAttachments) {
      if (await file.exists()) {
        final sizeInMB = await file.length() / (1024 * 1024);
        if (sizeInMB > 5) {
          showErrorMessage(
            title: 'Support',
            message: 'File ${file.path.split('/').last} exceeds 5MB limit',
          );
          return false;
        }
      }
    }

    try {
      isSendingReply.value = true;

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

        // Show success message
        showSuccessMessage(
          title: 'Success',
          message: 'Reply sent successfully',
        );
        return true;
      } else {
        // Show error if reply failed
        showErrorMessage(
          title: 'Error',
          message: 'Failed to send reply. Please try again.',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error replying to ticket: $e');
      }
      // Show error message for exceptions
      showErrorMessage(
        title: 'Error',
        message: 'An error occurred while sending the reply. Please try again.',
      );
    } finally {
      isSendingReply.value = false;
    }
    return false;
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

