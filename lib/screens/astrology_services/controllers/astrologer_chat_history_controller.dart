import 'dart:async';
import 'dart:convert';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AstrologerChatHistoryController extends BaseController {
  final AstrologerChatService _chatService = AstrologerChatService();

  final RxList<AstrologerChatSession> historyList =
      <AstrologerChatSession>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  final int _itemsPerPage = 20;
  bool _hasMore = true;

  // Search state
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  bool get hasMore => _hasMore;
  int get totalItems => _totalItems;

  // Get filtered list based on search query
  List<AstrologerChatSession> get filteredHistoryList {
    if (searchQuery.value.isEmpty) {
      return historyList.toList();
    }

    final query = searchQuery.value.toLowerCase();
    return historyList.where((session) {
      return session.chatId.toLowerCase().contains(query) ||
          session.status.toLowerCase().contains(query);
    }).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  /// Load chat session history
  Future<void> loadHistory({bool reset = false}) async {
    try {
      if (reset) {
        _currentPage = 1;
        _hasMore = true;
        historyList.clear();
      }

      if (!_hasMore && !reset) {
        return; // No more pages to load
      }

      isLoading.value = true;

      final result = await _chatService.getSessionHistory(
        page: _currentPage,
        limit: _itemsPerPage,
      );

      final raw = result['sessions'];
      final sessions = raw is List
          ? List<AstrologerChatSession>.from(
              raw.whereType<AstrologerChatSession>(),
            )
          : <AstrologerChatSession>[];
      final pagination = result['pagination'] as Map<String, dynamic>?;

      if (reset) {
        historyList.value = sessions;
      } else {
        historyList.addAll(sessions);
      }

      if (pagination != null) {
        _currentPage =
            (pagination['currentPage'] as num?)?.toInt() ?? _currentPage;
        _totalPages = (pagination['totalPages'] as num?)?.toInt() ?? 1;
        _totalItems = (pagination['totalItems'] as num?)?.toInt() ?? 0;
        _hasMore = _currentPage < _totalPages;
      } else {
        _hasMore = sessions.length >= _itemsPerPage;
      }

      if (kDebugMode) {
        print(
          'Loaded ${sessions.length} sessions (Page $_currentPage/$_totalPages)',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load chat history: $e');
      }
      showErrorMessage(message: 'Failed to load chat history: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more sessions (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;

    try {
      isLoadingMore.value = true;
      _currentPage++;
      await loadHistory();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load more sessions: $e');
      }
      _currentPage--; // Rollback page increment on error
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Download chat transcript
  Future<void> downloadChatTranscript(String chatId) async {
    try {
      isLoading.value = true;

      // Download chat transcript from API
      final transcript = await _chatService.downloadChatHistory(chatId);

      // Convert to JSON string
      final jsonEncoder = const JsonEncoder.withIndent('  ');
      final jsonString = jsonEncoder.convert(transcript);

      if (kDebugMode) {
        print('Chat transcript downloaded: ${jsonString.length} bytes');
        print(
          'Transcript preview: ${jsonString.substring(0, jsonString.length > 200 ? 200 : jsonString.length)}...',
        );
      }

      showSuccessMessage(message: 'Chat transcript downloaded successfully!');

      // TODO: Implement actual file download/share functionality
      // You can use FileDownloadService or share_plus package for file sharing
    } catch (e) {
      if (kDebugMode) {
        print('Failed to download chat transcript: $e');
      }
      showErrorMessage(
        message: 'Failed to download chat transcript: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to chat session detail
  void navigateToChat(String chatId, AstrologerModel? astrologer) {
    if (astrologer != null) {
      Get.toNamed(
        '/astrologer-chat',
        arguments: {'astrologer': astrologer, 'initialChatId': chatId},
      );
    }
  }

  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
      case 'EXPIRED':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'CREATED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
