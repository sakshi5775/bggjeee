import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/call_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AstrologerCallHistoryController extends BaseController {
  final String? callType; // VOICE or VIDEO
  AstrologerCallHistoryController({this.callType});

  final CallService _callService = CallService();

  final RxList<CallHistoryItem> historyList = <CallHistoryItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  final int _itemsPerPage = 20;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  bool get hasMore => _hasMore;
  int get totalItems => _totalItems;

  /// Load call history
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

      final result = await _callService.getCallHistory(
        page: _currentPage,
        limit: _itemsPerPage,
        callType: callType,
      );

      final raw = result['sessions'];
      final sessionList = raw is List
          ? List<CallHistoryItem>.from(raw.whereType<CallHistoryItem>())
          : <CallHistoryItem>[];
      final pagination = result['pagination'] as Map<String, dynamic>?;

      if (reset) {
        historyList.value = sessionList;
      } else {
        historyList.addAll(sessionList);
      }

      if (pagination != null) {
        _currentPage =
            (pagination['currentPage'] as num?)?.toInt() ?? _currentPage;
        _totalPages = (pagination['totalPages'] as num?)?.toInt() ?? 1;
        _totalItems = (pagination['totalItems'] as num?)?.toInt() ?? 0;
        _hasMore = _currentPage < _totalPages;
      } else {
        _hasMore = sessionList.length >= _itemsPerPage;
      }

      if (kDebugMode) {
        print(
          'Loaded ${sessionList.length} ${callType ?? 'All'} calls (Page $_currentPage/$_totalPages)',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load call history: $e');
      }
      showErrorMessage(message: 'Failed to load history: ${e.toString()}');
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
        print('Failed to load more call sessions: $e');
      }
      _currentPage--; // Rollback page increment on error
    } finally {
      isLoadingMore.value = false;
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
      case 'COMPLETED':
        return Colors.green;
      case 'MISSED':
        return Colors.orange;
      case 'REJECTED':
      case 'FAILED':
      case 'BUSY':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Format duration
  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}
